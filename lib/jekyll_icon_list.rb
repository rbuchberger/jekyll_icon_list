require 'jekyll_icon_list/version'

require 'jekyll'
require 'jekyll-inline-svg'
require 'jekyll/liquid_extensions'
require 'objective_elements'

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
    # Used for finding liquid variables in input
    include Jekyll::LiquidExtensions

    def initialize(tag_name, raw_input, tokens)
      @raw_input = raw_input
      @tokens = tokens
      super
    end

    def render(context)
      @context = context

      site_settings = @context.registers[:site]
      raise 'could not load website configuration data' unless site_settings

      @icon_list_settings = site_settings.config['icon_list'] || {}

      all_items_data = site_settings.data['icon_list'] || {}

      build_settings

      build_html(all_items_data)
    end

    def build_settings
      @attributes = @icon_list_settings['defaults'].dup || {}
      # {'ul' => 'class="awesome" (...)', (...)}

      # raw_input will look something like this:
      # 'item1 item2 item3 --ul attribute="value" --(...)'
      raw_input_array = liquid_lookup(@raw_input).split('--').map do |i|
        i.strip.split(' ')
      end
      # [['item1', 'item2', 'item3'], ['ul', 'attr="value', 'value2"'],(...)]

      @item_shortnames = raw_input_array.shift
      # item_shortnames = ['item1', 'item2', 'item3']
      # raw_input_array = ['ul, 'attribute="value1 value2"', (...)]

      raw_input_array.each { |a| @attributes[a.shift] = a.join ' ' }
      # {'ul' => 'attribute="value1 value2 value3"'}
    end

    LIQUID_REGEX = /\{\{\s*([\w]+\.?[\w]*)\s*\}\}/i
    def liquid_lookup(input)
      # I mostly stole this method from SVG Inliner. There may be a better way,
      # but this works well enough.
      input.scan LIQUID_REGEX do |match|
        value = lookup_variable(@context, match.first)
        value = value.join(' ') if value.is_a? Array

        input = input.sub(LIQUID_REGEX, value)
      end

      input
    end

    def build_html(all_items_data)
      list = DoubleTag.new 'ul', attributes: @attributes['ul']

      @item_shortnames.each do |n|
        this_item_data = all_items_data[n] || {}

        icon_location = find_icon n, this_item_data

        label = build_label(n, this_item_data)

        list.add_content build_li(this_item_data, icon_location, label)
      end

      list.to_s
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

    def search_path(path, item)
      # If there is a leading slash, we have to strip it for Dir to know it's
      # relative:
      search_path = path[0] == '/' ? path[1..-1] : path
      search_results = Dir.glob(search_path + item + '.*')
      raise "No icon found at #{path + item} .*" unless search_results.any?

      # And put it back so that pages outside of the root directory keep working
      search_results.first.prepend '/'
    end

    def build_label(shortname, this_item_data)
      this_item_data['label'] ||
        shortname.split(/[-_]/).map(&:capitalize).join(' ')
    end

    def build_li(this_item_data, icon_location, label)
      li = DoubleTag.new(
        'li',
        attributes: @attributes['li'],
        content: [build_image_tag(icon_location), label],
        oneline: true
      )
      return li unless this_item_data['url']

      li.reset_content build_anchor(this_item_data['url'], li.content)
    end

    def build_image_tag(icon_filename)
      if icon_filename.split('.').pop.casecmp('svg').zero?
        build_svg(icon_filename)
      else
        build_img(icon_filename)
      end
    end

    def build_svg(icon_filename)
      params = icon_filename
      params << ' ' + @attributes['svg'] if @attributes['svg']
      Jekyll::Tags::JekyllInlineSvg.send(
        :new,
        'svg',
        params,
        @tokens
      ).render(@context)
    end

    def build_img(icon_filename)
      img = SingleTag.new 'img', attributes: { src: icon_filename }
      img.add_attributes @attributes['img'] if @attributes['img']
    end

    def build_anchor(url, content)
      a = DoubleTag.new 'a', attributes: { href: url }, oneline: true
      a.add_content content
      a.add_attributes @attributes['a'] if @attributes['a']
      a
    end
  end
end

Liquid::Template.register_tag('icon_list', JekyllIconList::IconList)
