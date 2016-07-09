values_for :number, [17, 64, 1, 2, 31, 666013]

solution do |number|
	result = ""
	nrDiv = 0
	number.times do |i|
		if (number % (i + 1) == 0)
			nrDiv += 1
		end
	end

	if nrDiv == 2
		result = "prime"
	else
		result = "not prime"
	end

	result
end
