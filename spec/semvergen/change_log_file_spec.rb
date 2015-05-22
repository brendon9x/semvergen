require 'debugger'
describe Semvergen::ChangeLogFile do

  let(:changelog_filename) { "spec/support/CHANGELOG.md" }
  let(:changelog_file) { Semvergen::ChangeLogFile.new(changelog_filename) }

  describe :features do

    context "latest version" do

      it "returns the correct features" do
        expect(changelog_file.features).to include("* Feature 1", "* Feature 2", "* Feature 3")
      end

      it "does not include extra features" do
        expect(changelog_file.features.count).to eq(3)
      end

    end

    context "specified version" do
      let(:version) { "1.1.3" }
      let(:features) { changelog_file.features(version) }

      it "returns the correct features" do
        expect(features).to include("* feature", "* another feature")
      end

      it "does not include extra features" do
        expect(features.count).to eq(2)
      end

    end

  end

end
