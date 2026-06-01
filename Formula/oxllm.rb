class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.10/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "54d97597085dcb78592c348beb503b6ca62f10d704f34f78b8fd783be8e44860"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.10/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "4036ab7da79b8ba365086ecb6b064ed917347b4ce2113a5ae09f590b6fa02680"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.10/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7c8ee4c39db6e09c2458abd5d18df8c36dc03aa2a466e602df49dffa26fa18ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.10/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1980065cdb715d7c351ba8166efdefa4d80ad5ee99c2e0e61f5b588f2bff1bbe"
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
