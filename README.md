# cloudinary

**THIS VERSION IS DEVELOPING**

Module that allows uploading images to cloudinary in an easy way

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cloudinary:
    github: kimvex/cloudinary
```

## Usage

```crystal
require "cloudinary"
```

```
  CLOUDINARY = Cloudinary::Connect.new("api_key", "cloud_name", "preset")

  server = HTTP::Server.new do |context|
    response = CLOUDINARY.upload(
      context,
      "test"
    )

    context.response << response
  end

  server.bind_tcp 8085
  server.listen
```

## Development

To upload images are authentication problems, you have to add a presets that give you that freedom

Go to documentation of cloudinary [add-new-preset](https://cloudinary.com/documentation/upload_images#upload_presets)

- Step 1: Enter the console of cloudinary
- Step 2: Go to `settings`
- Step 4: Go to the `upload` tab
- Step 5: Go down to the section `Upload presets` and `add_upload_preset`
- Step 6: You can add name to your preset or leave it with the name by default and then and **important** in `Signing Mode` choose it as `unsigned`

## Contributing

1. Fork it (<https://github.com/kimvex/cloudinary/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kimvex](https://github.com/your-github-user) Benjamin de la cruz Martinez - creator, maintainer
