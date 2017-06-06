#!/usr/bin/env bash

# This bash script makes use of the Slack API to upload files.
# I found this useful due to the fact that the attachement option
# available in incoming webhooks seems to have an upper limit of
# content size, which is way too small.
#
# See also: https://api.slack.com/methods/files.upload

# safety first
set -euf -o pipefail

echo='echo -e'

Usage() {
  ${echo}
  ${echo} "\tusage:\n\t\t$0 [OPTIONS]"
  ${echo}
  ${echo} "Required:"
  ${echo} " -c CHANNEL\tSlack channel to post to"
  ${echo} " -f FILENAME\tName of file to upload"
  ${echo} " -s SLACK_TOKEN\tAPI auth token"
  ${echo}
  ${echo} "Optional:"
  ${echo} " -u API_URL\tSlack API endpoint to use (default: https://slack.com/api/files.upload)"
  ${echo} " -h     \tPrint help"
  ${echo} " -m TYPE\tFile type (see https://api.slack.com/types/file#file_types)"
  ${echo} " -n TITLE\tTitle for slack post"
  ${echo} " -v     \tVerbose mode"
  ${echo} " -x COMMENT\tAdd a comment to the file"
  ${echo}
  exit ${1:-$USAGE}
}

# Exit Vars

: ${HELP:=0}
: ${USAGE:=1}

# Default Vars
API_URL='https://slack.com/api/files.upload'
CURL_OPTS='-s'

# main

while getopts :c:f:s:u:hm:n:vx: OPT; do
  case ${OPT} in
    c)
      CHANNEL="$OPTARG"
      ;;
    f)
      FILENAME="$OPTARG"
      SHORT_FILENAME=$(basename ${FILENAME})
      ;;
    s)
      SLACK_TOKEN="$OPTARG"
      ;;
    u)
      API_URL="$OPTARG"
      ;;
    h)
      Usage ${HELP}
      ;;
    m)
      CURL_OPTS="${CURL_OPTS} -F filetype=${OPTARG}"
      ;;
    n)
      CURL_OPTS="${CURL_OPTS} -F title='${OPTARG}'"
      ;;
    v)
      CURL_OPTS="${CURL_OPTS} -v"
      ;;
    x)
      CURL_OPTS="${CURL_OPTS} -F initial_comment='${OPTARG}'"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      Usage ${USAGE}
      ;;
  esac
done

if [[ ( "${CHANNEL}" != "#"* ) && ( "${CHANNEL}" != "@"* ) ]]; then
  CHANNEL="#${CHANNEL}"
fi

# had to use eval to avoid strange whitespace behavior in options
eval curl $CURL_OPTS \
  --form-string channels=${CHANNEL} \
  -F file=@${FILENAME} \
  -F filename=${SHORT_FILENAME} \
  -F token=${SLACK_TOKEN} \
  ${API_URL}

exit 0
