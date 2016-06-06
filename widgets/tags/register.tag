<or-register>

  <div>
    <h3>{category_label()}</h3>

    <div each={bucket in ordered_buckets()} key={bucket.key}>
      <a>
        {bucket.key} ({bucket.doc_count})
      </a>
    </div>
  </div>

  <style type="text/scss">
    or-register {
      a {
        cursor: pointer;
      }
    }
  </style>

  <script type="text/coffee">
    self = this

    self.on 'mount', ->
      self.fetch() unless self.opts.orType == 'attribs'

      $(self.root).on 'click', 'a', (event) ->
        event.preventDefault()
        key = $(event.target).parents('div[key]').attr('key')
        self.or.routing.set_packed initial: key

      self.or.bus.on 'packed-data', (data) ->
        console.log data
        self.category_id = data['category_id']

        if data['initial'] != self.initial || !self.buckets
          self.initial = data['initial']
          self.fetch(data['initial'])


    self.or.bus.on 'locale-change', -> 
      if self.opts.orType == 'attribs'
        self.fetch()
        self.fetch(self.initial) if self.initial
      self.update()

    self.fetch = (initial) ->
      params = {
        type: self.opts.orType
        locale: self.or.config.locale
      }
      
      if initial
        params['initial'] = initial
        params['per_page'] = 1500
      else
        params['register'] = true

      if self.opts.orType == 'attribs'
        params['sort'] = {"name.#{self.or.config.locale}": 'asc'}
        params['kind_id'] = 43
        params['klass_id'] = 6
        params['category_id'] = self.category_id

      if self.opts.orType == 'people'
        params['sort'] = [{last_name: 'asc'}, {first_name: 'asc'}]

      $.ajax(
        type: 'post',
        url: "#{self.or.config.api_url}/api/entities/search"
        data: JSON.stringify(params)
        contentType: "application/json; charset=utf-8"
        success: (data) ->
          console.log data

          if initial
            self.or.bus.trigger 'register-results', data
          else
            self.buckets = data.aggregations.register.buckets
            self.update()
      )

    self.ordered_buckets = -> 
      self.buckets.sort (x, y) -> self.or.compare(x.key, y.key)
    self.category_label = ->
      console.log self.or.config.server.categories[self.category_id]
      self.or.i18n.l(self.or.config.server.categories[self.category_id])

  </script>

</or-register>