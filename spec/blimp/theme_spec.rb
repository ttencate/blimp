require "spec_helper"

describe Theme do
  let(:source) { stub }
  let(:root) { stub(:to_path => stub) }
  let(:theme) { Theme.new(source, root) }

  it "should be initializable from a path and a source" do
    theme.source.should == source
    theme.root.should == root
  end

  it "should have a layout" do
    layout = "{{ content }}"
    source.stub(:get_file => stub(:contents => layout))
    theme.layout.should be_a(Liquid::Template)
  end

  it "should render pages" do
    theme.stub(:layout => Liquid::Template.parse("<p>{{ content }}</p>"))
    page = "A nice page"
    theme.render(page).should == "<p>#{page}</p>"
  end
end
