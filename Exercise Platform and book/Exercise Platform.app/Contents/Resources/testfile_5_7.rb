values_for :problem, [
	"find the longest word in the problem description",
	"we heart swift",
	"I like solving problems with this platform",
	"oneword"
]

solution do |problem|
	res = ""

	problem.split.each do |word|
		if word.length > res.length
			res = word
		end
	end

	res
end
