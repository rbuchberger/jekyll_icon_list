require 'jekyll_icon_list/version'
require 'jekyll'
require 'jekyll-inline-svg'
# Title: Jekyll Icon List
# Author: Robert Buchberger : robert@robert-buchberger.com
# Description: Generates lists of icons + labels, useful for things like tag
# lists.

module JekyllIconList
  # This tag looks for commands in the following format:
  # {% iconlist item1 item2 item3 --ul class="example" --li class="example2" %}
  # Items are a space separated list of names defined in _data/icons.yml
  # Acceptable commands are --ul, --li, --svg, and --img. Their arguments are
  # inserted into their respective HTML elements upon render.
  class IconList < Liquid::Tag
    def initialize(tag_name, raw_input, tokens)
      @raw_input = raw_input
      @tokens = tokens
      super
    end

    def parse_input(raw_input, settings)
      # Liquid returns everything after the tag list as a string, it's up to us
      # to deal with it.

      # I'm terrible at regex. Here's what this one does: Match everyting from
      # the beginning of the string, excluding (escaped) --, of any length,
      # ignoring whitespace. This will return a space-separated string of items.
      item_regex = /^([^(\-\-)]*)/x

      @items = raw_input.match(item_regex)[0].split(' ')  # Array

      # This regex grabs anything which is preceded by '--' and one of our
      # attribute types, up until the next instance of '--', ignoring
      # whitespace.
      attribute_regex = /\-\-([ul|li|img|svg][^(\-\-)]*)/x

      @attributes = {}

      # This formats, adds defaults, and adds them to the attributes hash:
      raw_input
        .scan(attribute_regex) # Array of single-item arrays
        .map { |t| t[0].strip } # Array of strings with whitespace removed
        .each do |t|
          defaults = settings['defaults'][key] if settings['defaults']
          key = t[/^\w+/]
          value = t.gsub(/^\w+ /, '')
          value += (' ' + defaults) if defaults

          @attributes[key] = value
        end
    end

    def generate_image(icon_data, settings, context)
      if settings['icon_path']
        icon_filename = icon_data['icon'].prepend settings['icon_path']
      end

      file_ext_regex = /\.([a-zA-Z]{1,4})\z/
      file_ext = file_ext_regex.match(icon_filename)[1]

      if file_ext == 'svg'
        # Jekyll::Tags::JekyllInlineSvg.new('svg', icon).render(context)
        # Liquid::Tag.parse('svg', icon, @tokens, Liquid::ParseContext.new).render
        "<img src=\"#{icon_filename}\" alt=\"icon for #{icon_data['label']}\" #{@attributes['svg']}>"
      else
        "<img src=\"#{icon_filename}\" alt=\"icon for #{icon_data['label']}\" #{@attributes['img']}>"
      end
    end

    def render(context)
      # Get site settings
      site = context.registers[:site]
      raise 'could not load site data' unless site
      
      # get iconlist settings
      settings = site.config['icon_list']
      raise 'could not load icon_list settings in config.yml' unless settings
      # get data file
      icon_data = site.data['icon_list']
      raise 'could not load _data/icon_list.yml' unless icon_data

      # Parse the argument string and combine it with site defaults
      parse_input(@raw_input, settings)

      list = "<ul #{@attributes['ul']}>\n"

      @items.each do |i|
        
        raise "Could not find item named #{i} in _/data/icon_data.yml" unless icon_data[i]

        icon = generate_image(icon_data[i], settings, context)
        label = icon_data[i]['label']
        list += "<li #{@attributes['li']}>#{icon}#{label}</li>\n"
      end

      list += "</ul>\n"
    end
  end

end

Liquid::Template.register_tag('iconlist', JekyllIconList::IconList)
