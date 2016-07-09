values_for :strings, [
	"We heart Swift".split,
	"We all heart Swift so much ".split,
	"hello world".split,
	"oneword".split
]

expects_function_call "reduce"

solution do |strings|
	strings.join(" ")
end