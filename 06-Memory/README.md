# 06-Memory

AIOS v2 记忆层，存放跨任务状态、决策记录、成果索引与可长期复用的上下文。

写入内容应可追溯，并遵循现有 `SOURCES.md` 与 `DECISIONS.md` 约定。

## 执行记录

统一执行结果写入 `execution-log.yaml`：

```bash
ruby 00-Kernel/recorder.rb \
  --project 99-aios-system \
  --task "检查 AIOS 内核状态" \
  --result "AIOS 2.0.0 OK"
```
