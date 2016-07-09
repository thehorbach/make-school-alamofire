values_for :problem, [
	"split this string into words and print them on separate lines",
	"we heart swift",
	"I like solving problems with this platform",
	"oneword"
]

solution do |problem|
	problem.split.join("\n")
end
