values_for :strings, [
	["tuples", "are", "awesome", "tuples", "are", "cool", "tuples", "tuples", "tuples", "shades"],
	["this", "exercise", "is", "so", "hard"],
	["a", "a", "b", "a", "b", "ab"],
	["I", "heart", "swift", "so", "much", "it", "makes", "me", "go", "swift"],
	["to", "swift", "or", "not", "to", "swift", "that", "is", "not", "a", "question"]
]

expects :countedStrings

html_hide [:your_var, :expected_var]

html_add "Your Result" do |strings, runInfo|
	info = runInfo[:info]

	countedStringsInfo = info["countedStrings"].strip

	if countedStringsInfo[0] == "[" and countedStringsInfo[-1] == "]"
		stringsInfo = countedStringsInfo[1..-2]

		formated = "[" + 
		stringsInfo.split(")").map { |x| 
			x.split("(").last
		}.map { |tuple|
			tuple.split(", ")
		}.map { |string, count|
			"(#{string.inspect}, #{count})"
		}.join(", ") + "]"

		syntaxHighlight(formated)
	else
		syntaxHighlight("")
	end
end

html_add "Example Solution" do |strings|
	uniqStrings = strings.uniq

	freq = uniqStrings.map { |s|
		strings.select { |os| os == s }.count
	}

	syntaxHighlight(s(uniqStrings.zip(freq).map { |tuple|
		Tuple.new(tuple)
	}))
end

check_with do |strings, runInfo|
	begin
		uniqStrings = strings.uniq

		freq = uniqStrings.map { |s|
			strings.select { |os| os == s }.count
		}

		sol =  Hash[uniqStrings.zip(freq)]

		isOK = true

		userSol = runInfo[:info]["countedStrings"][1..-3].split("), ").map { |t|
			t = t[1..-1]

			s, fr = t.split(", ")

			if s[0] == '"'
				s.gsub!('"', "")
			end

			[s, fr.to_i]
		}

		userSol.each do |s, fr|
			if sol[s] == nil
				isOK = false
				break
			end

			if sol[s] != fr
				isOK = false
				break
			end				
		end


		isOK 	
	rescue Exception => e
		false
	end
	
end

has_no_output