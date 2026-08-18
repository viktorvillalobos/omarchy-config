-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

--------------------------------------------------------------------------------
-- Capa "estilo Mac"
--------------------------------------------------------------------------------
-- input.lua ya intercambió Alt/Super del lado izquierdo, así que SUPER = la
-- tecla pegada a la barra espaciadora = Cmd. Lo que sigue hace que Cmd+<tecla>
-- llegue a las apps como Ctrl+<tecla>, con excepciones para la terminal (donde
-- Ctrl+C, Ctrl+S, Ctrl+W, etc. significan otra cosa).
--
-- Cmd+C / Cmd+V / Cmd+X no están acá: Omarchy ya los trae en
-- default/hypr/bindings/clipboard.lua y ya distinguen terminal de app.

-- Manda un atajo a la superficie enfocada. El split down/up con timer es el
-- mismo truco que usa Omarchy en clipboard.lua: sin él Hyprland a veces deja
-- la tecla sintética pegada repitiéndose.
-- https://github.com/hyprwm/Hyprland/discussions/14099
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

-- Reusa el tag "terminal" de default/hypr/apps/terminals.lua para no tener una
-- segunda definición de qué cuenta como terminal. Los tags dinámicos traen "*".
local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

-- in_terminal: nil = hace lo mismo que en una app; false = no hace nada
-- (para atajos que en la terminal serían destructivos); función = eso.
local function mac_bind(keys, description, key, in_terminal)
  o.bind(keys, description, function()
    if in_terminal ~= nil and active_window_is_terminal() then
      if in_terminal then
        in_terminal()
      end
      return
    end

    send_shortcut_once("CTRL", key)()
  end)
end

-- Mismo comando que usa Omarchy detrás de { omarchy = "terminal" } en
-- default/hypr/bindings/applications.lua.
local function new_terminal()
  hl.dispatch(hl.dsp.exec_cmd("omarchy-launch-terminal"))
end

-- Atajos que no chocaban con nada de Omarchy ------------------------------

mac_bind("SUPER + A", "Cmd+A: Select all", "A")
mac_bind("SUPER + Z", "Cmd+Z: Undo", "Z")
mac_bind("SUPER + D", "Cmd+D: Duplicate / bookmark", "D")
mac_bind("SUPER + B", "Cmd+B: Bold", "B")
mac_bind("SUPER + I", "Cmd+I: Italic", "I")
mac_bind("SUPER + U", "Cmd+U: Underline", "U")
mac_bind("SUPER + Y", "Cmd+Y: History", "Y")

-- Cmd+R recarga; en la terminal Ctrl+R es la búsqueda inversa del historial,
-- que es justo lo que se querría ahí, así que no hace falta excepción.
mac_bind("SUPER + R", "Cmd+R: Reload", "R")

-- Redo. Shift ya viene físicamente apretado, pero lo mando explícito para que
-- la app reciba Ctrl+Shift+Z aunque Hyprland consuma el modificador.
o.bind("SUPER + SHIFT + Z", "Cmd+Shift+Z: Redo", send_shortcut_once("CTRL SHIFT", "Z"))

-- Cmd+N abre ventana nueva; en la terminal, una terminal nueva.
mac_bind("SUPER + N", "Cmd+N: New window", "N", new_terminal)

-- Atajos que pisan defaults de Omarchy -------------------------------------
-- En cada caso gana el atajo de Mac y la función de Omarchy se muda a
-- Cmd+Opt+<misma tecla>.

-- SUPER+F era "Full screen". En la terminal, Ctrl+F mueve el cursor, así que
-- ahí mando el atajo de búsqueda de foot (Ctrl+Shift+R).
hl.unbind("SUPER + F")
mac_bind("SUPER + F", "Cmd+F: Find", "F", send_shortcut_once("CTRL SHIFT", "R"))
-- Pantalla completa se queda con CTRL+SUPER+F, que es el atajo nativo de macOS
-- y el acorde más corto de los dos. "Tiled full screen" lo tenía por default y
-- se corre un lugar: es una función bastante más marginal.
hl.unbind("SUPER + CTRL + F")
o.bind("SUPER + CTRL + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + CTRL + ALT + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")

-- SUPER+T era "Toggle window floating/tiling".
hl.unbind("SUPER + T")
mac_bind("SUPER + T", "Cmd+T: New tab", "T", new_terminal)
o.bind("SUPER + ALT + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

-- SUPER+W era "Close window". En Mac, Cmd+W cierra pestaña y Cmd+Q cierra la
-- app, así que la ventana se cierra ahora con Cmd+Q. En la terminal no hay
-- pestañas: Cmd+W cierra la ventana, igual que en Terminal.app.
hl.unbind("SUPER + W")
mac_bind("SUPER + W", "Cmd+W: Close tab", "W", function()
  hl.dispatch(hl.dsp.window.close())
end)
o.bind("SUPER + Q", "Cmd+Q: Close window", hl.dsp.window.close())

-- SUPER+S era "Toggle scratchpad". En la terminal Ctrl+S es XOFF y congela la
-- pantalla, así que ahí Cmd+S no hace nada.
hl.unbind("SUPER + S")
mac_bind("SUPER + S", "Cmd+S: Save", "S", false)
o.bind("SUPER + ALT + M", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))

-- Hyprland no tiene "minimizar", pero mandar la ventana al scratchpad es lo
-- más parecido: desaparece y vuelve con Cmd+Opt+M.
o.bind(
  "SUPER + M",
  "Cmd+M: Minimize to scratchpad",
  hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

-- SUPER+L era "Toggle workspace layout".
hl.unbind("SUPER + L")
mac_bind("SUPER + L", "Cmd+L: Address bar", "L")
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- SUPER+P era "Pseudo window".
hl.unbind("SUPER + P")
mac_bind("SUPER + P", "Cmd+P: Print / command palette", "P")
o.bind("SUPER + ALT + P", "Pseudo window", hl.dsp.window.pseudo())

-- SUPER+O era "Pop window out (float & pin)".
hl.unbind("SUPER + O")
mac_bind("SUPER + O", "Cmd+O: Open", "O")
o.bind("SUPER + ALT + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

-- SUPER+SHIFT+D era "Docker" (lazydocker). Se libera el acorde y la TUI se muda
-- a Cmd+Opt+D, siguiendo la misma convención que el resto de lo desplazado.
hl.unbind("SUPER + SHIFT + D")
o.bind("SUPER + ALT + D", "Docker", { tui = "lazydocker" })

-- Tecla de captura del K950 -------------------------------------------------
-- El K950 no tiene PrintScreen, así que el "PRINT, Screenshot" que trae
-- Omarchy por default no se puede disparar. La tecla rotulada con el recuadro
-- de captura no manda un keycode propio: manda META + SHIFT + S, que es el
-- atajo de la herramienta de recortes de Windows (verificado leyendo evdev,
-- code 125 + 42 + 31 desde "Logitech USB Receiver").
--
-- Como input.lua aplica altwin:swap_lalt_lwin, ese Meta izquierdo llega a
-- Hyprland ya traducido a Alt, así que el acorde a bindear es ALT + SHIFT + S.
o.bind("ALT + SHIFT + S", "Screenshot (tecla de captura del K950)", "omarchy-capture-screenshot")

-- Tecla de search del K950 --------------------------------------------------
-- A diferencia de la de captura, ésta sí manda un keycode propio: KEY_SEARCH
-- (evdev 217) por el device "Logitech USB Receiver Consumer Control", que en
-- xkb es el keysym XF86Search. Omarchy no bindea nada ahí, por eso no hacía
-- nada. El menú de apps es el equivalente más cercano a Spotlight; el menú raíz
-- de Omarchy ya lo tenés en SUPER + SPACE.
o.bind("XF86Search", "Apps menu (tecla de search del K950)", "omarchy-menu toggle apps")

-- Tecla de lock del K950 ----------------------------------------------------
-- Como la de captura, tampoco manda keycode propio: manda META + L, el Win+L
-- de Windows (codes evdev 125 + 38). Con altwin:swap_lalt_lwin ese Meta llega
-- traducido a Alt, así que el acorde real es ALT + L (que estaba libre; los
-- binds con L eran modmask 64/68/72, todos con SUPER).
-- Mismo comando que usa Omarchy en SUPER + CTRL + L, que sigue funcionando.
o.bind("ALT + L", "Lock system (tecla de lock del K950)", "omarchy-system-lock")

-- El widget de nombre/icono de workspace mide cero hasta que algún workspace
-- tiene uno de los dos, así que la primera vez no hay nada que clicar. Este
-- atajo es la puerta de entrada, y sigue siendo lo más rápido después.
-- SUPER + ALT + R está libre: los recordatorios de Omarchy usan SUPER + CTRL + R
-- y sus variantes, y SUPER + R lo ocupa el Cmd+R de la capa Mac.
o.bind("SUPER + ALT + R", "Nombre e icono del workspace", "omarchy-shell jankeesvw.workspace-name toggle")

-- Opcionales ---------------------------------------------------------------
-- Cmd+Tab hoy cambia de workspace (el modelo de Omarchy). Para que cicle
-- ventanas como en Mac, descomentar estas dos líneas:
-- hl.unbind("SUPER + TAB")
-- o.bind("SUPER + TAB", "Cmd+Tab: Next window", hl.dsp.window.cycle_next())
