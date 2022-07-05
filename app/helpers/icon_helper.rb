# frozen_string_literal: true

module IconHelper
  # rubocop:disable Metrics/ParameterLists
  def icon(name, filled: false, size: 'medium', weight: 'normal', emphasis: 'normal', color: nil, classes: nil, hover_text: name, outline: nil)
    using_custom_icon = custom?(name)
    contents = using_custom_icon ? custom_content(name) : name
    options = {
      class: classes(using_custom_icon, filled, size, weight, emphasis, classes),
      title: hover_text
    }
    options[:style] = "#{using_custom_icon ? 'fill' : 'color'}: var(--rms-colors-#{color}-base);" if color # primary, secondary, tertiary

    tag.span(contents, **options)
  end

  private

  def classes(using_custom_icon, filled, size, weight, emphasis, additional_classes = nil)
    shape_class = filled ? 'icon--filled' : 'icon--outlined' # true, false
    size_class = "icon--#{size}" # normal, large, x-large
    weight_class = "icon--weight-#{weight}" # light, normal, semi-bold, bold
    emphasis_class = "icon--#{emphasis}-emphasis" # low, normal, high

    base_class = using_custom_icon ? 'custom-icons' : 'material-symbols-outlined'
    "#{base_class} #{shape_class} #{size_class} #{weight_class} #{emphasis_class} #{additional_classes}"
  end
  # rubocop:enable Metrics/ParameterLists

  def custom_icon_path(name)
    Webpacker.manifest.lookup("static/icons/#{name}.svg")
  end

  def custom?(name)
    custom_icon_path(name).present?
  end

  def custom_content(name)
    custom_icon_contents = load_svg_from_file_or_dev_server(custom_icon_path(name))

    # These SVG files can safely be marked html_safe since we created them and
    # they are part of this app's code.
    custom_icon_contents.html_safe # rubocop:disable Rails/OutputSafety
  end

  def load_svg_from_file_or_dev_server(custom_icon_path)
    # Read in SVG file. Needs special handling for the webpack dev server
    # because that doesn't write out any of the files.
    if Webpacker.dev_server.running?
      dev_server = Webpacker.dev_server
      custom_icon_path.slice!("#{dev_server.protocol}://#{dev_server.host_with_port}")
      connection = URI.open("#{dev_server.protocol}://#{dev_server.host_with_port}#{custom_icon_path}") # rubocop:disable Security/Open
      contents = connection.read
      connection.close
      contents
    else
      File.read(File.join(Webpacker.config.public_path, custom_icon_path))
    end
  end
end