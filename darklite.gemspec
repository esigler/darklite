Gem::Specification.new do |spec|
  spec.name          = 'darklite'
  spec.version       = '0.2.0'
  spec.authors       = ['Eric Sigler']
  spec.email         = ['me@esigler.com']
  spec.description   = 'A small daemon to manage Internet-connected lights.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/esigler/darklite'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'dotenv'
  spec.add_runtime_dependency 'huey'
  spec.add_runtime_dependency 'ruby-sun-times'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
