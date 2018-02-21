# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180212153032) do

  create_table "chunks", force: :cascade do |t|
    t.integer "size", null: false
    t.string "hash_value", null: false
    t.string "hash_function", null: false
    t.binary "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash_function"], name: "index_chunks_on_hash_function"
    t.index ["hash_value"], name: "index_chunks_on_hash_value"
    t.index ["size", "hash_value", "hash_function"], name: "index_chunks_on_size_and_hash_value_and_hash_function", unique: true
    t.index ["size"], name: "index_chunks_on_size"
  end

  create_table "data_files", force: :cascade do |t|
    t.string "filename", null: false
    t.integer "size", null: false
    t.string "hash_value", null: false
    t.string "hash_function", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["filename"], name: "index_data_files_on_filename", unique: true
  end

  create_table "file_chunks", force: :cascade do |t|
    t.integer "sequence", null: false
    t.integer "data_file_id"
    t.integer "chunk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chunk_id"], name: "index_file_chunks_on_chunk_id"
    t.index ["data_file_id"], name: "index_file_chunks_on_data_file_id"
  end

end
