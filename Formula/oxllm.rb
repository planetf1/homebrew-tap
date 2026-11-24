class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.34"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.34/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "9c15730b48e0413f2bed0c83f6a966fad693f55a17d208805276185dfb21af45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.34/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "c268c2d9035951cb3235e3cb497ed935f4e0d867fb22c72a58fc836152e39d2f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.34/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc0eafb8a00ac656ecad3d26cecf8deb1952702b27cb85fa17c083a42e5e5485"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.34/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ceb91b42e2b4fac3a717416050eb6b489f3a8c89dc74aa45a519b53ba05bf27"
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
