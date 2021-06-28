cmake_minimum_required(VERSION 3.16)
project(liblua
    VERSION 5.2.4
    LANGUAGES C
    DESCRIPTION "Powerful lightweight programming language designed for extending applications"
    HOMEPAGE_URL "https://www.lua.org/"
)
option(LUA_USE_READLINE "Use readline library" ON)
option(LUA_SHARED "Build the shared library" OFF)
option(LUA_BUILD_INTERPRETERS "Build the lua and luac interpreter" OFF)

set(LUA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/submodules/lua")
set(LUA_HEADERS
    "${LUA_DIR}/src/lua.h"
    "${LUA_DIR}/src/luaconf.h"
    "${LUA_DIR}/src/lualib.h"
    "${LUA_DIR}/src/lauxlib.h"
    "${LUA_DIR}/src/lua.hpp"
)
set(LUA_CORE_SRC
    "${LUA_DIR}/src/lapi.c"
    "${LUA_DIR}/src/lcode.c"
    "${LUA_DIR}/src/lctype.c"
    "${LUA_DIR}/src/ldebug.c"
    "${LUA_DIR}/src/ldo.c"
    "${LUA_DIR}/src/ldump.c"
    "${LUA_DIR}/src/lfunc.c"
    "${LUA_DIR}/src/lgc.c"
    "${LUA_DIR}/src/llex.c"
    "${LUA_DIR}/src/lmem.c"
    "${LUA_DIR}/src/lobject.c"
    "${LUA_DIR}/src/lopcodes.c"
    "${LUA_DIR}/src/lparser.c"
    "${LUA_DIR}/src/lstate.c"
    "${LUA_DIR}/src/lstring.c"
    "${LUA_DIR}/src/ltable.c"
    "${LUA_DIR}/src/ltm.c"
    "${LUA_DIR}/src/lundump.c"
    "${LUA_DIR}/src/lvm.c"
    "${LUA_DIR}/src/lzio.c"
)
set(LUA_LIB_SRC
    "${LUA_DIR}/src/lauxlib.c"
    "${LUA_DIR}/src/lbaselib.c"
    "${LUA_DIR}/src/lbitlib.c"
    "${LUA_DIR}/src/lcorolib.c"
    "${LUA_DIR}/src/ldblib.c"
    "${LUA_DIR}/src/liolib.c"
    "${LUA_DIR}/src/lmathlib.c"
    "${LUA_DIR}/src/loslib.c"
    "${LUA_DIR}/src/lstrlib.c"
    "${LUA_DIR}/src/ltablib.c"
    "${LUA_DIR}/src/loadlib.c"
    "${LUA_DIR}/src/linit.c"
)
set(LUA_CFLAGS LUA_COMPAT_ALL)
set(LUA_INCLUDE_DIR "${LUA_DIR}/src")
set(LUA_LINK_LIBS "")

add_library(liblua STATIC
    ${LUA_CORE_SRC}
    ${LUA_LIB_SRC}
)
set(LUA_LIBRARY liblua)

if(LUA_SHARED)
    add_library(liblua_shared SHARED
        ${LUA_CORE_SRC}
        ${LUA_LIB_SRC}
    )
    set(LUA_LIBRARY liblua_shared)
endif()

if(LUA_BUILD_INTERPRETERS)
    add_executable(lua "src/lua.c")
    add_executable(luac "src/luac.c")
endif()


if(CMAKE_HOST_WIN32)
    list(APPEND LUA_CFLAGS LUA_BUILD_AS_DLL)
    set_target_properties(liblua PROPERTIES OUTPUT_NAME "lua52")

elseif(CMAKE_SYSTEM_NAME MATCHES "FreeBSD" OR
       CMAKE_SYSTEM_NAME MATCHES "Linux" OR
       CMAKE_HOST_APPLE)

    find_package(Readline)
    if(READLINE_FOUND AND LUA_USE_READLINE)
        if(CMAKE_HOST_APPLE)
             list(APPEND LUA_CFLAGS LUA_USE_MACOSX)
        else()
             list(APPEND LUA_CFLAGS LUA_USE_LINUX)
        endif()
        if(0)
            # This resolves to `/usr/include`, screwing lua includes
            # when building custom static
            list(APPEND LUA_INCLUDE_DIR "${Readline_INCLUDE_DIR}")
        endif()
        list(APPEND LUA_LINK_LIBS readline)
    else()
        # Enable all flags except LUA_USE_READLINE.
         list(APPEND LUA_CFLAGS
            LUA_USE_POSIX
            LUA_USE_DLOPEN
            LUA_USE_STRTODHEX
            LUA_USE_AFORMAT
            LUA_USE_LONGLONG
        )
    endif()
elseif(CMAKE_HOST_SOLARIS)
     list(APPEND LUA_CFLAGS LUA_USE_POSIX LUA_USE_DLOPEN _REENTRANT)
else()
    # TODO: if needed test for names OpenBSD, NetBSD, DragonflyBSD
    # CMAKE_(HOST_)SYSTEM_NAME is not well documented.
     list(APPEND LUA_CFLAGS LUA_USE_POSIX DLUA_USE_DLOPEN)
endif()

if(NOT CMAKE_HOST_WIN32)
    set_target_properties(liblua PROPERTIES OUTPUT_NAME "lua")
endif()

list(APPEND LUA_LINK_LIBS m dl)

target_link_libraries(liblua PUBLIC ${LUA_LINK_LIBS})
target_compile_definitions(liblua PUBLIC ${LUA_CFLAGS})
target_include_directories(liblua PRIVATE ${LUA_INCLUDE_DIR})

if(LUA_SHARED)
    if(CMAKE_HOST_WIN32)
        set_target_properties(liblua_shared PROPERTIES OUTPUT_NAME "lua52")
    else()
        set_target_properties(liblua_shared PROPERTIES OUTPUT_NAME "lua")
    endif()
    target_link_libraries(liblua_shared PUBLIC ${LUA_LINK_LIBS})
    target_compile_definitions(liblua_shared PUBLIC ${LUA_CFLAGS})
    target_include_directories(liblua_shared PRIVATE ${LUA_INCLUDE_DIR})
endif()

if(LUA_BUILD_INTERPRETERS)
    target_compile_definitions(lua PRIVATE ${LUA_CFLAGS})
    target_compile_definitions(luac PRIVATE ${LUA_CFLAGS})
    target_link_libraries(lua PRIVATE ${LUA_LINK_LIBS} liblua)
    target_link_libraries(luac PRIVATE ${LUA_LINK_LIBS} liblua)
endif()

# TODO: MSVC installation
if(NOT MSVC)
    include(GNUInstallDirs)

    install(FILES ${LUA_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

    if(LUA_SHARED)
        install(TARGETS liblua_shared DESTINATION "${CMAKE_INSTALL_LIBDIR}")
        set(LUA_PKGCONFIG_FILE
            lua${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}.pc
        )
        configure_file(${PROJECT_SOURCE_DIR}/cmake/lua.pc.in
            ${LUA_PKGCONFIG_FILE} @ONLY
        )
        install(FILES ${CMAKE_BINARY_DIR}/${LUA_PKGCONFIG_FILE}
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
        )
    endif()

    if(LUA_BUILD_INTERPRETERS)
        install(TARGETS lua luac DESTINATION "${CMAKE_INSTALL_BINDIR}")
    endif()
endif()
