#!/usr/bin/ruby

# Inspired by https://github.com/vwochnik/jekyll-email-protect

if ARGV.length() != 1 then
    puts "Usage: encode your_string"
    exit    
end

input = ARGV[0]
output = ""

input.each_byte do |byte|
    char = byte.chr()
    if char =~ /[A-Za-z0-9]/
        output << '%%%02X' % byte
    else
        if char == '@'
            output << "&#64;"
        else
            output << char
        end
    end
end

puts output
