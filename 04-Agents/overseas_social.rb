#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PROJECTS_FILE = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 04-Agents/overseas_social.rb <task>" if task.empty?

projects = YAML.load_file(PROJECTS_FILE).fetch("projects")
project = projects.find { |item| item.fetch("id") == "overseas-accounts" }
abort "ERROR overseas-accounts project is not registered" unless project

project_path = File.join(ROOT, project.fetch("path"))
abort "ERROR project context is incomplete" unless File.file?(File.join(project_path, "RULES.md")) && File.file?(File.join(project_path, "MEMORY.md"))

puts "Overseas Social Executor"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Task: #{task}"
puts "Loaded: RULES.md, MEMORY.md, SOURCES.md"
puts "Platform workflow:"
puts "  1. 分别确认 Instagram 与 Reddit 的任务目标"
puts "  2. Instagram：检查视觉识别、内容支柱与互动状态"
puts "  3. Reddit：核验社区规则、问题语境与发帖边界"
puts "  4. 区分原创分享、经验讨论和推广内容"
puts "  5. 记录来源、日期、互动数据与复盘结论"
puts "Weekly deliverable:"
puts "  Instagram plan: 3 个内容支柱——产品/作品展示、场景故事、生活方式与幕后过程"
puts "  Instagram cadence: 2 条 feed + 3 组 stories，发布前检查视觉一致性和语言表达"
puts "  Reddit plan: 建立 5—10 个候选社区清单，记录人数、主题、规则和近期高质量帖子"
puts "  Reddit participation: 先阅读、回答问题和参与讨论，不复制 Instagram 文案，不冷启动推广"
puts "  Review metrics: 内容完成率、互动质量、收藏/点击、社区回应、有效问题与下周调整项"
puts "  Open questions: 主内容领域、目标国家/语言、账号状态、可持续素材与商业目标"
puts "Safety: no post, comment, follow, or message was sent"
puts "Result: overseas social plan ready"
