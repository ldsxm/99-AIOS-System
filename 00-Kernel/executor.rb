#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "rbconfig"
require "rbconfig"

ROOT = File.expand_path("..", __dir__)

execute = ARGV.delete("--execute")
task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/executor.rb [--execute] <task>" if task.empty?

system_check = task.match?(/检查.*(AIOS|内核|配置|状态)|验证.*(AIOS|内核|配置)|validate|verify/i)

def record_execution(task, status, result)
  recorder = File.join(__dir__, "recorder.rb")
  output, command_status = Open3.capture2(
    RbConfig.ruby,
    recorder,
    "--project", "99-aios-system",
    "--task", task,
    "--status", status,
    "--result", result
  )
  abort "ERROR could not record execution: #{output}" unless command_status.success?
end

puts "AIOS Executor"
puts "Task: #{task}"
puts "Mode: #{execute ? "execute" : "plan-only"}"

unless system_check
  puts "Handler: not registered"
  puts "Result: requires a task-specific executor"
  puts "Safety: no files or external services were changed"
  if execute
    record_execution(task, "blocked", "requires a task-specific executor")
    puts "Record: blocked"
    exit 2
  end
  exit 0
end

puts "Handler: system-check"
unless execute
  puts "Result: ready to run 00-Kernel/check.rb"
  exit 0
end

output, status = Open3.capture2(RbConfig.ruby, File.join(ROOT, "00-Kernel/check.rb"))
puts output
abort "ERROR system check failed" unless status.success?
record_execution(task, "success", "AIOS 2.0.0 OK")
puts "Result: executed and verified"
puts "Record: success"
