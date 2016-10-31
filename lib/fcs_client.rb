class FCSClient
  PROG = "/Library/Application Support/Final Cut Server/Final Cut Server.bundle/Contents/MacOS/fcsvr_client"

  def self.get_device(devicepath)
    `"#{PROG}" getmd "#{devicepath}" --xml`
  end

  def self.get_parent_links(assetpath)
    `"#{PROG}" list_parent_links "#{assetpath}" --xml`
  end
end
