{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayfire,
  gtkmm3,
  boost,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.10.0";
  
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-C5dgs81R4XuPjIm7sj1Mtu4IMIRBEYU6izg2olymeVI=";
  };
  
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  
  buildInputs = [
    wayfire
    gtkmm3
    boost
  ] ++ wayfire.buildInputs ++ wayfire.propagatedBuildInputs;
  
  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };
  
  mesonFlags = [
    "--sysconfdir /etc"
    (lib.mesonBool "enable_wayfire_shadows" true)
    (lib.mesonBool "enable_focus_request" false)
    (lib.mesonBool "enable_pixdecor" false)
    (lib.mesonBool "enable_filters" false)
  ];
  
  meta = {
    homepage = "https://github.com/WayfireWM/wayfire-plugins-extra";
    description = "Additional plugins for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rewine ];
    inherit (wayfire.meta) platforms;
  };
})
