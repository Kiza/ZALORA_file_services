class Chunk < ApplicationRecord
    has_many :file_chunks
    
    validates :hash_value, presence: true
    validates :hash_function, presence: true
    validates :size, presence: true
    validates :hash_value, uniqueness: { scope: [:hash_function, :size] }
end
