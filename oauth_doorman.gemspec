Gem::Specification.new do |s|
  s.name = "oauth_doorman"
  s.version = "0.1.0"
  s.date = "2012-07-25"
  s.summary = "google 3rd party authentification"
  s.files = [
    "lib/oauth_doorman.rb",
    "lib/oauth_sender.rb",
    "lib/oauth_receiver.rb",
    "lib/oauth_user_info_api.rb",
    "lib/oauth_domain_groups_api.rb",
    "lib/oauth_offline_api.rb",
    "lib/oauth_error.rb"
  ]
  s.authors = [
    "jan pospisil"
  ]
  s.require_paths = ["lib"]
  s.add_dependency('httpclient', '>= 2.2.5')
  s.add_dependency('json')
  s.add_dependency('activesupport')

  s.homepage = "http://www.ataxo.com"
  s.email = "jan.pospisil@ataxo.com"
  s.has_rdoc = true
  s.description = "composes authentification url, gets google acces_token of user account and gets access to user Google API"

  s.rdoc_options << '--title' << 'Rake -- Ruby Make' <<
                    '--main' << 'README' <<
                    '--line-numbers'
end
