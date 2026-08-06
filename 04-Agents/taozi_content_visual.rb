#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PROJECTS_FILE = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 04-Agents/taozi_content_visual.rb <task>" if task.empty?

projects = YAML.load_file(PROJECTS_FILE).fetch("projects")
project = projects.find { |item| item.fetch("id") == "taozi-tokyo" }
abort "ERROR taozi-tokyo project is not registered" unless project

project_path = File.join(ROOT, project.fetch("path"))
abort "ERROR project context is incomplete" unless File.file?(File.join(project_path, "RULES.md")) && File.file?(File.join(project_path, "MEMORY.md"))

puts "Taozi Content and Visual Executor"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Task: #{task}"
puts "Loaded: RULES.md, MEMORY.md, SOURCES.md"
puts "Content and visual workflow:"
puts "  1. 确认东京主题、受众、平台与内容目标"
puts "  2. 分离内容策划、视觉方向和素材整理"
puts "  3. 建立选题、标题、画面结构与素材清单"
puts "  4. 检查是否误用其它项目的定位、受众或视觉规则"
puts "  5. 输出方案与待确认项，不覆盖既有素材"
puts "Content and visual brief deliverable:"
puts "  Theme direction: 东京日常、商品/街景观察与生活方式内容的真实记录"
puts "  Topic structure: 一个东京具体场景 + 一个可感知细节 + 一个值得保存的实用信息"
puts "  Visual direction: 统一封面层级、清晰主体、留出文字空间，不套用其它项目模板"
puts "  Asset checklist: 已有商品图/日杂目录素材、现场照片、地图或路线信息、版权与来源记录"
puts "  Page structure: 封面主张 → 场景/商品细节 → 信息整理 → 个人观察 → 收藏/互动引导"
puts "  Open questions: 平台、目标受众、账号定位、栏目名称、视觉色彩与发布节奏"
puts "Safety: no existing content or visual asset was overwritten"
puts "Result: Taozi content and visual plan ready"
