#*****************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*****************************************************************************

# Create the theme config.ini
FROM debian:buster-slim AS configbuilder

ARG THEME_PATH

COPY planet/ /tmp/planet
RUN /tmp/planet/utils/genconfig.sh "${THEME_PATH}" "/tmp/planet/theme" > /tmp/config.ini

FROM eclipsefdn/planet-venus:buster-slim

ARG THEME_PATH
ARG CACHE_PATH
ARG WWW_PATH

WORKDIR /var/planet

# CACHE_PATH and WWW_PATH should be mounted as volumes, 
# but in case they are not, make sure that they exist
RUN mkdir -p "${THEME_PATH}" && chmod -R g+w "${THEME_PATH}" \
  && mkdir -p "${CACHE_PATH}" && chmod -R g+w "${CACHE_PATH}" \
  && mkdir -p "${WWW_PATH}" && chmod -R g+w "${WWW_PATH}"

COPY planet/planet.ini /var/planet/
COPY planet/theme "${THEME_PATH}"
COPY --from=configbuilder /tmp/config.ini "${THEME_PATH}"/

# This volume needs to be mounted inside a HTTP server container as the document root
VOLUME [ "${WWW_PATH}", "${CACHE_PATH}" ]

USER 10001:0

# Change refresh frequency to once every hour
# ENV REFRESH_FREQUENCY_SECONDS 3600

CMD [ "update-planet.sh", "/var/planet" ]