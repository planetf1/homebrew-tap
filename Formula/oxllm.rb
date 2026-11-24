class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.36/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "b381b48cffb01a07ba3a7d492a88f98dfd358ad6e97cc349e3b96e68b9149275"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.36/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "489b2293f0c65ebc6e558345b8c3f1cc649600159f432497ea93ba3046abf5f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.36/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6494958d9283f2bbfd6c2cad754f4ddf74c8e68e046d806bb8dc4cba8a5bc72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.36/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c83120f3d13d11a652a7b880c9c9f795c4db10695ebfb0e1f9ea5a051490556d"
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
