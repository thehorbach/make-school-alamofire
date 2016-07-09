@__output = ""

def pputs string
	@__output += "#{string}\n"
end

expects_func "applyKTimes(_:_:)", type: "(Int, () -> ()) -> ()"

values_for :swift_code, [
	"{\n    print(\"WeHeartSwift\")\n}",
	"{\n    print(\"Tic\")\n    print(\"Tac\")\n}"
]

values_for :ruby_code, [
	lambda { pputs "WeHeartSwift" },
	lambda { 
		pputs "Tic" 
		pputs "Tac"
	}
]

values_for :times, [
	3,
	4
]

add_func_call :applyKTimes, "<%= times %>, <%= swift_code %>"
html_hide [:input]


solution do |swift_code, ruby_code, times|
	@__output = ""

	times.times do 
		ruby_code.call
	end

	@__output
end
