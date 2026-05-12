-- Cursor environment variables
hl.env("HYPRCURSOR_SIZE", cursor_size)
hl.env("HYPRCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)
hl.env("XCURSOR_THEME", cursor_theme)

-- Nvidia environment variables
hl.env("NVD_BACKEND", "direct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
--hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- Adjust qt settings
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", 1)
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", 1)
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("CLUTTER_BACKEND", "wayland")

-- Fix sluggish GTK4 Vulkan renderer
hl.env("GSK_RENDERER", "cairo")

-- Setting up preferred GPU to first use
-- Run `lspci | grep -E 'VGA|3D'` then `ls -l /dev/dri/by-path`
-- hl.env("AQ_DRM_DEVICES","/dev/dri/card1:dev/dri/card0")
