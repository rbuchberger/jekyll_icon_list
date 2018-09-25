require 'jekyll_icon_list/version'
require 'jekyll'
require 'jekyll-inline-svg'
# Title: Jekyll Icon List
# Author: Robert Buchberger : robert@robert-buchberger.com
# Description: Generates lists of icons + labels, useful for things like tag
# lists.

module JekyllIconList
  # This tag looks for commands in the following format:
  # {% icon_list item1 item2 item3 --ul class="example" --li class="example2" %}
  # And renders an unordered list of icons and labels.  Items are a space
  # separated list of names defined in _data/icons.yml. Acceptable commands are
  # --ul, --li, --svg, and --img. Their arguments are inserted into their
  # respective HTML elements upon render.
  class IconList < Liquid::Tag
    def initialize(tag_name, raw_input, tokens)
      @raw_input = raw_input
      @tokens = tokens
      super
    end

    def parse_input
      # raw_input will look something like this:
      # 'item1 item2 item3 --ul attribute="value" --(...)'
      @attributes = @icon_list_settings['defaults'].dup || {}

      raw_input_array = @raw_input.split('--').map { |i| i.strip.split(' ') }
      # [['item1', 'item2', 'item3'], ['ul', 'attribute="value"'], (...) ]

      @item_shortnames = raw_input_array.shift

      raw_input_array.each { |a| @attributes[a.shift] = a.join ' ' }
      @attributes.each_value { |v| v.prepend(' ') }
      @attributes.default = '' # Convenient for concatenation
    end

    def build_image_tag(icon_filename)
      if icon_filename.split('.').pop.casecmp('svg') == 0
        Jekyll::Tags::JekyllInlineSvg.send(
          :new,
          'svg',
          icon_filename + @attributes['svg'],
          @tokens
        ).render(@context)
      else
        "<img src=\"#{icon_filename}\"#{@attributes['img']}>"
      end
    end

    def search_path(path, item)
      # We have to strip the leading slash for Dir to know it's relative:
      search_results = Dir.glob( path[1..-1] + item + '.*')
      raise "No icon found at #{path + item} .*" unless search_results.any?

      # And put it back so that pages outside of the root directory keep working
      search_results.first.prepend '/'
    end

    def find_icon(item_shortname, this_item_data)
      icon_filename = this_item_data['icon']
      path = @icon_list_settings['default_path'] || ''

      if icon_filename
        path + icon_filename
      else
        path = '/images/icons/' if path.empty?
        search_path(path, item_shortname)
      end
    end

    def build_label(shortname, this_item_data)
      this_item_data['label'] ||
        shortname.split(/[-_]/).map(&:capitalize).join(' ')
    end

    def build_li(this_item_data, icon_location, label)
      li = "  <li#{@attributes['li']}>"
      if this_item_data && this_item_data['url']
        li << "<a href=\"#{this_item_data['url']}\"#{@attributes['a']}>"
      end
      li << build_image_tag(icon_location)
      li << label
      li << '</a>' if this_item_data['url']
      li << "</li>\n"
    end

    def build_html(all_items_data)
      list = "<ul#{@attributes['ul']}>\n"

      @item_shortnames.each do |n|
        this_icon_data = all_items_data[n] || {}

        icon_location = find_icon n, this_icon_data

        label = build_label(n, this_icon_data)

        list << build_li(this_icon_data, icon_location, label)
      end

      list << "</ul>\n"
    end

    def render(context)
      @context = context

      site_settings = @context.registers[:site]
      raise 'could not load website configuration data' unless site_settings

      @icon_list_settings = site_settings.config['icon_list'] || {}

      all_items_data = site_settings.data['icon_list'] || {}

      parse_input

      build_html(all_items_data)
    end
  end
end

Liquid::Template.register_tag('icon_list', JekyllIconList::IconList)
