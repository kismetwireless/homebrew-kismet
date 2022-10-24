# Kismet git Formula
# 
# Does not build python modules - need to make custom packages for them
#
# Does not install suidroot
#
# Install with `brew install --HEAD kismet-git`

class KismetGit < Formula
  desc "Kismet Wi-Fi and Wireless Sniffer"
  homepage "https://www.kismetwireless.net"
  head "https://www.kismetwireless.net/git/kismet.git"
  license "GPL-2"

  depends_on "pkg-config"
  # depends_on "python3"
  depends_on "libpcap"
  depends_on "protobuf"
  depends_on "protobuf-c"
  depends_on "pcre"
  depends_on "librtlsdr"
  depends_on "libbtbb"
  depends_on "ubertooth" 
  depends_on "libusb" 
  depends_on "openssl" 
  depends_on "libwebsockets"
  depends_on "libbladerf"

  conflicts_with "kismet", because: "Install either kismet-git or release kismet"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["openssl"].include}"
    ENV.append "INSTUSR", "${USER}"
    ENV.append "INSTGRP", "staff"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-wifi-coconut", "--enable-bladerf", "--disable-python-tools", "--with-openssl=#{Formula[openssl]}"
    system "make", "install"
    bin.install "packaging/kismet_macos_configure_suid" "kismet_macos_configure_suid"
    ohai "The macOS packet capture component of Kismet (kismet_cap_osx_corewlan_wifi) needs to be configured to be suid-root in order to be able to reconfigure the network interfaces.  Read more about it at https://www.kismetwireless.net/docs/readme/suid/#why-does-kismet-need-root .  To change the permissions on the Kismet capture tool, run 'sudo kismet_macos_configure_suid' .  This only needs to be done once per install."
  end
end
