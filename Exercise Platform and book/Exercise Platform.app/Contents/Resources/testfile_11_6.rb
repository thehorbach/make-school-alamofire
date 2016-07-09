first_names = %w{ Calvin Garry Leah Sonja Noel Andrei Silviu Claudiu Alex }
last_names = %w{ Newton Mckenzie Rivera Moreno Bowen Puni Pop Smith Doe }

peoples = first_names.zip(last_names).map { |f, l|
	{
		"firstName" => f,
		"lastName" => l,
		"score" => f.length
	}
}

values_for :people, [
	peoples[1..3],
	peoples[3..-1],
	peoples[2..-2],
	peoples[0..-3],
	peoples[2..5]
]

solution do |people|
	sol = ""

	people.sort { |x, y| 
		y["score"] <=> x["score"]
	}.each_with_index do |person, index|
		sol += "#{index + 1}. #{person["firstName"]} #{person["lastName"]}\n"
	end

	sol
end

check_with do |people, info|
	user_out = info[:output]

	userboard = user_out.lines.map { |line|
		index, name_score = line.split(". ")
		name, score = name_score.split(" - ")

		{
			index: index.to_i,
			name: name,
			score: score.to_i
		}
	}

	sol = ""

	people.sort { |x, y| 
		y["score"] <=> x["score"]
	}.each_with_index do |person, index|
		sol += "#{index + 1}. #{person["firstName"]} #{person["lastName"]} - #{person["score"]}\n"
	end

	leaderboard = sol.lines.map { |line|
		index, name_score = line.split(". ")
		name, score = name_score.split(" - ")

		{
			index: index.to_i,
			name: name,
			score: score.to_i
		}
	}

	if leaderboard.count != userboard.count 
		false
	else
		isOK = true
		
		leaderboard.zip(userboard).each do |l, u|
			if l[:score] != u[:score]
				isOK = false
				break
			end
		end

		isOK 
	end
end