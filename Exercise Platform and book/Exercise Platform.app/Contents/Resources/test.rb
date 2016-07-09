# require "./utils.rb"

def pathFor(chapter,exercise,fileName="solution.swift")
	return "./Tests/Chapter#{chapter}/Exercise#{exercise}/#{fileName}"
end

def testFileFor(chapter,exercise)
	return "testfile_#{chapter}_#{exercise}.rb"
end

def has_testfile(chapter, exercise)
	File.exists?(testFileFor(chapter, exercise))
end

def runTest(chapterNumber,exerciseNumber,path=nil,testPath=nil)
	unless has_testfile(chapterNumber, exerciseNumber) 
		puts "No Testfile for ch. #{chapterNumber} ex. #{exerciseNumber}"
		return
	end

	if (path == nil)
		path = pathFor(chapterNumber,exerciseNumber)
	end

	if (testPath == nil)
		testPath = testFileFor(chapterNumber,exerciseNumber)
	end

	output = `ruby evaluateExercise.rb -DEBUG #{chapterNumber} #{exerciseNumber} #{testPath} #{path}`

	output		
end

only_chapter = nil

if ARGV.count == 3
	chapter, exercise, path = ARGV
	puts runTest(chapter, exercise, pathFor(chapter,exercise,path))
	exit
end

if ARGV.count == 2
	chapter, exercise = ARGV
	puts runTest(chapter, exercise)
	exit
end

if ARGV.count == 1
	only_chapter = ARGV[0]
end


to_run = []

Dir.foreach("./Tests") do |chapter|
	if chapter.include?("Chapter")
		if only_chapter and chapter[/[0-9]+/] != only_chapter
			next
		end

		Dir.foreach("./Tests/#{chapter}") do |exercise|
			if exercise.include?("Exercise")
				Dir.foreach("./Tests/#{chapter}/#{exercise}") do |test|

					if test.include?(".swift")

						chapterNumber = chapter[/[0-9]+/]
						exerciseNumber = exercise[/[0-9]+/]
						path = "./Tests/#{chapter}/#{exercise}/#{test}"

						if open(path).read.strip.length == 0
							next
						end

						to_run << [chapterNumber,exerciseNumber,path]
					end
				end
			end
		end
	end
end

to_run.each do |chapterNumber, exerciseNumber, path|
	puts runTest(chapterNumber,exerciseNumber,path)
end
	
