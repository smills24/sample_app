#!/usr/bin/ruby

def fib(n)

  #Prints the nth term of the fibonacci sequence

  xn = 1
  xm = 1
  x = 0

  while x < (n-2)

    nextx = xm + xn

    xn = xm
    xm = nextx

    x+=1

   end

  puts xm

end

n = gets.to_i

fib(n)
