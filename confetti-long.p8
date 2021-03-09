pico-8 cartridge // http://www.pico-8.com
version 30
__lua__
-- Based on Zep's tweet cart: https://twitter.com/lexaloffle/status/1184075962515767296
-- ::_::cls()srand()for z=5,1,-0.01 do
-- c,r=({8,13,5,1})[z-z%1],rnd
-- u,v,s,q=(r(140)+cos(t()/2+z*9)*(8/z)+t()*(20+rnd(20))/z)%140,(r(140)+t()*(40/z))%140,max(1,3/z),sin(t()*r(1)+z)*.7
-- if(c==8)c=8+r(7)
-- if(q>.6)c=7
-- for i=1,s do line(u,v+i,u+s,v-q*s+i,c)
-- end end flip()goto _

local RENDER_AREA_WIDTH = 128
local RENDER_AREA_HEIGHT = 128

local MIN_PARTICLE_SIZE = 1
local MAX_PARTICLE_SIZE = 3

-- ie; how strong is the wind today?
local MIN_VELOCITY_X = 20

-- As particles fall, they wave left/right in the "air". The amplitude is how
-- far left or right they move while going through a cos() curve
local WAVEY_AMPLITUDE = 8

local DEPTH_LEVELS = 5
local PARTICLES_PER_DEPTH_LEVEL = 100

local particles = {}
function _init()
  srand()
  -- Add the deepest particles first, so they are rendered first when later
  -- iterating over the list of particles.
  -- Use the fractional portion of the depth level to indicate which particle on
  -- that level it is
  for depth = DEPTH_LEVELS, 1, -1 / PARTICLES_PER_DEPTH_LEVEL do
    add(particles, {
      depth = depth,
      -- The "deeper" a particle is, the darker the colour
      -- For particles that are in the foreground, pick any of the 7 "bright"s
      -- NOTE: The integer division "\ 1" ensures depth is a whole number
      colour = ({8 + rnd(7), 13, 5, 1, 1})[depth \ 1],
      -- The "deeper" a particle is, the smaller it is
      size = max(MIN_PARTICLE_SIZE, MAX_PARTICLE_SIZE / depth),
      -- A random starting point on the screen
      startingX = rnd(RENDER_AREA_WIDTH),
      startingY = rnd(RENDER_AREA_HEIGHT),
      -- All particle are moving across the screen to simulate wind
      velocityX = MIN_VELOCITY_X + rnd(20),
      -- Everything is moving down at the same speed
      velocityY = 40,
      -- How wobbly is this particular particle?
      wobbleFactor = rnd(1),
    })
  end
end

function _draw()
  cls(0)
  foreach(particles, function(particle)
    local x =
      (
        particle.startingX
        + (
          cos(
            -- /2 determines how "wavey" in the air the particle is as it falls
            time() / 2
            -- A shortcut to make the waveyness appear random (ie; so not all
            -- particles are waving the same way at the same time). Really,
            -- it's using the fractional part of the depth only (because cos()
            -- takes numbers in the range 0-1.0, the integer portion doesn't
            -- have any effect) so it's equivalent to ((particle.depth % 1) * 9)
            -- Similarly, the *9 is only taking into account the fractional part
            -- of the result. Ie; 0.01*9=0.09, 0.02*9=0.18, but 0.2*9=0.8, etc
            + particle.depth * 9
          ) * WAVEY_AMPLITUDE
          -- Moving the particle across the screen over time
          + time() * particle.velocityX
        )
        -- "deeper" particles move across the screen slower to simulate parallax
        / particle.depth
      )
      -- Keep it within the range 0 - 128 (so it wraps around and keeps rendering on the screen)
      % RENDER_AREA_WIDTH

    local y =
      (
        particle.startingY
        -- Moving the particle across the screen over time
        + time() * particle.velocityY
        -- "deeper" particles move down the screen slower
        / particle.depth
      )
      -- Keep it within the range 0 - 128 (so it wraps around and keeps rendering on the screen)
      % RENDER_AREA_HEIGHT

    -- Give it some wobble
    local wobble = sin(time() * particle.wobbleFactor + particle.depth) * .7

    local colour = particle.colour

    -- When it wobbles to a certain point
    if (wobble > .6) then
      -- Make it shine like it's catching the light
      colour = 7
    end

    -- Each confetti piece is a series of horizontal(-ish) lines based on the size
    for i = 1, particle.size do
      line(
        x,
        y + i,
        x + particle.size,
        -- Changing the y position of the end of the line based on the "wobble"
        -- makes it look like the series of lines are a skewed parallelogram
        y + i - wobble * particle.size,
        colour
      )
    end
  end)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
