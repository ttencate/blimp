require 'spec_helper'

describe Router do
  describe "#handlers_for_path" do
    context "without any handlers configured" do
      let(:router) { Router.new }

      it "should return the default handlers for the root" do
        router.handlers_for_path("/").should == [Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler]
      end

      it "should return the default handlers for a subdir" do
        router.handlers_for_path("/subdir").should == [Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler]
      end
    end

    context "with some handlers configured" do
      let(:router) { Router.new([{ :path => "/", :handler => "static" }, { :path => "/page", :handler => "page" }]) }

      it "should return handlers for the root" do
        router.handlers_for_path("/").should == [Blimp::Handlers::StaticHandler]
      end

      it "should return configured handlers for subdirectories" do
        router.handlers_for_path("/page").should == [Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler]
      end

      it "should fall back the handler of parent directories" do
        router.handlers_for_path("/foo").should == [Blimp::Handlers::StaticHandler]
        router.handlers_for_path("/page/foo").should == [Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler]
      end

      it "should not match prefixes incorrectly" do
        router.handlers_for_path("/page_with_suffix").should == [Blimp::Handlers::StaticHandler]
      end
    end
  end
end
