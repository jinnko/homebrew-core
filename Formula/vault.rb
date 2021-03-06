# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.9.6",
      :revision => "7e1fbde40afee241f81ef08700e7987d86fc7242"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc7d69d5d898f5c66e75b9015fc6641c9a9eebff2ce9ab883202dfbdc210db04" => :high_sierra
    sha256 "7700573638768d15d7c89efcf5a21b0ca9d93484c99d22ca87876fe8133381c3" => :sierra
    sha256 "e4ccb7dcbf6b1ef93c9369ece99a5e20bee18081f5c4a4ef2db2d234a77acbed" => :el_capitan
    sha256 "73a60a0251331a395ccd9b962a545c50fc5b36323dc2e89f940142ebf76704a5" => :x86_64_linux
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      target = build.with?("dynamic") ? "dev-dynamic" : "dev"
      system "make", target
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
