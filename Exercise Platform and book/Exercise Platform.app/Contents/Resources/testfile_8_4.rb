expects_func "pow(_:_:)", recursive: true, type: "(Int, Int) -> Int"

values_for :number, [3, 15, 127, 10, 123]
values_for :power,  [3, 4,  6,   10,   3]


add_func_call :pow, "<%= number %>, <%= power %>", print: true
html_hide [:input]


solution do |number, power|
	number ** power
end

