<or-chronology>

  <div class="header">
    <div class="formats">
      <or-content-locale-selector item={opts.item} />
    </div>

    <div class="navigation">
      <a class="anchor" href="#or-article">{tcap('exhibition')}</a>
      <a class="anchor" href="#or-summary">{tcap('comment')}</a>
      <a class="anchor" href="#or-related-people" if={hasPeople()}>{tcap('people_involved')}</a>
      <a class="anchor" href="#or-attributes">{tcap('keyword', {count: 'other'})}</a>
      <a class="anchor" href="#or-citation">{tcap('recommended_citation_style')}</a>
      <a class="anchor" href="#or-license">{tcap('license')}</a>
    </div>

    <div class="w-clearfix"></div>
  </div>

  <virtual if={opts.item}>
    <div class="or-main-section or-detail-section">
      <div class="or-metadata">
        <h1 name="or-article">{lcv(opts.item._source.title)}</h1>
        <div class="or-subtitle" if={opts.item._type == 'chronology'}>
          {t('exhibition', {count: 1, capitalize: true})} {t('in')}
          <or-attribute
            each={id in opts.item._source.attrs.ids[7][168]}
            key={id}
            shorten-to={100}
          /><br />
          {range_label()}
        </div>
      </div>
    </div>

    <div class="or-detail-section" if={hasContent()}>
      <div class="or-metadata">
        <h2 name="or-summary">{tcap('comment')}</h2>
        <p>{lcv(opts.item._source.content)}</p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section" if={hasPeople()}>
      <div class="or-metadata">
        <h2 name="or-related-people">{lv(wApp.config.server.roles[12064])}</h2>
        <p>
          <or-people-list
            people={opts.item._source.people[12064]}
            as-buttons={true}
            on-click-person={clickPerson(12064)}
          />
        </p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-attributes">{tcap('keyword', {count: 'other'})}</h2>
        <p>
          <or-attribute-list
            keys={attrs(6, 43)}
            on-click-attribute={clickAttribute}
          />
        </p>
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-citation">{tcap('recommended_citation_style', {count: 1})}</h2>
        <or-citation item={opts.item} />
      </div>
      <or-icon which="up" />
    </div>

    <div class="or-detail-section">
      <div class="or-metadata">
        <h2 name="or-license">{tcap('license')}</h2>
        <or-license />
      </div>
      <or-icon which="up" />
    </div>
  </virtual>
  
  <script type="text/coffee">
    tag = this
    tag.mixin(wApp.mixins.i18n)

    tag.clickAttribute = (event) ->
      h(event) if h = tag.opts.handlers.clickAttribute

    tag.clickPerson = (role_id) ->
      (event) ->
        h(event) if h = tag.opts.handlers.clickPerson

    tag.attrs = (klass, category) ->
      (tag.opts.item._source.attrs.ids[6] || {})[43]

    tag.range_label = -> wApp.utils.range_label(tag.opts.item)

    tag.hasContent = ->
      tag.opts.item._source.content[tag.contentLocale()]

    tag.hasPeople = ->
      if tag.opts.item
        if people = tag.opts.item._source.people[12064]
          if people.length > 0
            return true
      false

  </script>

</or-chronology>