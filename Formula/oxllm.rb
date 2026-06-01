class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.8/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "378516b31f82d854371531a4ceaad74843a980b5f403b36d8ea5efd9806e8f54"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.8/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "a0f1d7922b6f5a857c899baf14bc5b67a032d2cee5997815394ecad04782992d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.8/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13428fc0df7604edddda465870b79c27ba70a04a4d4c9cecc938f5c14b70c57a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.8/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "267f3461a06f514044d615e3f7e01d40b841cc5a3a3f6e170bd108018e356bcd"
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
