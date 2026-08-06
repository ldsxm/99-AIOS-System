# 00-Kernel

AIOS v2 内核层，负责加载系统清单、识别任务、路由项目与能力，并编排统一执行流水线。

核心入口配置：`../kernel.manifest.yaml`

## 运行检查

在本目录的上一级执行：

```bash
ruby 00-Kernel/check.rb
```

## 路由并加载项目

```bash
ruby 00-Kernel/router.rb "橘李刚俊莲"
ruby 00-Kernel/router.rb feng-yue-man-yang
```

## 选择执行能力

```bash
ruby 00-Kernel/capability_router.rb "检查并修改项目配置文件"
```

## 统一入口

```bash
ruby 00-Kernel/aios.rb "橘李刚俊莲：检查并修改项目配置文件"
```

## 生成执行计划

```bash
ruby 00-Kernel/execution.rb "橘李刚俊莲：检查并修改项目配置文件"
```

## 执行已注册任务

```bash
ruby 00-Kernel/executor.rb "检查 AIOS 内核状态"
ruby 00-Kernel/executor.rb --execute "检查 AIOS 内核状态"
```

## 运行回归测试

```bash
ruby 00-Kernel/test_aios.rb
```
