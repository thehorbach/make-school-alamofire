expects_func "factorial(_:)", recursive: true, type: "(Int) -> Int"

values_for :_nr, [3, 5, 7, 10, 12]

def fact index 
	if index == 1 
		1
	else
		fact(index - 1) * index
	end
end


add_func_call :factorial, "<%= _nr %>", print: true
html_hide [:input]

solution do |number|
	fact number
end

