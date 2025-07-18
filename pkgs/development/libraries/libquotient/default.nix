{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  olm,
  openssl,
  qtbase,
  qtmultimedia,
  qtkeychain,
}:

stdenv.mkDerivation rec {
  pname = "libquotient";
  version = "0.9.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "libQuotient";
    rev = version;
    hash = "sha256-R9ms3sYGdHaYKUMnZyBjw5KCik05k93vlvXMRtAXh5Y=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    qtbase
    qtkeychain
    olm
    openssl
    qtmultimedia
  ];

  cmakeFlags = [
    "-DQuotient_ENABLE_E2EE=ON"
  ];

  # https://github.com/quotient-im/libQuotient/issues/551
  postPatch = ''
    substituteInPlace Quotient.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  dontWrapQtApps = true;

  postInstall = ''
    # causes cyclic dependency but is not used
    rm $out/share/ndk-modules/Android.mk
  '';

  meta = with lib; {
    description = "Qt5/Qt6 library to write cross-platform clients for Matrix";
    homepage = "https://quotient-im.github.io/libQuotient/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
