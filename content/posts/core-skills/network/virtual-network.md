---
title: "Network: 虚拟网络"
date: 2020-11-26T11:20:31+08:00
draft: true
tags: ['Network', '虚拟化']
categories: ['Network', 'Virtual network']
---

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

--

### Bridged Adapter

--

### NAT Network Adapter

--

### 内部网络

### 
