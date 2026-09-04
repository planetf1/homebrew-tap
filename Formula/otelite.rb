class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.120"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.120/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "db363614d88d56687a7cfcdc5335cd675139a4b56fca7576a67802345acc9558"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.120/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "1ae724e14092779f5366b3db56aa73d59b8f288628b2282edbe5697de7434939"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.120/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbcd1cf8a65954607ed96b1ac31a795de3bd7c50325da63941b9cd172192b249"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.120/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6c0159c8e6879aa326530fd6bc0bdc68b981aebbd05acdda92116ba47033be7"
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
