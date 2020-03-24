#!/bin/bash

set -eu

root_dir=$(cd "$(dirname ${BASH_SOURCE[0]})/.." && pwd)
script_dir=${root_dir}/bin
build_dir=${root_dir}/build

target_date="20200301"
model_path=${build_dir}/jawiki-${target_date}-pages-articles.model

cd ${root_dir}

pipenv run python \
  ${script_dir}/w2v_repl.py \
  ${model_path}

