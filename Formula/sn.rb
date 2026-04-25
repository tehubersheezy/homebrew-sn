class Sn < Formula
  desc "Agent-forward CLI for ServiceNow — Table, Change, CMDB, Attachment, Catalog, Import, CICD, and more"
  homepage "https://github.com/tehubersheezy/sn"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/sn/releases/download/v0.3.2/sn-aarch64-apple-darwin.tar.xz"
      sha256 "b1301e37100c59424288617c7b9495fb5b8fe92c4a23ba0af49601705f910f42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/sn/releases/download/v0.3.2/sn-x86_64-apple-darwin.tar.xz"
      sha256 "27708ee21f0419530ddffb410455eb415897a44c5519cc5504ab4d8239247639"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/sn/releases/download/v0.3.2/sn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1154025c9877ae94680c8d87c33314960ac965c34aaa1cfbbe0c1ddaac96e32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/sn/releases/download/v0.3.2/sn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7c3a321cb1021d1b67b2152851d82586889e7529e98736ecbe660c9d627f3f19"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
