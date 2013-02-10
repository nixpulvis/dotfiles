# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dotfiles/version'

Gem::Specification.new do |gem|
  gem.name          = "nathan_dotfiles"
  gem.version       = Dotfiles::VERSION
  gem.authors       = ["Nathan Lilienthal"]
  gem.email         = ["nathanl@ccs.neu.edu"]
  gem.description   = %q{These are my dotfiles, packaged up and ready to go, the gem itself is to assist in the setup and maintenance of the dotfiles.}
  gem.summary       = %q{My dotfiles, and the ruby that makes it all work.}
  gem.homepage      = "https://github.com/nathan/dotfiles"

  gem.files         = `git ls-files`.split($/)
  gem.executables   << "dotfiles"
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
