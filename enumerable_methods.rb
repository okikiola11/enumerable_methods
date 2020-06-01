# rubocop:disable Metrics/ModuleLength
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
    my_each { |item| result.push(item) if yield(item) }
    result
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_all?(args = nil)
    if block_given?
      my_each { |item| return false unless yield(item) }
    elsif args.nil?
      my_each { |item| return false unless item }
    elsif args.is_a?(Class)
      my_each { |item| return false unless item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| return false unless args.match?(item.to_s) }
    else
      my_each { |item| return false if item != args }
    end
    true
  end

  def my_any?(args = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
    elsif args.nil?
      my_each { |item| return true if item }
    elsif args.is_a?(Class)
      my_each { |item| return true if item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| return true if args.match?(item.to_s) }
    else
      my_each { |item| return true if item == args }
    end
    false
  end

  def my_none?(args = nil)
    condition = true
    if block_given?
      my_each { |item| condition = false if yield(item) == true }
    elsif args.is_a?(Class)
      my_each { |item| condition = false if item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = false if args.match?(item.to_s) }
    elsif args.nil?
      my_each { |item| condition = false if item }
    else
      my_each { |item| condition = false if item == args }
    end
    condition
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
# rubocop:enable Metrics/ModuleLength

def multiply_els(array)
  array.my_inject(:*)
end
