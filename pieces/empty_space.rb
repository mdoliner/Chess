class EmptySpace < NilClass

  def self.to_s
    " "
  end

  def self.nil?
    true
  end

  def self.dup
    EmptySpace
  end

  def self.color
    nil
  end

end
