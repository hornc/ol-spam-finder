class Olday < ActiveRecord::Base
  OTHER_MARKER = 'OTHER ADDITIONS:'
  USER_EXPR = /^\/(people\/.+)$/

  def previous_path
   (self.date - 1).strftime("/%Y-%m/%d")
  end

  def next_path
   (self.date + 1).strftime("/%Y-%m/%d")
  end

# returns a array of spammer accounts
  def spammers
    @spammers ||= get_spammers
  end

  def get_spammers
    raw = self.raw_output.lines
    previous_line = ''
    spammers = []
    until raw.empty? || previous_line.include?(OTHER_MARKER)
      case line = raw.shift
      when USER_EXPR
        spammers << $1
      else
        previous_line = line
      end
    end
    spammers
  end

  def good_users
    @good_users ||= get_good_users
  end

  def get_good_users
    raw = self.raw_output.lines
    good = []
    in_section = false
    until raw.empty?
      line = raw.shift
      in_section = true if line.include?(OTHER_MARKER)
      if in_section && line.match(USER_EXPR)
        good << "/#{$1}"
      end
    end
    good
  end
end
