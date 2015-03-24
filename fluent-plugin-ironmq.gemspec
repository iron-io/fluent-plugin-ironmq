# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = "fluent-plugin-ironmq"
  gem.version = "1.0.0"

  gem.authors = ["Ulan Djamanbalaev"]
  gem.email = ["support@iron.io"]
  gem.date = "2015-03-23"
  gem.extra_rdoc_files = [
    "README.rdoc"
  ]
  gem.files = [
    "lib/fluent/plugin/in_ironmq.rb",
    "lib/fluent/plugin/out_ironmq.rb"
  ]
  gem.require_paths = ["lib"]
  gem.summary = "IronMQ input/output plugin for Fluent event collector"
  gem.description = "IronMQ input/output plugin for Fluent event collector"
  gem.homepage = "https://github.com/iron-io/fluent-plugin-ironmq"
  gem.required_rubygems_version = ">= 1.3.6"
  gem.required_ruby_version = Gem::Requirement.new(">= 1.9.3")

  gem.add_runtime_dependency(%q<fluentd>, ["~> 0.10.0"])
  gem.add_runtime_dependency(%q<iron_mq>, ["~> 5.0.1"])

  gem.add_development_dependency "bundler"
end

