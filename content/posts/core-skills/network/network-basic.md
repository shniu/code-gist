---
title: "Network: 计算机网络基础知识"
date: 2020-10-25T22:00:29+08:00
draft: true
tags: ['Network']
categories: ['Network']
---

本文主要汇总在计算机网络中使用的基本概念、基本术语和一些常识。

## 网络协议

1. 物理层
2. 链路层: ARP, VLAN, STP
3. 网络层: ICMP, IP, OSPF, BGP, IPSec, GRE
4. 传输层: TCP, UDP
5. 应用层: DHCP, HTTP, HTTPS, P2P, DNS, RPC, GTP, RTMP

## 重新认识 ifconfig

在电脑上查看 ip 地址时，经常使用 ifconfig 或 ipconfig, 有时候也可以使用 ip addr 命令。

```shell
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:6a:93:8d:eb:87 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86362sec preferred_lft 86362sec
    inet6 fe80::6a:93ff:fe8d:eb87/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:bb:49:66 brd ff:ff:ff:ff:ff:ff
    inet 192.168.33.100/24 brd 192.168.33.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:febb:4966/64 scope link
       valid_lft forever preferred_lft forever
```

运行之后，如果不出意外，会出现类似上面的内容，来分析一下(我使用的是 ubuntu18.04, 其他系统可能会不一样):

- 有三个网卡，分别是 lo, enp0s3, enp0s8; lo 表示 loopback, 也叫回环地址，专门用来访问本机的, 经过内核处理后直接返回，不会在任何网络中出现，一般通过 127.0.0.1 或者 localhost; enp0s3 和 enp0s8 是两个可以正常的网卡，但是也稍有不同，主要以 enp0s3 来分析
- 为什么叫 enp0s3 而不是类似 eth0 ? 这是一种新的命名方案，叫 `Predictable Network Interface`, 名称取决于硬件的物理位置: en 是 `ethernet` 的意思，就像 `eth` 用于对应 eth0 一样, p 是以太网卡的总线编号, s 是插槽编号
- `<BROADCAST,MULTICAST,UP,LOWER_UP>` 代表什么呢？它表示的是网络设备的状态标识

BROADCAST 表示该接口支持广播，MULTICAST 表示该接口支持多播，UP 表示网络接口已启用，LOWER_UP 表示网络电缆已插入，设备已连接至网络

- mtu 1500 表示最大传输单位（数据包大小）为 1500 字节；mtu 是链路层的概念，MAC 层有 MAC 的头，**以太网规定连 MAC 头带正文合起来，不允许超过 1500 个字节**。正文里面有 IP 的头、TCP 的头、HTTP 的头。如果放不下，就需要分片来传输。

- qdisc fq_codel state UP group default qlen 1000

qdisc 表示排队规则(queueing discipline), 内核如果需要通过某个网络接口发送数据包，它都需要按照为这个接口配置的 qdisc（排队规则）把数据包加入队列。qdisc 将流量队列抽象化，比标准的FIFO队列要复杂得多，实现了内核的流量管理功能，包括流量分类，优先级和速率协商，后续再仔细研究。

state UP 表示网络接口已经启用；qlen 1000 表示传输队列长度是 1000 个数据包，第 1000 个数据包将排队，第 1001 个数据包将被丢弃。

- link/ether 02:6a:93:8d:eb:87 brd ff:ff:ff:ff:ff:ff

link/ether 02:6a:93:8d:eb:87 表示网卡的 MAC 地址；brd ff:ff:ff:ff:ff:ff 表示广播地址, 这个广播地址是全1，说明是一个受限的广播地址，只能在同一个子网中传输，路由器不会转发出去

- inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3 表示的是 ip 地址信息，10.0.2.15/24 是一种 CIDR 的表示方式；brd 10.0.2.255 是广播地址；scope global 表示全局有效；dynamic enp0s3 表示地址是动态分配的，动态分配一般是通过 DHCP 完成的；参考 [IP 地址划分](#ip-地址划分)

- valid_lft 86362sec 表示 IPv4 地址的有效使用期限，preferred_lft 表示 IPv4 地址的首选生存期
- inet6 fe80::a00:27ff:febb:4966/64 scope link 表示 ipv6 地址, scope link 表示私有地址，只在此设备上有效

## IP 地址划分

--

## 重新整理网络分层

--

## Routing tables

路由表的作用就是指定下一级网关，根据路由表怎么确定下一级网关，这里就有一个匹配过程，匹配规则：

1. 最长匹配
2. 优先级匹配

http://linux-ip.net/html/routing-tables.html

http://linux-ip.net/html/index.html

https://tldp.org/LDP/nag2/nag2.pdf

## 概念与术语

| 类别 | 名称 | 解释 |
| :--- | :----: | :---- |
| 基础概念 | 广播 | 广播是向在同一个网段中的所有主机发送数据包，详细参考 [广播地址介绍](https://blog.csdn.net/tennysonsky/article/details/45564479) |
| 链路层 | [网桥](https://zh.wikipedia.org/wiki/%E6%A9%8B%E6%8E%A5%E5%99%A8) | 网桥是一个二层桥接设备，桥接就是把两端连接起来，但不是所有的流量都放行，只有目的 MAC 才可以通过 |
| 链路层 | MTU | 最大传输单位，以太网规定 MTU 最大为 1500 字节，其中包括 MAC 头和 MAC 正文 |
| 内核 | qdisc | Queuing Disciplines，排队规则 |
| 内核 | fq-codel | 排队规则的一种，主要致力于解决 [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) 问题，可参考 [理解 fq-codl](https://www.jianshu.com/p/3b2e701f61ea) |
| 网络延迟 | bufferbloat | [bufferbloat](https://en.wikipedia.org/wiki/Bufferbloat) 是由数据包过多的缓冲导致数据包交换高延迟，也就是说它会影响某些应用的网络体验，可以翻译为缓冲区膨胀 |


## 网络相关的一些问题

- 当网络包到达一个路由器的时候，可以通过路由表得到下一跳的 IP 地址，直接通过 IP 地址找就可以了，为什么还要通过本地的 MAC 地址呢？
- net-tools 和 iproute2 有什么关系？

## Reference

- [Linux网络栈之队列](https://xiaoz.co/2019/12/14/Linux%E7%BD%91%E7%BB%9C%E6%A0%88%E4%B9%8B%E9%98%9F%E5%88%97-part1/#%E6%8E%92%E9%98%9F%E8%A7%84%E5%88%99-Queuing-Disciplines-QDisc)
- [Bufferbloat: Dark Buffers in the Internet](https://cacm.acm.org/magazines/2012/1/144810-bufferbloat/fulltext)
