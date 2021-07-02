#!/bin/bash

set -eu

## git リポジトリ上の scripts ディレクトリのパスを取得
scripts_dir=$(readlink -f $(cd $(dirname $0) && pwd))

## tiff ソースの tar ball 名を取得
src_tiff="$(basename "$(ls -1vd ${scripts_dir}/../tiff/tiff-*.tar.gz | tail -n 1)" .tar.gz)"
echo $src_tiff

## tiff のビルド
#  * 共有ライブラリはつくらない. 静的ライブラリのみ生成
env --chdir="${scripts_dir}/../tiff" rm -rf "${src_tiff}" || true;
env --chdir="${scripts_dir}/../tiff" tar xvf "${src_tiff}.tar.gz"
env --chdir="${scripts_dir}/../tiff/${src_tiff}" ./configure --prefix=/opt/tiff --disable-webp --enable-shared=no
env --chdir="${scripts_dir}/../tiff/${src_tiff}" make clean -j"$(nproc)"
env --chdir="${scripts_dir}/../tiff/${src_tiff}" make -j"$(nproc)"
env --chdir="${scripts_dir}/../tiff/${src_tiff}" make install
