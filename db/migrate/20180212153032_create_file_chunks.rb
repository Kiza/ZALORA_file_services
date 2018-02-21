class CreateFileChunks < ActiveRecord::Migration[5.1]
  def change
    create_table :file_chunks do |t|
      t.integer :sequence, null: false

      t.references :data_file, index: true, foreign_key: true
      t.references :chunk, index: true, foreign_key: true

      t.timestamps
    end
  end
end
