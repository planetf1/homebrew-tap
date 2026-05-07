class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.15/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "f676094df648cb51975710cbab40131da9bb07a56dd11002a42983ab0f41c502"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.15/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "c8396163f39268c81b5eb06c8743cfa1d332fa0f9852ba852395a58d8a74061d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.15/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1418e42a3a541991aaff4739ed66dc2955837721a07c8d04d69d151218268e1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.15/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "550328c0e07dddcc2a569875afc9333f489c50ecee70a35d7ebcebfd2234669b"
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
