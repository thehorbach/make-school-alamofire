expects_func "levelCost(heights:maxJump:)", type: "(heights: [Int], maxJump: Int) -> Int"

values_for :heights, [
	[1, 1, 2, 2, 5, 2, 1, 1],
	[1, 1, 3, 1, 1],
	[1, 1, 8, 1],
	[1, 2, 3, 4, 5, 8, 6, 3, 2, 2, 2, 3, 3],
	[1, 2, 4, 8, 4, 2, 3, 2, 3, 2, 1]
]

values_for :maxJump, [
	3,
	2,
	5,
	3,
	5
]

add_func_call :levelCost, "heights: <%= s heights %>, maxJump: <%= maxJump %>", print: true
html_hide [:input]


solution do |heights, maxJump|
	totalEnergy = 0
	lastHeight = 0

	heights.each do |height|
		if lastHeight != 0 
			diff = (height - lastHeight).abs

			if diff > maxJump
				totalEnergy = -1
				break
			end

			if diff == 0 
				totalEnergy += 1
			else
				totalEnergy += diff * 2
			end
		end
		lastHeight = height
	end

	totalEnergy
end

