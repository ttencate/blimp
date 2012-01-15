require 'spec_helper'

describe Blimp::Handler do
  it 'should find handlers by name' do
    Blimp::Handler.find_by_name("static").should be(Blimp::Handlers::StaticHandler)
    Blimp::Handler.find_by_name("page").should be(Blimp::Handlers::PageHandler)
  end

  it 'should raise on unknown handlers' do
    expect {
      Blimp::Handler.find_by_name("unknown")
    }.to raise_error(Blimp::Handler::HandlerNotFound)
  end
end
