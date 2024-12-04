# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)

APP_ROOT = File.expand_path('..', __dir__)
$LOAD_PATH.push(File.expand_path("#{APP_ROOT}/lib"))
