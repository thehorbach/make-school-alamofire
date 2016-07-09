expects_func "repeatPrint(_:_:)", type: "(String, Int) -> ()"

values_for :message, ["+", "-", "*", "()", "@"]
values_for :cnt,    [1,     3,   5,    7, 10]

add_func_call :repeatPrint, "<%= s message %>, <%= cnt %>", print: false
html_hide [:input]

solution do |message, cnt|
	message * cnt + "\n"
end

