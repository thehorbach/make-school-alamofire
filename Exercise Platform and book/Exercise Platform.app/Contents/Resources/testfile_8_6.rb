expects_func "binarySearch(_:_:left:right:)", recursive: true, type: "(Int, [Int], left: Int, right: Int) -> Bool"

values_for :numbers, [
	[1, 3, 4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18, 19, 20],
	[1, 3, 4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18, 19, 20],
	[1, 3, 4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18, 19, 20],
	[1, 3, 4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18, 19, 20],
	[1, 3, 4, 6, 7, 8, 9, 10, 11, 13, 14, 16, 17, 18, 19, 20]
]

values_for :number, [
	1,
	2, 
	4,
	15,
	23
]

add_func_call :binarySearch, "<%= number %>, <%= numbers %>", print: true
html_hide [:input]


solution do |numbers, number|
	s numbers.include?(number)
end

