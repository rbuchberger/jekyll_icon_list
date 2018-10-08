# Jekyll Icon List

## What is it? 

It's a jekyll tag that lets you build unordered lists of items that follow the "Icon + label"
format.

Write this: 
```
{% icon_list rails bootstrap heroku aws %}
```

Add some icons, configuration, and a little CSS, get something like this: 

![imgur screenshot]( https://i.imgur.com/9m6qCRB.png )

I use it on [my portfolio](https://robert-buchberger.com/projects.html)
([ github ](https://github.com/rbuchberger/robert-buchberger.com)) if you want to see an example.

You could use it to build category lists, or tag lists, or a bunch of other stuff.  You can pass
element attributes in the tag itself, or set default attributes in the config. It only generates
markup; the styling is up to you.

It integrates with (and requires) [jekyll-svg-inliner](https://github.com/sdumetz/jekyll-inline-svg)
to inline your SVGs for you. If you don't use inline SVGs (even though you should), it sets your file
as the `src=` of an `img` tag.

## Installation

```ruby
# Gemfile

group :jekyll_plugins do
  gem 'jekyll_icon_list'
end
```

`bundle install`

```yml
# _config.yml

plugins: 
  -jekyll_icon_list
```

## Basic Usage

```
{% icon_list example example2 example3 %}
```

By default, with no configuration:

* It will look for icons in images/icons/ with the same name as your shortname, grabbing the first
  result which matches (shortname).*

* It will take your shortname, swap dashes and underscores for spaces, and titleize it for the label.

Example: if you write `{% icon_list ruby-on-rails %}`, with `ruby-on-rails.png` located in
`images/icons/`, it will generate markup like this:
```html
<ul>
  <li><img src="/images/icons/ruby-on-rails.png">Ruby On Rails</li>
<ul>
```

You can add HTML attributes with --(element) arguments: 
```
{% icon_list example --ul class="stumpy" --li class="mopey" data-max-volume="11" %}
```
Which will generate markup like this:
```html
<ul class="stumpy">
  <li class="mopey" data-max-volume="11"><svg>(...)</svg>Example</li>
</ul>
```

Available arguments:
`--ul, --li, --img, --svg, --a`

**These will overwrite any global defaults you have set.** You can use this to prevent application
of the defaults, just pass an empty argument.

## Less Basic Usage
If the default filenames and labels don't work for you, create:
`/_data/icon_list.yml`

And fill it with your icons in the following format: 
```yml
# /_data/icon_list.yml

example1:
  icon: example_logo.svg 
  label: My Nicely Formatted, Long Name
  url: https://example1.com
example2:
  icon: sloppy.svg
  label: Here's Another Label I Don't Have To Type Again
```

Each key is an item shortname, and everything is optional. `icon:` is the filename of the icon you
would like to use, which will be prepended by your default_path if you set one (more on that later).

If you set a `url:`, it'll wrap the `<li>` contents in an anchor tag.

## Configuration

* All of icon_list's configuration is under the `icon_list:` key in \_config.yml
* `default_path:` - Where to find your icons.
* `defaults:` - Optional HTML attributes to include with your markup. They will be ignored if
    a corresponding --(element) argument is passed in the tag.

Here's an example configuration:

```yml
# _config.yml

icon_list:
  default_path: /images/here/
  defaults:
    ul: class="icon-list"
    li: class="icon-list-item"
    svg: overflow="visible" class="icon"
    img: class="wish-i-had-inline-svgs"
    a: example-attribute="example-value"

svg: 
  optimize: true # Tells svg-inliner to clean up your SVGs.

```

## Notes

### Icon finding logic 

It tries to be smart about finding your icons. Here's the decision  matrix:

...               | default_path set    | default_path not set
------------------|---------------------|---------------------
item icon set     | default_path + icon | icon
item icon not set | search default_path | search /images/icons

When it searches a path, it just uses the first match and raises an exception if there aren't
any.

### Accessibility
Right now the only way to set individualized alt text for your icons is to use SVGs, and include a
title tag in the file. Since the label itself will likely describe your image quite nicely, I
recommend you set `alt=""` as a default attribute for image tags.

If you would like automatic alt-text generation, or the ability to specify alt text in the data
file, let me know or write it yourself and submit a pull request.

### Styling
Here's an example that should get you close to the screenshot:

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

### Using \<use> to build an icon system
[CSS tricks on SVG Icon Systems](https://css-tricks.com/svg-sprites-use-better-icon-fonts/). It's an
older article sir, but it checks out. 

[Slightly newer CSS tricks article on \<use>](https://css-tricks.com/svg-use-with-external-reference-take-2/)

[MDN docs](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/use)

You can do it while using this plugin, but you have to do most of it yourself: build & inject the
reference file on your own, and then write your SVG files like this:

```html
<!-- example-name.svg -->
<svg>
	<use href="#example-icon">
</svg>
```

At this point the dependency on jekyll-svg-inliner gets pretty tenuous; do we
really need a plugin and an extra file to render 3 lines of simple code? In the
future I'd like to streamline this.

### Liquid variables

You can't pass in liquid variables yet. It's on the to-do list.

## Contributing

Bug reports and pull requests are welcome. https://github.com/rbuchberger/jekyll_icon_list
Contact: robert@robert-buchberger.com

I've been using rubocop with the default settings, and would appreciate if pull requests did the
same.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
