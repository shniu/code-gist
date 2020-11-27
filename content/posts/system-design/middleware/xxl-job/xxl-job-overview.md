---
title: "分布式任务调度平台 XXL-Job"
date: 2020-11-23T16:36:38+08:00
draft: true
tags: ['Distributed Job Scheduling']
categories: ['Middleware', 'Scheduler']
---

总结 xxl-job


- 调度中心：调度线程池做了拆分，分别是 fast 和 slow 两个线程池，慢任务进 slow 线程池，1分钟窗口期内任务耗时达500ms超过10次 被判定为慢任务

服务器时间错误引起的问题。
