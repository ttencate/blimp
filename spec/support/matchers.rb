RSpec::Matchers.define :start_with do |expected|
  match do |actual|
    actual.start_with?(expected)
  end
end
