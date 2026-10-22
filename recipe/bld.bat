@echo on

:: Use glfw from conda-forge
rmdir /S /Q external\glfw\
:: IMGUI_TEST_ENGINE has a strange license, just don't build with it.
rmdir /S /Q external\imgui_test_engine

set CMAKE_BUILD_PARALLEL_LEVEL=1

:: Fail the build instead of downloading a missing dependency
:: https://github.com/conda-forge/imgui-bundle-feedstock/pull/52#issuecomment-6342188164
set CMAKE_ARGS_SKBUILD=-DHELLOIMGUI_WITH_TEST_ENGINE=OFF
set CMAKE_ARGS_SKBUILD=%CMAKE_ARGS_SKBUILD%;-DHELLOIMGUI_DOWNLOAD_FREETYPE_IF_NEEDED=OFF
set CMAKE_ARGS_SKBUILD=%CMAKE_ARGS_SKBUILD%;-DHELLOIMGUI_DOWNLOAD_GLFW_IF_NEEDED=OFF
set CMAKE_ARGS_SKBUILD=%CMAKE_ARGS_SKBUILD%;-DFETCHCONTENT_FULLY_DISCONNECTED=ON

%PYTHON% -m pip install . -vvv --config-setting=cmake.args="%CMAKE_ARGS_SKBUILD%"
if errorlevel 1 exit 1
