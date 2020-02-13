
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "time_methods/version"

Gem::Specification.new do |spec|
  spec.name          = "time_methods"
  spec.version       = TimeMethods::VERSION
  spec.authors       = ["Seyon Vasantharajan"]
  spec.email         = ["seyon.vasantharajan@gmail.com"]

  spec.summary       = %q{Easily set methods to profile and view run-times in terminal }
  spec.description   = <<-DESCRIPTION
                        Time Method allows easy setting of runtime without having to alter 
                        the code of the methods and also allows
                       DESCRIPTION
  spec.homepage      = "https://github.com/seyonv/time_methods"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib","lib/time_method"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
