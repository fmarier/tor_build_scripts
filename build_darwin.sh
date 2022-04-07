#!/bin/sh
set -eu

# Download and verify dependencies
curl --proto '=https' --tlsv1.3 -fsSL "https://zlib.net/zlib-$ZLIB_VERSION.tar.gz" -o "zlib-$ZLIB_VERSION.tar.gz"
echo "$ZLIB_HASH  zlib-$ZLIB_VERSION.tar.gz" | shasum -a 256 -c -

curl --proto '=https' --tlsv1.3 -fsSL "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -o "openssl-$OPENSSL_VERSION.tar.gz"
echo "$OPENSSL_HASH  openssl-$OPENSSL_VERSION.tar.gz" | shasum -a 256 -c -

curl --proto '=https' --tlsv1.3 -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz" -o "libevent-$LIBEVENT_VERSION.tar.gz"
curl --proto '=https' --tlsv1.3 -fsSL "https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz.asc" -o "libevent-$LIBEVENT_VERSION.tar.gz.asc"
gpg --keyring gpg-keys/libevent.gpg --verify "libevent-$LIBEVENT_VERSION.tar.gz.asc" "libevent-$LIBEVENT_VERSION.tar.gz"
echo "$LIBEVENT_HASH  libevent-$LIBEVENT_VERSION.tar.gz" | shasum -a 256 -c -

curl --proto '=https' --tlsv1.3 -fsSL "https://dist.torproject.org/tor-$TOR_VERSION.tar.gz" -o "tor-$TOR_VERSION.tar.gz"
curl --proto '=https' --tlsv1.3 -fsSL "https://dist.torproject.org/tor-$TOR_VERSION.tar.gz.sha256sum" -o "tor-$TOR_VERSION.tar.gz.sha256sum"
sha256sum -c "tor-$TOR_VERSION.tar.gz.sha256sum"
curl --proto '=https' --tlsv1.3 -fsSL "https://dist.torproject.org/tor-$TOR_VERSION.tar.gz.sha256sum.asc" -o "tor-$TOR_VERSION.tar.gz.sha256sum.asc"
gpg --keyring gpg-keys/tor.gpg --verify "tor-$TOR_VERSION.tar.gz.sha256sum.asc" "tor-$TOR_VERSION.tar.gz.sha256sum"
echo "$TOR_HASH  tor-$TOR_VERSION.tar.gz" | shasum -a 256 -c -

# Build
sh build_darwin_arm64.sh
sh build_darwin_x86_64.sh

lipo -create -output "tor-$TOR_VERSION-darwin-brave-$BRAVE_TOR_VERSION" "arm64/tor-$TOR_VERSION/root/bin/tor" "x86_64/tor-$TOR_VERSION/root/bin/tor"
