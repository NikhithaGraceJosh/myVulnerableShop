ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
require "logger"
require "bundler/setup"
require "bootsnap/setup" # Remove this line if you don't use bootsnap
