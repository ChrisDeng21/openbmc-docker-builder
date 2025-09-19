# OpenBMC Builder Docker Environment / OpenBMC 編譯環境（Docker 版）

This project provides reusable Docker environments for building the OpenBMC project.  
支援快速建立多個 Ubuntu 版本的 OpenBMC 編譯容器，方便跨版本測試與開發。

## Features / 功能特性

- Pre-installed required packages / 預先安裝建置所需套件
- User/Group mapping to host / 自動對應主機的 UID/GID，避免權限問題
- System environment checking / 系統環境檢查與資源建議（CPU、RAM、Disk）
- Multi-version support / 支援多種 Ubuntu 版本（目前為 22.04 與 24.04）

## Build Docker Images / 建立 Docker 映像檔

```bash
# Ubuntu 22.04
docker build -f Dockerfile.ubuntu2204 -t obmc-builder-ubuntu2204 .

# Ubuntu 24.04
docker build -f Dockerfile.ubuntu2404 -t obmc-builder-ubuntu2404 .
```

## Run the Container / 啟動容器

```bash
# Ubuntu 22.04
docker run -it \
  -v $HOME:$HOME \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e LOCAL_USER=$USER \
  obmc-builder-ubuntu2204

# Ubuntu 24.04
docker run -it \
  -v $HOME:$HOME \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e LOCAL_USER=$USER \
  obmc-builder-ubuntu2404
```
This will automatically check environment and switch to a non-root user.  
上述指令會自動檢查環境，並切換至非 root 使用者執行。

### Stop the Container / 停止容器

```bash
exit
```

## Script: openbmc-builder-env-check.sh

This script runs inside the container to:

本腳本用於容器啟動時，執行以下動作：

- Check and install required packages / 檢查並安裝必要套件
- Check system resources / 檢查 CPU、記憶體、磁碟空間等系統資源
- Create container user matching host UID/GID / 建立符合主機帳號的容器使用者
- Show welcome message and start shell / 顯示歡迎訊息並進入 shell

You can also run it manually:

你也可以手動執行：

```bash
# For host environment check / 本機環境檢查
./openbmc-builder-env-check.sh

# For Docker container mode / Docker 模式檢查（建立使用者等）
./openbmc-builder-env-check.sh docker
```

## File Overview / 檔案說明

| File 檔案名稱                   | Description 說明                      |
| ------------------------------ | ------------------------------------- |
| `Dockerfile.ubuntu2204`        | OpenBMC builder based on Ubuntu 22.04 |
| `Dockerfile.ubuntu2404`        | OpenBMC builder based on Ubuntu 24.04 |
| `openbmc-builder-env-check.sh` | Entry script for environment checking |

## Build System Requirements / 編譯系統建議需求

| Resource 資源 | Minimum 最低需求 | Recommended 建議配置 |
| ------------ | ---------------- | ------------------- |
| CPU          | 4 cores          | 8+ cores            |
| RAM          | 8 GB             | 32+ GB              |
| Disk Space   | 100 GB           | 100+ GB             |

## Welcome Message / 歡迎訊息

You will see a welcome message when the container starts.  
你會在容器啟動時看到醒目的歡迎訊息：

```bash
===================================================
|  Welcome to openbmc builder docker container!!  |
===================================================
```
We hope this helps you get started with OpenBMC development faster.  
希望這能幫助你更快開始 OpenBMC 的開發
