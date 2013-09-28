class Float
  def to_fraction_s
    "#{numerator}/#{denominator}"
  end
end

class String
  def fraction?
    !!match(/^-?\d+(\/)-?\d+$/)
  end
  
  def eval_fraction
    a, op, b = scan(/(-?\d+)(\/)(-?\d+)/)[0]
    throw ArgumentError.new("'#{self}' is not a valid fraction") unless a.present? && op == "/" && b.present? && b.to_i != 0
    a.to_f / b.to_f
  end
end
