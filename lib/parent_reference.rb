require 'nokogiri'

class ParentReference
  def initialize(source_element)
    @doc = source_element
  end

  def method_missing(called_name)
    xmlname = called_name.upcase
    xmlnode = @doc.xpath("/value[@id='#{xmlname}']")
    if xmlnode.length>0
      xmlnode.children.text.strip
    else
      xmlnode = @doc.xpath("/value[@id='metadata']/value[@id='#{xmlname}']")
      raise KeyError, "no data for #{called_name}" unless(xmlnode.length>0)
      xmlnode.children.text.strip
    end

  end

end