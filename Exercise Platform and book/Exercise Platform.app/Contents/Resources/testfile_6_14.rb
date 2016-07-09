values_for :number, [6, 12, 30, 1764, 107]

def digits number
	number.to_s.split("").map(&:to_i)
end

expects_value :digits do |number|
	digits number
end

solution do |number|
	digits(number).map(&:to_s).join("\n")
end
