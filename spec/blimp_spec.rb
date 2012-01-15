require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Blimp" do
  describe '#gem_root' do
    it 'should be the root of the project' do
      gem_root = Blimp.gem_root
      File.exists?(File.join(gem_root, "lib/blimp.rb")).should be_true
      File.exists?(File.join(gem_root, "bin/blimp")).should be_true
    end
  end
end
