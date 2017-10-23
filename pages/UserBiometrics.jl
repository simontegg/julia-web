module UserBiometrics

  using Mux 
  include("./Layout.jl")

  export route, handle_get, stack
  




  
  age = Dict{String,String}("name"=>"age", "text"=>"Age:")
  weight = Dict{String,String}("name"=>"weight", "text"=>"Weight: (kilograms)")
  height = Dict{String,String}("name"=>"height", "text"=>"Height: (centimetres)")
  activity = Dict{String,String}("name"=>"activity", "text"=>"Workouts per week:")
  
  inputs = [age, weight, height, activity]

  function input(d)
    name = d["name"]
    text = d["text"]

    return """
      <div class="mt3">
        <label class="db lh-copy f5" for="$name">$text</label>
        <input id="$name" class="pa2 input-reset ba bg-transparent" type="number" name="age" value="" required=true>
      </div>
    """
  end

  function number_inputs()
    return reduce(string, map(input, inputs))
  end

  function form()
    numbers = number_inputs()

    return """
      <div class="san-serif">
        <form class="measure.ml5.mt5" accept-charset="UTF" action="/biometrics" method="POST">
          <input type="hidden">
            <fieldset id="biometrics" class="ba b--transparent ph0 mh0" >
              <legend class="f3 fw5 ph0 mh0 underline" > 
                Enter your details
              </legend>
              $numbers
              <div class="mt3">
              <legend class="f5 mb3">Your sex:</legend>
              <div class="ba pa2 mt1">
                <div class="mt0">
                  <input id="sex-no-answer" class="hidden-radio" type="radio" name="sex" value="no-answer" checked=true>
                  <label class="db pointer f5" for="sex-no-answer">No Answer</label>
                </div>
                <div class="mt2">
                  <input id="sex-no-female" class="hidden-radio" type="radio" name="sex" value="female">
                  <label class="db pointer f5" for="sex-female">Female</label>
                </div>
                <div class="mt2">
                  <input id="sex-male" class="hidden-radio" type="radio" name="sex" value="no-answer">
                  <label class="db pointer f5" for="sex-male">Male</label>
                </div>
                <div class="mt2">
                  <input id="sex-intersex" class="hidden-radio" type="radio" name="sex" value="intersex">
                  <label class="db pointer f5" for="sex-intersex">Intersex</label>
                </div>
              </div>
            </fieldset>
          <div class="mt4">
            <input class="f5 dim ph3 pv2 mb2 bn br2 dib white bg-near-black input-reset button-reset pointer" type="submit" value="Submit" /> 
          </div>  
        </form>
      </div>
    """
  end

  stack = Mux.stack(
      Mux.method("GET", Mux.respond(Layout.page(form())))
  )

  route = Mux.stack(
    Mux

  )




  


  routes = (
    # method("GET", respond("get"))
    # route("/:test", respond("test")),
    # route("/", respond("inddex"))
    Mux.notfound()
  )




end

