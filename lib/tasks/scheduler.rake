require 'spam_finder'

namespace :ol_spam do
  desc "Check OL for spam accounts created yesterday"
  task yesterday: :environment do
    yday = (Date.current-1).strftime("%Y-%m-%d")
    finder = SpamFinder.new
    finder.check_day(yday)
  end
end
