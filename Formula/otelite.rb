class Otelite < Formula
  desc "Otelite: OTLP receiver, dashboard, and CLI for local OpenTelemetry observability"
  homepage "https://github.com/planetf1/otelite"
  version "0.1.49"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.49/otelite-aarch64-apple-darwin.tar.xz"
      sha256 "3359edf5390e2d0683c817868cbd06dfe7ce9726f6c494611843d36bffd44a04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.49/otelite-x86_64-apple-darwin.tar.xz"
      sha256 "b85485c7c6ca1c60322107540cd403b2f7e97edb492daad1cfd9e514389e69b7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.49/otelite-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6abc09846bd58cd554f13d02c0ec3e37bcb474d0824724c392fe2d22424e3c99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/planetf1/otelite/releases/download/v0.1.49/otelite-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad535f7fd80472c063f11b34c444fbd0d5bf4f30b68616b51a50e1a72921660f"
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
