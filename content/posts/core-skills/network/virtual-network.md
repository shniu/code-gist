---
title: "Network: 虚拟网络"
date: 2020-11-26T11:20:31+08:00
draft: true
tags: ['Network', '虚拟化']
categories: ['Network', 'Virtual network']
---

## 虚拟网卡

虚拟机和容器已经成为标配。它们背后的网络管理都离不开一样东西，就是虚拟网络设备，或者叫虚拟网卡，tap/tun 就是在云计算时代非常重要的虚拟网络网卡。

### TAP/TUN

tap/tun 是 Linux 内核 2.4.x 版本之后实现的虚拟网络设备，不同于物理网卡靠硬件网路板卡实现，tap/tun 虚拟网卡完全由软件来实现，功能和硬件实现完全没有差别，它们都属于网络设备，都可以配置 IP，都归 Linux 网络设备管理模块统一管理。

TAP 等同于一个以太网设备，它操作第二层数据包如以太网数据帧。TUN 模拟了网络层设备，操作第三层数据包比如 IP 数据封包。

作为网络设备，tap/tun 也需要配套相应的驱动程序才能工作。tap/tun 驱动程序包括两个部分，一个是字符设备驱动，一个是网卡驱动。这两部分驱动程序分工不太一样，字符驱动负责数据包在内核空间和用户空间的传送，网卡驱动负责数据包在 TCP/IP 网络协议栈上的传输和处理。

1. via: https://www.cnblogs.com/bakari/p/10450711.html

## 网络虚拟化

## VirtualBox Network

每个 VirtualBox 虚拟机最多可以使用 8 个虚拟网络适配器，每个适配器又称为网络接口控制器 (NIC)。在 VirtualBox GUI（图形用户界面）中可以配置四个虚拟网络适配器。所有虚拟网络适配器 (最多 8 个) 都可以使用 VBoxManage modifyvm 命令进行配置。VBoxManage 是 VirtualBox 的命令行管理工具，可用于配置所有 VirtualBox 设置，包括 VirtualBox 网络设置。可以在虚拟机设置中访问 VirtualBox 网络适配器设置。

### NAT

此网络模式默认为虚拟网络适配器启用, 虚拟机上的访客操作系统可以通过使用虚拟 NAT（网络地址转换）设备访问物理局域网（LAN）中的主机。外部网络（包括互联网）可从访客操作系统访问。当 NAT 模式用于 VirtualBox 联网时，访客机无法访问主机，也无法从网络中的其他机器访问。这种默认的网络模式对于希望将虚拟机仅用于互联网访问的用户来说已经足够了。

虚拟机网络适配器的 IP 地址是通过 DHCP 获得的，在此网络模式下使用的网络 IP 地址不能在 GUI 中更改。VirtualBox 内置了 DHCP 服务器和 NAT 引擎。虚拟 NAT 设备将 VirtualBox 主机的物理网络适配器作为外部网络接口，NAT 模式中使用的虚拟 DHCP 服务器的默认地址是 10.0.2.2（这也是虚拟机默认网关的IP地址），网络掩码是255.255.255.0。

如果将两个或多个虚拟机的网络适配器配置为使用 NAT 模式，则每个虚拟机将在私有虚拟 NAT 设备后面的自己的隔离网络中获取 10.0.2.15  IP地址。每个虚拟机的默认网关为 10.0.2.2，在 VirtualBox 中，当使用 NAT 模式时，IP 地址是不会改变的。

![VirtualBox Network Mode: NAT](/img/network/VirtualBox-network-modes-NAT.png)

NAT 网络的原理是当私有网主机和公共网主机通信的 IP 包经过 NAT 网关时，将 IP 包中的源 IP 或目的 IP 在私有 IP 和 NAT 的公共 IP 之间进行转换。

VBox 中的 NAT 借助了 VBox 内置的 NAT 引擎和 DHCP 服务，在 VBox 管理程序的网络图形界面下，除了将虚拟机放入NAT以及端口转发外，没有任何其它可操作的配置。换句话说，用户只需要将虚拟机放入 NAT，VBox 会按照默认方式自动设置好一切，用户也没法修改相关网络设置。

比如，VBox 会自动将所有放入 NAT 的虚拟机放入 10.0.2.0/24 网段，并将它们的网关自动设置为 10.0.2.2。

此外，宿主机为每个设置为 NAT 连接方式的虚拟机维护一个私有的虚拟 NAT 设备，每个虚拟 NAT 设备都以宿主机的物理网卡作为外部接口：**每个虚拟 NAT 设备将虚拟机流向外部的流量做地址转换，即转换为物理网卡的地址，以便它们能通过物理网卡连接到外部网络。**

由于每个虚拟机都使用了自己私有的虚拟 NAT 设备将自己隔离开了，所以虚拟机之间不能互相通信。

注意，宿主机默认不能访问虚拟机，除非设置端口转发。其实很容易理解宿主机为什么不能访问虚拟机，想象一下，外网主机无法访问通过 NAT 隔离的内网主机一样。

1. via: https://www.nakivo.com/blog/virtualbox-network-setting-guide/
2. [NAT 通俗易懂的解释](https://blog.csdn.net/hzhsan/article/details/45038265)
3. https://mp.weixin.qq.com/s/vcAvET0W9SDnygxePoLrxg

### Host-only Adapter

该网络适配器类型用于虚拟机与主机之间的网络通信, 在同一个宿主机上的不同虚拟机之间是可以相互访问的，也可以访问到宿主机。因为 Host-only Adapter 模式的网络，VBox 会创建一个虚拟交换机

![Host-only Network](/img/network/VirtualBox-network-host-only-network.png)

### Bridged Adapter

--

### NAT Network Adapter

--

### Internal Network (内部网络)

由 VBox 创建的内部网络是一个独立的私有网络，VBox 创建一个虚拟交换机，将 VM 都连接在这个交换机上，所以多个 VM 之间是可以相互通信的，但是与宿主机之间是不互通的，因为这个虚拟交换机和宿主机的网卡没有连接在一起，所以它也不能和外部网络通信。

利用内部网络可以模拟一些真实的网络环境，如下图：

![Internal network](/img/network/VirtualBox-network-Internal-network-mode-in-a-combination-with-the-NAT-mode.png)

我们可以创建 3 个 VM

### 
