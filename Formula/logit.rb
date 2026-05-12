class Logit < Formula
  desc "Terminal-first Jira Tempo worklog logger with MCP support"
  homepage "https://github.com/kytmanov/logit"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kytmanov/logit/releases/download/v0.1.3/logit-aarch64-apple-darwin.tar.xz"
      sha256 "2452aa47cb1c6f5f248ebb1f33ba8ec44bb4f85d5152a5a486bbdd549772b22a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kytmanov/logit/releases/download/v0.1.3/logit-x86_64-apple-darwin.tar.xz"
      sha256 "0c8d119bf87ec87de2fde3b6f025fda1b20c798940a48afea13b7534bddc738b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kytmanov/logit/releases/download/v0.1.3/logit-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "3414a15d5a3e1927481d542a2c34c2174fd7984b7489996c01471f482c54e3f4"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cli-tempo", "logit", "logit-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "cli-tempo", "logit", "logit-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "cli-tempo", "logit", "logit-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
