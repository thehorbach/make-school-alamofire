expects_func "reverse(_:)", type: "([Int]) -> [Int]"

values_for :numbers, [
	[1, 2, 3],
	[1, 1, 1],
	[1, 3, 5, 7, 9],
	[1, 1, 2, 2, 3, 3, 4, 4, 5, 5],
	[10, 20, 30, 40, 50]
]


add_func_call :reverse, "<%= s numbers %>", print: true
html_hide [:input]


solution do |numbers|
	s numbers.reverse
end

