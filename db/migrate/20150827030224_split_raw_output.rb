class SplitRawOutput < ActiveRecord::Migration
  def up
    execute "create extension hstore"
    add_column :oldays, :spammers, :hstore, default: {}
    add_column :oldays, :clear_users, :hstore, default: {}

    Olday.find_each do |day|
      split_raw(day)
      day.save!
    end
  end

  def split_raw(day)
    user_expr = /^(\/people\/.+)$/
    book_expr = /(books\/.+)/
    other_marker = 'OTHER ADDITIONS:'
    spammers = {}
    clear_users = {}
    
    raw = day.raw_output.lines
    previous_line = ''
    in_spammers = true
    current_user = ''
    current_book = ''
    previous_line = ''
    until raw.empty?
      case line = raw.shift
      when user_expr
        current_user = $1
        if in_spammers
          spammers[current_user] = {}
        else
          clear_users[current_user] = {}
        end
      when book_expr
        current_book = $1
        if in_spammers
          spammers[current_user][current_book] = previous_line.strip
        else
          clear_users[current_user][current_book] = previous_line.strip
        end
      else
        previous_line = line 
      end
      in_spammers = false if previous_line.include?(other_marker)

    end
    day.spammers = spammers
    day.clear_users = clear_users
  end

  def down
    remove_column :oldays, :spammers
    remove_column :oldays, :clear_users
  end
end
