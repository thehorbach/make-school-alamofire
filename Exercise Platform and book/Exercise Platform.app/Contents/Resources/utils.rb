CHECKMARK = "✅"
CROSS = "❌"

def call_lambda lambda, args
    begin
        if args.count == 0 
            lambda.call
        elsif args.count == 1 
            lambda.call(args[0])
        elsif args.count == 2 
            lambda.call(args[0], args[1])
        elsif args.count == 3 
            lambda.call(args[0], args[1], args[2])
        elsif args.count == 4 
            lambda.call(args[0], args[1], args[2], args[3])
        elsif args.count == 5 
            lambda.call(args[0], args[1], args[2], args[3], args[4])
        elsif args.count == 6 
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5])
        elsif args.count == 7
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        elsif args.count == 8
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7])
        elsif args.count == 9
            lambda.call(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8])
        end    
    rescue
        return nil
    end 
end

class String
    def unstring
        quotes = ["'", '"'];
        ret = "#{self}"
        quotes.each do |quote|
            if ret[0] == quote and ret[-1] == quote 
                ret = ret[1..-2]
            end
        end

        ret
    end
end

def expected_status filepath_or_code
    code = filepath_or_code
    if File.exists? filepath_or_code
        code = open(filepath_or_code).read
    end

    status = code.lines.last
    if status != nil and status["//"]
        status.gsub!("//", "").strip

        status.to_s
    else
        :correct
    end
end


# Typo hack

TYPE_COST = 10 # for adding a letter
TYPO_COST = {} # distance based on qwerty keyboard - fuck the french

# @ is the marker for an irelevant character
# note that we care about '_' and '?'  
keyboard = [
    "1234567890_".split(""),
    "qwertyuiop@".split(""),
    "asdfghjkl@@".split(""),
    "zxcvbnm@@?@".split("")
]

for i in 0..keyboard.count-1
    for j in 0..keyboard[i].count-1
        first = keyboard[i][j]

        next if first == " "

        for x in 0..keyboard.count-1
            for y in 0..keyboard[x].count-1
                second = keyboard[x][y]

                next if second == " "
                
                dist = Math.sqrt((i-x)**2 + (j-y)**2).to_i

                TYPO_COST[first] ||= {}

                TYPO_COST[first][second] = dist
            end
        end

    end
end

# for i in 'a'..'z'
#     for j in 'a'..'z'
#         print "%2d " % TYPO_COST[i][j]
#     end
#     puts
# end

def compute_typo_cost x, y 
    cost = TYPO_COST[x][y]

    if cost == nil 
        cost = TYPE_COST
    end

    if x == y 
        cost = 0
    end

    cost
end

def is_typo this, of_that
    if this == of_that
        return false
    end

    # ignore 1 letter variables
    if this.length == 1 or of_that.length == 1
        return false
    end

    # ignore difference bigger than 4 letters
    if (this.length - of_that.length).abs > 4
        return false
    end

    # cost[i][j] = the cost to transform the first i characters 
    # of this in to the first j characters of of_that
    # cost[i][0] = 0
    # cost[0][j] = 0
    # cost[i][j] = 1 + cost[i-1][j-1] if this[i] == this[j]

    n = this.length 
    m = of_that.length

    cost = Array.new(n + 1) {
        Array.new(m + 1, 0)
    }
        

    for i in 1..n
        cost[i][0] = i * TYPE_COST
    end

    for j in 1..m
        cost[0][j] = j * TYPE_COST
    end

    for i in 1..n
        for j in 1..m
            x = this[i-1].downcase
            y = of_that[j-1].downcase

            cost[i][j] = [
                cost[i-1][j] + TYPE_COST,
                cost[i][j-1] + TYPE_COST,
                cost[i-1][j-1] + compute_typo_cost(x, y)
            ].min
        end
    end

    # puts cost[n][m]

    return cost[n][m] <= 18
end

# tests = [
#     ["min", "min2"],
#     ["number", "nomber"],
#     ["sun", "sum"],
#     ["secondsInYear", "secondsInAYear"],
#     ["yolo", "swag"]
# ]

# tests.each do |this, that|
#     puts "#{this} -> #{that} | #{is_typo this, that}"    
# end

class Tuple
    attr_accessor :data

    def initialize info
        self.data = info
    end

    def values 
        if data.is_a? Array
            return data 
        else
            return data.values
        end
    end

    def inspect 
       "Tuple.new(#{data.inspect})"
    end
end

# converts a value to swift code
def s value
    if value.is_a? String
        return "\"#{value}\""
    elsif value.is_a? Fixnum
        return "#{value}"
    elsif value.is_a? TrueClass or value.is_a? FalseClass
        return "#{value}"
    elsif value.is_a? Symbol 
        return ".#{value}"
    elsif value.is_a? Tuple
        res = "("

        if value.data.is_a? Array
            res += value.data.map { |item|
                s item
            }.join(", ")
        else
            res += value.data.map { |k, v|
                "#{k}: #{s v}"
            }.join(", ")
        end

        res += ")"

        return res
    elsif value.is_a? Array 
        res = "["

        value.each_with_index do |item, index|                        
            res += s item
            if index + 1 < value.count
                res += ", "
            end
        end

        res += "]"

        return res
    elsif value.is_a? Hash
        res = "["

        index = 0
        limit = value.count

        value.each do |k, v|
            res += s k
            res += " : "
            res += s v

            index += 1

            if index != limit 
                res += ", "
            end
        end
            
        res += "]"

        return res
    end

    return value.inspect
end

# s tests

# [
#     1,
#     "hello",
#     true,
#     false,
#     [1, 2, 3],
#     ["hello", "world", ["nested", "array", true]],
#     :yolo,
#     :Up,
#     {"hello" => "world", "yolo" => "swag"},
#     Tuple.new([1, 2]),
#     Tuple.new({x: 1, y: 2})
# ].each do |val|
#     puts s(val)
# end



def batch_process items, &lambda
    queue = Queue.new

    results = Queue.new

    items.each_with_index do |item, index|
        queue << [index, item]
    end

    consumers = []

    10.times do 
        consumers << Thread.new do
          until queue.empty? do 
            index, value = queue.pop

            result = lambda.call(value)

            results << [index, result]
          end
        end
    end 

    consumers.each do |consumer|
        consumer.join
    end

    ordered_results = []

    until results.empty?
        ordered_results << results.pop
    end

    final = ordered_results.sort { |x, y|
        x.first <=> y.first
    }.map(&:last)

    final
end








