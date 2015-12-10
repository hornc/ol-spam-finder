require 'spam_finder'

namespace :ol_spam do
  desc "Check for spam on a particular date,  [YYYY-MM-DD]"
  task :date, [:date] => [:environment] do |t, args|
    puts "Args were: #{args}"
    finder = SpamFinder.new
    finder.check_day(args.date)
  end

  desc "Check for spam on a particular month, [YYYY-MM]"
  task :month, [:month] => [:environment] do |t, args|
    finder = SpamFinder.new
    start = Date.parse(args.month + "-01")
    (start...start >> 1).each do |d|
      break if d > Date.current
      date = d.strftime("%Y-%m-%d")
      puts "Checking #{date}..."
      finder.check_day(date)
    end
  end

  desc "Revert all spammers and spam from today to one month ago"
  task :revert => :environment do |t|
    today = Date.current
    days = Olday.where(:date => today << 1..today)
    accounts = days.collect { |d| d.spammers.keys }.flatten

    unless accounts.empty?
      # login and set cookie
      http = Net::HTTP.new('openlibrary.org', 443)
      http.use_ssl = true
      data = "username=#{ENV['OL_USERNAME']}&password=#{ENV['OL_PASSWORD']}&login=login"
      response = http.post('/account/login', data)
      cookie = response['set-cookie']

      accounts.each do |account|
        puts "  Reverting #{account}"
        data = "action=block_account_and_revert"
        path = "/admin#{account}"
        headers = {'Cookie' => cookie}
        response = http.post(path, data, headers)
        puts "    Response: #{response.code}"
      end
    end
  end
end
