#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
CAPABILITIES_FILE = File.join(ROOT, "capabilities.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/capability_router.rb <task>" if task.empty?

registry = YAML.load_file(CAPABILITIES_FILE).fetch("capabilities")
by_id = registry.to_h { |item| [item.fetch("id"), item] }

selected = ["reasoning"]
reasons = ["所有任务先进行理解与判断"]

if task.match?(/文件|代码|配置|批量|git|仓库|修改|创建|删除|目录|脚本/i)
  selected << "filesystem"
  reasons << "任务涉及本地文件或执行修改"
end

if task.match?(/验证|检查|测试|校验|diff|构建/i)
  selected << "verification"
  reasons << "任务要求结果检查或验证"
end

if task.match?(/研究|资料|来源|新闻|最新|趋势|查询|浏览|网页|搜索/i)
  selected << "web_research"
  reasons << "任务需要外部资料或最新信息"
end

if task.match?(/写|文案|内容|选题|创意|设计|标题|发布|脚本/i)
  selected << "content"
  reasons << "任务包含内容或创意产出"
end

selected.uniq.each do |id|
  abort "ERROR capability not registered: #{id}" unless by_id.key?(id)
end

puts "Task: #{task}"
puts "Selected capabilities:"
selected.uniq.each do |id|
  capability = by_id.fetch(id)
  puts "  - #{id} (provider: #{capability.fetch("provider")})"
end
puts "Reasons:"
reasons.each { |reason| puts "  - #{reason}" }
