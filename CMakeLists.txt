project( molecule-parser C Fortran )

include( FindFLEX )
if( NOT FLEX_FOUND )
	message( FATAL_ERROR "Could not find flex" )
endif()

add_library( molparse
	${FLEX_mol_lexer_OUTPUTS}
)
