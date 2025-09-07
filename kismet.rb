# Kismet release Formula
#
# Does not build python modules - need to make custom packages for them
#
# Does not install suidroot

class Kismet < Formula
  desc "Kismet Wi-Fi and Wireless Sniffer"
  homepage "https://www.kismetwireless.net"
  url "https://github.com/kismetwireless/kismet/archive/refs/tags/kismet-2025-09-R1.zip"
  sha256 "fd9e20de64192fb922b58a22341b8b94d8e6bc46bfdec7ac4b26703ee52044cc"
  license "GPL-2"

  depends_on "pkg-config"
  # depends_on "python3"
  depends_on "libpcap"
  # depends_on "protobuf"
  # depends_on "protobuf-c"
  depends_on "pcre"
  depends_on "librtlsdr"
  depends_on "libbtbb"
  depends_on "ubertooth"
  depends_on "libusb"
  depends_on "openssl"
  depends_on "libwebsockets"
  depends_on "libbladerf"
  depends_on "mosquitto"

  conflicts_with "kismet-git", because: "Install either kismet-git or release kismet"

  def install
    on_macos do
      <<~EOS
        Due to changes made in recent macOS versions, it may not be possible to
        enable monitor mode (or properly control channels in monitor mode) using the
        built-in Airport Wi-Fi card.

        Unfortunately this reduces Kismet functionality to working with remote
        datasources and some SDR radios.
      EOS
    end
    ENV.append "CPPFLAGS", "-I#{Formula["openssl"].include}"
    ENV.append "INSTUSR", "${USER}"
    ENV.append "INSTGRP", "staff"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-wifi-coconut", "--enable-bladerf", "--disable-python-tools", "--enable-homebrew"
    system "make", "install"
    bin.install "packaging/kismet_macos_configure_suid" => "kismet_macos_configure_suid"
  end

  def caveats
    on_macos do
      <<~EOS
        The macOS packet capture component of Kismet (kismet_cap_osx_corewlan_wifi)
        needs to be suid-root in order to have the required permissions to reconfigure
        airport interfaces.  You can read more about the need for root permissions at

        https://www.kismetwireless.net/docs/readme/datasources/wifi-macos/

        To change the permissions on the Kismet capture tool, either run the script
        installed by Kismet via:

        sudo /opt/homebrew/bin/kismet_macos_configure_suid

        or by manually setting ownership of the capture tool to root and setting
        the suid bit:

        chown root /opt/homebrew/bin/kismet_cap_osx_corewlan_wifi
        chmod 4755 /opt/homebrew/bin/kismet_cap_osx_corewlan_wifi

        Additionally, due to changes made in recent macOS versions, it may not be
        possible to enable monitor mode or change channel on the built-in WiFi
        card, making Kismet useful primarily with remote sources (some SDR sources
        may still work as well)
      EOS
    end
  end
end
