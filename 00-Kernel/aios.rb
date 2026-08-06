#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "rbconfig"

task = ARGV.join(" ").strip
abort "Usage: ruby 00-Kernel/aios.rb <task>" if task.empty?

output, status = Open3.capture2(RbConfig.ruby, File.join(__dir__, "execution.rb"), task)
puts output
exit status.exitstatus unless status.success?
