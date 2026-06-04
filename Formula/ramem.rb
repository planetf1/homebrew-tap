class Ramem < Formula
  desc "Local, offline AI agent memory using LanceDB and MCP — the ram CLI"
  homepage "https://github.com/planetf1/ramem"
  version "0.1.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/planetf1/ramem/releases/download/v0.1.8/ramem-aarch64-apple-darwin.tar.xz"
    sha256 "c26c1358b9b9d971397e6607db934fa998282767e835b969a006f49a1d4ccfef"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.8/ramem-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab55c9dd29438f5d6cf06f0950ec97ea74051065dcbe735ef40b9ded89fb75d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/ramem/releases/download/v0.1.8/ramem-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c7b6367d3a0ae1156eff21d863b7ebd8184f4a4ee637e11156724c2de8f27682"
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
