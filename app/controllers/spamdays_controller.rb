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
    @day = Olday.find_or_initialize_by(date: "#{params[:month]}-#{params[:day]}")
  end

  def list
    if params[:date]
      date = params[:date]
      year, month, day = date.split('-')
    else
      date = Date.current.strftime("%Y-%m")
    end

    if day.nil?
      start = Date.parse(date + "-01")
      days = Olday.where(:date => start...start >> 1)
    else
      days = Olday.where(:date => Date.parse(date))
    end

    @accounts = days.collect { |d| d.spammers.keys }.flatten

    respond_to do |format|
      format.html
      format.json { render :json => @accounts }
      format.text { render :text => @accounts.join("\n") }
      format.xml  { render :xml  => @accounts.to_xml(:root => 'accounts') }
    end
  end
end
