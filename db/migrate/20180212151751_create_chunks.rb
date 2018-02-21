class CreateChunks < ActiveRecord::Migration[5.1]
  def change
    create_table :chunks do |t|
      t.integer :size, null: false
      t.string :hash_value, null: false
      t.string :hash_function, null: false
      t.binary :data, null: false

      t.timestamps
    end

    add_index :chunks, :size
    add_index :chunks, :hash_value
    add_index :chunks, :hash_function
    add_index :chunks, [:size, :hash_value, :hash_function], unique: true
  end
end
