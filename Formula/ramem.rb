class Ramem < Formula
  desc "Local, offline AI agent memory using LanceDB and MCP — the ram CLI"
  homepage "https://github.com/planetf1/ramem"
  version "0.1.9"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/planetf1/ramem/releases/download/v0.1.9/ramem-aarch64-apple-darwin.tar.xz"
    sha256 "6aac04531006f7ab3846bfce7a5971d30dc0c231c611f17223405942249f0eac"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.9/ramem-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "10ed2de9ad7a113aba37e835cab873596fdb36975bf9f24142b5fe5c55aa2993"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.9/ramem-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a481f651a94ad87619de32840d49c293e05d3dbbce88a9ff6360ba82345141dd"
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
