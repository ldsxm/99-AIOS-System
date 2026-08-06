#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "open3"
require "rbconfig"

ROOT = File.expand_path("..", __dir__)
REGISTRY = File.join(ROOT, "projects.registry.yaml")

task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/aios.rb <task>" if task.empty?

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

puts "AIOS v2"
puts "Task: #{task}"
puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Project status: #{project.fetch("status")}"

if project["path"]
  project_path = File.join(ROOT, project.fetch("path"))
  puts "Context: #{project.fetch("path")}"
  ["project.yaml", "RULES.md", "SOURCES.md", "MEMORY.md"].each do |filename|
    puts "  #{filename}: #{File.file?(File.join(project_path, filename)) ? "loaded" : "missing"}"
  end
else
  puts "Context: not connected"
end

puts "\nCapability route:"
output, status = Open3.capture2(RbConfig.ruby, File.join(__dir__, "capability_router.rb"), task)
puts output
exit status.exitstatus unless status.success?
