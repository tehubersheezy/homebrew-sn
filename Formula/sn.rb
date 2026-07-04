class Sn < Formula
  desc "Agent-forward CLI for ServiceNow — Table, Change, CMDB, Attachment, Catalog, Import, CICD, and more"
  homepage "https://github.com/tehubersheezy/servicenow-cli"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.6.1/sn-aarch64-apple-darwin.tar.xz"
      sha256 "1cbb9871980d4a2154a07d60431d8202a41e7ef618e2ade3369d68c36de8f6e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.6.1/sn-x86_64-apple-darwin.tar.xz"
      sha256 "d848982a3f730b1954dbceedfabff89148055f26ca5110d9bd5577dc2ce3e5ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.6.1/sn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "568968c4281c98e64f387238932a40585033c7631c9d5575c00be49ae0e85af3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.6.1/sn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03df1312e26d6b298d0a919b8ddef0622e35843f98469756193a8a01afe299d0"
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
