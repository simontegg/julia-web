using HttpServer, Lazy

include("./pages/UserBiometrics.jl")

function stack(handlers)
  reversed = reverse(handlers)

  function compose(index, func)
    if index < length(reversed)
      prev = func
      next_i = index + 1
      child = reversed[next_i]

      function next(args)
        if isa(args, Tuple)
          req, res = args
          func(req, res)
        else
          return args
        end
      end

      composed = next ∘ child

      return compose(next_i, composed)
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
  @show "hello"

  return req, res
end

function hi(req, res)
  @show "hi"

  req[:resource] == "/" ? "hi" : (req, res)
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
  @show "route_test"
  path = req[:path]

  if (length(path) == 1 && path[1] == "test")
    @show "route_test_return"
    return "you routed to /test"
  else
    return req, res
  end
end

function sub_route_test(req, res)
  @show "sub_route_test"
  path = req[:path]

  if (length(path) > 0 && path[1] == "test")
    return "you routed to /test/something"
  else
    return req, res
  end
end

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

  handler = HttpHandler(app)
  handler.events["error"]  = (client, error) -> println(error)
  handler.events["listen"] = (port)          -> println("Listening on $port...")

  return Server(handler)
end

test_routes = [route_test, sub_route_test]

server = main(
  todict,
  get_path,
  stack(test_routes),
  hello,
  hi
)


run(server, 8000)

