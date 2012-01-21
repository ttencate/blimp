require 'spec_helper'

describe Blimp::Post do
  describe "#parse" do
    let(:filename) { "2012-01-02-foo.markdown" }
    let(:body) { stub }
    let(:post) { Blimp::Post.parse(filename, body) }

    it 'parses the date' do
      post.date.should == Date.new(2012, 01, 02)
    end

    it 'parses the slug' do
      post.slug.should == 'foo'
    end

    it 'stores the body' do
      post.body.should == body
    end
  end
end
