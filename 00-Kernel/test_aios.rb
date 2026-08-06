#!/usr/bin/env ruby
# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "yaml"

ROOT = File.expand_path("..", __dir__)
PROJECTS = YAML.load_file(File.join(ROOT, "projects.registry.yaml"))["projects"]
EXECUTORS = YAML.load_file(File.join(ROOT, "04-Agents", "executors.registry.yaml"))["executors"]

class AiosRegressionTest < Minitest::Test
  def run_command(*args)
    Open3.capture2(RbConfig.ruby, *args, chdir: ROOT)
  end

  def test_kernel_check_passes
    output, status = run_command("00-Kernel/check.rb")
    assert status.success?, output
    assert_includes output, "AIOS 2.0.0 OK"
  end

  def test_six_sidebar_projects_have_context_files
    ids = %w[
      feng-yue-man-yang
      li-gang-jun-lian
      overseas-accounts
      business-research
      taozi-tokyo
      li-design
    ]
    ids.each do |id|
      project = PROJECTS.find { |item| item["id"] == id }
      refute_nil project, "missing project #{id}"
      path = File.join(ROOT, project.fetch("path"))
      %w[project.yaml RULES.md SOURCES.md MEMORY.md].each do |file|
        assert File.file?(File.join(path, file)), "missing #{id}/#{file}"
      end
    end
  end

  def test_all_registered_executors_are_active_and_have_entrypoints
    assert_equal 7, EXECUTORS.length
    EXECUTORS.each do |executor|
      assert_equal "active", executor.fetch("status"), executor.fetch("id")
      assert File.file?(File.join(ROOT, executor.fetch("entrypoint"))), executor.fetch("id")
    end
  end

  def test_task_routing_regression_cases
    cases = {
      "检查 AIOS 内核状态" => "system-check",
      "橘李刚俊莲：加载项目上下文" => "project-context",
      "风月慢养：生成小红书选题" => "xhs-content",
      "商业研究：整理研究报告" => "business-research",
      "ORLEE：检查品牌设计方向" => "brand-design",
      "海外账号运营：检查 Instagram 与 Reddit" => "overseas-social",
      "桃子逛东京：规划视觉内容" => "taozi-content-visual"
    }
    cases.each do |task, handler|
      output, status = run_command("00-Kernel/executor.rb", task)
      assert status.success?, "#{task}: #{output}"
      assert_includes output, "Handler: #{handler}"
    end
  end
end
