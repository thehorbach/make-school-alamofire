@__output = ""

def pputs string
	@__output += "#{string}\n"
end

expects_func "forEach(_:_:)", type: "([Int], Int -> ()) -> ()"

values_for :swift_code, [
	"{\n    print($0)\n}",
	"{\n    print($0 * 2)\n}",
	"{\n    print($0 * $0)\n}",
	"{\n    print($0 + 1)\n}",
	"{
	if $0 % 3 == 0 && $0 % 5 == 0 {
		print(\"Fizz Buzz\")
	} else if $0 % 3 == 0 {
		print(\"Fizz\")
	} else if $0 % 5 == 0 {
		print(\"Buzz\") 
	} else {
		print($0)
	}\n}"
]

values_for :ruby_code, [
	lambda { |x| pputs x },
	lambda { |x| pputs x * 2 },
	lambda { |x| pputs x * x },
	lambda { |x| pputs x + 1 },
	lambda { |x| 
		if x % 3 == 0 and x % 5 == 0
			pputs "Fizz Buzz"
		elsif x % 3 == 0 
			pputs "Fizz"
		elsif x % 5 == 0
			pputs "Buzz"
		else
			pputs x 
		end
	}
]

values_for :numbers, [
	[1, 2, 3, 4, 6, 8, 9, 3, 12],
	[1, 2, 3, 4, 5, 6, 7],
	[3, 3, 6, 7, 6, 3, 9],
	[1, 2, 5, 7, 13],
	[1, 2, 3, 4, 5, 6, 7, 15]
]

add_func_call :forEach, "<%= numbers %>, <%= swift_code %>"
html_hide [:input]



solution do |swift_code, ruby_code, numbers|
	@__output = ""

	numbers.each do |x|
		ruby_code.call(x)
	end

	@__output
end
