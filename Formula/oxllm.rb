class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.6/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "dc7bae5d0ec4f80aafa636b4ecc41caaeaa8c03bcc33df261d293aeae9112bd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.6/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "5b39e472d703fe35ab2c0c7debe497c8f15694258c337ed06b09ad25ffe0ff1d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.6/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1267a899a5aa99a0e9d43a2e5b9421bc9e558905365c9bfdf3bb867bce49282e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.6/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10743fce71ba4383550b30de6017a7e9407be01ae7346cd88f8767eb3be2b0e0"
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
    bin.install "oxllm" if OS.mac? && Hardware::CPU.arm?
    bin.install "oxllm" if OS.mac? && Hardware::CPU.intel?
    bin.install "oxllm" if OS.linux? && Hardware::CPU.arm?
    bin.install "oxllm" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
