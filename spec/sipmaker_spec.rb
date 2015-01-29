require 'spec_helper'

RSpec.describe 'SIPMaker' do
  describe '.new' do
    context "with a valid blue mountain object" do
      it "contains a valid issue path" do
        sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
        issue_path = sipmaker.issue_path
        expect(issue_path).to eq('bmtnaad/issues/1922/04_01')
      end
    end
  end

  describe '.generate_txt_files' do
    it "creates text files" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.generate_txt_files
    end
  end

  describe '.write_meta_file' do
    it "should create a file called meta.yml" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.write_meta_file
      expect(File.file?(File.join(sipmaker.sip_dir, 'meta.yml'))).to be_truthy
    end
  end
end

