class Sks3200 < Formula
  desc "CLI + TUI manager for XikeStor SKS3200-8E2X switches"
  homepage "https://github.com/planetf1/sks32kmon"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.6/sks3200-aarch64-apple-darwin.tar.xz"
      sha256 "dd1002912f576673129e5361a2582a3d093cdb82f4371678b2c56e5b95621eb3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.6/sks3200-x86_64-apple-darwin.tar.xz"
      sha256 "93a49249a6f34083ec39b27dfea44889119ca2b443ad6eb920065ccb83262faf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.6/sks3200-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43ec84c6b8651ac16116f1e7179f18fafaeed96ad570e93b83fe828becbfad70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/sks32kmon/releases/download/v0.1.6/sks3200-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac2c4208988ced5dc10e693dc58e25dab13a4bc698c8c2629386792d00dd4798"
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
