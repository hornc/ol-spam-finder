require 'spam_finder'

namespace :ol_spam do
  desc "TODO"
  task :date, [:date] => [:environment] do |t, args|
    puts "Args were: #{args}"
    finder = SpamFinder.new
    finder.check_day(args.date)
  end

  desc "TODO"
  task :month, [:month] => [:environment] do |t, args|
    finder = SpamFinder.new
    start = Date.parse(args.month + "-01")
    (start...start >> 1).each do |d|
      break if d == Date.current
      date = d.strftime("%Y-%m-%d")
      puts "Checking #{date}..."
      finder.check_day(date)
    end
  end

  desc "TODO"
  task yesterday: :environment do
  end

end
