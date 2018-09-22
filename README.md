# Jekyll Icon List

**This plugin works, but I haven't had time to test it very thoroughly. Use with caution, and please
report bugs if you find them.**

## What is it? 

It's a jekyll tag that lets you build unordered lists of items that follow the "Icon + label"
format.

Write a tag like this: 
```
{% icon_list rails bootstrap heroku aws %}
```

Add some icons, configuration, and a little CSS, and you get something like this: 

![imgur screenshot]( https://i.imgur.com/9m6qCRB.png )

I use it on [my portfolio](https://robert-buchberger.com/projects.html)
([ github ](https://github.com/rbuchberger/robert-buchberger.com)) if you want to see an example.
(Actually, currently my master branch doesn't use the gem. Yet. Check the other branches.)

You could use it to build category lists, or tag lists, or a bunch of other stuff.  You can pass
element attributes in the tag itself, or set default attributes in the config. It only generates
markup; the styling is up to you. 

It integrates with (and requires) [jekyll-svg-inliner](https://github.com/sdumetz/jekyll-inline-svg)
to inline your SVGs for you. If you don't use inline SVGs (even though you should), it sets your file
as an img src attribute (with alt text!).

## Installation

(I don't have it hosted on rubygems yet. It will be once I've cleaned it up a bit further. .)

```ruby
# Gemfile

group :jekyll_plugins do
  gem 'jekyll_icon_list', git: 'https://github.com/rbuchberger/jekyll_icon_list.git'
end
```

```yml
# _config.yml

plugins: 
  -jekyll_icon_list
```

You'll also want some css. Here's an example that should get you close to the screenshot:
```css

ul.icon-list {
  margin: 0;
  font-size: 1.1em;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  list-style: none;
}

ul.icon-list li {
    display: flex;
    align-items: center;
    margin: 0 .5em;
}

.icon {
  height: 1em;
  margin-right: .2em;
}

```

## Usage

Basic usage: 

```
{% icon_list example_shortname example2 %}
```

By default, with no configuration:

* It will look for icons in images/icons/ with the same name as your shortname, grabbing the first result which matches (shortname).*

* It will take your shortname, swap dashes for spaces, and titleize it for the label.

So for example, if you write `{% icon_list ruby-on-rails %}`, with `ruby-on-rails.png` located in
`images/icons/`, it will generate markup like this:
```
<ul>
  <li><img src="/images/icons/ruby-on-rails.png">Ruby On Rails</li>
<ul>
```

You can specify attributes to add with --(element) arguments: 
```
{% icon_list example example2 example3 --ul class="stumpy" --li class="mopey" %}

```

Available arguments:
`--ul, --li, --img, --svg, --a`
These will overwrite any global defaults you have set.

in your \_config.yml there are a few optional settings you can add. Here's an example:
```
# _config.yml

icon_list:
  default_path: images/here/
  defaults:
    ul: class="icon-list"
    li: class="icon-list-item"
    svg: overflow="visible" class="icon"
    img: class="wish-i-had-inline-svgs"
    a: example-attribute="example-value"

svg: 
  optimize: true # Tells svg-inliner to clean up your SVGs.

```

* `default_path:`- Prepended to the filenames specified in your data file.
* `defaults:` - Optional HTML attributes to include with your markup, if none are specified in the
    tag.

If the default filenames and labels don't work for you, create:
`/_data/icon_list.yml`

And fill it with your icons in the following format: 
```
# /_data/icon_list.yml

example1:
  icon: example_logo.svg 
  label: My Nicely Formatted, Long Name
  url: https://example1.com
example2:
  icon: sloppy.svg
  label: Here's Another Label I Don't Have To Type Again
```

The default directory setting in config.yml will be prepended to your
filenames. You'll obviously need some icons, I hear you can find them on the
internet.

If you set a url: for an item in the data file, it'll wrap the li's contents in
an anchor tag for you.

## Contributing

Bug reports and pull requests are welcome. https://github.com/rbuchberger/jekyll_icon_list

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
