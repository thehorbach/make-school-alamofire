values_for :number, [1000, 123, 123321, 6453, 1337]

solution do |number|
	number.to_s.reverse
end