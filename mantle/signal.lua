--
-- signal.lua from Lsyncd -- the Live (Mirror) Syncing Demon
--
--
-- Handles signal handlers.
--
--
-- License: GPLv2 (see COPYING) or any later version
-- Authors: Axel Kittenberger <axkibe@gmail.com>
--
if mantle
then
	print( 'Error, Lsyncd mantle already loaded' )
	os.exit( -1 )
end

-- "signames" is a a (mantle-)global table from signames.lua created by the
-- build script following code creates a (hash)table for the other direction.
local signums = { }

for num, name in pairs( signames )
do
	signums[ name ] = num
end


-- a table of all registered signal handlers
local sigHandlers = { }

-- counter of signal handlers
-- used to tell the core to enlarge the signal queue if needed
-- (the queue must be as large as the number of different signals listened for)
local sigHandlerCount = 0

--
-- onsignal function exported to userEnv
--
function onsignal
(
	signal, -- signal number or name
	handler -- function to call
	--      -- or nil to unload the handle
	--      -- or false to disable default signal handlers
)
	local signum

	if type( signal ) == 'number'
	then
		if signal < 0
		or signal ~= signal
		or signal - floor( signal ) ~= 0
		then
			error( 'signal ' .. signal .. ' is an invalid number.' , 2 )
		end

		signum = signal
	elseif type( signal ) == 'string'
	then
		signum = signums[ signal ]

		if signum == nil
		then
			error( 'signal "' .. signal .. '" unknown.' , 2 )
		end
	else
		error( 'signal of type ' .. type( signal ) .. ' invalid.', 2 )
	end

	-- FIXME store the handler in a table
	-- FIXME tell core of max queue size

	core.onsignal( signum, handler );
end


--
-- Sets up the default HUP/INT/TERM signal handlers.
--
-- Called after user scripts finished
--
function initSignalHandlers
(
	firstTime --- TODO check if needed
)
	onsignal(
		'HUP',
		function( )
			console.log( 'GOT A HUP SIGNAL' );
		end
	)

	onsignal(
		'INT',
		function( )
			console.log( 'GOT A INT SIGNAL' );
		end
	)

	onsignal(
		'TERM',
		function( )
			console.log( 'GOT A TERM SIGNAL' );
		end
	)
end