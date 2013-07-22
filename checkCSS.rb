require 'sass/css'
require 'pp'

def print_selector(file, target)
    css = ""
    arr = []

    File.open(file) do |io|
        css = io.read
    end
    css = Sass::CSS.new(css, {:filename => file})
    css_tree = css.__send__(:build_tree)
    css_tree.select {|n| n.is_a?(Sass::Tree::RuleNode) }.each do |rule|
        #pp rule.parsed_rules.members
        parseSelector(rule.parsed_rules.members, arr)
    end

    arr.uniq!
    pp arr
    #return searchSelector(arr, target)
end

def parseSelector(selector, arr)

    def parseChild(s, a)
        # さらに子供がいるとき
        if s.respond_to?(:members) then 
            if s.members.size > 1 then
                parseSelector(s.members, a)
            else
                new_s = getSelector(s.members[0])
                a.push(new_s)
            end
        else
            new_s = getSelector(s)
            a.push(new_s)
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

def getSelector(s)
    s_selector = s.to_s()
    
    id = /#.*/.match(s_selector).to_s
    if !id.empty? then
        puts id
        id.gsub!(/.+\..*/, '')
        id.gsub!(/.+:.*/, '')
        return id
    end

    klass = /\..*/.match(s_selector).to_s
    if !klass.empty? then
        puts klass
        klass.gsub!(/.+\..*/, '')
        klass.gsub!(/.+:.*/, '')
        return klass
    end
end

def searchSelector(s_arr, target)
    new_arr = []
    s_arr.each do |s|
        #s_selector = s.to_s()

        id = /^#/.match(s_selector)
        klass =  /^\./.match(s_selector)

        if !id.nil? then
            s_selector.gsub!(/^#/, '')
            s_selector.gsub!(/#.*/, '')
            new_arr.push(s_selector)
            #str = "id.*=.*".concat(s_selector)
            str = "id.*".concat(s_selector)
            results = system("grep -ir ".concat(str).concat(" ").concat(target));
        elsif !klass.nil? then
            s_selector.gsub!(/^\./, '')
            s_selector.gsub!(/\.*/, '')
            new_arr.push(s_selector)
            #str = "class.*=.*".concat(s_selector)
            str = "class.*".concat(s_selector)
            results = system("grep -ir ".concat(str).concat(" ").concat(target));
        else
            puts 'This is TAG'
        end

        if !results then
            puts "NO FILE REFERS THIS SELECTOR!"
        end
        puts ' ' 
    end
    return new_arr
end

print_selector(ARGV[0], ARGV[1])
