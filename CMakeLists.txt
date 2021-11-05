cmake_minimum_required(VERSION 3.12)

set(
    CMAKE_TOOLCHAIN_FILE
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpp17-toolchain.cmake"
    CACHE
    FILEPATH
    "Default toolchain"
)

set(
    HUNTER_CACHE_SERVERS
    "https://github.com/soramitsu/hunter-binary-cache"
    CACHE
    STRING
    "Binary cache server"
)

include("cmake/HunterGate.cmake")
# todo: automatically update along with the kagome settings
HunterGate(
    URL  "https://github.com/soramitsu/soramitsu-hunter/archive/tags/v0.23.257-soramitsu17.tar.gz"
    SHA1 "c7ccd337314b27485b75d0f0f5d5b42e7e3c2629"
    LOCAL
)

project(KagomeFromExternalProject)

hunter_add_package(kagome)
find_package(kagome REQUIRED CONFIG)

add_executable(main src/main.cpp)
target_link_libraries(main
    kagome::executor
    )
