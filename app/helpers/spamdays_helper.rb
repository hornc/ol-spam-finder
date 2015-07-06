module SpamdaysHelper
  def month_calendar_td_options
    ->(start_date, current_calendar_date) {
      # default_td_classes
      # {class: "calendar-date", data: {day: current_calendar_date}}
        today = Time.zone.now.to_date
        td_class = ["day"]
        td_class << "today"  if today == current_calendar_date
        td_class << "status-unknown"
        td_class << "empty" if start_date.month != current_calendar_date.month
        td_class << "future" if today < current_calendar_date
        #td_class << "status-spammed"

      { class: td_class.join(" ") }
    }
  end
end
