require 'spec_helper'

describe Blimp::Renderer do
  describe '#render' do
    it 'renders text/html' do
      Blimp::Renderer.render("html", "text/html").should == ["html", "text/html"]
    end

    it 'renders text/markdown' do
      Blimp::Renderer.render("*markdown*", "text/markdown").should == ["<p><em>markdown</em></p>\n", "text/html"]
    end
  end
end
