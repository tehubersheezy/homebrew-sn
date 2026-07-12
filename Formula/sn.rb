class Sn < Formula
  desc "Agent-forward CLI for ServiceNow — Table, Change, CMDB, Attachment, Catalog, Import, CICD, and more"
  homepage "https://github.com/tehubersheezy/servicenow-cli"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.9.0/sn-aarch64-apple-darwin.tar.xz"
      sha256 "1e58347dd2dae102298a964170c4c3b4c3e806b5babbbfdc20edfc21fa23d768"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.9.0/sn-x86_64-apple-darwin.tar.xz"
      sha256 "6d65903b4c2738c1590438c81a986df96b2ec41281f50ca6e5018679058d71ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.9.0/sn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1ba62bb46c3a5039616d73755ba0a66fca4c58e8eb20ae70e2c219ed30423f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.9.0/sn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2759edcf3a0c02e17ce2d677a058e991aecfdebf610dbdab1a0757ec2fdd5766"
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
