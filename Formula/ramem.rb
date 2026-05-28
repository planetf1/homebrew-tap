class Ramem < Formula
  desc "Local, offline AI agent memory using LanceDB and MCP — the ram CLI"
  homepage "https://github.com/planetf1/ramem"
  version "0.1.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/planetf1/ramem/releases/download/v0.1.7/ramem-aarch64-apple-darwin.tar.xz"
    sha256 "0ce8daf90e77546ef19145080eea2de64cbf9b6f5f8dcf4772b0a82e06964620"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.7/ramem-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "17380f5b100c4681cfdea0aa974b0c9f69d7935e94729d14b85e670c6e103f11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.7/ramem-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "772bcc950569d1357d96fe966c376b819cf14d763e8bab754a03442db0eadfc1"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "ram" if OS.mac? && Hardware::CPU.arm?
    bin.install "ram" if OS.linux? && Hardware::CPU.arm?
    bin.install "ram" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
