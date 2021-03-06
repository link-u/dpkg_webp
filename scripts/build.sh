#! /bin/bash

set -eu

## git リポジトリ上の root のパスを取得
root_dir="$(cd "$(dirname "$(readlink -f "$0")")" && cd .. && pwd)"

## パッケージのディレクトリ名
pkg_dir="webp"

## パッケージのソース tar ball のファイル名とバージョン名の取得
src="$(basename "$(find "${root_dir}/${pkg_dir}" -mindepth 1 -maxdepth 1 -type f -name "*.tar.gz")")"
libname="$(basename "${src}" ".tar.gz")"

## パッケージのソース tar ball の展開
env --chdir="${root_dir}/${pkg_dir}/" tar xvf "${src}"

## 展開したパッケージのソースのディレクトリ名取得
src_dir="$(basename "${root_dir}/${pkg_dir}/"*"${libname}")"

## debian package のビルド
env --chdir="${root_dir}/${pkg_dir}/" cp -r debian "${src_dir}";
env --chdir="${root_dir}/${pkg_dir}/${src_dir}" fakeroot debian/rules clean -j"$(nproc)"
env --chdir="${root_dir}/${pkg_dir}/${src_dir}" fakeroot debian/rules build -j"$(nproc)"
env --chdir="${root_dir}/${pkg_dir}/${src_dir}" fakeroot debian/rules binary -j"$(nproc)"

## 不要なパッケージの削除
#  * webp はスタティックリンクしているため共有ライブラリは必要ない.
rm "${root_dir}/${pkg_dir}/libwebp"*"$(lsb_release -cs)"*".deb"
