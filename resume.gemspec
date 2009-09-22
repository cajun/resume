# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{resume}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["cajun"]
  s.date = %q{2009-09-22}
  s.default_executable = %q{resume}
  s.email = %q{zac@kleinpeter.org}
  s.executables = ["resume"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/resume",
     "examples/ruby_coder.rb",
     "lib/pdf_printer.rb",
     "lib/resume.rb",
     "resume.gemspec",
     "spec/resume_spec.rb"
  ]
  s.homepage = %q{http://github.com/cajun/resume}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{cool resume}
  s.test_files = [
    "spec/resume_spec.rb",
     "examples/ruby_coder.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
