#!/usr/bin/ruby

def factorial(n)

  x = 1

  while n>1

    x=x*n

    n-=1

  end

  puts x

end

puts "What number?"

n = gets.to_i

factorial(n)
