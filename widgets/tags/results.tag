<or-results>
  
  <div class="result-tabs">
    <div class="controls">
      <a name="articles" class={current: (current_tab == 'articles')}>
        {or.filters.t('article', {count: 'other'})}
        ({or.data.aggregations['articles'].doc_count})
      </a>
      <a name="magazines" class={current: (current_tab == 'magazines')}>
        {or.filters.t('magazine', {count: 'other'})}
        ({or.data.aggregations['magazines'].doc_count})
      </a>
      <a name="interviews" class={current: (current_tab == 'interviews')}>
        {or.filters.t('interview', {count: 'other'})}
        ({or.data.aggregations['interviews'].doc_count})
      </a>
      <a name="sources" class={current: (current_tab == 'sources')}>
        {or.filters.t('source', {count: 'other'})}
        ({or.data.aggregations['sources'].doc_count})
      </a>
      <div class="clearfix"></div>
    </div>
    <div class="tab articles">
      <or-list-item
        each={item in or.data.results}
        item={item}
      />
    </div>
    <div class="tab magazines">
      <or-list-item
        each={item in or.data.results}
        item={item}
      />
    </div>
    <div class="tab interviews">
      <or-list-item
        each={item in or.data.results}
        item={item}
      />
    </div>
    <div class="tab sources">
      <or-people-filter />
      <or-journals-filter />

      <div class="clearfix"></div>

      <or-list-item
        each={item in or.data.results}
        item={item}
      />
    </div>
  </div>

  <style type="text/scss">
    or-results {
      .controls {
        margin-bottom: 1.5rem;

        a {
          display: block;
          float: left;
          width: 25%;
          box-sizing: border-box;
          cursor: pointer;
          padding: 0.5rem;
          padding-top: 1rem;
          padding-bottom: 1rem;
          background-color: #adadad;

          &.current {
            background-color: grey; 
          }
        }
      }


      ul li:before {
        content: none !important;
      }

      .tab {
        ul > li {
          padding-bottom: 0px;

          & > img.icon {
            width: 1rem;
          }
        }
      }

      or-people-filter, or-journals-filter {
        box-sizing: border-box;
        width: 50%;
        float: left;
      }

      .clearfix {
        clear: both;
      }
    }
  </style>

  <script type="text/coffee">
    self = this
    self.or = window.or
    self.current_tab = 'sources'

    self.on 'mount', ->
      $(self.root).find('.tab').hide()
      $(self.root).find('.tab.sources').show()

      $(self.root).on 'click', '.controls a', (event) ->
        name = $(event.target).attr('name')
        $(self.root).find('.tab').hide()
        $(self.root).find(".tab.#{name}").show()
        self.or.bus.trigger 'type-select', name
        self.current_tab = name

      self.or.bus.on 'results', ->
        # console.log 'results', self.or.data
        self.update()

      self.or.bus.on 'type-aggregations', -> self.update()
  </script>
  
</or-results>