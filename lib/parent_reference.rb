require 'nokogiri'
require 'awesome_print'
require 'device'
require 'fcs_client'

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
  def initialize(source_element)
    #ap source_element
    @doc = source_element
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

  def device_ref(device_cache, device_path)
    return device_cache[device_path] if device_cache.key?(device_path)
    device_cache[device_path] = Device.new(FCSClient.get_device(device_path))
  end

  def self.unscrew_contentbase(filename)
    parts = /^(\d+)_(.*)$/.match(filename)
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
    d = device_ref(device_cache, self.desc_device_address)
    basepath = self.address.slice(self.desc_device_address.length+1, self.address.length)

    if d.device_type == "contentbase"
      File.join(d.dev_root_path, ParentReference.unscrew_contentbase(basepath))
    else
      File.join(d.dev_root_path, basepath)
    end
  end
end
