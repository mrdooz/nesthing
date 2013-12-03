cmake_minimum_required (VERSION 2.6)

project (nesthing)

set(CMAKE_CXX_FLAGS "-std=c++11 -stdlib=libc++")

find_library(CORE_SERVICES CoreServices)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake_modules" ${CMAKE_MODULE_PATH})
find_package(SFML 2 REQUIRED system window graphics network audio)

include_directories(/opt/local/include/boost)

add_executable(nesthing src/cpu.cpp src/main.cpp src/mmc1.cpp src/nes.cpp src/nes_helpers.cpp src/ppu.cpp)
target_link_libraries(nesthing ${CORE_SERVICES} ${SFML_LIBRARIES})