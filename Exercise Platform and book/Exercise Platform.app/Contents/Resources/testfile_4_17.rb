values_for :number, [24, 15, 7, 720, 120]

solution do |number|
	sol = "#{number} = "

	div = 2
	first = true

	while number > 1 
		while number % div == 0
			number /= div
			if first
				first = false
			else
				sol += " * "
			end
			sol += "#{div}"
		end
		div += 1
	end

	sol
end