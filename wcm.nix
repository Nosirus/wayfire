{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayfire,
  wf-shell ? null,
  wrapGAppsHook3,
  gtk3,
  gtkmm3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wcm";
  version = "0.10.0";
  
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O4BYwb+GOMZIn3I2B/WMJ5tUZlaegvwBuyNK9l/gxvQ=";
  };
  
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];
  
  buildInputs = [
    wayfire
    gtk3
    gtkmm3
  ] ++ wayfire.buildInputs ++ wayfire.propagatedBuildInputs
    ++ lib.optionals (wf-shell != null) [ wf-shell ];
  
  mesonFlags = [
    "-Dwf_shell=${if wf-shell != null then "enabled" else "disabled"}"
  ];
  
  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wucke13
      rewine
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
