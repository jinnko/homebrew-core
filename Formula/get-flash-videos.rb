class GetFlashVideos < Formula
  desc "Download or play videos from various Flash-based websites"
  homepage "https://github.com/monsieurvideo/get-flash-videos"
  url "https://github.com/monsieurvideo/get-flash-videos/archive/1.25.99.tar.gz"
  sha256 "ffb6547f9bb0565031eb2a62c4702fc467f20464b12aec5747f5c5f0e506d9dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f05ffabed392a613bbf1f6dbfe6768143a0beaa90563813d5bf64f41fbae8d0" => :high_sierra
    sha256 "e33b1482d4054116f4d467c693b515b15f2de3e3746c0247aed7d521f9315804" => :sierra
    sha256 "3e940c869b6dae6288a60c18017726f455268c08a9ddaf52ead795a5e7852faf" => :el_capitan
    sha256 "a4552012a22578356698018d7a0939bcc8f5dfb8708e3b580ed4fc8e3d9f37a5" => :x86_64_linux
  end

  depends_on "rtmpdump"

  resource "Crypt::Blowfish_PP" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTBM/Crypt-Blowfish_PP-1.12.tar.gz"
    sha256 "714f1a3e94f658029d108ca15ed20f0842e73559ae5fc1faee86d4f2195fcf8c"
  end

  resource "LWP::Protocol" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.33.tar.gz"
    sha256 "97417386f11f007ae129fe155b82fd8969473ce396a971a664c8ae6850c69b99"
  end

  resource "Tie::IxHash" do
    url "https://cpan.metacpan.org/authors/id/C/CH/CHORNY/Tie-IxHash-1.23.tar.gz"
    sha256 "fabb0b8c97e67c9b34b6cc18ed66f6c5e01c55b257dcf007555e0b027d4caf56"
  end

  resource "WWW::Mechanize" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/WWW-Mechanize-1.87.tar.gz"
    sha256 "819342a55cdaaf742e8511ecf72c7764b71789f4d1ef0eb6f4b4db4361f3b9cf"
  end

  resource "Term::ProgressBar" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MANWAR/Term-ProgressBar-2.21.tar.gz"
    sha256 "66994f1a6ca94d8d92e3efac406142fb0d05033360c0acce2599862db9c30e44"
  end

  resource "Class::MethodMaker" do
    url "https://cpan.metacpan.org/authors/id/S/SC/SCHWIGON/class-methodmaker/Class-MethodMaker-2.24.tar.gz"
    sha256 "5eef58ccb27ebd01bcde5b14bcc553b5347a0699e5c3e921c7780c3526890328"
  end

  resource "Crypt::Rijndael" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Crypt-Rijndael-1.13.tar.gz"
    sha256 "cd7209a6dfe0a3dc8caffe1aa2233b0e6effec7572d76a7a93feefffe636214e"
  end

  unless OS.mac?
    resource "Module::Find" do
      url "https://cpan.metacpan.org/authors/id/C/CR/CRENZ/Module-Find-0.13.tar.gz"
      sha256 "4a47862072ca4962fa69796907476049dc60176003e946cf4b68a6b669f18568"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.28.tar.gz"
      sha256 "f1d166be8aa19942c4504c9111dade7aacb981bc5b3a2a5c5f6019646db8c146"
    end

    resource "XML::Simple" do
      url "https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.24.tar.gz"
      sha256 "9a14819fd17c75fbb90adcec0446ceab356cab0ccaff870f2e1659205dc2424f"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    ENV.prepend_create_path "PERL5LIB", lib/"perl5"
    system "make"
    (lib/"perl5").install "blib/lib/FlashVideo"

    bin.install "bin/get_flash_videos"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    chmod 0755, libexec/"bin/get_flash_videos"

    man1.install "blib/man1/get_flash_videos.1"
  end

  test do
    file = testpath/"BBC_-__Do_whatever_it_takes_to_get_him_to_talk.flv"
    system bin/"get_flash_videos", "http://news.bbc.co.uk/2/hi/programmes/hardtalk/9560793.stm"
    assert_predicate file, :exist?, "Failed to download #{file}!"
  end
end
