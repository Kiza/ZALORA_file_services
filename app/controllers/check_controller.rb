class CheckController < ApplicationController
  def live
    data = {live:true}

    render json: data
  end

end
