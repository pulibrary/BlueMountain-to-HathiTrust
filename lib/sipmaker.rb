# sipmaker.rb
class SIPMaker
  attr_reader     :objdir
  attr_accessor   :sipdir
  def initialize(obj_directory, sip_directory)
    raise Errno::ENOENT unless Dir.exist?(obj_directory)
    @objdir = obj_directory
    raise Errno::ENOENT unless Dir.exist?(sip_directory)
    @sipdir = sip_directory

  end

  def list
    Dir.entries(@objdir)
  end

end
