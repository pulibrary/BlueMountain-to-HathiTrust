# sipmaker.rb
require 'tmpdir'
require 'fileutils'
require 'nokogiri'
require 'yaml'
require 'digest'

class SIPMaker
  attr_reader     :bmtn_root
  attr_reader     :sip_root
  attr_reader     :issue_path
  attr_accessor   :image_dir
  attr_accessor   :meta_dir
  attr_reader     :sip_dir

  @@meta = {
    "bmtnaab" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2011-09-28T15:08:57-05:00"},
    "bmtnaac" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Firmware v5.23", "capture_date" => "2012-04-09T11:33:45-05:00"},
    "bmtnaad" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2009-06-06T05:47:07-05:00"},
    "bmtnaae" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Adobe Photoshop CS5 Macintosh", "capture_date" => "2011-05-26T18:29:41-04:00"},
    "bmtnaaf" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Adobe Photoshop CS5 Macintosh", "capture_date" => "2009-06-14T05:06:07-05:00"},
    "bmtnaag" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-06-18T09:37:32-05:00"},
    "bmtnaai" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2011-09-28T15:08:57-05:00"},
    "bmtnaaj" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-02-22T16:47:42-05:00"},
    "bmtnaal" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2011-05-26T18:29:41-04:00"},
    "bmtnaam" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2009-06-06T06:49:39-05:00"},
    "bmtnaan" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Firmware v5.30", "capture_date" => "2011-05-26T16:41:40-05:00"},
    "bmtnaao" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-12-03T10:42:11-05:00"},
    "bmtnaap" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-12-26T08:47:29-05:00"},
    "bmtnaaq" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-02T09:48:40-05:00"},
    "bmtnaar" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-18T15:38:31-05:00"},
    "bmtnaas" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-25T16:10:11-05:00"},
    "bmtnaat" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-25T12:01:26-05:00"},
    "bmtnaau" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-31T14:27:47-05:00"},
    "bmtnaav" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-10T10:56:58-05:00"},
    "bmtnaaw" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-02-01T10:11:02-05:00"},
    "bmtnaax" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-24T09:57:28-05:00"},
    "bmtnaay" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-11-12T13:15:12-05:00"},
    "bmtnaaz" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-02-01T12:15:58-05:00"},
    "bmtnaba" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-10T15:50:30-05:00"},
    "bmtnabb" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-01-10T11:57:22-05:00"},
    "bmtnabc" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-06-28T11:03:55-05:00"},
    "bmtnabd" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-10-09T14:53:06-05:00"},
    "bmtnabe" => {"scanner_make" => "Zeutschel", "scanner_model" => "Zeutschel Omniscan 11", "scanner_user" => "ImageGear Version:  13.07.000", "capture_date" => "2010-11-09T10:19:34-05:00"},
    "bmtnabf" => {"scanner_make" => "Zeutschel", "scanner_model" => "Zeutschel Omniscan 11", "scanner_user" => "ImageGear Version:  13.07.000", "capture_date" => "2010-05-04T14:20:14-04:00"},
    "bmtnabg" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-05-01T11:00:22-05:00"},
    "bmtnabh" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-08-06T14:43:02-05:00"},
    "bmtnabi" => {"scanner_make" => "Phase One", "scanner_model" => "P65+", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2011-05-26T18:29:41-04:00-5:00"},
    "bmtnabj" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-10-25T14:13:59-05:00"},
    "bmtnabk" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2012-06-21T08:39:04-05:00"},
    "bmtnabl" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-05-02T10:02:51-05:00"},
    "bmtnabm" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-03-26T15:12:33-05:00"},
    "bmtnabn" => {"scanner_make" => "Leaf", "scanner_model" => "Leaf Aptus-II 12(LI301739)/Other", "scanner_user" => "Capture One 6 Macintosh", "capture_date" => "2013-03-26T11:37:42-05:00"}
  }


#  def initialize-old(obj_directory, sip_directory)
#    raise Errno::ENOENT unless Dir.exist?(obj_directory)
#    @objdir = obj_directory
#    raise Errno::ENOENT unless Dir.exist?(sip_directory)
#    @sipdir = sip_directory
#  end

  def initialize(issueid)
    @issueid = issueid
    @bmtn_root = '/usr/share/BlueMountain'
    @sip_root  = '/tmp/sip'
    @checksums = {}

    # an issueid has the format bmtnxxx_datestring_issuance. E.g., bmtnaap_1921-11_01

    @bmtnid,issuedate,edition = issueid.match(/^([^_]+)_([^_]+)_([0-9]{2})$/).captures
    @issue_path = File.join(@bmtnid,'issues',(issuedate.sub('-','/') + '_' + edition))
    @image_path = File.join(@bmtn_root, 'astore', 'periodicals', @issue_path, 'delivery')
    @image_dir = Dir.new(File.join(@bmtn_root, 'astore', 'periodicals', @issue_path, 'delivery'))
    @meta_dir = Dir.new(File.join(@bmtn_root, 'metadata', 'periodicals', @issue_path))
    @alto_dir = Dir.new(File.join(@bmtn_root, 'metadata', 'periodicals', @issue_path, 'alto'))
    sip_path = File.join(@sip_root, @issue_path)
    unless Dir.exists?(sip_path) 
      FileUtils.mkdir_p(sip_path)
    end
    @sip_dir = Dir.new(sip_path)
  end

  def meta
    @@meta[@bmtnid].to_yaml
  end

  def copy_images
    Dir.glob(File.join(@image_path, '*.jp2')).each_with_index do |f,i|
      target = File.join(@sip_dir.path, (seq_number(f) + '.jp2'))
      FileUtils.cp f, target                   
    end
  end

  def seq_number(filepath)
    num = filepath.split('_').last.split('.').first
    #    "%08d" % filepath.split('_').last.split('.').first
    "%08d" % num.to_i
  end

  def copy_alto_files
    @alto_dir.each do |f|
      if f =~ /\.alto\.xml$/
        target = File.join(@sip_dir.path, (seq_number(f) + '.xml'))
        FileUtils.cp File.join(@alto_dir.path, f),  target
      end
    end
  end

  def alto2txt_path
    File.expand_path("../alto2txt.xsl", __FILE__)
  end

  def generate_txt_files
    stylesheetpath = '/Users/cwulfman/git/BlueMountain-to-HathiTrust/lib/alto2txt.xsl'
    @alto_dir.each do |filename|
      if filename =~ /\.alto\.xml$/
        filepath = File.join(@alto_dir.path, filename)
        target = File.join(@sip_dir.path, (seq_number(filename) + '.txt'))
        cmd = "saxon " + filepath + " -xsl:" + stylesheetpath + ' -o:' + target
        txt_doc = `#{cmd}`
      end
    end
  end

  def generate_txt_files_old
    # TODO parameterize this!

#    template = Nokogiri::XSLT(File.read('/home/cwulfman/work/BlueMountain-to-HathiTrust/lib/alto2txt.xsl'))
    xslpath = File.expand_path("../alto2txt.xsl", __FILE__)
    template = Nokogiri::XSLT(File.read(xslpath))
    @alto_dir.each do |filename|
      if filename =~ /\.alto\.xml$/
        filepath = File.join(@alto_dir.path, filename)
        document = Nokogiri::XML(File.read(filepath))
        text_doc = template.transform(document)
        target = File.join(@sip_dir.path, (seq_number(filename) + '.txt'))
#        File.open(target, 'w').write(text_doc)
        File.open(target, 'w') {|f| f.write(text_doc) }
      end
    end
  end

  def write_meta_file
    File.open(File.join(@sip_dir.path, "meta.yml"), 'w') { |f| f.write(self.meta) }
  end

  # Nokogiri doesn't support xslt 2.0! And the 1.0 marc scripts are broken!!!!
  def write_marcxml_file_old
    template = Nokogiri::XSLT(File.read('/Users/cwulfman/git/BlueMountain-to-HathiTrust/lib/mets2marc.xsl'))
    metsfile = File.join(@meta_dir, (@issueid + '.mets.xml'))
    target = File.join(@sip_dir.path, 'marc.xml')
    metsdoc = Nokogiri::XML(File.read(metsfile))
    marcxml_doc = template.transform(metsdoc)
    #    FileUtils.cp metsfile, target
    File.open(target, 'w').write(marcxml_doc)
  end

  def write_marcxml_file
    metsfile = File.join(@meta_dir, (@issueid + '.mets.xml'))
    target = File.join(@sip_dir.path, 'marc.xml')
    stylesheetpath = '/Users/cwulfman/git/BlueMountain-to-HathiTrust/lib/mets2marc.xsl'
    cmd = "saxon " + metsfile + " -xsl:" + stylesheetpath
    marcxml_doc = `#{cmd}`
#    File.open(target, 'w').write(marcxml_doc)
    File.open(target, 'w') { |f| f.write(marcxml_doc) }
  end


  def update_checksums
    @sip_dir.each do |f|
      unless f.eql? "checksum.md5"
        fp = File.join(@sip_dir, f)
        @checksums[f] = Digest::MD5.file(fp).hexdigest if File.file?(fp)
      end
    end
  end

  def checksums
    @checksums.each do |k,v|
      puts "#{v} #{k}"
    end
  end

  def write_checksum_file
    File.open(File.join(@sip_dir.path, "checksum.md5"), 'wb') {|f| @checksums.each {|k,v| f << "#{v} #{k}\n"} }
  end

  def make_sip
    self.copy_alto_files
    self.copy_images
    self.write_meta_file
    self.write_marcxml_file
    self.generate_txt_files
    self.update_checksums
    self.write_checksum_file
  end

end
