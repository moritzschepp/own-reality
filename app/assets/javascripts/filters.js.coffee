app.filter 't', [
  "orTranslate",
  (ot) ->
    filter = (input, options = {}) -> ot.translate(input, options)
    filter.$stateful = true
    filter
]

app.filter 'people_list', [ ->
  (input, options = {}) ->
    return null unless input

    if options["sort_by"]
      input.sort (x, y) ->
        return -1 if x[options['sort_by']] < y[options['sort_by']]
        return 0 if x[options['sort_by']] == y[options['sort_by']]
        return 1

    results = []
    for person in input
      if person.last_name == "Anonyme"
        results.push "Anonyme"
      else
        results.push "#{person.first_name} #{person.last_name}"
    results.join(', ')
]

app.filter 'capitalize', [
  "orTranslate",
  (ot) -> ot.capitalize
]

app.filter 'user', [
  "data_service",
  (ds) ->
    (input) ->
      person = ds.misc.people[input]
      if person then "#{person.first_name} #{person.last_name}" else ""
]

app.filter 'unique', [
  ->
    (input) ->
      output = {}
      output[e] = true for e in input
      key for key, value of output
]