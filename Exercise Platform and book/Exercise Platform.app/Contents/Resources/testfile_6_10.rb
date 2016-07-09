values_for :listOfNumbers, [
	[1, 6, 16],
	[1, 4, 2, 3, 5, 1],
	[2, 15, 7, 21, 23],
	[55, 66, 23, 31, 84],
	[84, 13, 22, 55, 114]
]

values_for :divisors, [
	[2, 3, 4],
	[3, 5, 6],
	[2, 5, 7],
	[11, 55, 66, 42, 32],
	[33, 99]
]

solution do |listOfNumbers, divisors|
	listOfNumbers.select { |number|
		divisors.select { |divisor|
			number % divisor == 0
		}.count >= 1
	}.map(&:to_s).join("\n")
end

check_with do |listOfNumbers, divisors, info|
	output = info[:output] || ""

	user_sol = output.lines.map(&:to_i).sort

	expected = 	listOfNumbers.select { |number|
		divisors.select { |divisor|
			number % divisor == 0
		}.count >= 1
	}.sort

	solved = user_sol == expected

	if output.strip == "" 
		solved = expected.count == 0
	end

	solved
end

has_no_output