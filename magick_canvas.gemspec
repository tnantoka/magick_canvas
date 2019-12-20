require_relative 'lib/magick_canvas/version'

Gem::Specification.new do |spec|
  spec.name          = "magick_canvas"
  spec.version       = MagickCanvas::VERSION
  spec.authors       = ["tnantoka"]
  spec.email         = ["tnantoka@bornneet.com"]

  spec.summary       = %q{Creative coding with RMagick.}
  spec.description   = %q{Easily generate PNG and GIF images drawn as you like.}
  spec.homepage      = "https://tnantoka.github.io/magick_canvas"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tnantoka/magick_canvas"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rmagick', '~> 4.0.0'
end
