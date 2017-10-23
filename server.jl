using HttpServer


include("./pages/UserBiometrics.jl")


function stack(handlers)
  function handle(index, req, res)
    request, response = handlers[index](req, res)
    @show index
    @show request
    @show response

    if request != nothing && index < length(handlers)
      handle(index + 1, request, response)
    else
      Response(response)
    end
  end

  return function(req, res)
    handle(1, req, res)
  end
end


function hello(req, res)
  @show "heloo"
  return req, res
end

function hi(req, res)
  return nothing, "hi"
end

handlers = [hello, hi]

function app(req, res)
  @show req.method
  @show req.resource
  @show req.headers

  handle = stack(handlers)

  handle(req, res)

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

