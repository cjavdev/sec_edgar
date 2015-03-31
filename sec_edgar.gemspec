Gem::Specification.new do |s|
  s.name        = 'sec_edgar'
  s.version     = '0.0.8'
  s.date        = '2015-03-27'
  s.summary     = "SEC filings finder"
  s.description = "Tool for querying the SEC database"
  s.authors     = ["CJ Avilla"]
  s.email       = 'cjavilla@gmail.com'
  s.files       =  Dir.glob("{lib}/**/*")
  s.homepage    = 'http://rubygems.org/gems/sec_edgar'
  s.license     = 'MIT'

  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "addressable"
  s.add_development_dependency "rspec", "~> 3.2.0"
end
