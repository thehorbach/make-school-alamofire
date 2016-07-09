values_for :N, [2, 5, 13, 33, 100]

solution do |n|
	(1..n).to_a.select { |number|
		isFree = true

		div = 2
		while div ** 2 <= number 
			if number % (div ** 2) == 0 
				isFree = false
				break
			end
			div += 1
		end

		isFree
	}.map(&:to_s).join("\n")
end