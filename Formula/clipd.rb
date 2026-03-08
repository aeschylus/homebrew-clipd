class Clipd < Formula
  desc "Clipboard history manager with global hotkey and floating panel UI"
  homepage "https://github.com/aeschylus/clipd"
  license "MIT"
  head "https://github.com/aeschylus/clipd.git", branch: "main"

  depends_on :macos
  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--manifest-path", "clipd-cli/Cargo.toml"
    bin.install "target/release/clipd"
  end

  service do
    run [opt_bin/"clipd", "daemon", "start", "--foreground"]
    keep_alive true
    log_path var/"log/clipd.log"
    error_log_path var/"log/clipd.log"
  end

  def caveats
    <<~EOS
      clipd daemon installed. Start it with:
        clipd daemon start
        brew services start aeschylus/clipd/clipd

      For the full Mac app (menu bar + Cmd+Shift+V hotkey):
        git clone https://github.com/aeschylus/clipd
        cd clipd && cargo tauri build

      Grant Accessibility access for source-app detection:
        System Settings > Privacy & Security > Accessibility > clipd
    EOS
  end

  test do
    assert_match "clipd", shell_output("#{bin}/clipd --version")
  end
end
