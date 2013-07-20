require 'sass/css'
require 'pp'

def print_selector(file)
  css = ""
  File.open(file) do |io|
    css = io.read
  end
  css = Sass::CSS.new(css, {:filename => file})
  css_tree = css.__send__(:build_tree)
  css_tree.select {|n| n.is_a?(Sass::Tree::RuleNode) }.each do |rule|
    pp "=============start==============="
    pp rule.parsed_rules.members
    parseSelector(rule.parsed_rules.members)
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
end

def parseSelector(selector)
    if Array === selector then
        case selector.size
        when 0 then
            puts 'Error'
        when 1 then
            # さらに子供がいるとき
            if selector[0].members.size > 1 then
                parseSelector(selector[0].members)
            else
                puts ' '
                puts '...output_1'
                puts selector[0]
                puts '...'
                puts ' '
            end
        else
            out = selector.slice!(0)
            if out.members.size > 1 then
                parseSelector(out.members)
            else
                puts ' '
                puts '...output_1'
                puts out
                puts '...'
                puts ' '
            end
            parseSelector(selector)
        end
    end
end



def parseSelector2(selector)
    pp selector.class
    if Array === selector then
        size = selector.size
        pp size
        case selector.size
        when 0 then
            puts 'Error'
        when 1 then
            puts ' '
            puts '>>>output_1'
            puts selector[0]
            puts '<<<'
            puts ' '

            puts selector[0].class
            puts selector[0].members
            puts selector[0].members.size
        else
            puts ' '
            puts '>>>output_2'
            pp selector.slice!(0)
            puts '<<<'
            puts ' '

            p 'bigger than 1'
            parseSelector(selector)
        end
    end
end

print_selector(ARGV[0])
