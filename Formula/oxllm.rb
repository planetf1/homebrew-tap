class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.4/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "7d66fe91c03b8a71eed1c45fb79e00ba22c4db757ca7b519a990e7675e8e2afc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.4/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "1e817858aae0ba240ec6dbc2f853015187c03fe1f48d994eb8ec060c18083a93"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.4/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a9e840ad043e8e3dd82d1c931dd6bee14fcb7f709d4d36164789710d13cc4738"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.4/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e05f0519fd4a25b7ca81a21c4e1964ab1cd5f318fbb8260d0ce7fb2db85fcde"
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
