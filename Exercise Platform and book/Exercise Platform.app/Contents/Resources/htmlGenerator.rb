require './templates.rb'

def renderTemplate(name,b)
	template = template_named(name)

	return render(template,b)
end

def shouldHide column, results
	results.each do |result|
		if result[:testCase].htmlHide.include? column
			return true
		end
	end

	false
end

def shouldShow column, results
	!shouldHide(column, results)
end

def hasInputs(results)
	return false if shouldHide(:input, results)

	results[0][:inputs] && results[0][:inputs].count > 0
end

def hasOutput(results)
	return false if results[0][:codeInfo] == nil
	return false if results[0][:codeInfo][:expectsOutput] == nil
	return false if shouldHide(:output, results)

	return results[0][:codeInfo][:expectsOutput] 
end

def hasExpectedOutput(results)
	return false if results[0][:codeInfo] == nil
	return false if results[0][:codeInfo][:expectsOutput] == nil
	return false if shouldHide(:expected_output, results)

	return results[0][:codeInfo][:expectsOutput] 
end

def hasYourVariables(results)
	return false if results[0][:codeInfo] == nil
	return false if results[0][:codeInfo][:expectedDeclarations] == nil
	return false if shouldHide(:your_var, results)

	return results[0][:codeInfo][:expectedDeclarations].count > 0
end

def hasExpectedVariables(results)
	return false if results[0][:codeInfo] == nil
	return false if results[0][:codeInfo][:expectedDeclarations] == nil
	return false if shouldHide(:expected_var, results)

	return results[0][:codeInfo][:expectedDeclarations].count > 0
end

def hasFunctionCall(results)
	results.each do |result|
		if result[:testCase].includeFunctionCall
			return true
		end
	end

	false
end

def extraColumnNames results
	testCase = results.first[:testCase]

	testCase.htmlExtra.map { |name, lambda|
		name
	}
end

def extraColumns results
	results.map { |result|
		testCase = result[:testCase]
		runInfo = result[:runInfo]

		testCase.htmlExtra.map { |name, lambda|
			call_lambda lambda, testCase.inputs + [runInfo]
		}
	}.transpose
end

def functionCalls results
	if hasFunctionCall(results) == false
		return nil
	end

	results.map { |result|
		codeInfo = result[:codeInfo]
		syntaxHighlight(codeInfo[:functionCall])
	}
end


def createHeaders(results)
	headers = []

	headers << "Inputs" if hasInputs(results)

	headers  << "Function call" if hasFunctionCall(results)

	headers << "Your Variables" if hasYourVariables(results)
	headers << "Expected Variables" if hasExpectedVariables(results)
	
	headers << "Your Output" if hasOutput(results)
	headers << "Expected Output" if hasExpectedOutput(results)

	headers += extraColumnNames(results)

	headers << "Status"

	return headers
end

def statuses(results)
	results.map do |result| 
		message_map = {
			runtime_error: "Runtime error"
		}

		bad_message = message_map[result[:status]] || 'EMOJI_INCORRECT'

		ret = result[:status] == :correct ? 'EMOJI_CORRECT' : bad_message 
		'<div style="align:center;">' + ret + '</div>'
	end
end

def syntaxHighlight(field)
	"<pre><code class='language-swift code-example'>" + field + "</code></pre>"
end

def codeHighlight(field)
	"""<pre>
<code class='code-example'>#{field}</code>
</pre>"""
end


def inputs(results)
	return nil if !hasInputs(results)

	return results.map do |result|
	
		result[:codeInfo][:substitutedDeclarations].zip(result[:inputs]).map do |b|
			"var #{b[0]} = #{s b[1]}"
		end.join("\n")
	end.map { |e| syntaxHighlight(e) }
end

def yourVariables(results)
	return nil if !hasYourVariables(results)

	# puts results
	# puts results[0][:runInfo]

	return results.map do |result|
		if result[:runInfo] and result[:runInfo][:info]
			result[:runInfo][:info].map do |name, value|
				"var #{name} = #{value}"
			end.join("\n")
		else
			""
		end
	end.map { |e| syntaxHighlight(e) }
end

def expectedVariables(results)
	return nil if !hasExpectedVariables(results)

	if results[0][:codeInfo][:expectedDeclarationValues] == nil
		return results.map { |result|
			result[:codeInfo][:expectedDeclarations].map do |v|
				"var #{v}"
			end.join("\n")
		}.map { |e| 
			syntaxHighlight(e) 
		}
	end

	return results.map do |result|
		result[:codeInfo][:expectedDeclarationValues].map do |name, value|
			"var #{name} = #{value}"
		end.join("\n")
	end.map { |e| syntaxHighlight(e) }
end

def formatOutput(value)
	if value == nil
		return ""
	end
	value = value.gsub(" ","&nbsp;")
	value = value.split("\n").join("<br/>")
	return codeHighlight(value)
end

def expectedOutput(results)
	return nil if !hasExpectedOutput(results)

	return results.map { |e| formatOutput(e[:codeInfo][:expectedOutput]) }
end

def output(results)
	return nil if !hasOutput(results)

	return results.map { |e| formatOutput(e[:output]) }
end

def addRow(rows,row)
	if row != nil and row.count > 0
		rows << row
	end
end

def createRows(results)
	rows = []

	addRow(rows, inputs(results))

	addRow(rows, functionCalls(results))

	addRow(rows, yourVariables(results))
	addRow(rows, expectedVariables(results))

	addRow(rows, output(results))
	addRow(rows, expectedOutput(results))

	extraColumns(results).each do |column|
		addRow(rows, column)
	end

	addRow(rows, statuses(results))

	return rows
end

def createRowClasses(results)

	results.map do |result|
		result[:status] == :correct ? "success" : "danger"
	end

end


def generateTable(results)
	# return ""

	# result now has testCase - will be used for customization

	# puts JSON.pretty_generate(results)

	headers = createHeaders(results)
	rows = createRows(results)
	rowClasses = createRowClasses(results)

	result = renderTemplate("runTable",binding)

	return result
end