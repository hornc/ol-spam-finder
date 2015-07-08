class Olday < ActiveRecord::Base

  def previous_path
   (self.date - 1).strftime("/%Y-%m/%d")
  end

  def next_path
   (self.date + 1).strftime("/%Y-%m/%d")
  end
end
