#!/usr/bin/ruby

def fib(n)
  (n==0 || n==1) ? n : fib(n-1) + fib(n-2)
end

puts fib(gets.to_i)

