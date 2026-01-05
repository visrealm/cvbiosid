cmake_minimum_required(VERSION 3.13)

# CVBIOSID CMake Build
# Ported from the legacy batch build to match RetroPIPE's CMake workflow

project(cvbiosid)

# Include shared CVBasic build helpers
include(${CMAKE_SOURCE_DIR}/visrealm_cvbasic.cmake)

set(PYTHON python3)

# Version information (matches build.bat)
set(VERSION "v0-0-1")
string(REPLACE "-" "." FRIENDLYVER "${VERSION}")

# Setup CVBasic toolchain (auto-build or find existing tools)
setup_cvbasic_tools()

# Set up directories
set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/src")
set(ASM_DIR "${CMAKE_BINARY_DIR}/asm")
set(ROMS_DIR "${CMAKE_BINARY_DIR}/roms")
file(MAKE_DIRECTORY "${ASM_DIR}")
file(MAKE_DIRECTORY "${ROMS_DIR}")

# Collect all CVBasic source files for dependency tracking
file(GLOB CVBASIC_SOURCE_FILES
    "${SOURCE_DIR}/*.bas"
    "${SOURCE_DIR}/lib/*.asm"
)

# Collect pletter source files
file(GLOB PLETTER_SOURCE_FILES
    "${SOURCE_DIR}/pletter/*.bas"
)

# Custom function to compress pletter source files
function(compress_pletter_file PLETTER_BAS)
    get_filename_component(BASENAME ${PLETTER_BAS} NAME_WE)
    set(OUTPUT_FILE "${SOURCE_DIR}/${BASENAME}.pletter.bas")

    # Set PLETTER_EXE environment variable for cvpletter.py
    if(WIN32)
        set(PLETTER_EXE_PATH "${PLETTER_EXE}.exe")
    else()
        set(PLETTER_EXE_PATH "${PLETTER_EXE}")
    endif()

    add_custom_command(
        OUTPUT "${OUTPUT_FILE}"
        COMMAND ${CMAKE_COMMAND} -E env "PLETTER_EXE=${PLETTER_EXE_PATH}"
                ${PYTHON} "${CMAKE_SOURCE_DIR}/tools/cvpletter.py" "${PLETTER_BAS}"
        DEPENDS "${PLETTER_BAS}" "${CMAKE_SOURCE_DIR}/tools/cvpletter.py" ${TOOL_DEPENDENCIES}
        WORKING_DIRECTORY "${SOURCE_DIR}"
        COMMENT "Compressing pletter source: ${BASENAME}.bas"
        VERBATIM
    )
endfunction()

# Compress all pletter files
set(PLETTER_OUTPUTS)
foreach(PLETTER_FILE ${PLETTER_SOURCE_FILES})
    get_filename_component(BASENAME ${PLETTER_FILE} NAME_WE)
    list(APPEND PLETTER_OUTPUTS "${SOURCE_DIR}/${BASENAME}.pletter.bas")
    compress_pletter_file(${PLETTER_FILE})
endforeach()

# Custom target for all pletter compression
add_custom_target(pletter_compression DEPENDS ${PLETTER_OUTPUTS})

# Setup CVBasic project configuration
cvbasic_setup_project(
    SOURCE_FILE "cvbiosid.bas"
    SOURCE_DIR "${SOURCE_DIR}"
    ASM_DIR "${ASM_DIR}"
    ROMS_DIR "${ROMS_DIR}"
    CART_TITLE "CVBIOSID"
    VERSION "${VERSION}"
    PLETTER_TARGET pletter_compression
    DEPENDENCIES ${CVBASIC_SOURCE_FILES} ${PLETTER_OUTPUTS}
    TOOL_DEPS ${TOOL_DEPENDENCIES}
)

# Define ColecoVision target (primary build)
cvbasic_add_target(coleco cv "")

# Convenience target matching RetroPIPE layout
add_custom_target(all_platforms DEPENDS coleco)

# Print build information
message(STATUS "CVBIOSID CMake Configuration")
message(STATUS "Version: ${FRIENDLYVER}")
message(STATUS "CVBasic: ${CVBASIC_EXE}")
message(STATUS "GASM80: ${GASM80_EXE}")
message(STATUS "Pletter: ${PLETTER_EXE}")
message(STATUS "linkticart.py: ${LINKTICART_SCRIPT}")
if(XAS99_SCRIPT)
    message(STATUS "XAS99: ${XAS99_SCRIPT}")
else()
    message(STATUS "XAS99: NOT FOUND (TI-99 builds will be limited)")
endif()
