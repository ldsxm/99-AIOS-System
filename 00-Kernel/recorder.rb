#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "time"
require "yaml"

ROOT = File.expand_path("..", __dir__)
LOG_FILE = File.join(ROOT, "06-Memory", "execution-log.yaml")

options = { status: "success" }
OptionParser.new do |parser|
  parser.banner = "Usage: ruby 00-Kernel/recorder.rb --project <id> --task <task> --result <result> [--status <status>]"
  parser.on("--project VALUE", "Project ID") { |value| options[:project] = value }
  parser.on("--task VALUE", "Task description") { |value| options[:task] = value }
  parser.on("--result VALUE", "Execution result") { |value| options[:result] = value }
  parser.on("--status VALUE", "success, failed, or blocked") { |value| options[:status] = value }
end.parse!

required = %i[project task result]
missing = required.select { |key| options[key].to_s.strip.empty? }
abort "ERROR missing: #{missing.join(", ")}" unless missing.empty?
abort "ERROR invalid status" unless %w[success failed blocked].include?(options[:status])

data = if File.file?(LOG_FILE)
  YAML.load_file(LOG_FILE) || {}
else
  { "schema_version" => "1.0", "records" => [] }
end

data["schema_version"] ||= "1.0"
data["records"] ||= []
data["records"] << {
  "id" => "exec-#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}",
  "recorded_at" => Time.now.utc.iso8601,
  "project" => options[:project],
  "task" => options[:task],
  "status" => options[:status],
  "result" => options[:result]
}

File.write(LOG_FILE, data.to_yaml)
puts "Recorded: #{LOG_FILE}"
puts "Records: #{data["records"].length}"
