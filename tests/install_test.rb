require "minitest/autorun"
require "tmpdir"
require "open3"
require "fileutils"

class DotfilesInstallTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def test_server_apply_preserves_auth_and_config_and_does_not_install
    Dir.mktmpdir do |home|
      FileUtils.mkdir_p(File.join(home, ".claude"))
      FileUtils.mkdir_p(File.join(home, ".codex"))
      auth = File.join(home, ".claude", ".credentials.json")
      File.write(auth, "sentinel")
      config = File.join(home, ".codex", "config.toml")
      File.write(config, "model = \"sentinel\"\n[mcp_servers.local]\ncommand = \"sentinel\"\n")
      2.times do
        output, status = Open3.capture2e({"HOME" => home}, "sh", File.join(ROOT, "install.sh"), "--server")
        assert status.success?, output
      end
      assert_equal "sentinel", File.read(auth)
      assert_includes File.read(config), 'model = "sentinel"'
      assert_includes File.read(config), '[mcp_servers.local]'
      assert_equal 1, File.read(config).scan(/^\[tui\]$/).length
      assert File.symlink?(File.join(home, ".zshenv"))
      assert File.symlink?(File.join(home, ".config/zsh/.zprofile"))
      refute File.exist?(File.join(home, ".config/karabiner"))
      refute_match(/brew (install|upgrade)|git clone|curl /, File.read(File.join(ROOT, "install.sh")))
    end
  end

  def test_symlink_guard_runs_before_any_settings_are_changed
    Dir.mktmpdir do |home|
      File.symlink(ROOT, File.join(home, ".config"))
      _, status = Open3.capture2e({"HOME" => home}, "sh", File.join(ROOT, "install.sh"), "--server")
      refute status.success?
      refute File.exist?(File.join(home, ".zshenv"))
    end
  end
end
