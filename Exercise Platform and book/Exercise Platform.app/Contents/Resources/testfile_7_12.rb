expects_func "verifyParentheses(_:)", type: "(String) -> Bool"

values_for :test, [
	")()()",
	"(())",
	"((()())())",
	"(((()))()()",
	"()()()()",
	"(())())"
]

add_func_call :verifyParentheses, "<%= s test %>", print: true
html_hide [:input]


solution do |test|
	open = 0
	closed = 0

	allOK = true
	
	test.split("").each do |ch|
		if ch == "("
			open += 1
		else
			closed += 1

			if open < closed
				allOK = false
				break
			end
		end
	end

	if allOK
		allOK = open == closed
	end

	s allOK
end

