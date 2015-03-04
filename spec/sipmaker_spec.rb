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
      expect(File.file?(File.join(sipmaker.sip_dir, '00000008.txt'))).to be_truthy
    end
  end

  describe '.write_meta_file' do
    it "should create a file called meta.yml" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.write_meta_file
      expect(File.file?(File.join(sipmaker.sip_dir, 'meta.yml'))).to be_truthy
    end
  end

  describe '.copy_alto_files' do
    it "copies the last alto file" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.copy_alto_files
      expect(File.file?(File.join(sipmaker.sip_dir, '00000008.alto.xml'))).to be_truthy
    end
  end

  describe '.copy_images' do
    it "copies the last image file" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.copy_images
      expect(File.file?(File.join(sipmaker.sip_dir, '00000008.jp2'))).to be_truthy
    end
  end

  describe '.update_checksums' do
    it "updates the checksum hash" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.write_meta_file                      # make sure there's a file to checksum
      sipmaker.update_checksums
    end
  end

  describe '.write_checksums' do
    it "writes the checksum file" do
      sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
      sipmaker.write_meta_file                      # make sure there's a file to checksum
      sipmaker.update_checksums
      sipmaker.write_checksum_file
      expect(File.file?(File.join(sipmaker.sip_dir, 'checksum.md5'))).to be_truthy
    end
  end


end

