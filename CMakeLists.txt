project( molecule-parser C )
cmake_minimum_required( VERSION 2.8 )

if( NOT CMAKE_BUILD_TYPE )
  set( CMAKE_BUILD_TYPE Release )
endif()

include( FindFLEX )
if( NOT FLEX_FOUND )
	message( FATAL_ERROR "Could not find flex" )
endif()

include( FindBISON )
if( NOT BISON_FOUND )
  message( FATAL_ERROR "Could not find bison" )
endif()

set( PARSER_DEBUG FALSE
  CACHE BOOL "Debug the parser" )

bison_target( parser parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.c )
flex_target( lexer lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.c )
add_flex_bison_dependency( lexer parser )
include_directories( ${CMAKE_CURRENT_BINARY_DIR} )

add_executable( molparse
	${FLEX_lexer_OUTPUTS}
  ${BISON_parser_OUTPUTS}
  molparse.c
)
target_link_libraries( molparse ${FLEX_LIBRARIES} )
set_target_properties( molparse
  PROPERTIES
  COMPILE_DEFINITIONS "YYERROR_VERBOSE;YYDEBUG=$<BOOL:${PARSER_DEBUG}>"
)
