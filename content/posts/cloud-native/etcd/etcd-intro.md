---
title: "Etcd Intro"
date: 2020-11-16T14:59:06+08:00
draft: true
categories: ['Cloud Native', 'etcd']
tags: ['Cloud Native', 'etcd', 'Consensus']
---

介绍 etcd 使用及其原理

1. 集群搭建和使用
2. Raft 协议
3. watch 机制
4. 应用场景：选主，服务发现，kv 存储

## raft 协议

数据一致性问题是分布式系统的难题，在过去的 10 年里，Paxos 算法统治着一致性算法这一领域：绝大多数的实现都是基于 Paxos 或者受其影响。但尽管有很多工作都在尝试降低它的复杂性，但是 Paxos 算法依然十分难以理解。而 Raft 算法是一个为可理解性而设计的一致性算法。

[TODO]

**参考:**

1. [raft 协议论文 - 中文版](https://github.com/maemual/raft-zh_cn/blob/master/raft-zh_cn.md)

## Watch 机制

[TODO]

- https://segmentfault.com/a/1190000021787055
- https://xiaoz.co/2020/08/10/etcd-intro/
