#!/bin/sh

mkdir build
cd build

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DProtobuf_PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc"
fi

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig

# See https://github.com/abseil/abseil-cpp/releases/tag/20230125.0
# We need to wait for upstream to use the new flags
export CXXFLAGS="$CXXFLAGS -DABSL_LEGACY_THREAD_ANNOTATIONS=1"

cmake ${CMAKE_ARGS} .. \
      -G "Ninja" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_STANDARD=17 \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DBUILD_SHARED_LIBS=ON

cmake --build . --config Release
cmake --build . --config Release --target install

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  export CTEST_OUTPUT_ON_FAILURE=1
  cmake --build . --config Release --target test
fi
