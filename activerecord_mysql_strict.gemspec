# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/mysql/strict/version'

Gem::Specification.new do |spec|
  spec.name          = 'activerecord_mysql_strict'
  spec.version       = ActiveRecord::MySQL::Strict::VERSION
  spec.authors       = ['Rémi Prévost']
  spec.email         = ['rprevost@mirego.com']
  spec.description   = 'ActiveRecord::MySQL::Strict adds validations to ActiveRecord models to make sure they do not trigger errors in MySQL strict mode.'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/mirego/activerecord_mysql_strict'
  spec.license       = 'BSD 3-Clause'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 3.0.0'
  spec.add_dependency 'activemodel', '>= 3.0.0'
  spec.add_dependency 'activesupport', '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'sqlite3'
end
