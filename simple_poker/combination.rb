class SimplePoker::Combination
  SUITS = %w(spade heart diamond club)
  KINDS = %w(2 3 4 5 6 7 8 9 T J Q K A)

  attr_reader :cards

  def initialize(combination)
    @cards = combination.sort {|a ,b| KINDS.index(a.kind) <=> KINDS.index(b.kind)}
  end

  def weight
    [flush, straight].compact.max
  end

  private

  def kinds
    @cards.map {|c| c.kind}
  end

  def suits
    @cards.map {|c| c.suit}
  end

  def weight_of(val)
    KINDS.index(val) || 0
  end

  def flush
    if suits.uniq.size == 1
      [
        600000000,
        1000000 * weight_of(kinds[-1]),
        10000 * weight_of(kinds[-2]),
        100 * weight_of(kinds[-3]),
        10 * weight_of(kinds[-4]),
        weight_of(kinds[-5])
      ].reduce(:+)
    end
  end

  def straight
    if kinds.last == "A" && kinds.first == "2"
      values = ["A1"].concat kinds[0..3]
    else
      values = kinds
    end
    if (["A1"] << KINDS).join.include?(values.join)
      [
        500000000,
        1000000 * weight_of(values[-1]),
        10000 * weight_of(values[-2]),
        100 * weight_of(values[-3]),
        10 * weight_of(values[-4]),
        weight_of(values[-5]) # "A1" will return 0
      ].reduce(:+)
    end
  end

end
