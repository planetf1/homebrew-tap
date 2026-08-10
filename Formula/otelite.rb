class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.57"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.57/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "22b696ef4a7fb0737f44aad13fa282a24106dea9b3135ec575f54ba438fb81c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.57/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "474136575f5052c80a379c19bffae09c79fa7992c49d401873bbb52711941cfb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.57/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b8f6bbf07d600478005aca41cff0137230892ba821d4a757f2281bba7a11138"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.57/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95851a97ab33db71e5dbe4d19511d518487181655e2cacc41c28d87d621f1b7d"
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
      bin.install "otelite"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "otelite"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "otelite"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "otelite"
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
