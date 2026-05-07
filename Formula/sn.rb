class Sn < Formula
  desc "Agent-forward CLI for ServiceNow — Table, Change, CMDB, Attachment, Catalog, Import, CICD, and more"
  homepage "https://github.com/tehubersheezy/servicenow-cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.5.0/sn-aarch64-apple-darwin.tar.xz"
      sha256 "06ab02b52c1ac04014c91503bfa0e39d5adabfb0390c296d49b3f75a731c8085"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.5.0/sn-x86_64-apple-darwin.tar.xz"
      sha256 "6e237823ec506b88900621298cdcccf980376033e4c4c0026ce090692de47277"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.5.0/sn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "356cd9ab1fe99dcfc9831439146b8c311f4bb44f8ae73bb4233cb22c2bf205d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.5.0/sn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2599b1cd696c1dffeb7cad4c80a5e53f6bea899abdaab6abf6749df7587a09fb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "sn" if OS.mac? && Hardware::CPU.arm?
    bin.install "sn" if OS.mac? && Hardware::CPU.intel?
    bin.install "sn" if OS.linux? && Hardware::CPU.arm?
    bin.install "sn" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
