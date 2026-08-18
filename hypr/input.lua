-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Teclado Logitech K950: la tecla rotulada "opt/start" manda Super y la
-- rotulada "cmd/alt" manda Alt, o sea al revés que en un Mac. swap_lalt_lwin
-- intercambia SOLO el par izquierdo, así la tecla pegada a la barra
-- espaciadora pasa a ser Super ("command") y queda el orden de un Mac:
--   ctrl | fn | alt (opt) | super (cmd) | espacio
-- Ojo: NO usar altwin:swap_alt_win, que también intercambia el par derecho y
-- rompería AltGr, imprescindible en el layout "es" para @ # ~ \ | [ ] { }.
-- Omarchy trae ademas compose:caps por defecto, que convierte el Bloq Mayus en
-- tecla Compose. Fuera: en layout "es" ya estan directas la n-tilde, los signos
-- de apertura y el euro, asi que Compose solo costaba el Bloq Mayus.
-- Se conserva shift:both_capslock_cancel, que es el default de Omarchy: los dos
-- Shift a la vez siguen activando mayusculas.
hl.config({
  input = {
    kb_options = "shift:both_capslock_cancel,altwin:swap_lalt_lwin",
  },
})

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
--
--     -- Use a specific keyboard variant if needed (e.g. intl for international keyboards).
--     kb_variant = "intl",
--
--     -- Change speed of keyboard repeat.
--     repeat_rate = 40,
--     repeat_delay = 250,
--
--     -- Start with numlock on by default.
--     numlock_by_default = true,
--
--     -- Increase sensitivity for mouse/trackpad (default: 0).
--     sensitivity = 0.35,
--
--     -- Turn off mouse acceleration (default: adaptive).
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Use natural (inverse) scrolling.
--       natural_scroll = true,
--
--       -- Use two-finger clicks for right-click instead of lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Control the speed of your scrolling.
--       scroll_factor = 0.4,
--
--       -- Enable the touchpad while typing.
--       disable_while_typing = false,
--
--       -- Left-click-and-drag with three fingers.
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
