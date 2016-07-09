require './filter.rb'
require 'erb'
require './SwiftAst.rb'
require "open3"


require 'digest'

class TestCase
    attr_accessor :declarations,
                  :inputs,
                  :expectedOutput,
                  :expectedDeclarations,
                  :expectedDeclationValues,
                  :expectedFunctions,
                  :requiresOutput,
                  :solutionLambda,
                  :evalLambda,
                  :beforeERB,
                  :afterERB,
                  :parseInfo,
                  :floatOutput,
                  :expectedEnums,
                  :expectedFunctionCalls,
                  :functionCalls,
                  :expectedFunctionCallCounts,
                  :expectedTypeCounts,
                  :includeFunctionCall,
                  :funcCallERB,
                  :htmlHide,
                  :htmlExtra


    def initialize
        self.declarations = []
        self.inputs = []
        self.expectedDeclarations = []
        self.expectedDeclationValues = []
        self.expectedFunctions = []
        self.expectedEnums = []
        self.expectedFunctionCalls = []
        self.expectedFunctionCallCounts = []
        self.expectedTypeCounts = []
        self.requiresOutput = true
        self.floatOutput = false
    end

    def to_s
        return "declarations #{declarations}
                inputs #{inputs}
                expectedOutput #{expectedOutput}
                expectedDeclarations #{expectedDeclarations}
                expectedDeclationValues #{expectedDeclationValues}
               "
    end

    # Substitute variables in code with values from the test case
    def substituteDeclarations(code)
        
        # variableRegex = /(^(?<full_match>\s*(?<decl>let|var)\s+(?<name>\w+)(:\s*(?<type>(\w+|\[[^=]+\])))?\s*=\s*(?<value>([0-9.f]+)|(\"[^\"]*\")|(\[[^\[]*\])|(\([^\)]*\)|(\w+)))))/m

        variableRegex = /(^(?<full_match>\s*(?<decl>let|var)\s+(?<name>\w+)(:\s*(?<type>(\w+|\[[^=]+\])))?\s*=\s*(?<value>([0-9.f]+)|(\"[^\"]*\")|(\[[^\[]*\])|(\([^\)]*\)|(\w+)|(\[.*\])))))/m

        # variableRegex = /(^(?<full_match>\s*(?<decl>let|var)\s+(?<name>\w+)(:\s*(?<type>(\w+|\[[^=]+\])))?\s*=\s*(?<value>([0-9.f]+)|(\"[^\"]*\")|(\[.*\])|(\([^\)]*\)|(\w+)))))/m

        toReplace = []

        declarationsHash = Hash[declarations.map.with_index.to_a] 

        code.scan(variableRegex) do |match|
            full_match, decl, name, type, value = match

            full_match.strip!

            # regex is not that good at parsing code - need to trim after first empty line
            if full_match.lines.select { |x| x.strip.length == 0 }.count > 0
                # puts "found a boo boo!"
                old_value = value.clone

                new_value = ""

                value.lines.each do |line|
                    if line.strip.length > 0 
                        new_value += line
                    else 
                        break
                    end
                end

                # puts "\nbefore:\n"
                # puts full_match

                full_match.gsub!(old_value, new_value)
                value = new_value

                # puts "\nafter:\n"
                # puts full_match
            end

            typeInfo = ""
            if type and type.length > 0
                typeInfo = ":#{type}"
            end

            if declarationsHash[name]
                index = declarationsHash[name]
                newValue = inputs[index]

                toReplace << [
                    full_match, 
                    "#{decl} #{name}#{typeInfo} = #{s newValue}"
                ]
            end

        end

        # puts declarationsHash
        # puts "toReplace = #{JSON.pretty_generate(toReplace)}"
        # puts "%" * 80

        # puts "%" * 80
        # puts code

        toReplace.each do |this, that|
            # puts "%" * 80
            # puts "replacing |#{this}|"
            # puts "with |#{that}|"

            code.gsub!(this, that)
        end

        # puts "^" * 80
        # puts code

    end

    @@parse_code_cache = {}

    # will return all the information it can from a file
    def parse(code)
        md5 = Digest::MD5.new
        md5 << code

        codeHASH = md5.hexdigest
        
        if @@parse_code_cache[codeHASH]
            return @@parse_code_cache[codeHASH]
        end

        # puts "parse #{codeHASH}"

        # gets info from the code: variables, constants, funcitons etc.
        # we might include data from the AST here ...
        filter_data = Filter.filters.reduce({}) { |info, filter|
            info.merge(filter.parse(code))
        }

        removeFoundation(code)


        ast = get_ast code

        variables = variables_from(ast)

        filter_data[:variables] = variables

        filter_data[:functions] = functions_from(ast)

        filter_data[:missingFunctions] = missingFunctions(ast)

        filter_data[:wrongFunctionDeclarations] = wrongFunctionDeclarations(ast)

        filter_data[:missingFunctionCalls] = missingFunctionCalls(ast)

        filter_data[:invalidFunctionCallCounts] = invalidFunctionCallCounts(ast)

        filter_data[:invalidTypeCounts] = invalidTypeCounts(ast)

        if includeFunctionCall
            filter_data[:functionCall] = get_function_call(code)
        end

        nonRecursiveFunctions = 
            expectedFunctions.select { |definition, options|
                if options[:recursive] == true
                    fname = definition.split("(").first
                    is_function_recursive(fname, ast) == false
                else
                    false
                end
            }.map { |definition, options|
                definition.split("(").first
            }

        filter_data[:nonRecursiveFunctions] = nonRecursiveFunctions

        foundEnums = enums_from(ast)

        filter_data[:enums] = foundEnums

        filter_data[:missingEnums] = missingEnums(foundEnums)
    
        filter_data[:expectedDeclarations] = (expectedDeclarations + expectedDeclationValues).map { |x, y| x } 
        filter_data[:substitutedDeclarations] = declarations
        filter_data[:expectsOutput] = requiresOutput

        filter_data[:expectedDeclarationValues] = expectedDeclationValues
        

        if expectedOutput != nil
            filter_data[:expectedOutput] = expectedOutput
        end

        filter_data.merge!({
            # include missing variables in the parse info
            missingDeclarations: missingOutputDeclarations(ast).map { |variable, message|
                variables.each do |var, type|
                    if is_typo variable, var
                        message = "You have a typo: #{var} -> #{variable}"
                    end
                end
                [variable, message]
            }
        })

        parseInfo = filter_data

        # puts JSON.pretty_generate(filter_data)
        # puts JSON.pretty_generate(ast)

        # exit

        @@parse_code_cache[codeHASH] = parseInfo

        parseInfo
    end

    def get_function_call(_code)
        # this binding will include the variables declared with
        # values for
        cool_binding = populate_binding _code, binding

        afterTemplate = ERB.new(funcCallERB)

        afterCode = afterTemplate.result(cool_binding)

        afterCode.lines.select { |line|
            line.strip.length != 0
        }.join
    end

    def populate_binding _code, cool_binding
        # this binding will include the variables declared with
        # values for

        to_eval = ""

        declarations.zip(inputs).each do |var, val|
            first_letter = var[0]

            if first_letter.upcase == first_letter
                var[0] = first_letter.downcase
            end

            to_eval += "#{var} = #{val.inspect}\n"
        end

        ast = get_ast _code

        missingFunc = missingFunctions(ast)
        wrongFuncDecl = wrongFunctionDeclarations(ast)

        expectedFunctions.each do |expectedFunc, options|
            fname = expectedFunc.split("(").first
            has_func = true

            if missingFunc.include?(expectedFunc)
                has_func = false
            end

            if wrongFuncDecl.include?(expectedFunc)
                has_func = false
            end

            to_eval += "has_#{fname} = #{has_func}\n"
        end

        # puts to_eval

        eval(to_eval, cool_binding)

        cool_binding
    end

    def removeFoundation _code
        _code.gsub! "import Foundation", <<-EOF
            class CrazyHack {
                static var randomSeed: UInt32 = #{Random.rand(2 * 10 ** 9)}
            }

            func arc4random() -> UInt32 {
                CrazyHack.randomSeed += 1234567891
                
                return CrazyHack.randomSeed
            }

            func sleep(time: UInt32) -> UInt32 {
                print("sleep \\\(time)")
                return 0;
            }
        EOF
    end

    # will add extra code at the begining or end of the code
    def hack(_code)
        substituteDeclarations(_code)
        removeFoundation(_code)

        info = parse(_code)

        ##### SOURCE CODE CONTEXT #####
        variables = info[:variables]
        constants = info[:constants]

        symbols = variables + constants
        ###############################

        cool_binding = populate_binding _code, binding

        # puts "^" * 40


        # puts "^" * 40

        hack_footer = ERB.new(open("hack_footer.erb").read)
        beforeTemplate = ERB.new(beforeERB)
        afterTemplate = ERB.new(afterERB)

        beforeCode = beforeTemplate.result(binding)
        afterCode = afterTemplate.result(cool_binding)

        footer = hack_footer.result(binding)

        _code = "#{beforeCode}\n#{_code}\n#{afterCode}\n\n#{footer}"


        # puts _code

        _code
    end

    def isOutputOK(code_info, run_info)
        info = run_info[:info]

        expectedDeclationValues.each do |variable, value|
            if info == nil or info[variable] == nil
                return false
            end
    
            if value != nil and "#{info[variable]}" != "#{value}"
                return false
            end
        end

        output = run_info[:output]

        if requiresOutput and evalLambda == nil
            unless isOutputCorrect(output)
                return false
            end
        end

        if evalLambda != nil
            params = inputs + [run_info]

            return call_lambda evalLambda, params
        end

        true
    end

    # report any expected declarations that are missing
    def missingOutputDeclarations(ast)
        output = []

        # only variable names
        variables = variables_from(ast)

        # expects
        expectedDeclarations.each do |name, message|
            foundDeclaration = variables.include? name

            if foundDeclaration == false
                output << [name, message]
            end
        end

        # expects_value
        expectedDeclationValues.each do |name, value|
            foundDeclaration = variables.include? name

            if foundDeclaration == false
                output << [name, "You did not declare the <code>#{name}</code> variable"]
            end
        end

        return output
    end

    def missingFunctions ast 
        declared_func = functions_from(ast)
        info = functions_info_from(ast)

        missing_func = expectedFunctions.select { |func, options|
            declared_func.include?(func) == false
        }.map { |x, y| x }
    end

    def wrongFunctionDeclarations ast 
        declared_func = functions_from(ast)
        info = functions_info_from(ast)

        # puts "declared_func = #{declared_func}"

        # i need all the function that are declared wrong
        expected = expectedFunctions.map(&:first)

        wrongFunctionDeclaration = []

        # for the momement leave the wrong type issue
        candidate_func = declared_func.select { |func_name|
            expected.include?(func_name) == false
        }


        expectedNames = expected.map { |func|
            func.split("(").first
        }

        # thats either: 
        candidate_func.each do |func| 
            # puts "func = #{func}"
            # a typo in the function name
            fname, param = func.split(/[()]/)

            found_problem = false

            expectedNames.each do |expectedName|
                if is_typo fname, expectedName 
                    wrongFunctionDeclaration << {
                        function: func,
                        reason: "You have a typo <strong>#{fname}</strong> -> <strong>#{expectedName}</strong>."
                    }

                    found_problem = true
                    break
                end
            end

            next if found_problem 

            # puts "fname = #{fname} param = #{param}"

            # or the wrong paramater names
            expected.each do |exfunc|
                exname, exparam = exfunc.split(/[()]/)

                # puts "exname = #{exname} exparam = #{exparam}"
                if fname == exname and param != exparam
                    wrongFunctionDeclaration << {
                        function: func,
                        reason: "Check the function definition for more details."
                    }


                    found_problem = true
                    break

                end
            end

            next if found_problem 


            # or the wrong parameter type
        end

        

        wrongFunctionDeclaration
    end

    def missingFunctionCalls ast

        return expectedFunctionCalls if expectedFunctionCalls.count == 0

        functionCalls ||= function_calls_from ast

        # puts functionCalls

        return expectedFunctionCalls.select do |functionCall, message|
            is_function_called(functionCall, ast, functionCalls) == false
        end.map { |functionCall, message| message.gsub("_FUNCTION_",functionCall) }
    end

    def invalidFunctionCallCounts ast
        return expectedFunctionCalls if expectedFunctionCalls.count == 0

        functionCalls ||= function_calls_from ast

    
        functionCallHash = functionCalls.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }

        invalidCalls = expectedFunctionCallCounts.select do |functionCalls, count, message|
            nr_calls = 0
            functionCalls.each do |functionCall|
                nr_calls += functionCallHash[functionCall] || 0
            end
            nr_calls > count
        end

        return invalidCalls.map {|functionCall, count, message| message}
    end

    def invalidTypeCounts(ast)
        return expectedTypeCounts if expectedTypeCounts.count == 0

        vars = variables_with_types_from ast

        invalidTypes = expectedTypeCounts.select do |expectedType, expectedCount, message|
            count = 0
            vars.each do |name, variableType|
                count += 1 if variableType == expectedType
            end


            count > expectedCount
        end

        return invalidTypes.map {|expectedType, expectedCount, message| message}
    end

    def missingEnums foundEnums 
        ret = []

        expectedEnums.each do |expectedEnum|
            name = expectedEnum[:name]
            values = expectedEnum[:values]

            found = false
            has_values = false

            foundEnums.each do |foundEnum|
                if name.to_s == foundEnum[:enum] 
                    found = true

                    vals = foundEnum[:elements].map(&:to_sym)

                    has_values = vals.sort == values.sort
                end
            end

            if found == false 
                ret << "You did not declare the <code>#{name}</code> enum!"
            elsif has_values == false 
                ret << "The <code>#{name}</code> enum is not corectly defined!"
            end
        end

        ret 
    end

    def isOutputCorrect(output)
        # puts "-" * 10
        # puts output
        # puts 
        # puts expectedOutput

        return false if output == nil
        return true if expectedOutput == nil

        if floatOutput
            out = output.to_f
            exp = expectedOutput.to_f

            diff = (out - exp).abs

            # puts "diff = #{diff}"

            return diff < 0.001
        end
        
        return output.strip == expectedOutput.strip
    end
end