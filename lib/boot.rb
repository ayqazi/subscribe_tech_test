# frozen_string_literal: true

APP_ROOT = File.expand_path('..', __dir__)
$LOAD_PATH.push(File.expand_path("#{APP_ROOT}/lib"))

require 'bundler/setup'
Bundler.require(:default)
