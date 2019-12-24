# frozen_string_literal: true

module MagickCanvas
  class CLI < Thor
    TYPES = %w[png gif].freeze
    DEFAULT_TYPE = TYPES.first

    desc 'new PATH [-t=TYPE]', 'generate the basic template file to PATH'
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

    desc 'draw SOURCE [-d=DIRECTORY] [-a=APP] [-w]',
         'save the image generated from SOURCE'
    method_option :directory,
                  aliases: '-d',
                  desc: 'Output directory',
                  default: './tmp'
    method_option :app,
                  aliases: '-a',
                  desc: 'Application to open the generated image'
    method_option :watch,
                  aliases: '-w',
                  type: :boolean,
                  desc: 'Flag to redraw automatically when SOURCE is changed'
    def draw(source)
      save(source)
      watch(source)
    end

    private

    def canvas_class
      Base.descendants.last
    end

    def watch(source)
      return unless options[:watch]

      listener(source).start
      sleep
    rescue Interrupt
      puts ''
    end

    def listener(source)
      Listen.to(
        File.expand_path('../', source),
        only: /\A#{Regexp.escape(File.basename(source))}\z/
      ) do
        canvas_class.class_eval do
          constants(false).each(&method(:remove_const))
        end
        save(source)
      end
    end

    def save(source)
      directory = options[:directory]
      basename = File.basename(source, '.*')

      FileUtils.mkdir_p(directory)

      load source
      canvas = canvas_class.new
      path = "#{directory}/#{basename}.#{canvas.extname}"
      canvas.save(path)

      open_in_app(path)
    rescue => e
      puts e.message, e.backtrace
    end

    def open_in_app(path)
      app = options[:app]
      `open -g -a #{app} #{path}` if app
    end
  end
end
