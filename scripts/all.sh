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

## deb ファイルのビルド
bash "${scripts_dir}/create_changelog.sh"
bash "${scripts_dir}/build.sh"
