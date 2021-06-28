# Set up macOS library paths (required for AppVeyor CI)
if(APPLE)
    # See https://stackoverflow.com/a/54103956
    # and https://stackoverflow.com/a/21692023
    list(APPEND CMAKE_PREFIX_PATH /usr/local)
endif()

include(FindPCRE2)

# TODO: Set the correct possible shared library names and if not found
#       switch to the submodule
if(0)
# using find_package(Lua "5.2" EXACT REQUIRED) only finds the wrong lib version,
# it needs a hint from command line, see also
# https://gitlab.kitware.com/cmake/cmake/-/issues/15756
    find_library(Lua NAMES lua52 lua5.2)
    find_package(Lua "5.2" EXACT REQUIRED)
endif()

include(LiteXlLua)

find_package(PkgConfig)

find_package(Freetype REQUIRED)

find_package(SDL2 REQUIRED)
if(TARGET SDL2::SDL2)
    add_library(SDL2 INTERFACE)
    target_link_libraries(SDL2 INTERFACE SDL2::SDL2)
else()
    add_library(SDL2 INTERFACE)
    string(STRIP "${SDL2_INCLUDE_DIRS}" SDL2_INCLUDE_DIRS)
    string(STRIP "${SDL2_LIBRARIES}" SDL2_LIBRARIES)
    target_include_directories(SDL2 INTERFACE ${SDL2_INCLUDE_DIRS})
    target_link_libraries(SDL2 INTERFACE ${SDL2_LIBRARIES})
endif()
add_library(lite-xl::sdl2 ALIAS SDL2)

include(LiteXlAgg)
include(LiteXlFontRenderer)

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/submodules/reproc")
