require 'nokogiri'
require 'awesome_print'
require 'device'
require 'fcs_client'
require 'logger'

#0  = None
#1  = Member (of Production)
#2  = Primary Representation (Original Media)
#3  = Representation
#4  = Clip Proxy
#5  = Thumbnail Proxy
#6  = Frame Proxy
#7  = Keyframe Proxy (Poster with alpha channel)
#8 = Primary Representation Cache
#9 = Backup Version
#10 = Project Directory
#11 = Modified XML
#12 = Master Asset (for Element)
#13 = Archived Representation
#14 = Archive Modified XML
#15 = Edit Proxy
#16 = Production

class ParentReference
  TYPE_DESCRIPTION = {
      0=>"none",
      1=>"member",
      2=>"media",
      3=>"representation",
      4=>"proxy",
      5=>"thumbnail",
      6=>"poster",
      7=>"keyframe",
      8=>"primary_cache",
      9=>"backup",
      10=>"project_directory",
      11=>"project_xml",
      12=>"master_asset",
      13=>"archived_media",
      14=>"archived_xml",
      15=>"edit_proxy",
      16=>"production"
  }

  def initialize(source_element,logger: nil)
    @doc = source_element
    if(logger)
	    @logger=logger
    else
	    @logger=Logger.new(STDOUT)
    end
  end

  def method_missing(called_name)
    xmlname = called_name.upcase
    xmlnode = @doc.xpath(".//value[@id='#{xmlname}']")
    if xmlnode.length>0
      xmlnode.children.text.strip
    else
      xmlnode = @doc.xpath(".//values/value[@id='metadata']/values/value[@id='#{xmlname}']")
      raise KeyError, "no data for #{called_name}" unless (xmlnode.length>0)
      xmlnode.children.text.strip
    end

  end

  def is_real_media?
    case self.link_type.to_i
      when 2
        true
      when 4
        true
      when 5
        true
      when 6
        true
      when 7
        true
      when 11
        true
      when 13
        true
      when 14
        true
      when 15
        true
      else
        false
    end
  end

  def device_ref(device_cache, device_path)
    return device_cache[device_path] if device_cache.key?(device_path)
    device_cache[device_path] = Device.new(FCSClient.get_device(device_path))
  end

  def link_type_name
    TYPE_DESCRIPTION[self.link_type.to_i]
  end

  def self.unscrew_contentbase(filename)
    parts = /^\/*(\d+)_(.*)$/.match(filename)
    raise NameError, "#{filename} is not a contentbase filename" unless (parts)
    hexified = parts[1].to_i.to_s(16)
    pathlead = hexified[2, 2]
    pathfollow = hexified[0, 2]

    leading_zeros = 16-hexified.length
    padding = ""
    leading_zeros.times { padding+='0' }

    "/#{pathlead}/#{pathfollow}/#{padding}#{hexified}/#{parts[2]}"
  end

  def real_filepath(device_cache)
    begin
      d = device_ref(device_cache, self.desc_device_address)
    rescue KeyError=>e
      @logger.error("Keyerror: #{e.message}")
      ap(@doc)
    end

    basepath = self.address.slice(self.desc_device_address.length+1, self.address.length)

    if d.device_type == "contentbase"
      File.join(d.dev_root_path, ParentReference.unscrew_contentbase(basepath))
    else
      File.join(d.dev_root_path, basepath)
    end
  end
end
