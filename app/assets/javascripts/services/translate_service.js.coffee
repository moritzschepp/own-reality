app.service 'orTranslate', [
  "session_service", "orTranslations",
  (ss, ts) ->
    service = {
      current_locale: -> ss.locale
      other_locale: -> if ss.locale == 'de' then 'fr' else 'de'
      capitalize: (string) -> 
        return "" unless typeof string is "string"
        string.charAt(0).toUpperCase() + string.slice(1)
      translate: (input, options = {}) ->
        result = ""

        try
          options.count ||= 1
          parts = input.split(".")
          result = ts[ss.locale]
          
          for part in parts
            result = result[part]
          
          count = if options.count == 1 then 'one' else 'other'
          result = result[count] || result

          for key, value of options.interpolations
            regex = new RegExp("%\{#{key}\}", "g")
            tvalue = this.translate(value, is_interpoliation: true)
            value = tvalue if (tvalue != "" && tvalue != value)
            result = result.replace regex, value

          result = service.capitalize(result) if options.capitalize
        catch error
          # console.log error

        if options.is_interpoliation
          result
        else
          result || "#{input} [TNF]"
      localize: (input, format_name = 'default') ->
        try
          format = service.translate "date.formats.#{format_name}"
          result = new FormattedDate(input)
          result.strftime format
        catch error
          ""
      has_value: (object) ->
        return false unless object
        object[service.current_locale()] || object[service.other_locale()]

    }
]