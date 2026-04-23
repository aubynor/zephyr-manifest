#!/usr/bin/env bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "usage: init.sh <SoC family> <workspace dir>"
  exit 0
fi

if [ -d "$2" ]; then
  echo "Workspace already exists. Delete it and rerun the script if you want a clean workspace."
  exit 1
fi

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
  echo "UV is not installed. Installing it now..."
  curl -LsSf https://astral.sh/uv/install.sh | sh -s -- --quiet
fi

set -e
set -T
trap '
  printf "\033[1;36m➜ %s\033[0m\n" "$BASH_COMMAND" >&2
' DEBUG

mkdir -p "$2/manifest"
cd "$2"

uv venv --python 3.12
if [ -f .venv/Scripts/activate ]; then
  source .venv/Scripts/activate
elif [ -f .venv/bin/activate ]; then
  source .venv/bin/activate
else
  echo "error: venv not found"
  exit 1
fi

curl -LsSf https://raw.githubusercontent.com/aubynor/zephyr-manifest/refs/heads/v4.4.0/manifests/$1.yml -o "manifest/west.yml"

uv pip install west
west init -l manifest
west update

west zephyr-export
uv pip install $(west packages pip | tr -d '\r')

if [ "$1" = "st-stm32" ]; then
  west sdk install --version 1.0.1 --gnu-toolchains arm-zephyr-eabi
  west config --local build.board disco_l475_iot1
fi

if [ "$1" = "espressif-s3" ]; then
  west blobs fetch hal_espressif
  west sdk install --version 1.0.1 --gnu-toolchains xtensa-espressif_esp32s3_zephyr-elf
  west config --local build.board adafruit_feather_esp32s3_tft/esp32s3/procpu
fi

mkdir samples
cp -r external/zephyr/samples/basic/blinky samples
cp -r external/zephyr/samples/basic/button samples
cp -r external/zephyr/samples/hello_world samples

west build -p always samples/blinky
west build -t pristine
