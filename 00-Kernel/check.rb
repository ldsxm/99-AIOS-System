#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)

FILES = {
  manifest: "kernel.manifest.yaml",
  capabilities: "capabilities.yaml",
  projects: "projects.registry.yaml",
  agents: "agents.registry.yaml"
}.freeze

def load_yaml(name)
  path = File.join(ROOT, FILES.fetch(name))
  abort "ERROR missing #{path}" unless File.file?(path)

  YAML.load_file(path) || {}
rescue Psych::SyntaxError => e
  abort "ERROR invalid YAML in #{path}: #{e.message.lines.first.strip}"
end

def require_key(data, key, source)
  abort "ERROR #{source} missing #{key}" unless data.key?(key)
end

manifest = load_yaml(:manifest)
capabilities = load_yaml(:capabilities)
projects = load_yaml(:projects)
agents = load_yaml(:agents)

require_key(manifest, "schema_version", FILES[:manifest])
require_key(manifest, "system", FILES[:manifest])
require_key(manifest, "pipeline", FILES[:manifest])
require_key(capabilities, "capabilities", FILES[:capabilities])
require_key(projects, "projects", FILES[:projects])
require_key(agents, "agents", FILES[:agents])

capability_ids = capabilities["capabilities"].map { |item| item.fetch("id") }
project_ids = projects["projects"].map { |item| item.fetch("id") }
agent_ids = agents["agents"].map { |item| item.fetch("id") }

abort "ERROR duplicate capability id" unless capability_ids.uniq.length == capability_ids.length
abort "ERROR duplicate project id" unless project_ids.uniq.length == project_ids.length
abort "ERROR duplicate agent id" unless agent_ids.uniq.length == agent_ids.length

known_capabilities = capability_ids.to_h { |id| [id, true] }
agents["agents"].each do |agent|
  agent.fetch("capabilities", []).each do |capability|
    abort "ERROR agent #{agent.fetch("id")} references unknown capability #{capability}" unless known_capabilities[capability]
  end
end

projects["projects"].each do |project|
  next if project["path"].nil?

  project_path = File.join(ROOT, project.fetch("path"))
  abort "ERROR project #{project.fetch("id")} path does not exist: #{project_path}" unless Dir.exist?(project_path)
end

puts "AIOS #{manifest.fetch("system").fetch("version")} OK"
puts "projects: #{project_ids.length}"
puts "agents: #{agent_ids.length}"
puts "capabilities: #{capability_ids.length}"
puts "pipeline: #{manifest.fetch("pipeline").join(" -> ")}"
