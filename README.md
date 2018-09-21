# Jekyll Icon List

**This plugin works, but I haven't had time to test it very thoroughly. Use with caution, and please
report bugs if you find them.**

## What is it? 

It's a jekyll tag that lets you build unordered lists of items that follow the "Icon + label"
format.

Write a tag like this: 
```
{% iconlist rails bootstrap heroku aws %}
```

Add some icons, configuration, and a little CSS, and you get something like this: 

![imgur screenshot]( https://i.imgur.com/9m6qCRB.png )

You can pass element attributes in the tag itself, or set default attributes in the config. It only
generates markup; the styling is up to you. 

It integrates with (and requires) [jekyll-svg-inliner](https://github.com/sdumetz/jekyll-inline-svg)
to inline your SVGs for you. If you don't use inline SVGs even though you should, it sets your file
as an img src=. 

I use it on [my portfolio](https://robert-buchberger.com/projects.html)
([ github ](https://github.com/rbuchberger/robert-buchberger.com)) if you want to see an example.
(Actually, currently my master branch doesn't use the gem. Yet. Check the other branches.)

## Installation and Setup

(I don't have it hosted on rubygems yet. It will be once I've cleaned it up a bit further. .)

```ruby
jekyll
group :jekyll_plugins do
  gem 'jekyll_icon_list', git: 'https://github.com/rbuchberger/jekyll_icon_list.git'
end
```

in your \_config.yml there are a few settings you should add:
```
# _config.yml
icon_list:
  default_path: /images/here/ # Default directory for your icons
  defaults: # HTML attributes to add to your various elements. 
    ul: class="icon-list"
    li: class="icon-list-item"
    svg: overflow="visible" class="icon"
    img: class="wish-i-could-join-the-inline-svg-master-race"

svg: 
  optimize: true # Optional setting, tells svg-inliner to clean up your SVGs.

```

create the file:
`/_data/icon_list.yml`

And fill it with your icons in the following format: 


```
# /_data/icon_list.yml

example1:
  icon: example_logo.svg 
  label: My Nicely Formatted, Long Name
example2:
  icon: sloppy.svg
  label: Here's Another Label I Don't Have To Type Again
```

The default directory setting in config.yml will be prepended to your filenames. You'll obviously
need some icons, I hear you can find them on the internet.

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
{% iconlist example_shortname example2 %}
```

It looks for a space separated list of the short names in the icon_list.yml file, and generates the
markup from that. You can specify attributes to add with --(element) arguments: 
```
{% iconlist example example2 --ul class="stumpy" --li class="mopey" %}

```

Available arguments:

`--ul, --li, --img, --svg`

It will very simply concatenate your parameters and the defaults set in \_config.yml. It's not
smart enough to handle the same attribute being set twice, so for example you can't add classes in
both the defaults and as an argument in the tag. If that's a feature you want, pull requests are
welcome. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jekyll_icon_list.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
