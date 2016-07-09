values_for :hack, Array.new(20, 0)

check_with do |hack, run_info|
	output = run_info[:output].strip
	output == "heads" or output == "tails"
end

after_tests do |results|
	allOK = true

	results.each do |result|
		if result.status != :correct
			allOK = false
			break
		end
	end

	first_result = results.first

	if allOK
		if results.map(&:output).uniq.count == 2
			results.shift(results.count)

			result = EvaluationResult.new(:correct)
            result.message = "Good job!"
	        result.testCase = first_result.testCase

			results << result
        else
			results.shift(results.count)

            result = EvaluationResult.new(:incorrect)
            result.message = "Not a fair coin!"
	        result.testCase = first_result.testCase

			results << result
		end
	else
		results.shift(results.count)

        result = EvaluationResult.new(:incorrect)
        result.message = "Something is wrong.."
        result.testCase = first_result.testCase

		results << result
	end
end
