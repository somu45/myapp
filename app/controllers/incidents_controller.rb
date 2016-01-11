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
    @error_msg = "No Data Found..!!!" if @data.blank?
  end

  def create
    if params[:incident][:file].present?
      response = Incident.import(params[:incident][:file])
      if response[:error].blank?
        @success_msg = "File uploaded successfully."
      else
        @error_msg = response[:error]
      end
    else
      @error_msg = "Please Choose a File"
    end
    respond_to do |format|
        format.html { redirect_to new_incident_path, notice: @success_msg, alert: @error_msg }
    end
  end

end
