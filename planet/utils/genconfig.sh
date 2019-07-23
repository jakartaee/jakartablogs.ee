#!/usr/bin/env bash
#*****************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*****************************************************************************

shopt -s nullglob

TEMPLATE_DIRECTORIES="${1:-}"
THEME_FOLDER="${2:-}"

cat <<EOF 
[Planet]

template_directories: ${TEMPLATE_DIRECTORIES}

template_files: 
EOF

for f in "${THEME_FOLDER}/"*.tmpl; do
  echo "  $(realpath --relative-to="${THEME_FOLDER}" "${f}")"
done

for f in "${THEME_FOLDER}/"*.xslt; do
  echo "  $(realpath --relative-to="${THEME_FOLDER}" "${f}")"
done

cat <<EOF 

bill_of_materials: 
EOF

for f in "${THEME_FOLDER}/authors/"*; do
  echo "  $(realpath --relative-to="${THEME_FOLDER}" "${f}")"
done

for f in "${THEME_FOLDER}/css/"*; do
  echo "  $(realpath --relative-to="${THEME_FOLDER}" "${f}")"
done

for f in "${THEME_FOLDER}/images/"*; do
  echo "  $(realpath --relative-to="${THEME_FOLDER}" "${f}")"
done