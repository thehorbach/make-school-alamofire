values_for :listOfNumbers, [
	[1, 1, 1],
	[1, 4, 2, 3, 5, 1],
	[2, 5, 7, 23],
	[55, 66, 23, 31, 42],
	[43, 25, 57, 28, 93]
]

values_for :otherNumbers, [
	[2, 3, 4],
	[3, 5, 1, 6],
	[2, 1, 5, 7, 12],
	[11, 55, 66, 42, 32],
	[57, 28, 93, 1, 1, 1]
]

solution do |listOfNumbers, otherNumbers|
	(listOfNumbers & otherNumbers).map(&:to_s).join("\n")
end

check_with do |listOfNumbers, otherNumbers, info|
	output = info[:output] || ""

	user_sol = output.lines.map(&:to_i).sort
	expected = (listOfNumbers & otherNumbers).sort

	solved = user_sol == expected

	if output.strip == "" 
		solved = expected.count == 0
	end

	solved
end

has_no_output