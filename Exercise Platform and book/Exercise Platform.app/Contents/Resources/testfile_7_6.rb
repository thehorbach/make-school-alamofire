expects_func "printFirstPrimes(_:)", type: "(Int) -> ()"

values_for :number, [1, 3, 5, 7, 10]


add_func_call :printFirstPrimes, "<%= number %>", print: false
html_hide [:input]


require 'prime'

solution do |number|
	(1..10+number**2).to_a.select { |nr|
		Prime.prime? nr
	}.take(number).map(&:to_s).join("\n")
end

