Gem::Specification.new do |s|
  s.name        = 'fcsxtractor'
  s.version     = '0.1'
  s.date        = '2016-10-31'
  s.summary     = "Final Cut Server extractor"
  s.description = "Tool to extract file information from Final Cut Server"
  s.authors     = ["Andy Gallagher"]
  s.email       = 'andy.gallagher@theguardian.com'
  s.files       = ["lib/device.rb","lib/parent_reference.rb","lib/parent_reference_collection.rb",
                "lib/fcs_client.rb"]
  s.executables = ["fcsxtractor.rb"]
  s.license       = 'GPLv3'

  s.add_development_dependency 'rspec', '>=3.5'
  s.add_development_dependency 'awesome_print', '>=1.7.0'
  s.add_development_dependency 'rspec_junit_formatter', '>=0.2.3'
  s.add_runtime_dependency 'nokogiri', '>=1.5.6'
  s.add_runtime_dependency 'elasticsearch-api', '>=1.0.7'
  s.add_runtime_dependency 'trollop', '>=2.0.0'

  s.required_ruby_version = '>=2.0.0'

end