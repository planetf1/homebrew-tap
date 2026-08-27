class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.80"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.80/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "659facb1a8aaa6ba1d90500b989a9f323db90d01f55cf413041aa950804ec291"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.80/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "dae09fa237248407281c931415da75658767181150df718fcbaf560710c6973c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.80/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7780a36875253029bb22074c16f8b62dfb5bb06b84bf6e0345b8862c4236a7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.80/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "242745cf0fb5e4b454182c39a8660717fafd0fdf826d8a157b1cb0d8382bcba2"
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
