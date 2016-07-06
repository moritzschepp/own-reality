# README

This repository contains the data platform for the research project [OwnReality. Jedem seine Wirklichkeit. Der Begriff der Wirklichkeit in der Bildenden Kunst in Frankreich, BRD, DDR und Polen der 1960er bis Ende der 1980er Jahre](https://dfk-paris.org/de/research-project/ownreality-jedem-seine-wirklichkeit-21.html) (website in German) by Dr. Mathilde Arnoux at the [German Centre for Art History Paris](https://dfk-paris.org). The project was funded by the European Research Council.

During the course of the project, data was gathered and entered into a database.
In general, this platform allows the integration of that data into web based
systems such as content management systems. To be independent of the target
technology, the integration is implemented with a set of customized html tags
with no assumptions on lower layers. An API-only web application retrieves the
data from an elasticsearch instance and relays to the widgets.

For legal reasons, the image data cannot be made available publicly. Please
contact Dr. Mathilde Arnoux (marnoux@dfk-paris.org) if you would like to have
access to the additional media.

This documentation aims to provide information on:

* the requirements to run the application
* how to set up the API-application
* importing the data from the included json documents
* importing the additional image data
* building the javascript integration asset
* how to integrate the widgets on a third-party page

## Requirements

We will just list the requirements here because their installation procedures
are documented nicely on their respective pages. The versions indicate tested
compatibility.

* linux (not a requirement but this howto assumes linux)
* elasticsearch (2.2.3)
* ruby (2.2.5)
* nodejs (4.4.4), only for building

## Setup

The API is a rails application that can be deployed under a ruby web server, the
phusion passenger apache module, the phusion passenger nginx module or a
combination of the above. For simplicity's sake, we will concentrate on a setup
under the ruby application server.

### Dependencies

Navigate to the folder where the application should reside and unpack the
sources there:

    mkdir -p /var/www/rack
    cd /var/www/rack
    wget https://github.com/moritzschepp/ownreality/archive/master.tar.gz
    tar xzf master.tar.gz
    mv ownreality-master ownreality
    cd ownreality

With ruby installed, proceed by installing the `bundler` gem:

    gem install bundler

This will allow you to fetch all other gems required for the app and install
them into a local directory:

    bundle install --path=./bundled_gems

And finally copy the default configuration file

    cp config/app.yml.example config/app.yml

### Building the javascript

This step is optional as the sources include a pre-built version of the
javascript. However, should you want to make modifications, the javascript will
have to be rebuilt afterwards. To do so, run the following with nodejs
installed:

    npm install
    npm run build

The built version will be placed at public/app.js within the app's directory.

### Data import

*Attention: please be aware that the data will be added to this repository only
after data curation has been completed. This section of the documentation only
applies afterwards.*

The sources include the metadata for the platform but they have to be imported.
The environment variable tells rails that it should run in the production
environment where some optimizations apply.

    RAILS_ENV=production bundle exec rake or:from_json

If you received a copy of the image data, you should have an additional tarball.
Simply unpack it within the application directory (e.g.):

    tar xzf /root/ownreality_media.tar.gz

The application will work without this last step but the user will be shown
placeholders instead of the actual media.

### Running the app

Now you can run the application:

    RAILS_ENV=production bundle exec puma

Simply go to http://127.0.0.1:9292 with your browser and you should see a demo
page integrating a subset of the available widgets.


## Using the widgets

In order to use the widgets, the javascript must be included **below** all usage
of the custom tags on that page. So the best would be to place the following 
directly above the closing body tag:

    <body>
      ...
      <script
        type="text/javascript"
        src="https://ownreality.dfkg.org/app.js"
        or-api-url="http://127.0.0.1:9292"
      ></script>
    </body>

because that allows you to use the custom tags anywhere on the page. It doesn't
matter how you place the content. This can be a static html page or a page
managed via a content management system.

### Widgets

* `<or-language-selector></or-language-selector>`: let's the use select the
content language. If you set the attribute **locales**, the widget will change
from a select box to a set of buttons allowing switches between those languages
instead of the default (de, fr, en).
* `<or-busy-wheel></busy-wheel>`: shows a spinning wheel as an indicator while
data is being loaded
* `<or-general-filters></or-general-filters>`: query input, time slider, people
(facets) and attribute (facets)
* `<or-results></or-results>`: displays the tabbed result panel, the widget
or-general-filters is required on the same page
* `<or-filtered-chronology></or-filtered-chronology>`: displays the chronology
results for the current search, the widget or-general-filters is required on the
same page
* `<or-item-list type="magazines"></or-item-list>`: shows the full list of
magazines. You may also use "articles" or "interviews" instead of "magazines".
* `<or-chronology-ranges></or-chronology-ranges>`: shows a list of links (one
for each year)
* `<or-chronology-results></or-chronology-results>`: shows the chronology
results according to the selected year, the widget or-chronology-ranges is
required on the same page
* `<or-register></or-register>`: show an alphabetical register for the given
type (people, attribs), requires attributes **or-base-target-url** (where links
should link to) and **or-type** ("people" or "attribs").
* `<or-register-results></or-register-results>`: show results generated by
or-register 