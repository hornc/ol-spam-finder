class SpamdaysController < ApplicationController
  def index
    year, month = params[:month].split('-')    
    @start_date = params[:month] + "-01"
    @month = Date::MONTHNAMES[month.to_i]
    @year = year

    @previous = Date.parse(@start_date).prev_month.strftime('%Y-%m')
    @next = Date.parse(@start_date).next_month.strftime('%Y-%m')

  end

  def show
    @day = params[:day]
  end

end
