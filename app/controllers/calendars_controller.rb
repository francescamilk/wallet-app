class CalendarsController < ApplicationController
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.user = current_user

    if @calendar.save
      redirect_to root_path
    else
      raise
    end
  end

  def import
    @calendar = Calendar.last
    @calendar.import(params[:file])
    
    if @calendar.save
      redirect_to root_path
    else
      raise
    end
  end

  private

  def calendar_params
    params.require(:calendar).permit(:name)
  end
end
