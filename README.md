# Language
[English](#English) | [中文](#中文)

# English

# OpenBMC Builder Docker Environment

This project provides reusable Docker environments for building the OpenBMC project.  

## Features

- Pre-installed required packages
- User/Group mapping to host
- System environment checking
- Multi-version support

## Build Docker Images

```bash
# Ubuntu 22.04
docker build -f Dockerfile.ubuntu2204 -t obmc-builder-ubuntu2204 .

# Ubuntu 24.04
docker build -f Dockerfile.ubuntu2404 -t obmc-builder-ubuntu2404 .
```

## Run the Container

```bash
# Ubuntu 22.04
docker run -it \
  -v $HOME:$HOME \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e LOCAL_USER=$USER \
  -h obmc-builder \
  obmc-builder-ubuntu2204

# Ubuntu 24.04
docker run -it \
  -v $HOME:$HOME \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e LOCAL_USER=$USER \
  -h obmc-builder \
  obmc-builder-ubuntu2404
```
This will automatically check environment and switch to a non-root user.  

### Stop the Container

```bash
exit
```

## Script: openbmc-builder-env-check.sh

This script runs inside the container to:

- Check and install required packages
- Check system resources
- Create container user matching host UID/GID
- Show welcome message and start shell

You can also run it manually:

```bash
# For host environment check
./openbmc-builder-env-check.sh

# For Docker container mode
./openbmc-builder-env-check.sh docker
```

## File Overview

| File                           | Description                           |
| ------------------------------ | ------------------------------------- |
| `Dockerfile.ubuntu2204`        | OpenBMC builder based on Ubuntu 22.04 |
| `Dockerfile.ubuntu2404`        | OpenBMC builder based on Ubuntu 24.04 |
| `openbmc-builder-env-check.sh` | Entry script for environment checking |

## Build System Requirements

| Resource     | Minimum          | Recommended         |
| ------------ | ---------------- | ------------------- |
| CPU          | 4 cores          | 8+ cores            |
| RAM          | 8 GB             | 32+ GB              |
| Disk Space   | 100 GB           | 100+ GB             |

## Welcome Message

You will see a welcome message when the container starts.  

```bash
===================================================
|  Welcome to openbmc builder docker container!!  |
===================================================
```
We hope this helps you get started with OpenBMC development faster.  

# 中文

# OpenBMC 編譯環境（Docker 版）

支援快速建立多個 Ubuntu 版本的 OpenBMC 編譯容器，方便跨版本測試與開發。

## 功能特性

- 預先安裝建置所需套件
- 自動對應主機的 UID/GID，避免權限問題
- 系統環境檢查與資源建議（CPU、RAM、Disk）
- 支援多種 Ubuntu 版本（目前為 22.04 與 24.04）

## 建立 Docker 映像檔

```bash
# Ubuntu 22.04
docker build -f Dockerfile.ubuntu2204 -t obmc-builder-ubuntu2204 .

# Ubuntu 24.04
docker build -f Dockerfile.ubuntu2404 -t obmc-builder-ubuntu2404 .
```

## 啟動容器

```bash
# Ubuntu 22.04
docker run -it \
  -v $HOME:$HOME \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e LOCAL_USER=$USER \
  -h obmc-builder \
  obmc-builder-ubuntu2204

# Ubuntu 24.04
docker run -it \
  -v $HOME:$HOME \
  -e LOCAL_UID=$(id -u) \
  -e LOCAL_GID=$(id -g) \
  -e LOCAL_USER=$USER \
  -h obmc-builder \
  obmc-builder-ubuntu2404
```
上述指令會自動檢查環境，並切換至非 root 使用者執行。

### 停止容器

```bash
exit
```

## Script: openbmc-builder-env-check.sh

本腳本用於容器啟動時，執行以下動作：

- 檢查並安裝必要套件
- 檢查 CPU、記憶體、磁碟空間等系統資源
- 建立符合主機帳號的容器使用者
- 顯示歡迎訊息並進入 shell

你也可以手動執行：

```bash
# 本機環境檢查
./openbmc-builder-env-check.sh

# Docker 模式檢查（建立使用者等）
./openbmc-builder-env-check.sh docker
```

## 檔案說明

| 檔案名稱                        | 說明                                   |
| ------------------------------ | ------------------------------------- |
| `Dockerfile.ubuntu2204`        | 基於Ubuntu 22.04的OpenBMC建構器         |
| `Dockerfile.ubuntu2404`        | 基於Ubuntu 24.04的OpenBMC建構器         |
| `openbmc-builder-env-check.sh` | 環境檢查入口腳本                         |

## 編譯系統建議需求

| 資源          | 最低需求          | 建議配置             |
| ------------ | ---------------- | ------------------- |
| CPU          | 4 cores          | 8+ cores            |
| RAM          | 8 GB             | 32+ GB              |
| Disk Space   | 100 GB           | 100+ GB             |

## 歡迎訊息

你會在容器啟動時看到醒目的歡迎訊息：

```bash
===================================================
|  Welcome to openbmc builder docker container!!  |
===================================================
```
希望這能幫助你更快開始 OpenBMC 的開發
