# frozen_string_literal: true

module MagickCanvas
  class CLI < Thor
    desc 'save SOURCE', 'save the image generated from SOURCE'
    method_option :directory,
                  aliases: '-d',
                  desc: 'Output directory',
                  default: './tmp'
    def save(source)
      directory = options[:directory]
      FileUtils.mkdir_p(directory)

      load source
      Base.descendants.last.new.open(directory)
    end
  end
end
