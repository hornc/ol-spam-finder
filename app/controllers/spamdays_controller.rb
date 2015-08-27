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
    @day = Olday.find_by(date: "#{params[:month]}-#{params[:day]}")
  end

  def list
    if params[:date]
      year, month, day = params[:date].split('-')
      date = params[:date]
    else
      date = Date.current.strftime("%Y-%m")
    end
    @accounts = []
    unless day.nil?
      @day = Olday.find_by(date: date)
      @accounts = @day.spammers.keys
    else
      start = Date.parse(date + "-01")
      (start...start >> 1).each do |d|
        if day = Olday.find_by(date: d)
          @accounts += day.spammers.keys
        end
      end
    end
  end
end
