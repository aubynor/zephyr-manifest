# Zephyr West Manifest

This repository provides west manifests for working with the Zephyr RTOS, pinned to a specific Zephyr version, given by the branch name.

Each manifest is configured for a specific SoC family for a storage optimized workspace.

## init.sh

**init.sh** is a cross platform Bash script that initializes a complete T3 workspace and builds an example to ensure that everything works.

Dependencies: Zephyr platform dependencies and UV. The required SDK will be installed automatically.

Script parameters: SoC family and workspace directory.

SoC families:

* espressif-s3
* st-stm32

### Espressif S3

```bash
curl -sL https://raw.githubusercontent.com/aubynor/zephyr-manifest/v4.4.0/init.sh | bash -s espressif-s3 zephyr-workspace
```

### ST STM32

```bash
curl -sL https://raw.githubusercontent.com/aubynor/zephyr-manifest/v4.4.0/init.sh | bash -s st-stm32 zephyr-workspace
```
