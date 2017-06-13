describe Semvergen::Bump do
  let(:semvergen) { Semvergen::Bump.new nil, nil, nil, nil, nil, nil, nil, nil }

  describe :next_version do
    let(:next_version) { semvergen.next_version current_version, release_type }
    let(:current_version) { "3.2.19" }

    context "when bumping a major version" do
      let(:release_type) { Semvergen::Bump::MAJOR }
      it { expect(next_version).to eq "4.0.0" }
    end

    context "when bumping a minor version" do
      let(:release_type) { Semvergen::Bump::MINOR }
      it { expect(next_version).to eq "3.3.0" }
    end

    context "when bumping a patch version" do
      let(:release_type) { Semvergen::Bump::PATCH }
      it { expect(next_version).to eq "3.2.20" }
    end

  end

end
