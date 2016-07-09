expects_func "first(_:)", type: "(Int) -> [Int]"

values_for :_number, [1, 3, 5, 7, 10]


add_func_call :first, "<%= _number %>", print: true
html_hide [:input]


solution do |number|
	s (1..number).to_a
end

