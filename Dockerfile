#
# Copyright (c) 2019 Eclipse Foundation, Inc.
# 
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v. 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0.
# 
# Contributors:
#   Christopher Guindon <chris.guindon@eclipse-foundation.org>
# 
# SPDX-License-Identifier: EPL-2.0

FROM debian:jessie
MAINTAINER Christopher Guindon <chris.guindon@eclipse-foundation.org>

# Install requirements
RUN apt-get update && \
  apt-get install -y planet-venus vim cron git

# Create workspace
WORKDIR /workspace
RUN git clone https://github.com/jakartaee/jakartablogs.ee.git \
  && mkdir -p www && mkdir -p cache

# Create crontab file in the cron directory
RUN echo "*/5 * * * * root { cd /workspace/jakartablogs.ee && git pull origin master && cd planet && planet planet.ini \
  && cp -rf theme/authors /workspace/www && cp -rf theme/css /workspace/www  ;} \
  2> /proc/1/fd/1" \
  > /etc/cron.d/jakartablogs

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/jakartablogs

# Apply cron job
RUN crontab /etc/cron.d/jakartablogs

CMD ["cron", "-f"]