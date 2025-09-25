{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  cmake,
  meson,
  ninja,
  pkg-config,
  wf-config,
  cairo,
  doctest,
  libGL,
  libdrm,
  libevdev,
  libinput,
  libxkbcommon,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots,
  pango,
  yyjson,
  pixman,
  glm,
  vulkan-headers,
  vulkan-loader,
  xorg,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-rnrcuikfRPnIfIkmKUIRh8Sm+POwFLzaZZMAlmeBdjY=";
  };
  
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];
  
  buildInputs = [
    libGL
    libdrm
    libevdev
    libinput
    libxkbcommon
    wayland-protocols
    xorg.xcbutilwm
    yyjson
    pixman
    glm
    vulkan-headers
    vulkan-loader
    libxml2
  ];
  
  propagatedBuildInputs = [
    wlroots
    wayland
    cairo
    pango
  ];
  
  nativeCheckInputs = [
    cmake
    doctest
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    find . -name "*.hpp" -o -name "*.cpp" | xargs grep -l "drm_fourcc.h" | while read file; do
      sed -i 's|#include <drm_fourcc.h>|#include <drm/drm_fourcc.h>|' "$file"
    done
  '';
  
  doCheck = true;
  
  mesonFlags = [
    "--sysconfdir=/etc"
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=disabled"
  ];
  
  passthru.providedSessions = [ "wayfire" ];
  
  meta = {
    homepage = "https://wayfire.org/";
    description = "Compositeur Wayland 3D modulaire et extensible";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wucke13
      rewine
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
