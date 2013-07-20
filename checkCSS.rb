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
    pp rule.parsed_rules.members
  end
end

print_selector(ARGV[0])