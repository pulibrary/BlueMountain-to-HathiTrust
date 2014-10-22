# sipmaker.rb
require 'tmpdir'
require 'fileutils'

class SIPMaker
  attr_reader     :bmtn_root
  attr_reader     :sip_root
  attr_reader     :issue_path
  attr_accessor   :image_dir
  attr_accessor   :meta_dir
  attr_reader     :sip_dir

#  def initialize-old(obj_directory, sip_directory)
#    raise Errno::ENOENT unless Dir.exist?(obj_directory)
#    @objdir = obj_directory
#    raise Errno::ENOENT unless Dir.exist?(sip_directory)
#    @sipdir = sip_directory
#  end

  def initialize(issueid)
    @bmtn_root = '/usr/share/BlueMountain'
    @sip_root  = '/tmp/sip'

    @bmtnid,issuedate,edition = issueid.match(/^([^_]+)_([^_]+)_([0-9]{2})$/).captures
    @issue_path = File.join(@bmtnid,'issues',(issuedate.sub('-','/') + '_' + edition))
    @image_dir = Dir.new(File.join(@bmtn_root, 'astore', 'periodicals', @issue_path, 'delivery'))
    @meta_dir = Dir.new(File.join(@bmtn_root, 'metadata', 'periodicals', @issue_path))
    @alto_dir = Dir.new(File.join(@bmtn_root, 'metadata', 'periodicals', @issue_path, 'alto'))
    sip_path = File.join(@sip_root, @issue_path)
    unless Dir.exists?(sip_path) 
      FileUtils.mkdir_p(sip_path)
    end
    @sip_dir = Dir.new(sip_path) 
  end

  def copy_images
    @image_dir.each do |f|
      if f =~ /\.jp2$/
        FileUtils.cp File.join(@image_dir.path, f),  @sip_dir
      end
    end
  end

  def copy_alto_files
    @alto_dir.each do |f|
      if f =~ /\.alto\.xml$/
        FileUtils.cp File.join(@alto_dir.path, f),  @sip_dir
      end
    end
  end


end
