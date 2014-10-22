require 'spec_helper'

describe 'SIPMaker' do
  it 'SIPMaker#new()' do
    sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
    issue_path = sipmaker.issue_path
    expect(issue_path).to eq('bmtnaad/issues/1922/04_01')
  end

  it 'SIPMaker#image_dir' do
    sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
    expect(sipmaker.image_dir.path).to eq('/usr/share/BlueMountain/astore/periodicals/bmtnaad/issues/1922/04_01/delivery')
  end

  it 'SIPMaker#sip_dir' do
    sipmaker = SIPMaker.new('bmtnaad_1922-04_01') # Given
    expect(sipmaker.sip_dir.path).to eq('/tmp/sip/bmtnaad/issues/1922/04_01')

  end

end
