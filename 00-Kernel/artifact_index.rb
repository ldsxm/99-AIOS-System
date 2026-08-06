#!/usr/bin/env ruby
# frozen_string_literal: true

require "time"

root = File.expand_path("..", __dir__)
artifact_dir = File.join(root, "06-Memory", "artifacts")
index_path = File.join(root, "06-Memory", "ARTIFACTS.md")

files = Dir[File.join(artifact_dir, "*.md")].sort_by { |path| File.mtime(path) }.reverse

lines = ["# AIOS 成果索引", "", "自动扫描 `06-Memory/artifacts` 生成。", "", "| 时间 | 成果文件 | 项目 |", "|---|---|---|"]
files.each do |path|
  filename = File.basename(path)
  project = if filename.include?("风月慢养")
    "风月慢养"
  elsif filename.include?("橘李刚俊莲")
    "橘李刚俊莲"
  elsif filename.include?("海外账号运营")
    "海外账号运营"
  elsif filename.include?("桃子逛东京")
    "桃子逛东京"
  elsif filename.include?("橘李设计")
    "橘李设计"
  else
    "未分类"
  end
  timestamp = File.mtime(path).utc.iso8601
  lines << "| #{timestamp} | [`#{filename}`](artifacts/#{filename}) | #{project} |"
end

File.write(index_path, lines.join("\n") + "\n")
puts "Indexed #{files.length} artifacts: #{index_path}"
