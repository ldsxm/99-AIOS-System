#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
REGISTRY = File.join(ROOT, "projects.registry.yaml")

def abort_usage(message = nil)
  warn "ERROR #{message}" if message
  warn "Usage: ruby 00-Kernel/router.rb <project-id-or-name>"
  exit 1
end

query = ARGV.join(" ").strip
abort_usage("project is required") if query.empty?

registry = YAML.load_file(REGISTRY)
projects = registry.fetch("projects")
project = projects.find { |item| item["id"] == query || item["name"] == query }
abort_usage("project not found: #{query}") unless project

project_path = project["path"]
if project_path.nil?
  puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
  puts "Status: #{project.fetch("status")}"
  puts "Path: not connected"
  exit 0
end

absolute_project_path = File.join(ROOT, project_path)
abort_usage("project path does not exist: #{absolute_project_path}") unless Dir.exist?(absolute_project_path)

project_config_path = File.join(absolute_project_path, "project.yaml")
project_config = YAML.load_file(project_config_path)

puts "Project: #{project.fetch("name")} (#{project.fetch("id")})"
puts "Status: #{project.fetch("status")}"
puts "Path: #{project_path}"
puts "Context files:"

["project.yaml", "RULES.md", "SOURCES.md", "MEMORY.md"].each do |filename|
  path = File.join(absolute_project_path, filename)
  puts "  #{filename}: #{File.file?(path) ? "loaded" : "missing"}"
end

confirmed = project_config.dig("project", "confirmed_context")
if confirmed && !confirmed.empty?
  puts "Confirmed context:"
  confirmed.each { |key, value| puts "  #{key}: #{value.is_a?(Array) ? value.join(", ") : value}" }
end

puts "Ready: #{project.fetch("name")} context loaded"
