function test() 
  println("be")

end

function gg()
  println("be")

end

handlers = [test, gg]

reversed = reverse(handlers)

println(reversed)

