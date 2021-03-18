class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.50.0.tar.gz"
  sha256 "6ade7b7ecf1b0c6338ba6b404f68b76ed23a368d27317b39f3cf1d0f89057b6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4ae3e3c577c3753e15b75cf0af1deb822c441df381d3d1d923a9337684d62a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7f3e8d91d907888ebe0585f29b01c64f25cc829f55e3aa0a896d9ef60177a70"
    sha256 cellar: :any_skip_relocation, catalina:      "cf34ec271d9a63ea979c379cfb3c30828d4b53ebc3d691d4b7798ca83c7fb87d"
    sha256 cellar: :any_skip_relocation, mojave:        "d59cd7e3d92970fb71818826c9a93d3ced9ce9179493d33914df125bbbaa78b0"
  end

  depends_on "go" => :build

  resource "sonobuoyresults" do
    url "https://raw.githubusercontent.com/vmware-tanzu/sonobuoy/master/pkg/client/results/testdata/results-0.10.tar.gz"
    sha256 "a945ba4d475e33820310a6138e3744f301a442ba01977d38f2b635d2e6f24684"
  end

  def install
    system "go", "build", "-ldflags",
                   "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}",
                   *std_go_args
    prefix.install_metafiles
  end

  test do
    resources.each { |r| r.verify_download_integrity(r.fetch) }
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kube-conformance-image-version=v1.14 2>&1")
    assert_match "all tests",
      shell_output("#{bin}/sonobuoy e2e --show=all " + resource("sonobuoyresults").cached_download + " 2>&1")
  end
end
