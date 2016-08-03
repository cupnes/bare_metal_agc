		SETLOC	4000
		CAF	BIT4		# turn on temp light
		# CAF	BIT7		# turn on opr err light
		EXTEND
		WOR	DSALMOUT
END		TC	END
BIT4		OCT	00010
BIT7		OCT	00100
DSALMOUT	EQUALS	11

# reference
# http://www.ibiblio.org/apollo/developer.html#Table_of_IO_Channels
# https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/T4RUPT_PROGRAM.agc#L677
# https://github.com/chrislgarry/Apollo-11/blob/master/Comanche055/PINBALL_GAME_BUTTONS_AND_LIGHTS.agc#L3406
