#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PROFILE = File.join(ROOT, "03-Projects", "business-research", "research-profile.yaml")

data = YAML.load_file(PROFILE).fetch("research_profile")
required = {
  "topic" => "研究主题",
  "primary_question" => "核心问题",
  "business_decision" => "支持的商业决策",
  "target_audience" => "目标市场或受众",
  "geography" => "目标地区",
  "deliverable.format" => "交付格式",
  "deliverable.deadline" => "交付时间"
}

missing = required.select do |path, _label|
  value = path.split(".").reduce(data) { |current, key| current.is_a?(Hash) ? current[key] : nil }
  value.nil? || (value.respond_to?(:empty?) && value.empty?)
end

puts "Business Research Profile Check"
puts "Status: #{data.fetch("status")}"
if missing.empty?
  puts "Ready: yes"
else
  puts "Ready: no"
  puts "Missing inputs:"
  missing.each_value { |label| puts "  - #{label}" }
end
