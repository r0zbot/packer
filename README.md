## Usage

For testing, build and run the docker container, setting as environment variables:
- `INPUT_DO_TOKEN` - Your DigitalOcean token
- `INPUT_AWS_KEY_ID` - Your AWS key ID (unused for now, DO only)
- `INPUT_AWS_SECRET_KEY` - Your AWS secret (unused for now, DO only)

Ex:

`docker build . -t r0zbot/packer-doctl-awscli:latest && docker run -it -e INPUT_DO_TOKEN=mytokenhere r0zbot/packer-doctl-awscli`
