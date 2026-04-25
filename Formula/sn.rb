class Sn < Formula
  desc "Agent-forward CLI for ServiceNow — Table, Change, CMDB, Attachment, Catalog, Import, CICD, and more"
  homepage "https://github.com/tehubersheezy/servicenow-cli"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.4.1/sn-aarch64-apple-darwin.tar.xz"
      sha256 "fd1b2ae0176749888b2203eaf94e7bdf9d82808741991e13a3f0a441252e696a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.4.1/sn-x86_64-apple-darwin.tar.xz"
      sha256 "28a4d6ea324860eb05c79b5b7fe7b81cd56155e7311a7afa6c1223933c329fc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.4.1/sn-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20b4fb98b362c754443adaf7a509891a0f49621e3def153d2ad05d35931a7274"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tehubersheezy/servicenow-cli/releases/download/v0.4.1/sn-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2bd7655089336c80428f6dee6214e55b5a30ff6f90921e5b3184a90815dfad9"
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
