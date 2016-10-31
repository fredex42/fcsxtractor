require 'nokogiri'
require 'awesome_print'
require 'device'
require 'fcs_client'

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
      raise KeyError, "no data for #{called_name}" unless(xmlnode.length>0)
      xmlnode.children.text.strip
    end

  end

  def device_ref(device_cache,device_path)
    return device_cache[device_path] if device_cache.key?(device_path)
    device_cache[device_path] = Device.new(FCSClient.get_device(device_path))
  end

  def real_filepath(device_cache)
   d = device_ref(device_cache,self.desc_device_address)
   basepath = self.address.slice(self.desc_device_address.length,self.address.length)

   if d.device_type == "contentbase"
	#contentbase stores screw around with their filenames
	File.join(d.dev_root_path,basepath) 
   else
	File.join(d.dev_root_path,basepath)
   end
  end
end
