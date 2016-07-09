values_for :number, [6, 12, 30, 1764, 107]

def divs number
	(1..number).to_a.select { |div|
		number % div == 0
	}
end

expects_value :divisors do |number|
	divs number
end

solution do |number|
	divs(number).map(&:to_s).join("\n")
end
