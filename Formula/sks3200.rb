class Sks3200 < Formula
  desc "CLI + TUI manager for XikeStor SKS3200-8E2X switches"
  homepage "https://github.com/planetf1/sks32kmon"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.7/sks3200-aarch64-apple-darwin.tar.xz"
      sha256 "b6c061b0a5e67395830cd9c44d0c6774f1ad654aa0d52a2d5647ed301c408cf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.7/sks3200-x86_64-apple-darwin.tar.xz"
      sha256 "d5b60b2e169dd06805631891815dad3265b213e176e35ef755e57ef585c092b3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.7/sks3200-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5e287be025d3aab8057c860b76891ed7bc53f24f787930fe7ec7c8aa0efc539"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.7/sks3200-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6abf38c30f31e7564c7d03df0397dd0531f866f04879e04c78e99fab2313e39b"
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
    bin.install "sks3200" if OS.mac? && Hardware::CPU.arm?
    bin.install "sks3200" if OS.mac? && Hardware::CPU.intel?
    bin.install "sks3200" if OS.linux? && Hardware::CPU.arm?
    bin.install "sks3200" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
