set(LITEXL_HEADERS
    src/api/api.h
    src/fontdesc.h
    src/rencache.h
    src/renderer.h
    src/renwindow.h
)
set(LITEXL_SOURCES
    src/api/api.c
    src/api/cp_replace.c
    src/api/renderer.c
    src/api/renderer_font.c
    src/api/regex.c
    src/api/system.c
    src/api/process.c
    src/renderer.c
    src/renwindow.c
    src/fontdesc.c
    src/rencache.c
    src/main.c
)
if(APPLE)
    list(APPEND LITEXL_SOURCES bundle_open.m)
    set(MACOSX_BUNDLE_ICON_FILE icon.icns)
    set(LITEXL_APP_ICON "${CMAKE_CURRENT_SOURCE_DIR}/dev-utils/icon.icns")
    set_source_files_properties(${LITEXL_APP_ICON} PROPERTIES
        MACOSX_PACKAGE_LOCATION "Resources"
    )
    add_executable(lite-xl
        MACOSX_BUNDLE
        ${LITEXL_HEADERS}
        ${LITEXL_SOURCES}
        ${LITEXL_APP_ICON}
    )
elseif(WIN32)
    list(APPEND LITEXL_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/res.rc")
    add_executable(lite-xl
        WIN32
        ${LITEXL_HEADERS}
        ${LITEXL_SOURCES}
    )
else()
    add_executable(lite-xl
        ${LITEXL_HEADERS}
        ${LITEXL_SOURCES}
    )
endif()

target_include_directories(lite-xl PRIVATE
    "src"
    "lib/font_renderer"
    ${LUA_INCLUDE_DIR}
)
target_link_libraries(lite-xl PRIVATE
    ${LUA_LIBRARY}
    ${FREETYPE_LIBRARY}
    ${PCRE2_LIBRARIES}
    lite-xl::sdl2
    lite-xl::fontrenderer
    reproc
)
