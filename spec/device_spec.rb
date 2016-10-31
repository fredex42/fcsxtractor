$: << "../lib"
require 'device'

class DeviceSpec
  test_xml = '
  <?xml version="1.0"?>
<session>
 <values>
  <value id="LDS_LAST_FETCHED">
   <timestamp>2016-10-31T12:14:16Z</timestamp>
  </value>
  <value id="WINDOWS_EIP_URI">
   <string xml:space="preserve"></string>
  </value>
  <value id="DB_LAST_FETCHED">
   <timestamp>2016-10-31T12:10:13Z</timestamp>
  </value>
  <value id="DEVICE_NAME">
   <string xml:space="preserve">Proxies</string>
  </value>
  <value id="DEVICE_TYPE">
   <atom>contentbase</atom>
  </value>
  <value id="SUPPORTS_PUT">
   <bool>true</bool>
  </value>
  <value id="ENTITY_CREATED">
   <timestamp>2009-04-01T14:43:20Z</timestamp>
  </value>
  <value id="ENTITY_CREATE_USER_NAME">
   <string xml:space="preserve">admin</string>
  </value>
  <value id="DEVICE_ENCODING">
   <atom>UTF-8</atom>
  </value>
  <value id="DEV_ROOT_PATH">
   <string xml:space="preserve">/Volumes/Proxies/DAM_PROXY/Proxies.bundle</string>
  </value>
  <value id="DB_ENTITY_ID">
   <bigint>30</bigint>
  </value>
  <value id="PROFILETOOL_CREATED">
   <bool>true</bool>
  </value>
  <value id="DEVICE_ID">
   <atom>1</atom>
  </value>
  <value id="ASSET_CREATE_RESTRICTION">
   <atom>always</atom>
  </value>
  <value id="IS_CONTAINER">
   <bool>true</bool>
  </value>
  <value id="MD_LAST_MODIFIED">
   <timestamp>2009-04-09T14:18:26Z</timestamp>
  </value>
  <value id="SUPPORTS_SUBDIR">
   <bool>false</bool>
  </value>
  <value id="DEV_NUMBER">
   <int>1</int>
  </value>
  <value id="MAC_EIP_URI">
   <string xml:space="preserve">file://localhost/Volumes/Proxies/DAM_PROXY/Proxies.bundle</string>
  </value>
  <value id="LDS_ENTITY_STATUS">
   <atom>ok</atom>
  </value>
 </values>
</session>'

  RSpec.describe Device, "#parse" do
    context "with a given test XML" do
      device = Device.new(test_xml)
      it "loads in the pre-prepared XML and returns the correct root path" do
        expect(device.dev_root_path).to eq "/Volumes/Proxies/DAM_PROXY/Proxies.bundle"
        expect(device.device_id).to eq "1"
        expect(device.device_name).to eq "Proxies"
      end
      it "raises appropriately if an invalid value is requested" do
        expect{device.invalid_thingy}.to raise_error(KeyError)
      end
    end
  end
end