class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.27/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "634dc7878377c844aba53fb868d8b72a0a6a90514cecb446d1c08c66e4260671"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.27/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "4c22aa09961d3e72705ab2549432983a004809c41dfcba28048b5bc15d32e095"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.27/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "de367ea02bd8eafad62c38ada402d149a9e5245c342df81207f7380a577cc8f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.27/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "477264e1cd060f36822379b8c0bd3eb2fafca6ee6b5d17ab74d9495ec6813789"
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
