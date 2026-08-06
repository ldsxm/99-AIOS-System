#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "open3"
require "rbconfig"
require "time"

ROOT = File.expand_path("..", __dir__)
ARTIFACTS = File.join(ROOT, "06-Memory", "artifacts")

execute = ARGV.delete("--execute")
task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/artifact_runner.rb [--execute] <task>" if task.empty?

FileUtils.mkdir_p(ARTIFACTS)
command = [File.join(ROOT, "00-Kernel", "aios.rb")]
command << "--execute" if execute
command << task
output, status = Open3.capture2(RbConfig.ruby, *command)

timestamp = Time.now.utc
slug = task.downcase.gsub(/[^a-z0-9\u4e00-\u9fff]+/i, "-").gsub(/\A-|-$/, "")[0, 48]
filename = "#{timestamp.strftime("%Y%m%dT%H%M%SZ")}-#{slug}.md"
path = File.join(ARTIFACTS, filename)

File.write(path, <<~MARKDOWN)
  # AIOS Execution Artifact

  - Recorded at: #{timestamp.iso8601}
  - Mode: #{execute ? "execute" : "plan-only"}
  - Task: #{task}

  ```text
  #{output}
  ```
MARKDOWN

puts output
puts "Artifact: 06-Memory/artifacts/#{filename}"
exit status.exitstatus unless status.success?
