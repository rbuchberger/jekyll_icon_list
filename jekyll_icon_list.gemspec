lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_icon_list/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll_icon_list'
  spec.version       = JekyllIconList::VERSION
  spec.authors       = ['Robert Buchberger']
  spec.email         = ['robert@robert-buchberger.com']

  spec.summary       = 'Builds lists of Icons and labels'
  spec.homepage      = 'https://github.com/rbuchberger/jekyll_icon_list'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.  The
  # `git ls-files -z` loads the files in the RubyGem that have been added into
  # git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'jekyll-inline-svg'
  spec.add_dependency 'objective_elements', '~>0.1.0'
end
