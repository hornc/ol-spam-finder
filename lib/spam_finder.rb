# Finds works added immediately to OL by newly created users and checks them for spamness
class SpamFinder
  BASE = "http://openlibrary.org/"
  LIMIT = 10
  OFFSET = 0

  def check_day(date)
    client = Openlibrary::Client.new
    @day = Olday.find_or_initialize_by(date: Date.parse(date))

    users = keep_created_on(users_who_added_books_on(date), date)

    users.each do |user|
      # Skip checking user if the user/works have already been deleted
      if @day.clear_users.keys.include?(user) && eval(@day.clear_users[user]).values.first.blank?
        puts "User already cleared: #{user}"
        next
      end
      puts user
      # for each user, check if their recent changes are spammy and add name to spammers
      response = Net::HTTP.get(URI(BASE+"recentchanges.json?author=#{user}&limit=#{LIMIT}"))
      changes = JSON.parse(response)
      
      spam_works = 0 
      @user_works = {}
      changes.each do |c|
        next if c['kind'] != 'add-book' # skip change if not adding a book
        c['changes'].each do |item|
          if item['key'].include?("/books/")
            book = get_book(client, item['key'])
            puts "  #{book.title}"
            @user_works[item['key'][1..-1]] = book.title
            spam_works += 1 if is_spam?(book)
            break # only care about the first book of a change-set
          end
          break if spam_works > 1
        end
      end

      if spam_works > 0
        @day.spammers[user] = @user_works
        puts " SPAMMER FOUND: #{user}"
        @day.clear_users.delete(user) # remove user if it was in the clear_users list
      else
        @day.clear_users[user] = @user_works
        @day.spammers.delete(user) # remove user if it was in the spammers list
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
    last_seen_id = ""
    limit = 1000  # API limits this to 1000
    while more_books
      puts " .... getting books from #{bookcount} to #{bookcount + limit} ..."
      response = Net::HTTP.get(URI(BASE+"recentchanges/#{year}/#{month}/#{day}/add-book.json?limit=#{limit}&offset=#{bookcount}"))
      books = JSON.parse(response)
      bookcount += books.size
      more_books = false if books.size < limit || books.last['id'] == last_seen_id
      last_seen_id = books.last['id']
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

  def get_book(client, olid)
    id = olid.sub('/books/', '')
    client.book(id)
  end

  # book is a Hashie::Mash as returned from the Openlibrary gem
  def is_spam?(book)
    match = book.title && (
      book.title =~ /[☞◁≫【〚〖┫『《▶➸。ㆍ→≒♥⑧∽]/ ||
      book.title.include?('-BAMWAR닷컴') ||
      book.title.include?('★최신') ||
      book.title =~ /(PDF|FREE|EBOOK|FONT|DRIVER) DOWNLOAD$/ ||
      book.title.include?("POOR CHARLIE'S ALMANACK EBOOK") ||
      book.title =~ /Escorts in Dubai$/ ||
      book.title =~ /\p{Hangul}.+([CcＣćĆｃ]\s*[oO0oｏＯ]\s*[MmｍＭḿḾ]|[Nn]\s*[Ee]\s*[Tt])/ || # Korean with .com .net etc
      book.title.include?('바카라')  || # Bacarat in Korean
      book.title.include?('＼＼') ||
      book.title =~ /↔\d{4}/ || # double headed arrow with 4digits
      book.title =~ /\+\d{9}/ || # phone numbers
      book.title =~ /\d{9}.*\p{Han}+/ # Chinese /w phone number spam
    )
    !!match
  end
end
