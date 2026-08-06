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
puts "Safety: no content was published"
puts "Result: content draft plan ready"
