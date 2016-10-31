require 'nokogiri'
require 'awesome_print'

class Device
  def initialize(sourcexml)
    @doc = Nokogiri::XML(sourcexml)

  end

  def method_missing(called_name)
    xmlname = called_name.upcase
    xmlnode = @doc.xpath("//value[@id='#{xmlname}']")
    raise KeyError, "no data for #{called_name}" unless(xmlnode.length>0)
    xmlnode.children.text.strip
  end

  def decode_path(path)

  end
end