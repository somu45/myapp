class IncidentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index

  end

  def new
    @incident = Incident.new
  end

  def reports

  end

  def generate_report
    @data = Incident.where(:technology => params["report_name"]).page(params[:page]).per(10)
  end

  def create
    if params[:incident][:file].present?
      Incident.import(params[:incident][:file])
      @success_msg = "File uploaded successfully."
    else
      @error_msg = "Please Choose a File"
    end
    respond_to do |format|
        format.html { redirect_to new_incident_path, notice: @success_msg, alert: @error_msg }
    end
  end

end
