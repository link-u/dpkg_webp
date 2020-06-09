#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
scripts_dir=$(readlink -f $(cd $(dirname $0) && pwd))

## パッケージのディレクトリ名
pkg_dir="webp"

## ビルド時に必要なパッケージのインストール
env --chdir="${scripts_dir}/../${pkg_dir}" \
  mk-build-deps --install --remove \
  --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' \
  debian/control

env --chdir="${scripts_dir}/../tiff" rm -rf tiff-4.1.0 || true;
env --chdir="${scripts_dir}/../tiff" tar xvf tiff-4.1.0.tar.gz
env --chdir="${scripts_dir}/../tiff/tiff-4.1.0" ./configure --prefix=/opt/tiff --disable-webp --enable-shared=no
env --chdir="${scripts_dir}/../tiff/tiff-4.1.0" make clean -j"$(nproc)"
env --chdir="${scripts_dir}/../tiff/tiff-4.1.0" make -j"$(nproc)"
env --chdir="${scripts_dir}/../tiff/tiff-4.1.0" make install

## deb ファイルのビルド
bash "${scripts_dir}/create_changelog.sh"
bash "${scripts_dir}/build.sh"
