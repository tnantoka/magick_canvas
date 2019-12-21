# frozen_string_literal: true

module MagickCanvas
  class CLI < Thor
    TYPES = %w[png gif].freeze
    DEFAULT_TYPE = TYPES.first

    desc 'new PATH [-t TYPE]', 'generate the basic template file to PATH'
    method_option :type,
                  aliases: '-t',
                  desc: "Image type (options: #{TYPES.join(', ')})",
                  default: DEFAULT_TYPE
    def new(path)
      type = TYPES.find { |t| t == options[:type] } || DEFAULT_TYPE
      template_filename = "../../examples/sine_wave_#{type}.rb"
      template = File.read(File.expand_path(template_filename, __dir__))
      File.write(path, template)
    end

    desc 'draw SOURCE [-d DIRECTORY] [-a APP]',
         'save the image generated from SOURCE'
    method_option :directory,
                  aliases: '-d',
                  desc: 'Output directory',
                  default: './tmp'
    method_option :app,
                  aliases: '-a',
                  desc: 'Application to open the generated image'
    def draw(source)
      directory = options[:directory]
      basename = File.basename(source, '.*')
      FileUtils.mkdir_p(directory)

      load source
      canvas = Base.descendants.last.new
      path = "#{directory}/#{basename}.#{canvas.extname}"
      canvas.save(path)

      app = options[:app]
      `open -a #{app} #{path}` if app
    end
  end
end
