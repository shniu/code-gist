---
title: "Redis Intro"
date: 2020-11-20T11:17:39+08:00
draft: true
tags: ['KV', 'Redis']
categories: ['Middleware', 'Redis']
---

https://wingsxdu.com/post/database/redis/struct/#gsc.tab=0

redis 的核心及周边全部掌握

1. 缓存和数据库的一致性问题
2. Redis 在秒杀场景中的应用
3. Redis 如何实现高性能高并发的分布式锁，以及有哪些注意事项
4. Reids 的内核：数据结构，

### sds

简单动态字符串是 Redis 中的基础数据结构，用于存储字符串和整型数据，SDS 兼容 C 语言标准字符串处理函数，且在此基础上保证了二进制安全。(通俗地讲，C 语言中，用 `\0` 表示字符串的结束，如果字符串中本身就有 `\0` 字符，字符串就会被截断，即非二进制安全；若通过某种机制，保证读写字符串时不损害其内容，则是二进制安全。)

C 语言表示字符串的方式是使用字符数组，并结合 `\0` 作为结尾，缺点是二进制不安全，扩容时不方便，因为每次扩容我们都需要对字符数组做大量重复操作，且使用不友好；封装实现细节，暴露容易使用的接口

Redis 中的 SDS 就是这样一个数据结构:

```c
struct sds {
    int len;
    int alloc;
    char flgs;
    char buf[];
}
```

sds 的基本雏形就是上面这样，它使用 len, alloc, buf 来表示一个动态字符串，len 和 alloc 可以方便的获取到字符串的长度

buf 是一个柔性数组 (什么是柔性数组，也叫[零长度数组](https://blog.csdn.net/gatieme/article/details/64131322), 主要用途是为了满足需要变长度的结构体)

Redis 3.2后的SDS结构由1种增至5种，且对于sdshdr5类型，在创建空字符串时会强制转换为sdshdr8。原因可能是创建空字符串后，其内容可能会频繁更新而引发扩容，故创建时直接创建为sdshdr8

SDS暴露给上层的是指向柔性数组buf的指针
读操作的复杂度多为O(1)，直接读取成员变量；涉及修改的写操作，则可能会触发扩容。

sdshdr5只负责存储小于32字节的字符串。一般情况下，小字符串的存储更普遍，故Redis进一步压缩了sdshdr5的数据结构，将sdshdr5的类型和长度放入了同一个属性中，用flags的低3位存储类型，高5位存储长度。创建空字符串时，sdshdr5会被sdshdr8替代。

SDS在涉及字符串修改处会调用sdsMakeroomFor函数进行检查，根据不同情况动态扩容，该操作对上层透明。


### ziplist

ziplist 本质上就是一个字节数组，是 Redis 为了节约内存而设计的一种线性数据结构，可以包含多个元素，每个元素可以是一个字节数组或一个整数。

Redis 的有序集合、散列和列表都直接或者间接使用了压缩列表。当有序集合或散列表的元素个数比较少，且元素都是短字符串时，Redis便使用压缩列表作为其底层数据存储结构

### hash

字典又称散列表，是用来存储键值（key-value）对的一种数据结构



### Redisson 


Redisson 初始化流程

RedissonClient redissonClient = Redisson.create(config);

1. ConnectionManager: org.redisson.config.ConfigSupport#createConnectionManager
  根据 config 配置的 redis server 类型来决定使用哪个 ConnectionManager, 类型如下
  a. org.redisson.connection.SingleConnectionManager extends MasterSlaveConnectionManager
  b. org.redisson.connection.MasterSlaveConnectionManager
  c. org.redisson.connection.SentinelConnectionManager
  d. org.redisson.cluster.ClusterConnectionManager
  e. org.redisson.connection.ReplicatedConnectionManager
  f. 应该也支持自定义的 ConnectionManager

  接着主要看一下 MasterSlaveConnectionManager 的初始化过程
  1.1. 根据配置的 TransportMode 来初始化 EventLoopGroup (NIO, Epoll, KQueue), nettyThreads 默认是 32, EventLoopGroup 也支持 config 传入，也就是在外部初始化好 EventLoopGroup 后，传给 Redisson 使用；根据 TransportMode 来赋值 socketChannelClass；这里决定了 ConnectionManager 要使用什么样的网络模型和线程模型，底层是使用的 Netty 的 EventLoop 模型，需要对 Netty 进行进一步学习 

  

  1.2. resolverGroup 的用户暂时不清楚
  1.3. 初始化 executorService, 可以外部指定，如果不指定默认会创建一个固定线程大小的线程池，默认配置是 16，如果不想指定，就设置 config.setThreads(0)
  1.4. 保存 config, codec
  1.5. 初始化 `CommandSyncService commandExecutor`, 目前还不清楚有什么用
  1.6. 初始化定时器，使用 HashedWheelTimer 时间轮
  1.7. 初始化一个空闲连接监控器 org.redisson.connection.IdleConnectionWatcher connectionWatcher
  1.8. 初始化一个发布订阅服务 org.redisson.pubsub.PublishSubscribeService#PublishSubscribeService
  1.9.  初始化 masterSlaveEntry，然后 setupMasterEntry 创建一个 RedisClient 的实例，连接到 Master Redis，被 RFuture 包裹, syncUninterruptibly 有什么用呢？

  > org.redisson.connection.MasterSlaveConnectionManager#initSingleEntry
    > org.redisson.connection.MasterSlaveEntry#setupMasterEntry(org.redisson.misc.RedisURI)
      > org.redisson.connection.ConnectionManager#createClient
        > org.redisson.connection.MasterSlaveConnectionManager#createClient
        > org.redisson.connection.MasterSlaveConnectionManager#createClient(org.redisson.api.NodeType, org.redisson.misc.RedisURI, int, int, java.lang.String)
        > org.redisson.client.RedisClient#create
        > new RedisClient(config)
          > 创建 netty bootstrap 和 netty pubSubBootstrap: new BootStrap()
      > org.redisson.connection.MasterSlaveEntry#setupMasterEntry(redisClient)
        > redisClient.resolveAddr

  1.10. 如果是 Master-Slave 模式，会在初始化 Slave Entry
  1.11. 开启 DNSMonitoring，监控 Master Slave 的变化

2. 初始化一个 Eviction scheduler (驱逐调度器)，用于删除在 5s 和 2h 之间的过期项, 它分析已删除的过期键数量，并根据它来 "调整" 下一次的执行延迟。

3. 初始化 writeBehindService，这是一个后台写入服务，用来处理后台写入相关的任务



Todo:

* Netty Bootstrap, EventLoop, EventLoopGroup etc.



git clone https://github.com/shniu/netty.git
git remote add upstream https://github.com/netty/netty.git
git remote -v
git fetch upstream
git checkout -b 4.1.55.Final
git pull upstream netty-4.1.55.Final
https://git-scm.com/book
