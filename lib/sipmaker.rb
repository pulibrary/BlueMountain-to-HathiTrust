# sipmaker.rb
require 'tmpdir'
require 'fileutils'
require 'nokogiri'
require 'yaml'

class SIPMaker
  attr_reader     :bmtn_root
  attr_reader     :sip_root
  attr_reader     :issue_path
  attr_accessor   :image_dir
  attr_accessor   :meta_dir
  attr_reader     :sip_dir

  @@meta = {
    "bmtnaab" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2011:09:28 15:08:57Z"},
    "bmtnaac" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Firmware v5.23", "date" => "2012:04:09 11:33:45Z"},
    "bmtnaad" => {"make" => "Phase One", "model" => "P65+", "creator" => "Capture One 6 Macintosh", "date" => "2009:06:06 05:47:07"},
    "bmtnaae" => {"make" => "Phase One", "model" => "P65+", "creator" => "Adobe Photoshop CS5 Macintosh", "date" => "2011:05:26 18:29:41-04:00"},
    "bmtnaaf" => {"make" => "Phase One", "model" => "P65+", "creator" => "Adobe Photoshop CS5 Macintosh", "date" => "2009:06:14 05:06:07"},
    "bmtnaag" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:06:18 09:37:32Z"},
    "bmtnaai" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2011:09:28 15:08:57Z"},
    "bmtnaaj" => {"make" => "Phase One", "model" => "P65+", "creator" => "Capture One 6 Macintosh", "date" => "2012:02:22 16:47:42"},
    "bmtnaal" => {"make" => "Phase One", "model" => "P65+", "creator" => "Capture One 6 Macintosh", "date" => "2011:05:26 18:29:41-04:00"},
    "bmtnaam" => {"make" => "Phase One", "model" => "P65+", "creator" => "Capture One 6 Macintosh", "date" => "2009:06:06 06:49:39"},
    "bmtnaan" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Firmware v5.30", "date" => "2011:05:26 16:41:40Z"},
    "bmtnaao" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2012:12:03 10:42:11Z"},
    "bmtnaap" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:12:26 08:47:29Z"},
    "bmtnaaq" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:02 09:48:40Z"},
    "bmtnaar" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:18 15:38:31Z"},
    "bmtnaas" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:25 16:10:11Z"},
    "bmtnaat" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:25 12:01:26Z"},
    "bmtnaau" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:31 14:27:47Z"},
    "bmtnaav" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:10 10:56:58Z"},
    "bmtnaaw" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:02:01 10:11:02Z"},
    "bmtnaax" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:24 09:57:28Z"},
    "bmtnaay" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:11:12 13:15:12Z"},
    "bmtnaaz" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:02:01 12:15:58Z"},
    "bmtnaba" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:10 15:50:30Z"},
    "bmtnabb" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2013:01:10 11:57:22Z"},
    "bmtnabc" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:06:28 11:03:55Z"},
    "bmtnabd" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301708)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:10:09 14:53:06Z"},
    "bmtnabe" => {"make" => "Zeutschel", "model" => "Zeutschel Omniscan 11", "creator" => "ImageGear Version:  13.07.000", "date" => "2010:11:09 10:19:34-05:00"},
    "bmtnabf" => {"make" => "Zeutschel", "model" => "Zeutschel Omniscan 11", "creator" => "ImageGear Version:  13.07.000", "date" => "2010:05:04 14:20:14-04:00"},
    "bmtnabg" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:05:01 11:00:22Z"},
    "bmtnabh" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:08:06 14:43:02Z"},
    "bmtnabi" => {"make" => "Phase One", "model" => "P65+", "creator" => "Capture One 6 Macintosh", "date" => "2011:05:26 18:29:41-04:00"},
    "bmtnabj" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:10:25 14:13:59Z"},
    "bmtnabk" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301737)/Schneider Lens Control", "creator" => "Capture One 6 Macintosh", "date" => "2012:06:21 08:39:04Z"},
    "bmtnabl" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:05:02 10:02:51Z"},
    "bmtnabm" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:03:26 15:12:33Z"},
    "bmtnabn" => {"make" => "Leaf", "model" => "Leaf Aptus-II 12(LI301739)/Other", "creator" => "Capture One 6 Macintosh", "date" => "2013:03:26 11:37:42Z"}
  }


#  def initialize-old(obj_directory, sip_directory)
#    raise Errno::ENOENT unless Dir.exist?(obj_directory)
#    @objdir = obj_directory
#    raise Errno::ENOENT unless Dir.exist?(sip_directory)
#    @sipdir = sip_directory
#  end

  def initialize(issueid)
    @bmtn_root = '/usr/share/BlueMountain'
    @sip_root  = '/tmp/sip'

    # an issueid has the format bmtnxxx_datestring_issuance. E.g., bmtnaap_1921-11_01

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

  def meta
    @@meta[@bmtnid].to_yaml
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

  def generate_txt_files
    # TODO parameterize this!

#    template = Nokogiri::XSLT(File.read('/home/cwulfman/work/BlueMountain-to-HathiTrust/lib/alto2txt.xsl'))
    template = Nokogiri::XSLT(File.read('/Users/cwulfman/git/BlueMountain-to-HathiTrust/lib/alto2txt.xsl'))
    @alto_dir.each do |filename|
      if filename =~ /\.alto\.xml$/
        filepath = File.join(@alto_dir.path, filename)
        document = Nokogiri::XML(File.read(filepath))
        text_doc = template.transform(document)

        text_file_name = File.join(@sip_dir.path, filename.sub("alto.xml", "txt"))
        File.open(text_file_name, 'w').write(text_doc)
      end
    end
  end

  def write_meta_file
    File.open(File.join(@sip_dir.path, "meta.yml"), 'w').write(self.meta)
  end

end
