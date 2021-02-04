class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/v2.4.1.tar.gz"
  sha256 "ae6387c097c9359d71d0e8dec864d6553e47e7edfb93ddbfe017062a05f4b396"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bbf9b989e5796e9b544f38a7385776d799266920bdb6d52ccfc49e26245e5000"
    sha256 cellar: :any_skip_relocation, big_sur:       "beda64b997040618737d3df1da876186e229b3208af0be3508cccc5a6267e77b"
    sha256 cellar: :any_skip_relocation, catalina:      "d0fd755d4119c662dd1d91983045850bca52cdd7d12b0d1c0216035b15cd567f"
    sha256 cellar: :any_skip_relocation, mojave:        "f3352fc9ff3f97a62fe132292cd7034abd3f05e65c6c2e3f821dbd762366cfd3"
  end

  depends_on "go" => :build

  def install
    build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{build_time}
    ]

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd/youtubedr"
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch\?v\=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
