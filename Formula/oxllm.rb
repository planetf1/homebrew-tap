class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.31/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "ac726e424a21d0b6f5360c781a0d6267cdc8574cd7fde42be7cfa3ce9bba7568"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.31/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "c635be312efff8abedd32fa445209539a80c5002d3034475d695713b10c6405d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.31/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c440f3b103a863e1c989a53a24935bbebb2df0d6e5db13bdafb6d97dd9a82ae3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.31/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5888a83e9913c2c43e36be4e6a421e3c32a6de934d7d91865ffd6339e8953991"
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
