project(agg
    VERSION 2.4.1
    LANGUAGES C CXX
    DESCRIPTION "Anti-Grain Geometry Library"
    HOMEPAGE_URL "https://franko.github.io/antigrain/"
)
set(CMAKE_CXX_STANDARD 11)
set(AGG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/subprojects/libagg")
set(AGG_SOURCES
    "${AGG_DIR}/src/agg_arc.cpp"
    "${AGG_DIR}/src/agg_arrowhead.cpp"
    "${AGG_DIR}/src/agg_bezier_arc.cpp"
    "${AGG_DIR}/src/agg_bspline.cpp"
    "${AGG_DIR}/src/agg_curves.cpp"
    "${AGG_DIR}/src/agg_vcgen_contour.cpp"
    "${AGG_DIR}/src/agg_vcgen_dash.cpp"
    "${AGG_DIR}/src/agg_vcgen_markers_term.cpp"
    "${AGG_DIR}/src/agg_vcgen_smooth_poly1.cpp"
    "${AGG_DIR}/src/agg_vcgen_stroke.cpp"
    "${AGG_DIR}/src/agg_vcgen_bspline.cpp"
    "${AGG_DIR}/src/agg_gsv_text.cpp"
    "${AGG_DIR}/src/agg_image_filters.cpp"
    "${AGG_DIR}/src/agg_line_aa_basics.cpp"
    "${AGG_DIR}/src/agg_line_profile_aa.cpp"
    "${AGG_DIR}/src/agg_rounded_rect.cpp"
    "${AGG_DIR}/src/agg_sqrt_tables.cpp"
    "${AGG_DIR}/src/agg_embedded_raster_fonts.cpp"
    "${AGG_DIR}/src/agg_trans_affine.cpp"
    "${AGG_DIR}/src/agg_trans_warp_magnifier.cpp"
    "${AGG_DIR}/src/agg_trans_single_path.cpp"
    "${AGG_DIR}/src/agg_trans_double_path.cpp"
    "${AGG_DIR}/src/agg_vpgen_clip_polygon.cpp"
    "${AGG_DIR}/src/agg_vpgen_clip_polyline.cpp"
    "${AGG_DIR}/src/agg_vpgen_segmentator.cpp"
    "${AGG_DIR}/src/ctrl/agg_cbox_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_gamma_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_gamma_spline.cpp"
    "${AGG_DIR}/src/ctrl/agg_rbox_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_slider_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_spline_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_scale_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_polygon_ctrl.cpp"
    "${AGG_DIR}/src/ctrl/agg_bezier_ctrl.cpp"
    "${AGG_DIR}/gpc/gpc.c"
)
if(WIN32)
    list(APPEND AGG_SOURCES
        "${AGG_DIR}/src/platform/win32/agg_platform_support.cpp"
        "${AGG_DIR}/src/platform/win32/agg_win32_bmp.cpp"
    )
elseif(UNIX AND NOT APPLE)
    list(APPEND AGG_SOURCES "${AGG_DIR}/src/platform/X11/agg_platform_support.cpp")
endif()

add_library(agg STATIC ${AGG_SOURCES})
add_library(lite-xl::agg ALIAS agg)

find_package(PkgConfig)

if(UNIX AND NOT APPLE)
    find_package(X11)
    target_link_libraries(agg PRIVATE X11)
endif()

find_library(MATH_LIB NAMES m)
target_link_libraries(agg PRIVATE m)

target_include_directories(agg PRIVATE "${AGG_DIR}/include")
