class Sn < Formula
  desc "Agent-forward CLI for ServiceNow — Table, Change, CMDB, Attachment, Catalog, Import, CICD, and more"
  homepage "https://github.com/tehubersheezy/servicenow-cli"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.10.0/sn-aarch64-apple-darwin.tar.xz"
      sha256 "27a5e509a0750ff43f1898e7a4d106b5dee405fd680c3995c9b04f33854206db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.10.0/sn-x86_64-apple-darwin.tar.xz"
      sha256 "c14c876b0e9f073d2eb03f5feca48abc07503dbc64c74b658b93a6cdeb750345"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.10.0/sn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "33e19ba9bfe656519ce2cd17cb4a311a0665a10179dbdd7e9c841dccb6bb08c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.10.0/sn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52e8268d88179843ed6890f94401c1e55f910b35421b0b685214ab9df154dfbd"
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
