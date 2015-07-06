class SpamdaysController < ApplicationController
  def index
    if params[:month]
      year, month = params[:month].split('-')
    else
      year = Date.current.year.to_s
      month = Date.current.strftime('%m')
    end
    @start_date = "#{year}-#{month}-01"
    @month = Date::MONTHNAMES[month.to_i]
    @year = year

    @previous = Date.parse(@start_date).prev_month.strftime('%Y-%m')
    @next = Date.parse(@start_date).next_month.strftime('%Y-%m')

  end

  def show
    @day = params[:day]
  end

end
