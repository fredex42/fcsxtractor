$: << "../lib"
require 'parent_reference_collection'

class ParentReferenceCollectionSpec
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
    context "with a given test XML" do
      c = ParentReferenceCollection.new(test_xml)
      it "loads in the pre-prepared XML and returns 3 references" do
        expect(c.length).to eq 3
      end
    end
  end
end