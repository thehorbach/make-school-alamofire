expects_func "divides(_:_:)", type: "(Int, Int) -> Bool"
expects_func "countDivisors(_:)", type: "(Int) -> Int"
expects_func "isPrime(_:)", type: "(Int) -> Bool"

values_for :number, [1, 3, 5, 7, 10]

add_func_call :isPrime, "<%= number %>", print: true
html_hide [:input]


require 'prime'

solution do |number|
	s Prime.prime?(number)
end

