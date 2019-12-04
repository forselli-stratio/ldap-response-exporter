FROM alpine:3.10
MAINTAINER Stratio Operations <operations@stratio.com>

USER ROOT
ADD query.sh /query.sh
ADD kms_utils.sh kms_utils.sh
ADD b-log.sh b-log.sh
ADD entrypoint.sh /entrypoint.sh

EXPOSE 9118
