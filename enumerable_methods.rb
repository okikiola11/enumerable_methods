module Enumerable
  def my_each
    return enum_for unless block_given?
    
    i = 0
    while i < self.size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return enum_for unless block_given?
    
    i = 0
    my_each do |item|
      yield(item, i)
      i += 1
    end
  end

  def my_select
    return enum_for unless block_given?

    result = []
    i = 0
    while i < self.size
      result << self[i] if yield(self[i]) == true
      i += 1
    end
  end
end
