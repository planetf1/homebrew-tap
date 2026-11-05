class Sks3200 < Formula
  desc "CLI + TUI manager for XikeStor SKS3200-8E2X switches"
  homepage "https://github.com/planetf1/sks32kmon"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.9/sks3200-aarch64-apple-darwin.tar.xz"
      sha256 "7d01fbadda4055f1bd24ee146a704a99a5f46f8fcf1af5a751330ea8cc0f67f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.9/sks3200-x86_64-apple-darwin.tar.xz"
      sha256 "921401a721d5e617053a6ab512bd88d3be861ca4597133c5a8245f31be860282"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.9/sks3200-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc43c738b0e82eb31c482cb44a3d393172c4bc8d23d8cabb3adaee0d53faa4a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.9/sks3200-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21398b4cd58c76fbd652cfb5c9c4640a55caf60475a8d0f18531beb63c6aac62"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sks3200"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sks3200"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sks3200"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sks3200"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
