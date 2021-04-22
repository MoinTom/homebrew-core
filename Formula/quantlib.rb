class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.22/QuantLib-1.22.tar.gz"
  sha256 "85c81816f689f458596dd7073e4da8fd7f596c1e4c8ada81a6300389a39588af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b930efbd942abbb5f9317d3d15fc0ca6a551cc3f7d5c3eb7cdb77464770d5ae0"
    sha256 cellar: :any, big_sur:       "d5e6c206260e8ef5e297e464dd45979fe56bdaa938c75a071f70fce97b1b391e"
    sha256 cellar: :any, catalina:      "18dd1cc854b50e811fec338ba31f7ea3d6aacf80a4f0c1f90c8d8db8d891b2b7"
    sha256 cellar: :any, mojave:        "03c142589e975e9ba78966cd9f813fc77ae22aefea1049b43f3e7406cd090193"
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
