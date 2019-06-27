require "http"
require "../src/cloudinary"

CLOUDINARY = Cloudinary::Connect.new("", "", "")

def server
  server = HTTP::Server.new do |context|
    response = CLOUDINARY.upload(
      context,
      "test"
    )

    context.response << response
  end

  server.bind_tcp 8085
  server.listen
end

def upload
  IO.pipe do |reader, writer|
    channel = Channel(String).new(1)

    spawn do
      HTTP::FormData.build(writer) do |formdata|
        channel.send(formdata.content_type)

        File.open("./spec/colomitos.jpg") do |file|
          metadata = HTTP::FormData::FileMetadata.new(filename: "foo.jpg")
          headers = HTTP::Headers{"Content-Type" => "image/png"}
          formdata.file("file", file, metadata, headers)
        end
      end

      writer.close
    end

    headers = HTTP::Headers{"Content-Type" => channel.receive}
    response = HTTP::Client.post("http://localhost:8085/", body: reader, headers: headers)

    return response
  end
end
