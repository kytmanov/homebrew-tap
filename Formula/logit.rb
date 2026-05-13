class Logit < Formula
  desc "Terminal-first Jira Tempo worklog logger with MCP support"
  homepage "https://github.com/kytmanov/logit"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kytmanov/logit/releases/download/v0.1.4/logit-aarch64-apple-darwin.tar.xz"
      sha256 "0178797765aa984605957f0cc224b44300efb0ac4e3a9645455b4d9b777ac043"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kytmanov/logit/releases/download/v0.1.4/logit-x86_64-apple-darwin.tar.xz"
      sha256 "b39c9e4708e8da6c45fd417e7e6e263870b1aadc0032da4b6f030e78b3896824"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/kytmanov/logit/releases/download/v0.1.4/logit-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "78abec65d901d26256edf7595e0df2d0e4c0f9bba4fd87f4bfeb7a741179d08b"
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
