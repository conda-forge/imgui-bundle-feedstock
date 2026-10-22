#!/bin/bash
set -ex

# Use glfw from conda-forge
rm -rf external/glfw/
# IMGUI_TEST_ENGINE has a strange license, just don't build with it.
rm -rf external/imgui_test_engine

export CMAKE_BUILD_PARALLEL_LEVEL=${CPU_COUNT}

if [[ "${target_platform}" == linux-* ]]; then
    # Not sure why I need to specify -lGL so hard here....
    # It seems related to nanobind
    # ${external_dir}/imgui/bindings/pybind_imgui_backends.cpp
    export CFLAGS="${CFLAGS} -lGL"
fi

# Fail the build instead of downloading a missing dependency
# https://github.com/conda-forge/imgui-bundle-feedstock/pull/52#issuecomment-6342188164
cmake_args=(
    -DHELLOIMGUI_WITH_TEST_ENGINE=OFF
    -DHELLOIMGUI_DOWNLOAD_FREETYPE_IF_NEEDED=OFF
    -DHELLOIMGUI_DOWNLOAD_GLFW_IF_NEEDED=OFF
    -DFETCHCONTENT_FULLY_DISCONNECTED=ON
)
# scikit-build-core takes a ;-separated list
cmake_args_joined=$(IFS=';'; echo "${cmake_args[*]}")

${PYTHON} -m pip install . -vvv --config-setting=cmake.args="${cmake_args_joined}"
