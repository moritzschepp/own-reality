<or-list-item class={'or-search-result': opts.searchResult}>

  <div class="or-item-frame" if={opts.item}>

    <virtual if={opts.item && opts.item._type == 'sources'}>
      <or-icon which="right" />
      
      <div class="or-item" onclick={openPaper} or-type="sources">
        <or-medium item={opts.item} />

        <div class="or-width-limit">
          <or-people-list people={opts.item._source.people[12063]} />
          <a>
            <or-localized-value class="or-title" value={opts.item._source.title} />
          </a>
          <or-journal-and-volume item={opts.item} />
          <or-localized-value
            class="or-text"
            value={opts.item._source.interpretation}
          />
        </div>

        <div class="w-clearfix"></div>
      </div>
    </virtual>

    <virtual if={opts.item && opts.item._type == 'interviews'}>
      <or-icon which="right" />

      <div class="or-item" onclick={openPaper} or-type="interviews">
        <virtual if={!opts.searchResult}>
          <a
            class="or-title"
            if={hasHTML()}
          >{label()}</a>
          <span if={!hasHTML()} class="or-title">
            {label()}
          </span>

          <div class="or-interviewer">
            {tcap('interview')} {t('by')}
            <or-people-list people={opts.item._source.people[16530]} />
          </div>
        </virtual>

        <virtual if={opts.searchResult}>
          <or-people-list people={opts.item._source.people[16530]} />
          <a>
            <or-localized-value class="or-title" value={opts.item._source.title} />
          </a>
          <div class="or-teaser" if={opts.searchResult}></div>
        </virtual>
      </div>

      </virtual>
    </virtual>

    <virtual if={opts.item && opts.item._type == 'articles'}>
      <or-icon which="right" />
      
      <div class="or-item" onclick={openPaper} or-type="articles">
        <or-pdf-link item={opts.item} download={true} />

        <or-people-list people={opts.item._source.people[16530]} />

        <a
          class="or-title"
          if={hasHTML()}
        >{label()}</a>
        <span if={!hasHTML()} class="or-title">
          {label()}
        </span>

        <div class="or-teaser" if={opts.searchResult}></div>
      </div>
    </virtual>

    <virtual if={opts.item && opts.item._type == 'magazines'}>
      <or-icon which="right" />

      <div class="or-item" onclick={openPaper} or-type="magazines">
        <!-- <or-medium item={opts.item} /> -->
        <!-- <or-people-list people={opts.item._source.people[16530]} /> -->
        <virtual if={!opts.searchResult}>
          <div class="or-title">
            {lv(opts.item._source.title)}
          </div>

          <a
            onclick={openPaper}
          ><span class="or-decorate-fix">{opts.label}</span></a>

          <a onclick={toJournalArticles}>
            <span class="or-decorate-fix">{opts.label2}</span>
          </a>
        </virtual>

        <virtual if={opts.searchResult}>
          <or-people-list people={opts.item._source.people[16530]} />
          <a
            class="or-title"
            if={hasHTML()}
          >{label()}</a>
          <span if={!hasHTML()} class="or-title">
            {label()}
          </span>
          <div class="or-teaser" if={opts.searchResult}></div>
        </virtual>
      </div>
    </virtual>

    <virtual if={opts.item && opts.item._type == 'chronology'}>
      <or-icon which="right" />
      
      <div class="or-item" onclick={openPaper} or-type="chronology">
        <or-people-list people={opts.item._source.people[12064]} />
        <span class="or-title">{label()}</span>
        <div class="or-location">
          {t('exhibition', {count: 1, capitalize: true})} {t('in_country')}
          <or-attribute
            each={id in opts.item._source.attrs.ids[7][168]}
            key={id}
            shorten-to={100}
          />,
          {range_label()}
        </div>
      </div>
    </virtual>
    
  </div>

  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.on 'mount', ->
      unless tag.opts.item
        wApp.bus.on 'object-data', ->
          id = parseInt(tag.opts.id)
          tag.opts.item = wApp.cache.data.object_index[tag.opts.type][id]
          tag.update()
        wApp.cache.objects(tag.opts.type)

    tag.on 'updated', ->
      if tag.opts.item
        if teaser = tag.opts.item._source.teaser
          Zepto(tag.root).find('.or-teaser').html(tag.lv teaser)

    tag.openPaper = (event) ->
      event.preventDefault()
      wApp.routing.packed(
        modal: 'true',
        tag: 'or-paper',
        id: tag.opts.item._id
        clang: wApp.config.locale
        searchContext: true
      )

    tag.hasHTML = ->
      html = tag.opts.item._source.html
      html && html[tag.locale()]

    tag.label = -> tag.opts.label || tag.lv(tag.opts.item._source.title)

    tag.toJournalArticles = (event) ->
      event.preventDefault()
      base = tag.opts.orSearchUrl
      hash = wApp.routing.pack(
        type: 'sources'
        journals: [tag.opts.item._source.journal_short]
      )
      window.location.href = "#{base}#/?q=#{hash}"

    tag.range_label = -> wApp.utils.range_label(tag.opts.item)

  </script>

</or-list-item>