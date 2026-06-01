class Oxllm < Formula
  desc "Minimalist adaptive routing LLM proxy in Rust"
  homepage "https://github.com/planetf1/oxllm"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.12/oxllm-aarch64-apple-darwin.tar.xz"
      sha256 "4a632a0b6dd2c7095737fea1379fb1192ebebad3d7ef0b9c1669fa296c4d5761"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.12/oxllm-x86_64-apple-darwin.tar.xz"
      sha256 "d415b5b54d7f62881a72c1bfd2f6fe786325161efdadcf0dbd67344de1ce8f28"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.12/oxllm-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6164210aeb4069d6cf8f1f388e0ef8bc46bceafce22303cdf7ce9ae41cd79263"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/oxllm/releases/download/v0.1.12/oxllm-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad5c6ae9fed20c3ca174eb5c42d4887fad17a9520b29534be324fa921c9e24c1"
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
