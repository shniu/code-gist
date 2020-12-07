---
title: "Network: 搭建一个学习网络的实验环境"
date: 2020-11-25T10:43:22+08:00
draft: true
tags: ['Network', 'Practice']
categories: ['Network', 'Env']
---

https://www.jianshu.com/p/4e893b5bfe81  kvm, qemu, qemu-kvm

虚拟机网络
网络实验环境搭建

## 简单的实验环境

大部分人使用的是 Windows 和 Mac Book, 我们使用虚拟机可以在自己的电脑上轻松搞个网络环境，需要先准备好：

1. VirtualBox
2. Vagrant (可选，方便启动 VirtualBox)
3. 下载 Vagrant Box 镜像或者 Linux 系统的 ISO 镜像，如 Ubuntu 18.04, Centos 7

大致思路：在 MacOS 或者 Windows 上安装 VirtualBox，用 VirtualBox 启动一个 Ubuntu 18.04 的 VM，VM 的网络配置可以使用桥接模式，在 VM 中安装 KVM 相关的软件，然后就可以使用 KVM 来虚拟化出多个 VM，比如可以用 KVM 创建多个 VM 并配置相关的网络

## 复杂的实验环境
