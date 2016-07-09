expects_func "lastDigit(_:)", type: "(Int) -> Int"

values_for :_number, [1001, 2000, 0, 4321, 369]


add_func_call :lastDigit, "<%= _number %>", print: true
html_hide [:input]


solution do |number|
	number % 10
end

