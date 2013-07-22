require 'sass/css'
require 'pp'

def print_selector(file)
    css = ""
    arr = []

    File.open(file) do |io|
        css = io.read
    end
    css = Sass::CSS.new(css, {:filename => file})
    css_tree = css.__send__(:build_tree)
    css_tree.select {|n| n.is_a?(Sass::Tree::RuleNode) }.each do |rule|
        pp "=============start==============="
        pp rule.parsed_rules.members
        #parseSelector(rule.parsed_rules.members, arr)
        parseSelector(rule.parsed_rules.members, arr)


=begin
        pp rule.parsed_rules.members
        pp rule.parsed_rules.members.class
        pp rule.parsed_rules.members.size
        rule.parsed_rules.members.each do |selector|
            pp selector.members.class
            pp selector.members.size
            #pp selector.gsub(/\s.+/, '')
            pp selector
        end
=end
  end

        pp "=============final_output==============="
        arr.uniq!
        pp arr
        delHead(arr)
end

def parseSelector(selector, arr)

    def parseChild(s, a)
        # さらに子供がいるとき
        if s.members.size > 1 then
            parseSelector(s.members, a)
        else
            puts s
            a.push(s.members[0])
        end
    end

    if Array === selector then
        case selector.size
        when 0 then
            puts 'Error'
        when 1 then
            parseChild(selector.slice!(0), arr)
        else
            # 兄弟セレクタのの先頭のセレクタを分解
            parseChild(selector.slice!(0), arr)

            # 残りの兄弟セレクタを分かい
            parseSelector(selector, arr)
        end
    end
end

def delHead(s_arr)
    s_arr.each do |s|
        test = s.to_s()
        pp s.class
        test.gsub(/#/, '')
        pp test
    end
end

print_selector(ARGV[0])
