class Olday < ActiveRecord::Base

  def previous_path
   (self.date - 1).strftime("/%Y-%m/%d")
  end

  def next_path
   (self.date + 1).strftime("/%Y-%m/%d")
  end

# returns a array of spammer accounts
  def spammers
    raw = self.raw_output
    output = raw.lines
    previous_line = ''
    spammers = []
    until output.empty? || previous_line.include?('OTHER ADDITIONS:')
      case line = output.shift
      when /^\/(people\/.+)$/
        spammers << $1
      else
        previous_line = line
      end
    end
    spammers
  end
end
