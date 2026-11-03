class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.23/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "ab245070d6a2a442f4b2b6594a44739d2f7ec2c87d9870f8478b5aeafdf6a92c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.23/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "3de3473872c938a59b994b093c5488d83f71c006c3d1c4c2b4b31761b47cac5d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.23/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bab94d924c6d9d19542acdac70e548021137b392a91f2f18346b2633824e8718"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.23/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1f86d23a271fc0210378e777e08f8a0cefeb1e26c643c7ea31dfcf7638d30a57"
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
      bin.install "oxllm"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "oxllm"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "oxllm"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "oxllm"
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
