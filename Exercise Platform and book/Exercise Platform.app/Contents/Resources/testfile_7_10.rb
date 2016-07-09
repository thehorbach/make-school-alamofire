expects_func "parseDigit(_:)", type: "(String) -> Int"
expects_func "isNumber(_:)", type: "(String) -> Bool"
expects_func "parseNumber(_:)", type: "(String) -> Int"

values_for :_string, [
	"a",
	"123",
	"1",
	"0",
	"",
	"50",
	"123a"
]


add_func_call :parseNumber, "<%= s _string %>", print: true
html_hide [:input]

solution do |string|
	if string.to_i.to_s == string
		string.to_i
	else
		-1
	end
end

