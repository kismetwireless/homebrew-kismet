# Kismet release Formula
# 
# Does not build python modules - need to make custom packages for them
#
# Does not install suidroot

class Kismet < Formula
  desc "Kismet Wi-Fi and Wireless Sniffer"
  homepage "https://www.kismetwireless.net"
  url "https://github.com/kismetwireless/kismet/archive/refs/tags/kismet-2022-08-R1.zip"
  sha256 "0ebffeff643e0bbf9875f2b3e5d34efad9f9d9a613f27db4c0cc4e675ef57aa7"
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

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["openssl"].include}"
    ENV.append "INSTUSR", "${USER}"
    ENV.append "INSTGRP", "staff"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-wifi-coconut", "--enable-bladerf", "--disable-python-tools", "--with-openssl=#{Formula["openssl"]}"
    system "make", "install"
  end
end
