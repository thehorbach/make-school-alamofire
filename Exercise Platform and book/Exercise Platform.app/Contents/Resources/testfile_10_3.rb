expects_enum :HandShape, [
	:Rock,
	:Paper,
	:Scissors
]

expects_enum :MatchResult, [
	:Win,
	:Draw,
	:Lose
]

expects_func "match(_:_:)", type: "(HandShape, HandShape) -> MatchResult"

values_for :first, [
	:Rock,
	:Paper,
	:Scissors,
	:Rock,
	:Paper
]

values_for :second, [
	:Rock,
	:Rock,
	:Scissors,
	:Scissors,
	:Paper
]

add_func_call :match, "<%= s first %>, <%= s second %>", {
	print: true,
	call: "toString(match(<%= s first %>, <%= s second %>))",
	setup: <<-EOF
		func toString(result: MatchResult) -> String {
			if result == .Win {
				return ".Win"
			} 
			if result == .Lose {
				return ".Lose"
			} 
			if result == .Draw {
				return ".Draw"
			} 

			return ""
		} 
	EOF
}

html_hide [:input]

solution do |first, second|
	sol = :Draw

	if first != second 
		sol = :Lose

		if first == :Rock and second == :Scissors
			sol = :Win
		end

		if first == :Paper and second == :Rock
			sol = :Win
		end

		if first == :Scissors and second == :Paper
			sol = :Win
		end
	end

	s sol
end
