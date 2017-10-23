using HttpServer, Lazy


include("./pages/UserBiometrics.jl")

function stack(handlers)
  reversed = reverse(handlers)

  function compose(index, func)
    if index < length(reversed)
      next = index + 1
      child = reversed[next]



      destructure = function (args)
        req, res = args
        @show typeof(res)

        func(req, res)
      end



      composed = destructure ∘ child

      return compose(next, composed)
    else
      return func
    end
  end


  return function(req, res)
    
    index = 1
    app = compose(index, reversed[index])
    return app(req, res)
  end
end



function hello(req, res)
  # req, res = args

  @show "hello"
  # @show args

  return req, res
end

function hi(req, res)
  # req, res = args
  @show "hi"
  @show req[:path]

  req[:resource] == "/" ? (req, "hi") : (req, res)
end

splitpath(p::AbstractString) = split(p, "/", keep=false)
splitpath(p) = p

function todict(req::Request, res::Response)
  req′ = Dict()
  req′[:method]   = req.method
  req′[:headers]  = req.headers
  req′[:resource] = req.resource
  # req.data != "" && (req′[:data] = req.data)
  return req′, res
end

function get_path(req, res)
  req[:path] = splitpath(req[:resource])
  return req, res
end

function route_test(req, res)
  path = req[:path]

  @show "route_test"
  @show length(path)


  if (length(path) == 1 && path[1] == "test")
    return req, "you routed to /test"
  else
    return req, res
  end
end

function sub_route_test(req, res)
  path = req[:path]
  @show "sub_route_test"
  @show res

  if (length(path) > 0 && path[1] == "test")
    return req, "you routed to /test/something"
  else
    return req, res
  end
end


# function routes(args)
#   req, res = args





#   req.resource = "/test" ? route(args) : args
# end

# function route()

# end

function unfold(iter)
  result = []

  for x in iter
    if isa(x, Array)
      push!(result, unfold(x))
    else
      push!(result, x)
    end
  end

  result
end

function main(args...)
  handlers = unfold(args)
  app = stack(handlers)

  function destructure(req, res)
    request, response = app(req, res)

    return response
  end

  handler = HttpHandler(destructure)
  handler.events["error"]  = (client, error) -> println(error)
  handler.events["listen"] = (port)          -> println("Listening on $port...")

  return Server(handler)
end

test_routes = [route_test, sub_route_test]

server = main(
  todict,
  get_path,
  # route_test,
  # sub_route_test,
  stack(test_routes),
  hello,
  hi
)


run(server, 8000)

