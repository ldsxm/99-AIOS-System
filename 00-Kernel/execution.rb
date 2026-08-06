#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "open3"
require "rbconfig"

ROOT = File.expand_path("..", __dir__)
REGISTRY = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/execution.rb <task>" if task.empty?

projects = YAML.load_file(REGISTRY).fetch("projects")
query = task.downcase
matches = projects.select do |project|
  [project["id"], project["name"]].compact.any? { |value| query.include?(value.to_s.downcase) }
end

project = if matches.length == 1
  matches.first
elsif matches.empty?
  projects.find { |item| item["id"] == "99-aios-system" }
else
  abort "ERROR ambiguous project: #{matches.map { |item| item.fetch("name") }.join(", ")}"
end

pipeline = YAML.load_file(File.join(ROOT, "kernel.manifest.yaml")).fetch("pipeline")

puts "AIOS Execution Plan"
puts "Task: #{task}"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Mode: plan-only"
puts "\nPipeline:"
pipeline.each_with_index do |stage, index|
  detail = case stage
  when "understand" then "确认目标与成功标准"
  when "route_project" then "加载 #{project.fetch("name")} 项目上下文"
  when "load_rules" then "读取项目规则、来源与记忆"
  when "select_capabilities" then "调用 Capability Router"
  when "execute" then "按授权范围执行具体动作"
  when "verify" then "检查输出、结构与验收标准"
  when "record" then "记录结果与后续状态"
  else "执行 #{stage}"
  end
  puts "  #{index + 1}. #{stage}: #{detail}"
end

puts "\nContext:"
if project["path"]
  project_path = File.join(ROOT, project.fetch("path"))
  ["project.yaml", "RULES.md", "SOURCES.md", "MEMORY.md"].each do |filename|
    state = File.file?(File.join(project_path, filename)) ? "loaded" : "missing"
    puts "  #{filename}: #{state}"
  end
else
  puts "  not connected"
end

puts "\nCapability route:"
output, status = Open3.capture2(RbConfig.ruby, File.join(__dir__, "capability_router.rb"), task)
puts output
exit status.exitstatus unless status.success?

puts "\nNext action: review this plan, then run the authorized task-specific executor."
