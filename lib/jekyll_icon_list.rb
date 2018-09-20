require "jekyll_icon_list/version"
require 'jekyll'
# Title: Jekyll Icon List
# Author: Robert Buchberger : robert@robert-buchberger.com
# Description: Generates lists of icons + labels, useful for things like tag
# lists.

module JekyllIconList
  # Here's the tag!
  class IconList < Liquid::Tag
    def initialize(tag_name, content, tokens)
      super
    end

    def render(context)
      "Your icon list is working!"
    end
  end
end

Liquid::Template.register_tag('iconlist', JekyllIconList::IconList)


# Steps to accomplish:
# Parse tag argument (split comma separated string into an array)
# -- Argument will have a list of technologies, and a set of attributes for the icons and the list.
# need a way to set default attributes for the list, so we don't have to type it every time
# build the list.
