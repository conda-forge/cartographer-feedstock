mkdir build
cd build

set CL=/DNOMINMAX=1 %CL%

cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
    -DBUILD_SHARED_LIBS=ON ^
    -DBoost_NO_BOOST_CMAKE=ON ^
    "-DTARGET_COMPILE_FLAGS=/D_USE_MATH_DEFINES /D_ENABLE_EXTENDED_ALIGNED_STORAGE /DPROTOBUF_USE_DLLS /DBOOST_ALL_NO_LIB /DBOOST_ALL_DYN_LINK /DABSL_LEGACY_THREAD_ANNOTATIONS" ^
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
