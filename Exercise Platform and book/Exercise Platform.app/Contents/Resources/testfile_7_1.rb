expects_func "min2(_:_:)", type: "(Int, Int) -> Int"

values_for :a, [1, 2, 3, 4]
values_for :b, [4, 3, 2, 1]

add_func_call :min2, "<%= a %>, <%= b %>", print: true

html_hide [:input]

solution do |a, b|
	[a, b].min
end

