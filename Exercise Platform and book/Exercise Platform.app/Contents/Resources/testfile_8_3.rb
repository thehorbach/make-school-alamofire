expects_func "digits(_:)", recursive: true, type: "(Int) -> [Int]"

values_for :number, [3, 15, 127, 1000, 123654789]

add_func_call :digits, "<%= number %>", print: true
html_hide [:input]



solution do |number|
	s number.to_s.split("").map(&:to_i)
end

