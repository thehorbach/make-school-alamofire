# encoding: UTF-8
# require 'json'

# old_info = JSON.parse(open('old_definitions.json').read)
# new_info = JSON.parse(open('new_definitions.json').read)

# chapters = JSON.parse(open('Chapters.json').read)

# hack = {}

# old_info.zip(new_info).each do |o, n|
# 	name, old_def = o 
# 	name, new_def = n 

# 	# puts "#{name}:\nfrom:\n#{old_def.gsub(/\s/, "")}\nto:\n#{new_def}\n\n"
# 	hack[name] = {
# 		from: old_def,
# 		to: new_def
# 	}

# end

hack = {"minmax"=>{:from=>"func minmax(a: Int, b: Int) -> (Int, Int) {", :to=>"func minmax(a: Int, _ b: Int) -> (Int, Int) {"}, "match"=>{:from=>"func match(first: HandShape, second: HandShape) -> MatchResult {", :to=>"func match(first: HandShape, _ second: HandShape) -> MatchResult {"}, "min2"=>{:from=>"func min2(a: Int, b: Int) -> Int {", :to=>"func min2(a: Int, _ b: Int) -> Int {"}, "parseDigit"=>{:from=>"func parseDigit(digit: String) -> Int {", :to=>"func parseDigit(digit: String) -> Int {"}, "isNumber"=>{:from=>"func isNumber(string: String) -> Bool {", :to=>"func isNumber(string: String) -> Bool {"}, "parseNumber"=>{:from=>"func parseNumber(number: String) -> Int {", :to=>"func parseNumber(number: String) -> Int {"}, "timeDifference"=>{:from=>"func timeDifference(#firstHour: Int, #firstMinute: Int, #secondHour: Int, #secondMinute: Int) -> Int {", :to=>"func timeDifference(firstHour firstHour: Int, firstMinute: Int, secondHour: Int, secondMinute: Int) -> Int {"}, "verifyParentheses"=>{:from=>"func verifyParentheses(expression: String) -> Bool {", :to=>"func verifyParentheses(expression: String) -> Bool {"}, "levelCost"=>{:from=>"func levelCost(#heights: [Int], #maxJump: Int) -> Int {", :to=>"func levelCost(heights heights: [Int], maxJump: Int) -> Int {"}, "push"=>{:from=>"func push(number: Int, inout stack: [Int]) {", :to=>"func push(number: Int, inout _ stack: [Int]) {"}, "pop"=>{:from=>"func pop(inout stack: [Int]) -> Int? {", :to=>"func pop(inout stack: [Int]) -> Int? {"}, "top"=>{:from=>"func top(stack: [Int]) -> Int? {", :to=>"func top(stack: [Int]) -> Int? {"}, "lastDigit"=>{:from=>"func lastDigit(number: Int) -> Int {", :to=>"func lastDigit(number: Int) -> Int {"}, "first"=>{:from=>"func first(N: Int) -> [Int] {", :to=>"func first(N: Int) -> [Int] {"}, "countdown"=>{:from=>"func countdown(N: Int) {", :to=>"func countdown(N: Int) {"}, "divides"=>{:from=>"func divides(a: Int, b: Int) -> Bool {", :to=>"func divides(a: Int, _ b: Int) -> Bool {"}, "countDivisors"=>{:from=>"func countDivisors(number: Int) -> Int {", :to=>"func countDivisors(number: Int) -> Int {"}, "isPrime"=>{:from=>"func isPrime(number: Int) -> Bool {", :to=>"func isPrime(number: Int) -> Bool {"}, "printFirstPrimes"=>{:from=>"func printFirstPrimes(count: Int) {", :to=>"func printFirstPrimes(count: Int) {"}, "repeatPrint"=>{:from=>"func repeatPrint(message: String, count: Int) {", :to=>"func repeatPrint(message: String, _ count: Int) {"}, "reverse"=>{:from=>"func reverse(numbers: [Int]) -> [Int] {", :to=>"func reverse(numbers: [Int]) -> [Int] {"}, "sum"=>{:from=>"func sum(numbers: [Int]) -> Int {", :to=>"func sum(numbers: [Int]) -> Int {"}, "fibonacci"=>{:from=>"func fibonacci(i: Int) -> Int {", :to=>"func fibonacci(i: Int) -> Int {"}, "factorial"=>{:from=>"func factorial(N: Int) -> Int {", :to=>"func factorial(N: Int) -> Int {"}, "digits"=>{:from=>"func digits(number: Int) -> [Int] {", :to=>"func digits(number: Int) -> [Int] {"}, "pow"=>{:from=>"func pow(x: Int, y: Int) -> Int {", :to=>"func pow(x: Int, _ y: Int) -> Int {"}, "gcd"=>{:from=>"func gcd(a: Int, b: Int) -> Int {", :to=>"func gcd(a: Int, _ b: Int) -> Int {"}, "binarySearch"=>{:from=>"func binarySearch(key: Int, numbers: [Int], left: Int = 0, var right: Int = -1) -> Bool {", :to=>"func binarySearch(key: Int, _ numbers: [Int], left: Int = 0, var right: Int = -1) -> Bool {"}, "applyKTimes"=>{:from=>"func applyKTimes(K: Int, closure: () -> ()) {", :to=>"func applyKTimes(K: Int, _ closure: () -> ()) {"}, "forEach"=>{:from=>"func forEach(array: [Int],closure: Int -> ()) {", :to=>"func forEach(array: [Int], _ closure: Int -> ()) {"}, "combineArrays"=>{:from=>"func combineArrays(array1: [Int], array2: [Int], closure: (Int,Int) -> Int) -> [Int] {", :to=>"func combineArrays(array1: [Int], _ array2: [Int], _ closure: (Int,Int) -> Int) -> [Int] {"}}

def functions_from_code code
	begin
		code.lines.select { |line|
			line =~ /\s*func\s+\w+/
		}.map { |func_line|
			func_line.split("(").first.strip.split(/\s+/).last
		}
	rescue 
		[]
	end
end

def fix_function_definitions_with_hack code, functions, hack
	new_code = "#{code}"

	state = :searching

	# :searching
	# :missing_para -> {
	# :found_para
	buffer = ""

	lines = code.lines

	lines.each do |line|
		if line =~ /\s*func\s+\w+/
			buffer = line

			if buffer["{"]
				state = :found_para
			else 
				state = :missing_para
			end
		elsif state == :missing_para
			buffer += line
			if buffer["{"]
				state = :found_para
			end
		end

		if state == :found_para
			definition = buffer.split("{").first 

			# puts "|#{definition}|"

			name = definition.split("(").first.strip.split(/\s+/).last

			if hack[name]
				from = hack[name][:from].gsub("{", "").strip
				to = hack[name][:to].gsub("{", "").strip

				# puts "is:           #{definition}"
				# puts "wanted:       #{from}"
				# puts "destination:  #{to}"
				# puts "def.nospace:  #{definition.gsub(/\s/, "")}"
				# puts "from.nospace: #{from.gsub(/\s/, "")}"

				def_nospace = definition.gsub(/\s/, "")
				from_nospace = from.gsub(/\s/, "")

				if def_nospace == from_nospace
					new_code.gsub!(definition, to + " ")
				end
			end

			state = :searching
		end
	end

	new_code
end

# old_sources = []

# chapters.each do |chapter|
# 	chapter["exercises"].each do |exercise|
# 		if exercise["solutions"]
# 			solution = exercise["solutions"].first
# 			code = solution["codes"].first
# 			content = code["content"]

# 			old_sources << [exercise["title"], content]
# 		else 
# 			exercise["spoilers"].each do |spoiler|
# 				if spoiler["params"]["title"] =~ /[Ss]olution/
# 					spoiler["codes"].each do |code|
# 						content = code["content"]

# 						old_sources << [exercise["title"], content]
# 					end
# 				end
# 			end
# 		end
# 	end
# end

# old_sources.each do |title, code|
# 	chapter, exercise = title.split(" ").first.split(".")

# 	functions = functions_from_code code

# 	if functions.count > 0
# 		puts "=" * 50
# 		puts "#{chapter}.#{exercise}"
# 		puts "\nBEFORE:\n\n"
# 		puts code
# 		puts "\nAFTER:\n\n"
# 		puts fix_function_definitions_with_hack code, functions, hack
# 		puts "-" * 50
# 	end
# end

# puts "#{old_sources.inspect}"

if ARGV.count > 0
	code = open(ARGV.first).read

	code

	functions = functions_from_code code

	if functions.count > 0
		puts fix_function_definitions_with_hack(code, functions, hack)
	else
		puts code
	end
end



