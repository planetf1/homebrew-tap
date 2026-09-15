class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.136"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.136/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "9e167be0555ff98d9171dd8f349b78d0f1749abac122a2c317d89bdcbb50c154"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.136/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "552f60b6847457f3c3a2a50728bfb50cfef06a93982a2bdee1d6968eb99058ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.136/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b75ff9bdd7f6485befc8949839162eb07e1ed8d27c9680d1134fa6c1e115c0df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.136/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f89032d34fcf52ab7083541449ed9e7433cf3469fca98ea1a1add69ee2e8fe9b"
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
