# encoding: utf-8
require File.expand_path('../lib/capistrano/tagging3/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'capistrano-tagging3'
  s.platform    = Gem::Platform::RUBY
  s.version     = Capistrano::Tagging3::VERSION.dup

  s.authors     = ['Dimko', 'Leon Berenschot', 'Ian Heggie']
  s.email       = ['deemox@gmail.com', 'LeonB@beriedata.nl', 'ian@heggie.biz']

  s.summary     = "Tag your deployed commit to git"
  s.description = <<-EOF
    Create a tag in the local and remote repo on every deploy with capistrano v3
  EOF

  s.homepage    = 'http://github.com/ianheggie/capistrano-tagging3'

  s.add_dependency 'capistrano', '~> 3.0'

  s.files       = `git ls-files`.split("\n")
  s.has_rdoc    = false

  s.require_paths = ['lib']
end
