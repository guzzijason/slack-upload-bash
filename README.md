# slack-upload.sh

Bash script for uploading files via the slack API

I was previously using the attachment option of incoming webhooks, but
ran into a problem where content that was too large would get truncated.
File uploads (i.e. code snippets, etc) have a much larger max size.

## Usage

```
  usage:
    ./slack-upload.sh [OPTIONS]

Required:
 -c CHANNEL Slack channel to post to
 -f FILENAME  Name of file to upload
 -s SLACK_TOKEN API auth token

Optional:
 -u API_URL Slack API endpoint to use (default: https://slack.com/api/files.upload)
 -h       Print help
 -m TYPE  File type (see https://api.slack.com/types/file#file_types)
 -n TITLE Title for slack post
 -v       Verbose mode
 -x COMMENT Add a comment to the file
```

## Example

```
./slack-upload.sh -f /tmp/somefile.txt -c '#mychannel' -s SLACK_API_KEY -n 'Lorem Ipsum' -x 'Hope you find this useful!'
```
![slack upload](/img/slack-upload.png?raw=true "Slack Upload")


