class CreateDataFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :data_files do |t|
      t.string :filename, null: false
      t.integer :size, null: false
      t.string :hash_value, null: false
      t.string :hash_function, null: false

      t.timestamps
    end

    add_index :data_files, :filename, unique: true
  end
end
