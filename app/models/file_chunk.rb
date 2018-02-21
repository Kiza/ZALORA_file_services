class FileChunk < ApplicationRecord
    belongs_to :data_file
    belongs_to :chunk
end
