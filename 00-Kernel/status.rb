#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)

projects = YAML.load_file(File.join(ROOT, "projects.registry.yaml")).fetch("projects")
executors = YAML.load_file(File.join(ROOT, "04-Agents", "executors.registry.yaml")).fetch("executors")
records = YAML.load_file(File.join(ROOT, "06-Memory", "execution-log.yaml")).fetch("records")
artifacts = Dir[File.join(ROOT, "06-Memory", "artifacts", "*.md")].sort_by { |path| File.mtime(path) }.reverse

puts "AIOS v2 Status"
puts "Projects: #{projects.length}"
projects.group_by { |project| project.fetch("status") }.each do |status, items|
  puts "  #{status}: #{items.length}"
end
puts "Executors: #{executors.length}"
executors.group_by { |executor| executor.fetch("status") }.each do |status, items|
  puts "  #{status}: #{items.length}"
end
puts "Execution records: #{records.length}"
puts "Artifacts: #{artifacts.length}"

if records.any?
  latest = records.last
  puts "Latest: #{latest.fetch("project")} / #{latest.fetch("status")} / #{latest.fetch("task")}"
end

if artifacts.any?
  puts "Latest artifact: #{File.basename(artifacts.first)}"
end

needs_input = projects.select { |project| project.fetch("status") == "needs_input" }
unless needs_input.empty?
  puts "Needs input:"
  needs_input.each { |project| puts "  - #{project.fetch("name")}" }
end
