module SpamdaysHelper
  OL = "http://openlibrary.org/"
  def month_calendar_td_options
    ->(start_date, current_calendar_date) {
      # default_td_classes
      # {class: "calendar-date", data: {day: current_calendar_date}}
        today = Time.zone.now.to_date
        ol_day = Olday.find_by(date: current_calendar_date)
        td_class = ["day"]
        td_class << "today" if today == current_calendar_date

        td_class << "empty" if start_date.month != current_calendar_date.month
        td_class << "future" if today < current_calendar_date
        if ol_day
          td_class << (ol_day.spammers_found ? "status-spammed" : "status-clear")
        else
          td_class << "status-unknown"
        end
      { class: td_class.join(" ") }
    }
  end

  def format_raw_output(raw)
    orig = raw
    formatted = ''
    output = raw.lines
    previous_line = ''
    in_spammers = true
    until output.empty?
      case line = output.shift
      when /([A-Z ]+):/
        formatted += "<h3>#{$1}</h3>"
        in_spammers = false unless $1.match('SPAMMERS')
      when /^\/(people\/.+)$/
        formatted += "#{admin_link($1) if in_spammers} #{account_link($1)}<br/>"
      when /\/(books\/OL[^ ]+)/
        formatted += "    #{book_link($1, previous_line)}<br/>"
      else
        previous_line = line
      end
    end
    raw(formatted)
  end

  def list_link(account)
    link_to account, "#{OL}admin/#{account}"
  end

  def account_link(account)
    link_to account, "#{OL}#{account}", {class: "person"}
  end

  def admin_link(account)
    "<span class='admin'>#{link_to "&nbsp; admin &nbsp;".html_safe, "#{OL}admin/#{account}"}</span>"
  end

  def book_link(book, title)
    c = 'book-link'
    if title.nil? || title.strip.empty?
      title = "{ blank / deleted }"
      c = 'deleted-book'
    end
    "#{'&nbsp;'*5}&bull; #{link_to title, "#{OL}#{book}", {class: c}}"
  end
end
