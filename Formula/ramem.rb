class Ramem < Formula
  desc "Local, offline AI agent memory using LanceDB and MCP — the ram CLI"
  homepage "https://github.com/planetf1/ramem"
  version "0.1.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/planetf1/ramem/releases/download/v0.1.10/ramem-aarch64-apple-darwin.tar.xz"
    sha256 "54635dc055389e6e81dad76ffa2beacfdd7e2f5f454260e338250c92611359c5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.10/ramem-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a359e0d84eaa8b6b0bc6e209620a131dce654ed400f26af0157912cf6be0a90d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.10/ramem-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42d3b4abce02f2491f0118ae421b57a783f96e0878dc823111d61486b192fdc8"
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
