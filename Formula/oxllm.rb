class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.17/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "c3a9d676c77b27f10a10100796598d073f9ceb7b83e2fc34809570ea749fa608"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.17/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "9b63b1a6668c164ae2212cb64ce6db0f95e11c0e2ed21548284280700108666e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.17/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e5be514f29e68ed1ae3ab5de2e1bcdcae619363cad6f381fd8cac4facfb5cdb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.17/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29603c53653caf77651d0fdd225fcc8d8f33a29b57c7005fdde7ad08a7a428b0"
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
