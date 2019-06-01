class Lwtools < Formula
  desc "Cross-development tools for Motorola 6809 and Hitachi 6309"
  homepage "http://lwtools.projects.l-w.ca/"
  url "http://lwtools.projects.l-w.ca/releases/lwtools/lwtools-4.17.tar.gz"
  sha256 "a93ab316ca0176901822873dba4bc286d3a5cf86e6a853d3edb7a51ecc96a91c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd7e751cd045083974d3063b620d2e029936193713a35235cc0207a60e2c2198" => :mojave
    sha256 "60c533f65bf648768d5f1f3b7187c71c2e4144571f6e24009aabfbd512858146" => :high_sierra
    sha256 "5519f50965bf8fa7f3f2361eab1ae240f7cfd2ac1c9e0c2fecc045950e14768a" => :sierra
    sha256 "4c3bd277100d597d7b773fe4ef352658cb1c47c9af62d4a832bcb314048e7a7e" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # lwasm
    (testpath/"foo.asm").write "  SECTION foo\n  stb $1234,x\n"
    system "#{bin}/lwasm", "--obj", "--output=foo.obj", "foo.asm"

    # lwlink
    system "#{bin}/lwlink", "--format=raw", "--output=foo.bin", "foo.obj"
    code = File.open("foo.bin", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0xe7, 0x89, 0x12, 0x34], code

    # lwobjdump
    dump = `#{bin}/lwobjdump foo.obj`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert dump.start_with?("SECTION foo")

    # lwar
    system "#{bin}/lwar", "--create", "foo.lwa", "foo.obj"
    list = `#{bin}/lwar --list foo.lwa`
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert list.start_with?("foo.obj")
  end
end
