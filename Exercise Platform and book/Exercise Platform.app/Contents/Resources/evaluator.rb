require "./testFile.rb"
require "./evaluationResult.rb"
require "./SwiftAst.rb"
require "./XcodeHelper.rb"
require 'securerandom'


def outputForEvaluationResults(evaluationResults)
    return evaluationResults.map { |result| 
        result.toJSON
    }
end

class Evaluator
    attr_accessor :path, 
                  :chapterNumber,
                  :exerciseNumber,
                  :mockedCodePath,
                  :testFilePath,
                  :testFile

    def initialize(chapterNumber,exerciseNumber,testFilePath,codePath=nil)

        self.chapterNumber = chapterNumber
        self.exerciseNumber = exerciseNumber

        if codePath == nil
            self.path = "#{ARGV[3]}/Contents/Resources"
        end

        self.mockedCodePath = codePath
        self.testFilePath = testFilePath
    end

    # The path to the swift file in the playround
    def solutionPath 

        return self.mockedCodePath if self.mockedCodePath

        playgroundName = "Exercise#{chapterNumber}_#{exerciseNumber}.playground"
        playgroundPath = "#{path}/UserPlaygrounds/#{playgroundName}/"

        Dir.foreach(playgroundPath) do |item|
            if item.include? ".swift" 
                next if item.include? "-original"

                file = open(playgroundPath + item).read.strip
                if file and  file.length > 0
                    # puts file
                    return playgroundPath + item
                end
            end
        end

        return nil
    end

    # The code of the solution as entered by the user
    def solutionCode
        return File.open(solutionPath).read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
    end

    def timeLimit
        return 2
    end

    # Evaluate the solution for a TestCase returning an EvaluationResult
    def evaluateSolution(testCase)

        code = solutionCode()

        # PARSE
        ## gets all the variables / constants
        ## finds missing variables
        ## finds typos
        code_info = testCase.parse(code)
        self.testFile.code = code

        # puts JSON.pretty_generate(code_info)


        # HACK
        ## change variable values
        ## adds extra code to check the value of a variable or stuff
        code = testCase.hack(code)

        # RUN
        ## runs the code
        ## gets the exit status
        ## gets the output

        # puts "%" * 100
        # puts code
        # puts JSON.pretty_generate(code_info)

        run_info = run(code)

        # EVAL
        ## based on PARSE, HACK, RUN determines if the solution is correct 
        ## and creates an EvaluationResult
        result = eval(testCase, code_info, run_info)

        return result
    end

    def run(code)
        md5 = Digest::MD5.new
        md5 << code

        codeHASH = md5.hexdigest
        random_string = SecureRandom.hex
        
        tempFilePath = "/var/tmp/ast#{random_string}.swift" # ".tempFile"

        File.open(tempFilePath, "w+") { |io|  io.write(code)}

        output = ""
        info = nil

        exitStatus = -1
        
        status = :executed

        sdkPathOption = ""
        # sdkPath = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/"
        # sdkPath = `xcrun --sdk iphoneos --show-sdk-platform-path`.strip
        
        # if File.exists? sdkPath
        #     sdkPathOption = "-sdk '#{sdkPath}'"
        # end

        swift = swift_2

        cmd = "#{swift} '#{tempFilePath}' #{sdkPathOption} 2> .tempFile2" 
        # puts "#{cmd}"

        thread = Thread.new do
            output = `#{cmd}`

            exitStatus = $?.exitstatus
        end

        thread.join(timeLimit)

        if thread.alive?
            Thread.kill(thread)
            status = :timed_out
        end

        # puts "exitStatus = #{exitStatus}"
        # puts "status = #{status}"
        # puts "code = #{code}"
        # puts "output = #{output}"
        # puts `swift -version`
        # puts "tempFile2 = #{`cat .tempFile2`}"

        if exitStatus != 0 and status == :executed
            if get_ast(code)[:status] == :compilation_error
                status = :compilation_error
            else
                status = :runtime_error
            end
        end

        if exitStatus == 0 
            output, info = output.split("MuchSuperDuperMegaCoolAwesomeHACK\n")
            if output and output.length == 0
                output = nil
            end
        end

        if info != nil
            info = info.lines.map { |line|
                variable, value = line.split("@@#@@")
                {
                    variable => value.strip
                }
            }.reduce({}) { |x, y| x.merge(y) }
        end

        {
            exitStatus: exitStatus,
            status: status,
            output: output,
            info: info
        }
    end

    def eval(testCase, code_info, run_info)
        status = run_info[:status]

        if status == :compilation_error
            result = EvaluationResult.new(:compilation_error)
            result.message = "Error"

            return result
        end

        if status == :timed_out
            result = EvaluationResult.new(:timed_out)
            result.message = "Timed out"
            
            return result
        end

        missingDeclarations = code_info[:missingDeclarations]
        if missingDeclarations.count > 0
            status_sym = :missing_variables

            missingDeclarations.each do |name, message|
                if message["typo"]
                    status_sym = :typo
                end
            end

            result = EvaluationResult.new(status_sym)

            result.message = missingDeclarations.map { |name, message|
                message
            }.join("<br />")

            return result
        end

        wrongFunctionDeclarations = code_info[:wrongFunctionDeclarations]
        if wrongFunctionDeclarations and wrongFunctionDeclarations.count > 0
            status_sym = :wrong_function_definition

            result = EvaluationResult.new(status_sym)

            result.message = code_info[:wrongFunctionDeclarations].map { |info|
                fname = info[:function]
                reason = info[:reason] 
                "<code>#{fname}</code> is not defined correctly! #{reason}"
            }.join("<br />")

            return result
        end


        missingFunctions = code_info[:missingFunctions]
        if missingFunctions.count > 0 
            status_sym = :missing_functions

            result = EvaluationResult.new(status_sym)

            result.message = missingFunctions.map { |name|
                fname = name.split("(").first
                "You did not declare the <code>#{fname}</code> function"
            }.join("<br />")

            return result
        end

        if code_info[:nonRecursiveFunctions]
            if code_info[:nonRecursiveFunctions].count > 0
                status_sym = :not_recursive

                result = EvaluationResult.new(status_sym)

                result.message = code_info[:nonRecursiveFunctions].map { |fname|
                    "<code>#{fname}</code> is not a recursive function"
                }.join("<br />")

                return result
            end
        end

        missingEnums = code_info[:missingEnums]

        if missingEnums.count > 0 
            status_sym = :missing_enums

            result = EvaluationResult.new(status_sym)

            result.message = missingEnums.join("<br />")

            return result
        end

        missingFunctionCalls = code_info[:missingFunctionCalls]


        if missingFunctionCalls.count > 0
            result = EvaluationResult.new(:missing_function_calls)

            result.message = missingFunctionCalls.join("<br />")

            return result
        end

        invalidFunctionCallCounts = code_info[:invalidFunctionCallCounts]

        if invalidFunctionCallCounts.count > 0
            result = EvaluationResult.new(:invalid_function_call_count)

            result.message = invalidFunctionCallCounts.join("<br />")

            return result 
        end

        invalidTypeCounts = code_info[:invalidTypeCounts]

        if invalidTypeCounts.count > 0
            result = EvaluationResult.new(:invalid_type_count)

            result.message = invalidTypeCounts.join("<br />")

            return result 
        end


        output = run_info[:output]

        if testCase.requiresOutput and (output == nil or output.strip.length == 0) and status != :runtime_error
            result = EvaluationResult.new(:no_output)
            result.message = "Your code has no output!"
            result.inputs = testCase.inputs
            result.runInfo = run_info

            return result
        end

        # the test case should decide this one
        correctOutput = testCase.isOutputOK(code_info, run_info)

        if correctOutput
            result = EvaluationResult.new(:correct)
            result.message = "✅"
        else
            result = EvaluationResult.new(:incorrect)
            result.message = "❌"
        end

        if status == :runtime_error
            result = EvaluationResult.new(:runtime_error)
            result.message = "Error"

            # puts "***" * 10
            # puts open(".tempFile2").read
        end


        result.output = output
        result.inputs = testCase.inputs
        result.codeInfo = code_info
        result.runInfo = run_info


        return result
    end

    # evaluate all testcases in a testfile
    def evaluateTestFile
        self.testFile = TestFile.new(testFilePath)

        evaluationResults = batch_process testFile.testCases do |testCase|
            evaluationResult = evaluateSolution(testCase)

            evaluationResult.testCase = testCase

            evaluationResult
        end

        if testFile.afterTestsLambda
            testFile.afterTestsLambda.call(evaluationResults)
        end

        results = outputForEvaluationResults(evaluationResults)

        testFile.process results
    end
end