class DataFile < ApplicationRecord
    CHUNK_SIZE = 1024 * 10

    has_many :file_chunks, -> { order(:sequence) }
    has_many :chunks, through: :file_chunks

    validates :filename, uniqueness: true
    validates :filename, presence: true
    validates :hash_value, presence: true
    validates :hash_function, presence: true
    validates :size, presence: true

    def to_file
        f = StringIO.new
        
        self.chunks.each do |c|
            f.write c.data
        end
        f.close

        return f.string
    end

    def delete
        ActiveRecord::Base.transaction do
            self.file_chunks.each do |file_chunk|
                chunk = file_chunk.chunk
                file_chunk.destroy!

                if chunk.file_chunks.size == 0
                    chunk.destroy!
                end
            end

            self.destroy!
        end
        return {success:true}
    rescue ActiveRecord::RecordInvalid => e
        return {success:false, error:e.message}
    end


    def self.to_data_file(filename, f)
        if DataFile.find_by_filename(filename)
            return {success:false, error:"Filename has already been taken."}
        end
        
        data_file = DataFile.new
        file_sha2 = Digest::SHA2.new
        file_size = 0
        chunks = []
        ActiveRecord::Base.transaction do
            until f.eof?
                data = f.read(DataFile::CHUNK_SIZE)
                file_size = file_size + data.size
                file_sha2 << data

                chunk_sha2 = Digest::SHA2.new
                chunk_sha2 << data
                chunk_sha2 = chunk_sha2.hexdigest
                
                chunk = nil
                _chunks = Chunk.where(hash_value:chunk_sha2).where(hash_function:'sha2').where(size:data.size)
                if _chunks.size == 0
                    chunk = Chunk.new
                    chunk.data = data
                    chunk.size = chunk.data.size
                    chunk.hash_function = 'sha2'
                    chunk.hash_value = chunk_sha2

                    chunk.save!
                else
                    chunk = _chunks[0]
                end

                chunks << {chunk:chunk, sequence:file_size}
            end
            
            data_file.filename = filename
            data_file.hash_value = file_sha2.hexdigest
            data_file.hash_function = 'sha2'
            data_file.size = file_size
            data_file.save!

            chunks.each do |c|
                file_chunk = FileChunk.new
                file_chunk.chunk = c[:chunk]
                file_chunk.sequence = c[:sequence]
                file_chunk.data_file = data_file
                file_chunk.save!
            end
        end

        return {success:true}
    rescue ActiveRecord::RecordInvalid => e
        return {success:false, error:e.message}
    end
end
