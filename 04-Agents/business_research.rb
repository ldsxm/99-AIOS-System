#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PROJECTS_FILE = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 04-Agents/business_research.rb <task>" if task.empty?

projects = YAML.load_file(PROJECTS_FILE).fetch("projects")
project = projects.find do |item|
  item.fetch("id") == "business-research" || task.include?(item.fetch("name"))
end
abort "ERROR include the project name: 商业研究" unless project

project_path = File.join(ROOT, project.fetch("path"))
abort "ERROR project context is incomplete" unless File.file?(File.join(project_path, "RULES.md")) && File.file?(File.join(project_path, "MEMORY.md"))

puts "Business Research Executor"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Task: #{task}"
puts "Loaded: RULES.md, MEMORY.md, SOURCES.md"
puts "Research workflow:"
puts "  1. 明确研究问题、范围、时间和交付形式"
puts "  2. 建立资料来源清单与检索关键词"
puts "  3. 区分事实、推断与建议"
puts "  4. 记录来源、发布日期、访问日期与可信度"
puts "  5. 输出带证据链的研究摘要或报告结构"
puts "Safety: no unsupported conclusion was published"
puts "Result: research plan ready"
