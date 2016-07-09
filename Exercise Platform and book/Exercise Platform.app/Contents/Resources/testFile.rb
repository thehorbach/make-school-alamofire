require "./testCase"
require "./htmlGenerator"

class TestFile

    attr_accessor :solution_lambda,
                  :symbols,
                  :values,
                  :expectedDeclarations,
                  :expectedValues,
                  :expectedFunctions,
                  :requiresOutput,
                  :evalLambda,
                  :afterTestsLambda,
                  :htmlGenerator,
                  :code,
                  :beforeERB,
                  :afterERB,
                  :funcCallERB,
                  :floatOutput,
                  :expectedEnums,
                  :expectedFunctionCalls, # Array of [functionCall, message]
                  :expectedFunctionCallCounts, #Array of [functionCall, count, message]
                  :expectedTypeCounts, #Array of [functionCall, count, message]
                  :includeFunctionCall,
                  :htmlHide,
                  :htmlExtra


    def initialize(filePath)
        self.symbols = []
        self.values = []
        self.expectedDeclarations = []
        self.expectedValues = []
        self.expectedFunctions = []
        self.requiresOutput = true
        self.beforeERB = ""
        self.afterERB = ""
        self.funcCallERB = ""
        self.floatOutput = false
        self.expectedEnums = []
        self.expectedFunctionCalls = []
        self.expectedFunctionCallCounts = []
        self.expectedTypeCounts = []
        self.includeFunctionCall = false
        self.htmlHide = []
        self.htmlExtra = []

        instance_eval(open(filePath).read)

    end

    # returns the testcases for the current test file

    def valueFor(expectedValue,inputs,solution)
         case expectedValue
            when Symbol
                return solution
            when Proc
                return call_lambda(expectedValue,inputs).to_s
            else
                return expectedValue
        end
    end

    def testCases
        testCases = []

        if values.count > 0 
            number_of_tests = values[0].count

            number_of_tests.times do |testIndex|
                testCase = TestCase.new

                # add test specific values
                symbols.each_with_index do |symbol, index|
                    test_values = values[index]

                    
                    testCase.declarations << symbol.to_s
                    testCase.inputs << test_values[testIndex]
                end

                init_test testCase

                testCases << testCase
            end
        else
            testCase = TestCase.new

            init_test testCase

            testCases << testCase
        end

        return testCases
    end

    def init_test testCase
        if solution_lambda
            testCase.expectedOutput = call_lambda(solution_lambda,testCase.inputs).to_s
        else
            testCase.expectedOutput = nil
        end

        testCase.beforeERB = beforeERB
        testCase.afterERB = afterERB
        testCase.funcCallERB = funcCallERB
        
        testCase.expectedDeclarations = expectedDeclarations
        testCase.expectedFunctions = expectedFunctions
        testCase.expectedEnums = expectedEnums
        testCase.expectedFunctionCalls = expectedFunctionCalls
        testCase.expectedFunctionCallCounts = expectedFunctionCallCounts
        testCase.expectedTypeCounts = expectedTypeCounts
        testCase.includeFunctionCall = includeFunctionCall
        testCase.htmlHide = htmlHide
        testCase.htmlExtra = htmlExtra

        expectedValues.each do |name, value|
            expected = [name, valueFor(value,
                                      testCase.inputs,
                                      testCase.expectedOutput)]

            testCase.expectedDeclationValues << expected
        end


        testCase.solutionLambda = solution_lambda
        testCase.evalLambda = evalLambda

        testCase.requiresOutput = self.requiresOutput
        testCase.floatOutput = self.floatOutput
    end

    # provides values for a declaration. Each value represents a test case
    def values_for(symbol,test_values)
        symbols << symbol
        values << test_values
    end

    # variable should be defined
    def expects(symbol,message=nil)
        unless message
            message = "You did not declare <code>#{symbol.to_s}</code>"
        end

        expectedDeclarations << [symbol.to_s, message]
    end

    # Symbol should be value after code is executed
    def expects_value(symbol,value=nil,&lambda)
        #array, value or lambda. symbol
        if lambda
            expectedValues << [symbol.to_s,lambda]
            return
        end
        expectedValues << [symbol.to_s,value]
    end

    # a lambda that provides a solution for the problem. i.e. solves the problem given the input data
    def solution(&lambda)
        self.solution_lambda = lambda
    end

    # need to think about this one
    def check_with(&lambda)
        self.evalLambda = lambda
    end

    def has_no_output()
        self.requiresOutput = false
    end

    def expects_func(definition, options = {})
        self.expectedFunctions << [definition, options]
    end

    def test_func(definition, params)
        # params[:with]
    end

    def before template
        self.beforeERB = template
    end
    
    def after template
        self.afterERB = template
    end

    def add_func_call func, params = "", options = {}
        self.includeFunctionCall = true

        func_call = "#{func}(#{params})"

        final_call = func_call

        if options[:call]
            final_call = options[:call]
        end

        if options[:print] 
            final_call = "print(#{final_call})"
        end

        setup = ""
        if options[:setup]
            setup = options[:setup]
        end

        self.funcCallERB = <<-EOF
<% if has_#{func} %>
#{func_call}
<% end %>
        EOF

        self.afterERB = <<-EOF
<% if has_#{func} %>
#{setup}
#{final_call}
<% end %>
        EOF
    end

    def after_tests(&lambda)
        self.afterTestsLambda = lambda
    end

    def html_hide columns
        self.htmlHide = columns
    end

    def html_add name, &lambda
        self.htmlExtra << [name, lambda]
    end

    def html(&lambda)
        self.htmlGenerator = lambda
    end

    def float_output
        self.floatOutput = true
    end

    def expects_enum name, values 
        self.expectedEnums << {
            name: name,
            values: values
        }
    end

    def expects_function_call name, message="You did not call the <code>_FUNCTION_</code> function."
        self.expectedFunctionCalls << [name, message]
    end

    def expects_function_call_count functions, count, message
        if functions.kind_of?(Array) == false
            functions = [functions]
        end

        self.expectedFunctionCallCounts << [functions, count, message]

    end

    def expects_type_count type, count, message
        self.expectedTypeCounts << [type, count, message]
    end

    # HTML Generation

    def process results 

        allOK = true
        message = nil

        results.each do |result|
            status = result[:status]

            if status != :correct
                allOK = false
            end

            if status == :compilation_error
                message = "Compilation Error"
                break
            end

            # if status == :runtime_error
            #     message = "Runtime Error"
            #     break
            # end

            if status == :typo
                message = result[:message]
                break
            end

            if status == :missing_variables
                message = result[:message]
                break
            end

            if status == :missing_functions
                message = result[:message]
                break
            end

            if status == :wrong_function_definition
                message = result[:message]
                break
            end

            if status == :not_recursive
                message = result[:message]
            end

            if status == :missing_function_calls
                message = result[:message]
            end

            if status == :invalid_function_call_count
                 message = result[:message]
            end

            if status == :invalid_type_count
                 message = result[:message]
            end

            if requiresOutput and result[:status] == :no_output
                message = result[:message]
            end

            if status == :missing_enums
                message = result[:message]
            end
        end

        html = ""
        if message == nil
            html = generateTable(results)
            message = ""
        end

    
        return {
                    status: allOK ? 1 : 0,
                    results: results,
                    tests: html,
                    code: code,
                    message: message
               }
    end

end