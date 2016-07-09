values_for :numbers, [
	[1, 2, 3, 4, 6, 8, 9, 3, 12, 11],
	[1, 2, 3, 4, 5, 6, 7],
	[3, 3, 6, 7, 6, 3, 9],
	[1, 2, 5, 7, 13],
	[3, 3, 12, 2, 1, 3, 18]
]

expects_function_call "reduce"

solution do |numbers|
	s numbers.max
end

