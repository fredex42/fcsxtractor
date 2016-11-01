$: << "../lib"
require 'parent_reference'

class ParentReferenceSpec
  test_xml = '
  <?xml version="1.0"?>
      <session>
  <values>
  <value id="METADATA">
  <values>
  <value id="DESC_PATH">
  <string xml:space="preserve"></string>
    </value>
  <value id="DESC_SIZE">
  <bigint>1582378209</bigint>
    </value>
  <value id="DESC_TYPE">
  <string xml:space="preserve">Video - QuickTime</string>
    </value>
  <value id="DESC_TITLE">
  <string xml:space="preserve">150825UNLGBT_FromGuAmRM.mov</string>
    </value>
  <value id="DESC_DEVICE">
  <string xml:space="preserve">Media Library - GaAmerica - Remote Mastering</string>
    </value>
  <value id="DESC_DEVICE_ADDRESS">
  <string xml:space="preserve">/dev/123</string>
    </value>
  <value id="DESC_STATUS">
  <atom>ok</atom>
    </value>
  </values>
  </value>
  <value id="LINK_TYPE">
  <int>2</int>
  </value>
  <value id="ADDRESS">
  <string xml:space="preserve">/dev/123/150825UNLGBT_FromGuAmRM.mov</string>
  </value>
  </values>
 <values>
  <value id="METADATA">
   <values>
    <value id="DESC_PATH">
     <string xml:space="preserve"></string>
  </value>
    <value id="DESC_SIZE">
     <bigint>10227</bigint>
  </value>
    <value id="DESC_TYPE">
     <string xml:space="preserve">Image - JPEG</string>
  </value>
    <value id="DESC_TITLE">
     <string xml:space="preserve">150825UNLGBT_FromGuAmRM.jpg</string>
  </value>
    <value id="DESC_DEVICE">
     <string xml:space="preserve">Proxies</string>
  </value>
    <value id="DESC_DEVICE_ADDRESS">
     <string xml:space="preserve">/dev/1</string>
    </value>
  <value id="DESC_STATUS">
  <atom>ok</atom>
    </value>
  </values>
  </value>
  <value id="LINK_TYPE">
  <int>5</int>
  </value>
  <value id="ADDRESS">
  <string xml:space="preserve">/dev/1/2670117_150825UNLGBT_FromGuAmRM.jpg</string>
  </value>
  </values>
 <values>
  <value id="METADATA">
   <values>
    <value id="DESC_PATH">
     <string xml:space="preserve"></string>
  </value>
    <value id="DESC_SIZE">
     <bigint>221397</bigint>
  </value>
    <value id="DESC_TYPE">
     <string xml:space="preserve">Image - JPEG</string>
  </value>
    <value id="DESC_TITLE">
     <string xml:space="preserve">150825UNLGBT_FromGuAmRM.jpg</string>
  </value>
    <value id="DESC_DEVICE">
     <string xml:space="preserve">Proxies</string>
  </value>
    <value id="DESC_DEVICE_ADDRESS">
     <string xml:space="preserve">/dev/1</string>
    </value>
  <value id="DESC_STATUS">
  <atom>ok</atom>
    </value>
  </values>
  </value>
  <value id="LINK_TYPE">
  <int>6</int>
  </value>
  <value id="ADDRESS">
  <string xml:space="preserve">/dev/1/2670118_150825UNLGBT_FromGuAmRM.jpg</string>
  </value>
  </values>
</session>'

  RSpec.describe ParentReference, "#parse" do
    context "class methods" do
      it "unscrew a contentbase filename correctly" do
        expect(ParentReference.unscrew_contentbase("2670118_150825UNLGBT_FromGuAmRM.jpg")).to eq("/be/28/000000000028be26/150825UNLGBT_FromGuAmRM.jpg")
        expect(ParentReference.unscrew_contentbase("368103_FOUNDLINGFINAL2_2964061.jpg")).to eq("/9d/05/0000000000059de7/FOUNDLINGFINAL2_2964061.jpg")
      end
    end
    context "with a given test XML" do
      testdoc = Nokogiri::XML(test_xml)
      testelem = testdoc.xpath("/session/values").first
      ref = ParentReference.new(testelem)

      it "should return the right address" do
        expect(ref.address).to eq("/dev/123/150825UNLGBT_FromGuAmRM.mov")
      end
      it "should return the right link type" do
        expect(ref.link_type).to eq("2")
      end

      it "should return the right metadata" do
        expect(ref.desc_device_address).to eq("/dev/123")
        expect(ref.desc_size).to eq("1582378209")
      end

      it "should return the right link type string" do
        expect(ref.link_type_name).to eq("media")
      end
    end

  end

end