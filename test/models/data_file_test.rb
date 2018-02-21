require 'test_helper'
require 'securerandom'
require 'tempfile'


class DataFileTest < ActiveSupport::TestCase
  test "should save data" do
    assert Chunk.all.size == 0

    filename = SecureRandom.hex
    data = SecureRandom.base64(20000)

    tmp = Tempfile.new(filename)
    tmp.write data
    tmp.flush
    tmp.close

    r = DataFile.to_data_file(filename, File.open(tmp.path))

    assert r[:success]
    assert Chunk.all.size != 0
  end

  test "should delete data" do
    assert Chunk.all.size == 0

    filename = SecureRandom.hex
    data = SecureRandom.base64(20000)

    tmp = Tempfile.new(filename)
    tmp.write data
    tmp.flush
    tmp.close

    r = DataFile.to_data_file(filename, File.open(tmp.path))
    assert r[:success]

    data_file = DataFile.find_by_filename(filename)
    r = data_file.delete
    assert r[:success]

    assert !DataFile.find_by_filename(filename)
    assert Chunk.all.size == 0
  end

  test "should not save duplicate filenames" do
    filename = SecureRandom.hex
    data = SecureRandom.base64(20000)

    tmp = Tempfile.new(filename)
    tmp.write data
    tmp.flush
    tmp.close

    r = DataFile.to_data_file(filename, File.open(tmp.path))
    assert r[:success]

    data = SecureRandom.base64(20000)
    tmp = Tempfile.new(filename)
    tmp.write data
    tmp.flush
    tmp.close

    r = DataFile.to_data_file(filename, File.open(tmp.path))
    assert !r[:success]
  end

  test "should load data" do
    filename = SecureRandom.hex
    data = SecureRandom.base64(20000)

    tmp = Tempfile.new(filename)
    tmp.write data
    tmp.flush
    tmp.close

    r = DataFile.to_data_file(filename, File.open(tmp.path))
    
    assert r[:success]

    data_file = DataFile.find_by_filename(filename)
    f = data_file.to_file

    assert data == f
  end

  test "should reuse common chunk" do
    filename_1 = SecureRandom.hex
    data = SecureRandom.base64(20000)
    tmp = Tempfile.new(filename_1)
    tmp.write data
    tmp.flush
    tmp.close

   
    r = DataFile.to_data_file(filename_1, File.open(tmp.path))
    assert r[:success]
    before_chunk_count = Chunk.all.size

    filename_2 = SecureRandom.hex
    r = DataFile.to_data_file(filename_2, File.open(tmp.path))
    assert r[:success]
    after_chunk_count = Chunk.all.size

    data_file_1 = DataFile.find_by_filename(filename_1)
    data_file_2 = DataFile.find_by_filename(filename_2)

    assert before_chunk_count != 0
    assert before_chunk_count == after_chunk_count
    assert data_file_1.chunks == data_file_2.chunks
    
  end

  test "should reuse common chunk - delete one" do
    filename_1 = SecureRandom.hex
    data = SecureRandom.base64(20000)
    tmp = Tempfile.new(filename_1)
    tmp.write data
    tmp.flush
    tmp.close

   
    r = DataFile.to_data_file(filename_1, File.open(tmp.path))
    assert r[:success]
    before_chunk_count = Chunk.all.size

    filename_2 = SecureRandom.hex
    r = DataFile.to_data_file(filename_2, File.open(tmp.path))
    assert r[:success]
    after_chunk_count = Chunk.all.size

    data_file_1 = DataFile.find_by_filename(filename_1)
    data_file_2 = DataFile.find_by_filename(filename_2)

    assert before_chunk_count != 0
    assert before_chunk_count == after_chunk_count
    assert data_file_1.chunks == data_file_2.chunks

    r = data_file_1.delete
    assert r[:success]
    assert !DataFile.find_by_filename(filename_1)

    data_file_2 = DataFile.find_by_filename(filename_2)
    f = data_file_2.to_file
    final_chunk_count = Chunk.all.size

    assert data == f
    assert before_chunk_count == final_chunk_count

  end

  test "should reuse common chunk - delete all" do
    filename_1 = SecureRandom.hex
    data = SecureRandom.base64(20000)
    tmp = Tempfile.new(filename_1)
    tmp.write data
    tmp.flush
    tmp.close

    r = DataFile.to_data_file(filename_1, File.open(tmp.path))
    assert r[:success]
    before_chunk_count = Chunk.all.size

    filename_2 = SecureRandom.hex
    r = DataFile.to_data_file(filename_2, File.open(tmp.path))
    assert r[:success]
    after_chunk_count = Chunk.all.size

    data_file_1 = DataFile.find_by_filename(filename_1)
    data_file_2 = DataFile.find_by_filename(filename_2)

    assert before_chunk_count != 0
    assert before_chunk_count == after_chunk_count
    assert data_file_1.chunks == data_file_2.chunks

    r = data_file_1.delete
    assert r[:success]
    assert !DataFile.find_by_filename(filename_1)

    data_file_2 = DataFile.find_by_filename(filename_2)
    f = data_file_2.to_file
    final_chunk_count = Chunk.all.size

    assert data == f
    assert before_chunk_count == final_chunk_count

    r = data_file_2.delete
    assert r[:success]
    assert !DataFile.find_by_filename(filename_2)
    assert Chunk.all.size == 0
  end
end
