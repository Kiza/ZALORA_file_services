require 'digest'

class DataFileController < ApplicationController
  def create
    filename = params[:file].original_filename
    f = params[:file]

    result = DataFile.to_data_file(filename, f)
    
    if result[:success]
      render json: result, status: :ok
    else
      render json: result, status: :bad_request
    end 
  end

  def show
    filename = params[:filename]

    data_file = DataFile.find_by_filename(filename)
    
    payload = {}
    if data_file

      f = data_file.to_file

      send_data f, filename: data_file.filename, disposition: 'attachment'
    else
      render json: {success:false, error:"Filename cannot be found."}, status: :not_found
    end
  end

  def delete
    filename = params[:filename]
    data_file = DataFile.find_by_filename(filename)

    if data_file
      result = data_file.delete

      if result[:success]
        render json: {success:true}, status: :ok
      else
        render json: result, status: :bad_request
      end
      
    else
      render json: {success:false, error:"Filename cannot be found."}, status: :not_found
    end
  end
end
