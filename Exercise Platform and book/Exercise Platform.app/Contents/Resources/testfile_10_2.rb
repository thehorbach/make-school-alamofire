expects_func "minmax(_:_:)", type: "(Int, Int) -> (Int, Int)"

values_for :a, [1, 4, 7, 2, 7]
values_for :b, [2, 3, 7, 8, 3]

add_func_call :minmax, "<%= a %>, <%= b %>", print: true
html_hide [:input]


solution do |a, b|
	min = [a, b].min
	max = [a, b].max

	s Tuple.new([min, max])
end
