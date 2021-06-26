set(LITEXL_FONTRENDERER_HEADERS
    lib/font_renderer/agg_font_freetype.h
    lib/font_renderer/agg_lcd_distribution_lut.h
    lib/font_renderer/agg_pixfmt_alpha8.h
    lib/font_renderer/font_renderer_alpha.h
    lib/font_renderer/font_renderer.h
)
set(LITEXL_FONTRENDERER_SOURCES
    lib/font_renderer/agg_font_freetype.cpp
    lib/font_renderer/font_renderer.cpp
)
add_library(fontrenderer STATIC
    ${LITEXL_FONTRENDERER_HEADERS}
    ${LITEXL_FONTRENDERER_SOURCES}
)
add_library(lite-xl::fontrenderer ALIAS fontrenderer)

add_definitions(-DFONT_RENDERER_HEIGHT_HACK)

find_package(Freetype REQUIRED)

target_link_libraries(fontrenderer PUBLIC
    ${FREETYPE_LIBRARY}
    lite-xl::agg
)
target_include_directories(fontrenderer PUBLIC
    "${FREETYPE_INCLUDE_DIRS}"
    "${AGG_DIR}/include"
)
