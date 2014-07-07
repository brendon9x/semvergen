require 'spec_helper'

describe Semvergen::Shell do

  let :shell do
    Semvergen::Shell.new(command_map)
  end

  describe :git_index_dirty? do

    let :with_added do
      <<-STR
 M file_a
A  file_b
AM file_c
?? file_d
      STR
    end

    let :with_only_changed do
      <<-STR
?? file_x
      STR
    end

    it "returns true when index dirty" do
      expect(Semvergen::Shell.new("git status --porcelain" => with_added).git_index_dirty?).to be_truthy
      expect(Semvergen::Shell.new("git status --porcelain" => with_only_changed).git_index_dirty?).to be_falsey
    end

  end

end