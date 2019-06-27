require "http"
require "json"

module Cloudinary
  VERSION = "0.1.0"

  # Adding module for upload image to cloudinary
  # Has been add:
  # - api_key => of acount on cloudinary
  # - cloud_name => of cloud in the acount
  # - preset => of preset that gives permission, read documentation of module or cloudinary
  class Connect
    @api_key = ""
    @cloud_name = ""
    @format = "png"
    @preset = ""

    # Create a instace
    #
    # ```api_key``` => of acount on cloudinary
    #
    # ```cloud_name``` => of cloud in the acount
    #
    # preset => of preset that gives permission, read documentation of module or cloudinary
    def initialize(api_key = "", cloud_name = "", preset = "")
      puts api_key
      @api_key = api_key
      @cloud_name = cloud_name
      @preset = preset
      @folder = ""
    end

    private def engineUpload(file)
      IO.pipe do |reader, writer|
        channel = Channel(String).new(1)

        spawn do
          HTTP::FormData.build(writer) do |formdata|
            channel.send(formdata.content_type)

            formdata.field("upload_preset", @preset)
            formdata.field("folder", @folder)
            metadata = HTTP::FormData::FileMetadata.new(filename: file.filename)
            formdata.file("file", file.body, metadata)
          end

          writer.close
        end

        headers = HTTP::Headers{"Content-Type" => channel.receive, "api_key" => @api_key}
        response = HTTP::Client.post("https://api.cloudinary.com/v1_1/#{@cloud_name}/image/upload", body: reader, headers: headers)
        {
          data:        JSON.parse(response.body),
          status_code: response.status_code,
        }.to_json
      end
    end

    # Upload image to server
    #
    # ```env``` refers to context of server when make a request to endpoint
    #
    # ```folder``` where the image is saved in the cloudinary
    #
    # Example:
    # ```
    # server = HTTP::Server.new do |context|
    #   response = CLOUDINARY.upload(
    #     context,
    #     "test"
    #   )
    #
    #   context.response << response
    # end
    #
    # server.bind_tcp 8085
    # server.listen
    # ```
    def upload(env, folder)
      @folder = folder
      HTTP::FormData.parse(env.request) do |upload|
        return self.engineUpload(upload)
      end
    end
  end
end
