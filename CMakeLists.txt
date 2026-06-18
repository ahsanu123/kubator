cmake_minimum_required(VERSION 3.20)

set(PICO_BOARD pico2 CACHE STRING "Target board")
# only for pico2
set(PICO_PLATFORM rp2350-arm-s)

# set(PICO_USE_SW_SPIN_LOCK 0 CACHE BOOL "Use hardware spin locks" FORCE)
set(PICO_BOARD_HEADER_DIRS "${CMAKE_SOURCE_DIR}/boards/include" CACHE PATH "Custom board headers")

cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TOOLCHAIN_PATH "${CMAKE_SOURCE_DIR}/xpacks/.bin")
set(TOOLCHAIN_PREFIX "${TOOLCHAIN_PATH}/arm-none-eabi")

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}-gcc)

set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}-objcopy)
set(CMAKE_SIZE ${TOOLCHAIN_PREFIX}-size)
set(PICO_TOOLCHAIN_PATH
    "./cmake/.bin/"
    CACHE PATH "Path to ARM GCC toolchain")

# cpm cache folder
set(CPM_SOURCE_CACHE "${CMAKE_SOURCE_DIR}/.cache/CPM" CACHE PATH "CPM source cache")

include(cmake/CPM.cmake)

CPMAddPackage(
  URI "gh:ETLCPP/etl#20.47.1"
)
CPMAddPackage(
  NAME pico_sdk
  GITHUB_REPOSITORY raspberrypi/pico-sdk
  GIT_TAG 2.1.1
)

set(PICO_SDK_PATH "${pico_sdk_SOURCE_DIR}" CACHE PATH "Path to Pico SDK")

# include("${PICO_SDK_PATH}/external/pico_sdk_import.cmake")
include("${PICO_SDK_PATH}/pico_sdk_init.cmake")

project(kubator C CXX ASM)

pico_sdk_init()

add_definitions(-DETL_DEBUG)
add_executable(main main.cpp)

set_target_properties(main PROPERTIES SUFFIX ".elf")

# work with rp2040
# target_compile_options(main PRIVATE -mthumb -mcpu=cortex-m0plus)
# target_link_options(main PRIVATE -mthumb -mcpu=cortex-m0plus)

# work with rp2350
target_compile_options(main PRIVATE -mthumb -mcpu=cortex-m33)
target_link_options(main PRIVATE -mthumb -mcpu=cortex-m33)

target_link_libraries(main PRIVATE
                      pico_stdlib
                      etl::etl)

pico_add_extra_outputs(main)


# For PoC, use Pico 2 config first:
#
# ```cmake
# set(PICO_BOARD pico2 CACHE STRING "Target board")
# ```
#
# Put it before Pico SDK import/init.
#
# For real custom hardware, create a custom board header, e.g.:
#
# ```text
# boards/include/boards/kubator_rp2350.h
# ```
#
# Minimal example:
#
# ```c
# #pragma once
#
# #define PICO_BOARD "kubator_rp2350"
# #define PICO_PLATFORM "rp2350"
#
# #define PICO_DEFAULT_LED_PIN 25
#
# #define PICO_DEFAULT_UART 0
# #define PICO_DEFAULT_UART_TX_PIN 0
# #define PICO_DEFAULT_UART_RX_PIN 1
#
# #define PICO_DEFAULT_I2C 0
# #define PICO_DEFAULT_I2C_SDA_PIN 4
# #define PICO_DEFAULT_I2C_SCL_PIN 5
#
# #define PICO_DEFAULT_SPI 0
# #define PICO_DEFAULT_SPI_TX_PIN 19
# #define PICO_DEFAULT_SPI_RX_PIN 16
# #define PICO_DEFAULT_SPI_SCK_PIN 18
# #define PICO_DEFAULT_SPI_CSN_PIN 17
# ```
#
# Then in `CMakeLists.txt`, before Pico SDK init:
#
# ```cmake
# set(PICO_BOARD kubator_rp2350 CACHE STRING "Target board")
# set(PICO_BOARD_HEADER_DIRS "${CMAKE_SOURCE_DIR}/boards/include" CACHE PATH "Custom board headers")
# ```
#
# Basic structure:
#
# ```cmake
