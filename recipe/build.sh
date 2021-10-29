#!/bin/sh

mkdir build
cd build

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DProtobuf_PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc"
fi

cmake ${CMAKE_ARGS} .. \
      -G "Ninja" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=ON \
      -DBUILD_SHARED_LIBS=ON

cmake --build . --config Release
cmake --build . --config Release --target install

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  export CTEST_OUTPUT_ON_FAILURE=1
  cmake --build . --config Release --target test
fi
