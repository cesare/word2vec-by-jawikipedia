#!/bin/bash

set -eu

root_dir=$(cd "$(dirname ${BASH_SOURCE[0]})/.." && pwd)
build_dir="${root_dir}/build"

mkdir -p ${build_dir} && cd ${build_dir}

target_date="20200301"
base_name="jawiki-${target_date}-pages-articles"
archive_name="${base_name}.xml"
compressed_file_name="${archive_name}.bz2"
download_url="https://dumps.wikimedia.org/jawiki/${target_date}/${compressed_file_name}"


if [[ ! -f ${archive_name} ]]; then
  if [[ ! -f ${compressed_file_name} ]]; then
    curl --output ${compressed_file_name} ${download_url}
  fi

  bzip2 -d ${compressed_file_name}
fi


text_file_name="${base_name}.txt"

if [[ ! -f ${text_file_name} ]]; then
  wp2txt_dir="wp2txt"
  rm -rf ${wp2txt_dir}
  mkdir -p ${wp2txt_dir}

  bundle exec wp2txt \
    --input-file ${archive_name} \
    --output-dir=${wp2txt_dir}

  cat ${wp2txt_dir}/*.txt > ${text_file_name}
fi


wakati_file_name="${base_name}-wakati.txt"

if [[ ! -f ${wakati_file_name} ]]; then
  dicdir="$(mecab-config --dicdir)/mecab-ipadic-neologd"
  mecab --dicdir=${dicdir} \
    --input-buffer-size=50000 \
    --output-format-type=wakati \
    --output=${wakati_file_name} \
    ${text_file_name}
fi

model_file_name="${base_name}.model"

if [[ ! -f ${model_file_name} ]]; then
  pipenv run python "${root_dir}/bin/generate_w2v.py" \
    ${wakati_file_name} \
    ${model_file_name}
fi
