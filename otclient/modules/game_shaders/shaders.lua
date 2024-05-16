HOTKEY = 'Ctrl+X' -- Keyboard shortcut for shaders

MAP_SHADERS = {   -- Table with all Main Map shaders
  { name = 'Default',     frag = 'shaders/default.frag' },
  { name = 'Bloom',       frag = 'shaders/bloom.frag' },
  { name = 'Sepia',       frag = 'shaders/sepia.frag' },
  { name = 'Grayscale',   frag = 'shaders/grayscale.frag' },
  { name = 'Pulse',       frag = 'shaders/pulse.frag' },
  { name = 'Old Tv',      frag = 'shaders/oldtv.frag' },
  { name = 'Fog',         frag = 'shaders/fog.frag',                    tex1 = 'images/clouds.png' },
  { name = 'Party',       frag = 'shaders/party.frag' },
  { name = 'Radial Blur', frag = 'shaders/radialblur.frag' },
  { name = 'Zomg',        frag = 'shaders/zomg.frag' },
  { name = 'Heat',        frag = 'shaders/heat.frag' },
  { name = 'Noise',       frag = 'shaders/noise.frag' },
  { name = 'Outline',     frag = 'shaders/outline.frag' },
  { name = 'Trail',       frag = 'shaders/trail.frag', --[[dir = true]] },
  { name = 'Dither',      frag = 'shaders/dither.frag' },
  { name = 'Time Stop',   frag = 'shaders/zawarudo.frag' }
}

ITEM_SHADERS = { -- Table with Item Shaders
  { name = 'Fake 3D', vert = 'shaders/fake3d.vert' }
}

shadersPanel = nil -- Shader panel
--dir = nil        -- to store direction of player

function init()
  g_ui.importStyle('shaders.otui')

  g_keyboard.bindKeyDown(HOTKEY, toggle)

  shadersPanel = g_ui.createWidget('ShadersPanel', modules.game_interface.getMapPanel())
  shadersPanel:hide()

  local mapComboBox = shadersPanel:getChildById('mapComboBox')
  mapComboBox.onOptionChange = function(combobox, option)
    local map = modules.game_interface.getMapPanel()
    map:setMapShader(g_shaders.getShader(option))
  end

  if not g_graphics.canUseShaders() then return end

  for _i, opts in pairs(MAP_SHADERS) do
    local shader = g_shaders.createFragmentShader(opts.name, opts.frag)

    -- -- For shaders with a direction "dir" argument:
    -- if opts.dir then
    --   local player = g_game.getLocalPlayer()
    --   if player then
    --     local dir = player:getDirection()
    --     shader:setOpacity(1.0)
    --   end
    -- end
    if opts.tex1 then
      shader:addMultiTexture(opts.tex1)
    end
    if opts.tex2 then
      shader:addMultiTexture(opts.tex2)
    end

    mapComboBox:addOption(opts.name)
  end

  local map = modules.game_interface.getMapPanel()
  map:setMapShader(g_shaders.getShader('Default'))
end

function terminate()
  g_keyboard.unbindKeyDown(HOTKEY)
  shadersPanel:destroy()
end

function toggle()
  shadersPanel:setVisible(not shadersPanel:isVisible())
end
