#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "rbconfig"
require "yaml"

ROOT = File.expand_path("..", __dir__)
EXECUTORS_FILE = File.join(ROOT, "04-Agents", "executors.registry.yaml")
PROJECTS_FILE = File.join(ROOT, "projects.registry.yaml")

execute = ARGV.delete("--execute")
task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/executor.rb [--execute] <task>" if task.empty?

executors = YAML.load_file(EXECUTORS_FILE).fetch("executors")
projects = YAML.load_file(PROJECTS_FILE).fetch("projects")

handler_id = if task.match?(/检查.*(AIOS|内核|配置|状态)|验证.*(AIOS|内核|配置)|validate|verify/i)
  "system-check"
elsif task.match?(/加载.*项目|项目上下文|路由项目|读取.*规则|读取.*记忆/i)
  "project-context"
elsif task.match?(/小红书|选题|文案|内容|复盘|发布/i)
  "xhs-content"
end

handler = executors.find { |item| item.fetch("id") == handler_id }
project_matches = projects.select do |project|
  [project["id"], project["name"]].compact.any? { |value| task.downcase.include?(value.to_s.downcase) }
end
project_id = project_matches.length == 1 ? project_matches.first.fetch("id") : "99-aios-system"

def record_execution(task, project_id, status, result)
  recorder = File.join(__dir__, "recorder.rb")
  output, command_status = Open3.capture2(
    RbConfig.ruby,
    recorder,
    "--project", project_id,
    "--task", task,
    "--status", status,
    "--result", result
  )
  abort "ERROR could not record execution: #{output}" unless command_status.success?
end

puts "AIOS Executor"
puts "Task: #{task}"
puts "Mode: #{execute ? "execute" : "plan-only"}"

unless handler
  puts "Handler: not registered"
  puts "Result: requires a task-specific executor"
  puts "Safety: no files or external services were changed"
  if execute
    record_execution(task, project_id, "blocked", "requires a task-specific executor")
    puts "Record: blocked"
    exit 2
  end
  exit 0
end

puts "Handler: #{handler.fetch("id")}"
unless handler.fetch("status") == "active"
  puts "Result: executor is #{handler.fetch("status")}"
  if execute
    record_execution(task, project_id, "blocked", "executor #{handler.fetch("id")} is not active")
    puts "Record: blocked"
    exit 2
  end
  exit 0
end

entrypoint = handler.fetch("entrypoint")
entrypoint_path = File.join(ROOT, entrypoint)
abort "ERROR missing executor entrypoint: #{entrypoint_path}" unless File.file?(entrypoint_path)

unless execute
  puts "Result: ready to run #{entrypoint}"
  exit 0
end

entrypoint_argument = handler.fetch("id") == "project-context" ? project_id : task
output, status = Open3.capture2(RbConfig.ruby, entrypoint_path, entrypoint_argument)
puts output
abort "ERROR executor failed" unless status.success?
record_execution(task, project_id, "success", "#{handler.fetch("id")} completed")
puts "Result: executed and verified"
puts "Record: success"
