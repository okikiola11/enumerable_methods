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
    i = 0
    while i < size
      result << self[i] if yield(self[i]) == true
      i += 1
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_all?(args = nil)
    condition = true
    if block_given?
      my_each { |item| condition = false if yield(item) == false }
    elsif args.is_a?(Class)
      my_each { |item| condition = false unless item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = false unless args.match?(item.to_s) }
    elsif !args.nil?
      my_each { |item| condition = false if item != args }
    else
      my_each { |item| condition = false unless item == true }
    end
    condition
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_any?(args = nil)
    condition = false
    if block_given?
      my.each { |item| condition = true if yield(item) == true }
    elsif args.is_a?(Class)
      my_each { |item| condition = true unless item.is_a?(args) }
    elsif args.is_a?(Regexp)
      my_each { |item| condition = true unless args.match?(item.to_s) }
    elsif !args.nil?
      my_each { |item| condition = true if item != args }
    else
      my_each { |item| condition = true unless item == false }
    end
    condition
  end

  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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

  # rubocop:disable Performance/RedundantBlockCall
  def my_map(&proc)
    return enum_for(:my_map) unless block_given?

    new_array = []
    my_each do |item|
      new_array << proc.call(item)
    end
    new_array
  end
  # rubocop:enable Performance/RedundantBlockCall

  def my_inject(args = nil) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    reducer = args[0] if args[0].is_a?(Integer)

    if block_given?
      accumulator = 0
      my_each { |item| accumulator = yield(accumulator, item) }
      accumulator
    elsif block_given? && args[0].is_a?(Integer)
      accumulator = args[0]
      my_each { |item| accumulator = yield(accumulator, item) }
      accumulator
    elsif args[0].is_a?(Symbol)
      my_each { |item| reducer = reducer ? reducer.send(args[0], item) : item }
      reducer
    elsif args[0] && args[1].is_a?(Symbol)
      my_each { |item| reducer = reducer ? reducer.send(args[1], item) : item }
      reducer
    end
  end
end

def multiply_els(array)
  array.my_inject(:*)
end
# rubocop:enable Metrics/ModuleLength
