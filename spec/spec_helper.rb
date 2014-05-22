$LOAD_PATH.unshift(File.join(__dir__, "..", "lib"))

require "rspec/its"

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end