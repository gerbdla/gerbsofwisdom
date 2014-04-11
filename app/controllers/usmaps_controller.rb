class UsmapsController < ApplicationController
  # GET /usmaps
  # GET /usmaps.json
  def index
   

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @usmaps }
    end
  end
end
