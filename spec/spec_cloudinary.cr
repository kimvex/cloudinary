require "spec"
require "./server_cloudinary"

describe "Upload image to server" do
  spawn do
    server()
  end

  it "the image has been uploaded" do
    uploaded = upload()
    uploaded.should_not be_nil

    uploaded.status_code.should eq(200)
    uploaded.body.should_not be_nil
  end
end
