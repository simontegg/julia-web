using HttpServer


include("./pages/UserBiometrics.jl")


function stack(handlers)
  reversed = reverse(handlers)

  function compose(index, func)
    if index < length(reversed)
      next = index + 1
      child = reversed[next] 
      composed = func ∘ child

      return compose(next, composed)
    else
      return func
    end
  end


  return function(args)
    index = 1
    app = compose(index, reversed[index])
    request, response = app(args)

    return response
  end
end


function hello(args)
  req, res = args

  @show "hello"

  return req, res
end

function hi(args)
  req, res = args
  @show "hi"

  req.resource == "/" ? (req, "hi") : (req, res)
end

# function predicate(args)
#   req, res = args
#   req.resource = "/test" ? route(args) : args
# end

# function route()

# end


handlers = [hello, hi]

function app(req, res)
  @show req.method
  @show req.resource
  @show req.headers
  args = (req, res)

  handle = stack(handlers)
  handle(args)

end

function http_handler(app)
  handler = HttpHandler(app)
  handler.events["error"]  = (client, error) -> println(error)
  handler.events["listen"] = (port)          -> println("Listening on $port...")
  return handler
end

handler = http_handler(app)


server = Server(handler)
run(server, 8000)

