require 'spam_finder'

namespace :ol_spam do
  desc "Check OL for spam accounts created YESTERDAY"
  task yesterday: :environment do
    yday = (Date.current-1).strftime("%Y-%m-%d")
    finder = SpamFinder.new
    finder.check_day(yday)
  end

  desc "Check OL for spam accounts for all days in the CURRENT month"
  task current_month: :environment do
    month = (Date.current).strftime("%Y-%m")
    Rake::Task["ol_spam:month"].invoke(month)
  end

  desc "Check OL for spam accounts for all days in the PREVIOUS month"
  task previous_month: :environment do
    month = (Date.current<<1).strftime("%Y-%m")
    Rake::Task["ol_spam:month"].invoke(month)
  end
end
