class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.22"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.22/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "31dc4b4a3ec457cb081bc8baa6d40bb5e73919af3b3e07c57cb455a34e9540c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.22/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "25b58e0a5f660265f38d1e5de531858177255dbeb3ed20c0ef0f349c3d7a7574"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.22/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a41c7ebeac13cfdf77052718c3a884c36430ec299bc25e11f7c6c5b0069721b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.22/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddbee5480c9a0de2ef822e5ea5af45152c93f6cb3f4a7616f8d85de424ec3920"
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
    bin.install "otelite" if OS.mac? && Hardware::CPU.arm?
    bin.install "otelite" if OS.mac? && Hardware::CPU.intel?
    bin.install "otelite" if OS.linux? && Hardware::CPU.arm?
    bin.install "otelite" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
