cmake_minimum_required(VERSION 3.16)
project(lite-xl
    VERSION 2.0.0
    LANGUAGES C CXX
    DESCRIPTION "A lightweight text editor written in Lua"
    HOMEPAGE_URL "https://lite-xl.github.io"
)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/scripts/cmake)
set(LITEXL_VERSION ${PROJECT_VERSION})
set(LITEXL_NAME ${PROJECT_NAME})

include(LiteXlConfig)
include(LiteXlDependencies)
include(LiteXl)

message(STATUS "
CMake Generator:             ${CMAKE_GENERATOR}

Project name:                ${LITEXL_NAME}
Project version:             ${LITEXL_VERSION}
Build type:                  ${CMAKE_BUILD_TYPE}
Build processor:             ${LITEXL_SYSTEM_PROCESSOR}
Use clang libc++:            ${LITEXL_USE_LIBCPP}
Install prefix:              ${CMAKE_INSTALL_PREFIX}
Output directory:            ${CMAKE_BINARY_DIR}

Lua library:                 ${Lua}
PCRE2 libraries:             ${PCRE2_LIBRARIES}
Fontconfig version:          ${Fontconfig_VERSION}
Freetype version:            ${FREETYPE_VERSION_STRING}
SDL2 version:                ${SDL2_VERSION}
libagg version:              ${agg_VERSION}

Compiler C debug flags:      ${CMAKE_C_FLAGS_DEBUG}
Compiler C release flags:    ${CMAKE_C_FLAGS_RELEASE}
Compiler C min size flags:   ${CMAKE_C_FLAGS_MINSIZEREL}

Compiler CXX debug flags:    ${CMAKE_CXX_FLAGS_DEBUG}
Compiler CXX release flags:  ${CMAKE_CXX_FLAGS_RELEASE}
Compiler CXX min size flags: ${CMAKE_CXX_FLAGS_MINSIZEREL}
")
if(0)
    include(Utils)
    print_all_variables()
endif()
