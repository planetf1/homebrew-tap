class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.141"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.141/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "dad7cb1e3f33dbe55ee232309c5c08672d32dc9c813a4bae84f29443fb494ecd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.141/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "c1cb26d01964da13e7b18983f7ac003481fe50e44cf0366d94e5e56dfb6052bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.141/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d3bf26d8b1e28ac64d004aa279ddb6b24818737ed393cd01874c954ed306b12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.141/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50993404fdab30469b338d99d52094c0e4e9ed9c1f3e8a8a99a611ca5e6514b6"
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
  service do
    run [opt_bin/"otelite", "serve"]
    keep_alive true
    log_path var/"log/otelite.log"
    error_log_path var/"log/otelite.log"
  end
end
