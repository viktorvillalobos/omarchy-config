-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Samsung S34CG50: 3440x1440 en 34.2" = ~109 PPI. Omarchy viene afinado para
-- pantallas de 218+ PPI, así que los defaults retina no aplican. El manual pide
-- gdk_scale = 1 y monitor_scale = 1 para 1440p, y GTK solo entiende enteros: el
-- gdk_scale tiene que ser el entero más cercano al monitor_scale.
--
-- PROBANDO 1.25 para compararla contra la escala 1.
-- Costo conocido: la escala fraccional deja borrosas a las apps que corren bajo
-- XWayland, porque Hyprland las dibuja a 1x y después las estira. Spotify ya no
-- entra en ese grupo (ver ~/.config/spotify-flags.conf), pero Steam sí.
-- Para volver: poner 1 acá y correr `omarchy display text size 14`.
local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1.25

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- "preferred" elegía 59.97 Hz pudiendo usar los 100 Hz que soporta el panel.
hl.monitor({ output = "HDMI-A-2", mode = "3440x1440@100", position = "0x0", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
