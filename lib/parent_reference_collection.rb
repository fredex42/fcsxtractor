require 'nokogiri'
require 'parent_reference'

class ParentReferenceCollection
  include Enumerable

  def initialize(source_xml)
    @doc = Nokogiri::XML(source_xml)
    @refs = []

    @doc.xpath("/session/values").each { |reference_node|
      @refs << ParentReference.new(reference_node)
    }
  end

  def each(&b)
    @refs.each(&b)
  end

  def length
    @refs.length
  end
end