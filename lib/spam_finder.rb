class SpamFinder

  BASE = "http://openlibrary.org/"
  LIMIT = 10
  OFFSET = 0

  def check_day(date)
    client = Openlibrary::Client.new
    @day = Olday.find_or_initialize_by(date: Date.parse(date))

    users = keep_created_on(users_who_added_books_on(date), date)

    users.each do |user|
      # Skip checking user if we already know it is not a spammer.
      if @day.clear_users.keys.include?(user)
        puts "Good user: #{user}"
        next
      end
      puts user
      # for each user, check if their recent changes are spammy and add name to spammers
      response = Net::HTTP.get(URI(BASE+"recentchanges.json?author=#{user}&limit=10"))
      changes = JSON.parse(response)
      
      spam_works = 0 
      @user_works = {}
      changes.each do |c|
        next if c['kind'] != 'add-book' # skip change if not adding a book
        c['changes'].each do |item|
          if item['key'].include?("/books/")
            spam_works += 1 if is_spam?(client, item['key'])
            break # only care about the first book of a change-set
          end
          break if spam_works > 1
        end
      end

      if spam_works > 0
        @day.spammers[user] = @user_works
        puts " SPAMMER FOUND: #{user}"
      else
        @day.clear_users[user] = @user_works
        @day.spammers.delete(user) # clear user if it was in the spammers list
      end
    end

    puts "  == #{@day.spammers.keys.length} SPAMMERS FOUND#{date ? ' on ' + date : ''} =="
    @day.last_spammer_count = @day.spammers.keys.length
    if @day.last_spammer_count > @day.max_spammer_count
      @day.max_spammer_count = @day.last_spammer_count
    end
    @day.spammers_found = !@day.spammers.keys.empty?
    @day.save
  end

  # get list of recently added books
  def get_recently_added
    response = Net::HTTP.get(URI(BASE+"recentchanges/add-book.json?limit=#{LIMIT}"))
    JSON.parse(response)
  end

  def users_added_over(changes, threshold = 0)
    users = Hash.new(0) 
    changes.each do |c|
      users[c['author']['key']] += 1
    end
    users.keep_if {|k, v| v > threshold}
    users.keys
  end

  def users_who_added_books_on(date)
    year, month, day = date.split('-')
    users = []
    bookcount = 0
    more_books = true
    limit = 1000  # API limits this to 1000
    while more_books
      puts " .... getting books from #{bookcount} to #{bookcount + limit} ..."
      response = Net::HTTP.get(URI(BASE+"recentchanges/#{year}/#{month}/#{day}/add-book.json?limit=#{limit}&offset=#{bookcount}"))
      books = JSON.parse(response)
      bookcount += books.size
      more_books = false if books.size < limit
      books.each { |b| users << b['author']['key'] unless users.include?(b['author']['key']) }
    end
    puts " #{bookcount} books added by #{users.size} users on #{date}"
    @day.new_books = bookcount
    @day.book_adding_accounts = users.size
    users
  end

  def keep_created_on(users, date)
    keep = users_on(date) & users
    puts "  #{keep.size} new users added books"
    @day.new_book_adding_accounts = keep.size
    keep
  end

  def recent_users
    users = []
    limit = 1000
    response = Net::HTTP.get(URI(BASE+"recentchanges/new-account.json?limit=#{limit}&offset=#{OFFSET}"))
    new_accounts = JSON.parse(response)
    new_accounts.each { |a| users << a['author']['key'] } 
    users
  end

  def users_on(date)
    if date.nil?
      raise "You must select a date to check"
    end
    year, month, day = date.split('-')
    users = []
    usercount = 0
    limit = 1000
    more_users = true
    while more_users
      response = Net::HTTP.get(URI(BASE+"recentchanges/#{year}/#{month}/#{day}/new-account.json?limit=#{limit}&offset=#{usercount}"))
      accounts = JSON.parse(response)
      usercount += accounts.size
      puts "  Found #{usercount} accounts created on #{date}"
      more_users = false if accounts.size < limit
      accounts.each { |a| users << a['author']['key'] }
    end
    @day.new_accounts = usercount
    users
  end

  def is_spam?(client, olid)
    id = olid.sub('/books/', '')
    book = client.book(id)
    puts "  #{book.title}"
    #@user_works += "  #{book.title}\n  /books/#{id}\n"
    @user_works["books/#{id}"] = book.title

    book.title && ( 
      book.title =~ /[【〚〖┫『《▶➸。ㆍ→≒♥⑧]/ || 
      # book.title.include?('tpm1004.com') ||
      book.title.include?('-BAMWAR닷컴') ||
      book.title.include?('★최신') ||
      book.title =~ /(PDF|FREE|EBOOK|FONT|DRIVER) DOWNLOAD$/ ||
      book.title.include?("POOR CHARLIE'S ALMANACK EBOOK") ||
      book.title =~ /\p{Hangul}.+(COM|com|net|NET|CoM)/ || # Korean with .com .net etc
      book.title.include?('바카라')  || # Bacarat in Korean
      book.title.include?('＼＼') || 
      book.title =~ /\+\d{9}/ # phone numbers
    )
  end

  def format_spammers(spammers)
    spammers.each { |s| puts "https://openlibrary.org/admin#{s}" }
  end

end
