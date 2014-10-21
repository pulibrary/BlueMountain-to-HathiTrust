require 'spec_helper'

describe 'SIPMaker' do
  it 'SIPMaker#new()' do
    obj_dir = "/tmp/foo"
    sip_dir = "/tmp/bar"
    sipmaker = SIPMaker.new(obj_dir, sip_dir)  # Given
    objdir = sipmaker.objdir    # When
    expect(objdir).to eq(obj_dir)  # Then
    expect(sipmaker.sipdir).to eq(sip_dir)
  end

  it 'SIPMaker#list' do
    obj_dir = "/tmp/foo"
    sip_dir = "/tmp/bar"
    sipmaker = SIPMaker.new(obj_dir, sip_dir)  # Given
    filelist = sipmaker.list
    expect(filelist).not_to be_empty
  end
end
