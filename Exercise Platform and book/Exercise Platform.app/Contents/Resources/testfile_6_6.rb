values_for :listOfNumbers, [
	[1, 1, 1],
	[1, 4, 2, 3, 5, 1],
	[2, 5, 7, 23],
	[55, 66, 23, 31, 42],
	[43, 25, 57, 28, 93]
]

expects_value :listOfNumbers, :solution

expects_type_count "[Int]", 1, "You have declared an additional array."

solution do |listOfNumbers|
	listOfNumbers.reverse
end

has_no_output