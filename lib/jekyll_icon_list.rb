require 'jekyll_icon_list/version'
require 'jekyll'
require 'jekyll-inline-svg'
# Title: Jekyll Icon List
# Author: Robert Buchberger : robert@robert-buchberger.com
# Description: Generates lists of icons + labels, useful for things like tag
# lists.

module JekyllIconList
  # Here's the tag!
  class IconList < Liquid::Tag
    def initialize(tag_name, raw_args, tokens)
      @raw_args = raw_args
      super
    end

    def parse_arguments(raw_args, settings)
      # Format: {% iconlist tag1, tag2, tag3, ul: class="example", li: class="example2" %}

      args_parser = /(?<icons>.+?)(, ul: (?<ul_attributes>.+?))?(, li: (?<li_attributes>.+?))?\z/

      args_hash = args_parser.match raw_args
      @icons = args_hash[:icons].split(', ')


      @ul_attrs = args_hash[:ul_attributes] 
      @li_attrs = args_hash[:li_attributes]

      if settings['ul_defaults']
        @ul_attrs += (" " + settings['ul_defaults'])
      end

      if settings["li_defaults"]
        @li_attrs += (" " + settings['li_defaults'])
      end

      @ul_attrs = @ul_attrs.prepend(' ') if @ul_attrs
      @li_attrs = @li_attrs.prepend(' ') if @li_attrs
    end

    def generate_image(icon, settings, context)
      if settings['icon_path']
        icon = icon.prepend settings['icon_path']
      end

      file_ext_regex = /\.([a-zA-Z]{1,4})\z/
      file_ext = file_ext_regex.match(icon)[1]

      if file_ext == 'svg'
        JekyllInlineSVG.new('svg', icon).render(context)
      else
        "<img src=#{icon}>"
      end
    end

    def render(context)
      # Get site settings
      site = context.registers[:site]
      # get iconlist settings
      settings = site.config['icon_list']
      # get data file
      icon_data = site.data['icon_list']

      # Parse the argument string and combine it with site defaults
      parse_arguments(@raw_args, settings)

      list = "<ul#{@ul_attrs}>\n"

      @icons.each do |i|
        icon = generate_image(icon_data[i]['icon'], settings, context)
        label = icon_data[i]['label']
        list += "<li#{@li_attrs}>#{icon}#{label}</li>\n"
      end

      list += "</ul>\n"

    end
  end


end

Liquid::Template.register_tag('iconlist', JekyllIconList::IconList)
