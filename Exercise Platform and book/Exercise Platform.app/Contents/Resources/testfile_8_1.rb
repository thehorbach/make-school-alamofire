expects_func "fibonacci(_:)", recursive: true, type: "(Int) -> Int"

values_for :number, [3, 5, 7, 10, 23]

def fibo index 
	if index <= 2 
		1
	else
		fibo(index - 1) + fibo(index - 2)
	end
end

add_func_call :fibonacci, "<%= number %>", print: true
html_hide [:input]

solution do |number|
	fibo number
end

