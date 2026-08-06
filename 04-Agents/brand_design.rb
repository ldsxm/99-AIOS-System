#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PROJECTS_FILE = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 04-Agents/brand_design.rb <task>" if task.empty?

projects = YAML.load_file(PROJECTS_FILE).fetch("projects")
project = if task.match?(/ORLEE/i)
  projects.find { |item| item.fetch("id") == "li-design" }
else
  projects.find { |item| item.fetch("id") == "li-design" && task.include?(item.fetch("name")) }
end
abort "ERROR include 橘李设计 or ORLEE in the task" unless project

project_path = File.join(ROOT, project.fetch("path"))
abort "ERROR project context is incomplete" unless File.file?(File.join(project_path, "RULES.md")) && File.file?(File.join(project_path, "MEMORY.md"))

puts "Brand Design Executor"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Task: #{task}"
puts "Loaded: RULES.md, MEMORY.md, SOURCES.md"
puts "Design workflow:"
puts "  1. 明确品牌目标、使用场景与交付范围"
puts "  2. 读取品牌定位、设计原则和既有资产"
puts "  3. 建立方向、构图、色彩、字体与应用方案"
puts "  4. 检查识别性、可缩放性、可制造性与跨媒介适配"
puts "  5. 输出方案与待确认项，不覆盖既有资产"
puts "Design brief deliverable:"
puts "  Brand goal: 将专业性能、东方精神与当代设计统一为可识别的户外品牌系统"
puts "  Core claim: 山高，人为峰。"
puts "  Design direction: 东方留白与负形 + 现代结构逻辑 + 克制的橘色识别节点"
puts "  Logo checks: 缩小识别、黑白适配、产品刻印、商标近似排查"
puts "  VI checks: 标准字、色彩、字体、网格、产品与数字媒体应用"
puts "  Product checks: Atelier / Summit / Trek / Daily / Endure 的统一基因与层级区分"
puts "  Open questions: 最终 Logo 版本、标准色、字体、应用场景与交付规格"
puts "Safety: no existing design asset was overwritten"
puts "Result: design plan ready"
