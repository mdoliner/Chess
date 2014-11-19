class EmptySpace < NilClass

  def self.to_s
    " "
  end

  def self.nil?
    true
  end

  def self.dup
    nil
  end

end
