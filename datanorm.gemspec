# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'datanorm'
  s.version = '1.0.5'
  s.required_ruby_version = '>= 3.4.0'
  s.license = 'MIT'
  s.summary = 'Parse German DATANORM files like you belong to the 90s'
  s.authors = ['halo']
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/halo/datanorm/issues',
    'changelog_uri' => 'https://github.com/halo/datanorm/blob/master/CHANGELOG.md',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/halo/datanorm'
  }

  s.files = Dir['lib/**/*', 'README.md']

  s.add_dependency 'base64'
  s.add_dependency 'bigdecimal'
  s.add_dependency 'calls'
  s.add_dependency 'csv'
  s.add_dependency 'logger'
  s.add_dependency 'tron'
end
