<or-delayed-input>
  <input
    type={opts.type}
    placeholder={opts.placeholder}
  />

  <script type="text/coffee">
    tag = this

    tag.input = -> $(tag.root).find('input')
    
    tag.on 'mount', ->
      to = null
      Zepto(tag.root).on 'keyup', ->
        clearTimeout(to)
        to = setTimeout(tag.notify, tag.opts.timeout)
      wApp.bus.on 'packed-data', tag.from_packed_data

    tag.on 'unmount', ->
      wApp.bus.off 'packed-data', tag.from_packed_data

    tag.value = -> tag.input().val()
    tag.reset = (notify = true) ->
      tag.input().val(null)
      tag.notify() if notify
    tag.notify = ->
      tag.to_packed_data()


    tag.from_packed_data = (data) ->
      if data['terms'] != tag.value()
        tag.input().val data['terms']
        tag.update()
    tag.to_packed_data = ->
      wApp.routing.query terms: tag.value(), page: 1

  </script>
</or-delayed-input>