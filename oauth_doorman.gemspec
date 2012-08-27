# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = "oauth_doorman"
  s.version         = OauthDoorman::VERSION
  s.date            = "2012-07-25"

  s.authors         = ["jan pospisil"]
  s.email           = "jan.pospisil@ataxo.com"
  s.homepage        = "https://github.com/Ataxo/oauth_doorman"
  s.description     = "composes authentification url, gets google acces_token of user account and gets access to user Google API"
  s.summary         = "google 3rd party authentification"

  s.files           = [
                        "lib/oauth_doorman.rb",
                        "lib/oauth_sender.rb",
                        "lib/api/oauth_access_api.rb",
                        "lib/api/oauth_error.rb",
                        "lib/api/oauth_user_info_api.rb",
                        "lib/api/oauth_domain_groups_api.rb"
                      ]

  s.executables     = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files      = s.files.grep(%r{^(test|api/test)/})
  s.require_paths   = ["lib", "lib/api"]

  s.has_rdoc        = true
  s.rdoc_options << '--title' << 'Rake -- Ruby Make' <<
                    '--main' << 'README' <<
                    '--line-numbers'

  s.add_dependency('rake', '~> 0.9.2')
  s.add_dependency('httpclient', '~> 2.2.5')
  s.add_dependency('json_pure')
  s.add_dependency('activesupport', '~> 3.2.0')
  s.add_dependency('nokogiri')

  s.add_development_dependency('shoulda', '~> 3.1.1')
  s.add_development_dependency('turn', '~> 0.9.6')
#  s.add_development_dependency('fakeweb', '~> 1.3')
#  s.add_development_dependency('mocha', '~> 0.10')

end

