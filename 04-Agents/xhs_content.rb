#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PROJECTS_FILE = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 04-Agents/xhs_content.rb <task>" if task.empty?

projects = YAML.load_file(PROJECTS_FILE).fetch("projects")
matches = projects.select do |project|
  [project["id"], project["name"]].compact.any? { |value| task.downcase.include?(value.to_s.downcase) }
end
project = matches.first
abort "ERROR include a supported project name: 风月慢养 or 橘李刚俊莲" unless project
abort "ERROR project is not registered for XHS content: #{project.fetch("name")}" unless %w[feng-yue-man-yang li-gang-jun-lian].include?(project.fetch("id"))

project_path = File.join(ROOT, project.fetch("path"))
rules_path = File.join(project_path, "RULES.md")
memory_path = File.join(project_path, "MEMORY.md")
abort "ERROR project context is incomplete" unless File.file?(rules_path) && File.file?(memory_path)

puts "XHS Content Executor"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Task: #{task}"
puts "Loaded: RULES.md, MEMORY.md"
puts "Workflow:"
puts "  1. 读取项目定位与内容边界"
puts "  2. 确定用户痛点与选题角度"
puts "  3. 生成标题、封面文案、正文与标签"
puts "  4. 按项目规则自检语气、事实与平台适配"
puts "  5. 输出草稿，等待人工确认后发布"
puts "Draft deliverable:"
if project.fetch("id") == "feng-yue-man-yang"
  puts "  Title options:"
  puts "    1. 老人真正需要的，可能不是更多照顾，而是被认真对待"
  puts "    2. 子女以为是在尽孝，老人感受到的却可能是另一种压力"
  puts "    3. 人到晚年，最难得的不是有人安排，而是还能自己做决定"
  puts "  Cover copy: 你的晚年，应该由谁来决定？"
  puts "  Body structure: 现实场景 → 冲突感受 → 换位理解 → 可执行的温和建议"
  puts "  Tags: #风月慢养 #养老生活 #家庭关系 #晚年尊严"
else
  puts "  Content execution brief:"
  puts "    1. 定位中心：确认本次内容服务的受众、栏目和账号目标"
  puts "    2. 资料库：只使用已登记、可追溯且属于本项目的资料"
  puts "    3. 选题：用户痛点 → 明确冲突 → 可执行观点 → 互动问题"
  puts "    4. 制作：标题、封面文案、正文、标签与配图需求"
  puts "    5. 复盘：记录曝光、互动、收藏、评论质量和下一轮调整"
  puts "  Title: [从橘李刚俊莲资料库确认具体选题]"
  puts "  Cover copy: [一句明确冲突或用户收益]"
  puts "  Body structure: 用户痛点 → 观点判断 → 具体方法 → 互动问题"
  puts "  Tags: [根据项目资料库补充]"
end
puts "  Review checklist: 事实可核验、语气符合项目规则、未混用其它项目资料、等待人工确认"
puts "Safety: no content was published"
puts "Result: content draft plan ready"
