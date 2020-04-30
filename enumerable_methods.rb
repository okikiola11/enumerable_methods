module Enumerable
  def my_each
    return enum_for(:my_each) unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return enum_for(:my_each_with_index) unless block_given?

    i = 0
    my_each do |item|
      yield(item, i)
      i += 1
    end
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    result = []
    i = 0
    while i < size
      result << self[i] if yield(self[i]) == true
      i += 1
    end
  end

  def my_all?(args = nil)
    condition = true
    if block_given?
      my_each { |item| condition = false if yield(item) == false }
    elsif args.is_a?(Class)
      my_each { |item| condition = false unless item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = false unless args.match?(item.to_s) }
    elsif args.nil? == false
      my_each { |item| condition = false if item != args }
    else
      my_each { |item| condition = false unless item == true }
    end
    condition
  end

  def my_any?(args = nil)
    condition = false
    if block_given?
      my.each { |item| condition = true if yield(item) == true }
    elsif args.is_a?(Class)
      my_each { |item| condition = true unless item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = true unless args.match?(item.to_s) }
    elsif args.nil? == false
      my_each { |item| condition = true if item != args }
    else
      my_each { |item| condition = true unless item == false }
    end
    condition
  end

  def my_none?(args = nil)
    condition = true
    if block_given?
      my_each { |item| condition = false if yield(item) == true }
    elsif args.nil? == false
      my_each { |item| condition = false if item != args }
    else
      my_each { |item| condition = true unless item == false }
    end
    condition
  end
end
