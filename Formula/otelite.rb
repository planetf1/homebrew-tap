class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.37"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.37/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "733973cc8926e6769a2c6ac751b9222e6dab4a8994148d13557b1e4d77312a4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.37/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "dca92a94ae170eb3bd887c1df30ce9f900319c4fe8c1a38138a07bbdf557f9c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.37/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "078603cf9d49c6030c04ebc737d569eda401f0f066c1ca34980ff6d56d3f6630"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.37/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c246a5a74c5eb5705226a23266fd9587f290921f47dde852c2dd628910856442"
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
