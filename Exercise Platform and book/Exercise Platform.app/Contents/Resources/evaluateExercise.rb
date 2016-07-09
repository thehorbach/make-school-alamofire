# encoding: utf-8
Dir.chdir(File.dirname(__FILE__))
require "json"
require "./utils.rb"
require "./evaluator.rb"

if ARGV[0] == "-DEBUG"
	evaluator = Evaluator.new(ARGV[1],ARGV[2],ARGV[3],ARGV[4])

	result = evaluator.evaluateTestFile()

	expected_outcoume = expected_status ARGV[4]

	allOK = true

	result[:results].each do |res|
		if res[:status].to_s != expected_outcoume.to_s
			allOK = false
			break
		end
	end
	
	if allOK
		print "✅"
	else
		print "❌"
	end

	firstRes = allOK ? result[:results].first[:status] : result[:results].map { |res|
		res[:status]
	}

	
	puts "  - ch #{ARGV[1]} ex #{ARGV[2]} - #{ARGV[4]} | #{firstRes}"

	# puts JSON.pretty_generate(result)
else
	sleep 0.1

	chapter = ARGV[1]
	exercise = ARGV[2]
	mainBundle = ARGV[3]
		
	testFilePath = mainBundle + "/Contents/Resources/testfile_#{chapter}_#{exercise}.rb"

	codeFolder = mainBundle + "/Contents/Resources/Exercise#{chapter}_#{exercise}.playground/"

	# get all the swift files from the playground 
	codePath = Dir[codeFolder + "*.swift"].select { |file| 
		# remove all that have original in name
		file.include?("original") == false 
	}.sort {|x, y| 
		# take the one changed last
		File.mtime(y) <=> File.mtime(x) 
	}.first

	# puts "codePath = #{codePath}"

	evaluator = Evaluator.new(ARGV[1],ARGV[2],testFilePath)

	result = evaluator.evaluateTestFile()


	puts JSON.pretty_generate(result)
end
