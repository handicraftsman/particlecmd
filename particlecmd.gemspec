
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'particlecmd/version'

Gem::Specification.new do |spec|
  spec.name          = 'particlecmd'
  spec.version       = ParticleCMD::VERSION
  spec.authors       = ['Nickolay Ilyushin']
  spec.email         = ['nickolay02@inbox.ru']

  spec.summary       = 'A command parser'
  spec.description   = 'A command parser'
  spec.homepage      = 'https://github.com/handicraftsman/particlecmd'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
end
