## Usage

For testing, build and run the docker container, setting as environment variables:
- `INPUT_DO_TOKEN` - Your DigitalOcean token
- `INPUT_AWS_KEY_ID` - Your AWS key ID
- `INPUT_AWS_SECRET_KEY` - Your AWS secret

Ex:

`docker build . -t r0zbot/packer-doctl-awscli:latest && docker run -it -e INPUT_DO_TOKEN=mytokenhere -e INPUT_AWS_KEY_ID=myawskeyid -e INPUT_AWS_SECRET_KEY=myawssecret r0zbot/packer-doctl-awscli`


## AWS Security groups

For AWS, before running this you need to create a security group that allows at least port 22, 80, 443 and 3000 to 0.0.0.0/0, with the `packer` tag key, otherwise the tests will fail to connect.