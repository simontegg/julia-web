module Calories

  export get

  function get(activity, age, height, sex, weight)
    const multiplier = activity_multiplier(activity)
    const mod = modifier(sex)

    return baseline_metabolic_rate(weight, height, age, mod) * multiplier
  end

  function activity_multiplier(activity)
    if activity == 0
      return 1.2
    else if activity < 3
      return 1.375
    else if activity < 6
      return 1.55
    else if activity < 8
      return 1.725
    else
      return 1.9
    end
  end

  function baseline_metabolic_rate(weight, height, age, mod)
    return (10 * weight) + (6.25 * height) - (5 * age) + mod
  end

  function modifier(sex)
    if sex == "female"
      return -161
    else if sex == "male"
      return 5
    else
      return -76
    end
  end
end
