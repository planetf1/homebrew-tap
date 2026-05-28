class Ramem < Formula
  desc "Local, offline AI agent memory using LanceDB and MCP — the ram CLI"
  homepage "https://github.com/planetf1/ramem"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/planetf1/ramem/releases/download/v0.1.6/ramem-aarch64-apple-darwin.tar.xz"
    sha256 "4669d2c3c1bb1d55a3719139e7a52642f9b5dd71a00e404b0d4c906585b8d29e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.6/ramem-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f9f6ca1c317863861e48b432fec186034abbac809e0d2a4bdea1a9f151d2a099"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.6/ramem-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddbfca99c2f8f26eefc68bc387385fd01611445bd510642219cfddea5eb918ac"
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
