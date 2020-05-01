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
      my_each { |item| condition = false if item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = false if args.match?(item.to_s) }
    elsif !args.nil?
      my_each { |item| condition = false if item != args }
    else
      my_each { |item| condition = false if item }
    end
    condition
  end

  def my_any?(args = nil)
    condition = false
    if block_given?
      my.each { |item| condition = true if yield(item) == true }
    elsif args.is_a?(Class)
      my_each { |item| condition = true if item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = true if args.match?(item.to_s) }
    elsif args.nil?
      my_each { |item| condition = true if item }
    else
      my_each { |item| condition = true if item == args }
    end
    condition
  end

  def my_none?(args = nil)
    condition = true
    if block_given?
      my_each { |item| condition = false if yield(item) == true }
    elsif !args.nil?
      my_each { |item| condition = false if item != args }
    else
      my_each { |item| condition = true unless item == false }
    end
    condition
  end

  def my_count(args = nil)
    count = 0
    if block_given?
      my_each { |item| count += 1 if yield(item) }
    elsif args
      my_each { |item| count += 1 if item == args }
    else
      count = size
    end
    count
  end

  def my_map(proc = nil)
    return enum_for(:my_map) unless block_given? || proc
    new_array = []
    if proc.nil?
      to_a.my_each { |item| new_array << yield(item) }
    else
      to_a.my_each { |item| new_array << proc.call(item) }
    end
    new_array
  end

  def my_inject(initial_arg = nil, sym = nil)
    arr = to_a
    if initial_arg.nil?
      accumulator = arr[0]
      arr[1..-1].my_each { |item| accumulator = yield(accumulator, item) }
    elsif initial_arg && sym
      accumulator = initial_arg
      arr.my_each { |item| accumulator = accumulator.send(sym, item) }
    elsif block_given? && initial_arg.is_a?(Integer)
      accumulator = initial_arg
      arr.my_each { |item| accumulator = yield(accumulator, item) }
    else
      accumulator = arr[0]
      arr[1..-1].my_each { |item| accumulator = accumulator.send(initial_arg, item) }
    end
    accumulator
  end
end

def multiply_els(array)
  array.my_inject(:*)
end
