#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "rbconfig"

execute = ARGV.delete("--execute")
if ARGV == ["status"] && !execute
  output, status = Open3.capture2(RbConfig.ruby, File.join(__dir__, "status.rb"))
  puts output
  exit status.exitstatus unless status.success?
  exit 0
end

task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/aios.rb <task>" if task.empty?

entrypoint = execute ? "executor.rb" : "execution.rb"
arguments = execute ? ["--execute", task] : [task]
output, status = Open3.capture2(RbConfig.ruby, File.join(__dir__, entrypoint), *arguments)
puts output
exit status.exitstatus unless status.success?
