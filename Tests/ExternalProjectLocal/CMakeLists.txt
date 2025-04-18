cmake_minimum_required(VERSION 3.10)
project(ExternalProjectLocalTest NONE)
if(CMAKE_XCODE_BUILD_SYSTEM VERSION_GREATER_EQUAL 12)
  cmake_policy(SET CMP0114 NEW)
endif()

include(ExternalProject)

# Test ExternalProject with local projects

option(ExternalProjectTest_USE_FOLDERS "Enable folder grouping in IDEs." ON)
if(ExternalProjectTest_USE_FOLDERS)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
else()
  set_property(GLOBAL PROPERTY USE_FOLDERS OFF)
endif()

set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER
  "CMakePredefinedTargets-in-ExternalProjectTest")

set(base "${CMAKE_BINARY_DIR}/Ext")
set(binary_base "${base}/Build")
set_property(DIRECTORY PROPERTY EP_BASE ${base})
set_property(DIRECTORY PROPERTY EP_STEP_TARGETS configure build test)


# Local DIR:
#
set(proj TutorialStep5-Local)
ExternalProject_Add(${proj}
URL "${CMAKE_CURRENT_SOURCE_DIR}/Step5"
CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
CMAKE_ARGS -G ${CMAKE_GENERATOR} <SOURCE_DIR>
TEST_BEFORE_INSTALL 1
LOG_INSTALL 1
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local")
ExternalProject_Get_Property(${proj} install_dir)
set(TutorialStep5_install_dir ${install_dir})

set(proj TutorialStep5-Local-TestAfterInstall)
ExternalProject_Add(${proj}
URL "${CMAKE_CURRENT_SOURCE_DIR}/Step5"
CMAKE_ARGS --install-prefix=<INSTALL_DIR> -G ${CMAKE_GENERATOR} <SOURCE_DIR>
CMAKE_CACHE_DEFAULT_ARGS -DUSE_MYMATH:BOOL=OFF
TEST_AFTER_INSTALL 1
LOG_TEST 1
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local")

set(proj TutorialStep5-Local-TestExcludeFromMainBefore)
ExternalProject_Add(${proj}
URL "${CMAKE_CURRENT_SOURCE_DIR}/Step5"
CMAKE_ARGS --install-prefix=<INSTALL_DIR>  -G ${CMAKE_GENERATOR} <SOURCE_DIR>
CMAKE_CACHE_DEFAULT_ARGS -DUSE_MYMATH:BOOL=OFF
TEST_BEFORE_INSTALL 1
TEST_EXCLUDE_FROM_MAIN 1
STEP_TARGETS test
LOG_TEST 1
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local")

set(proj TutorialStep5-Local-TestExcludeFromMainAfter)
ExternalProject_Add(${proj}
URL "${CMAKE_CURRENT_SOURCE_DIR}/Step5"
CMAKE_ARGS --install-prefix=<INSTALL_DIR>  -G ${CMAKE_GENERATOR} <SOURCE_DIR>
CMAKE_CACHE_DEFAULT_ARGS -DUSE_MYMATH:BOOL=OFF
TEST_AFTER_INSTALL 1
TEST_EXCLUDE_FROM_MAIN 1
STEP_TARGETS test
LOG_TEST 1
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local")



# Local TAR:
#
set(proj TutorialStep1-LocalTAR)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1.tar"
  URL_MD5 e3774630066d0df5b9074cb777d72802
  LIST_SEPARATOR ::
  PATCH_COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/Step1Patch.cmake
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
             -DTEST_LIST:STRING=A::B::C
  INSTALL_COMMAND ""
  LOG_CONFIGURE 1
  LOG_PATCH 1
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/TAR")

set(proj TutorialStep1-LocalNoDirTAR)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1NoDir.tar"
  URL_MD5 a7357d2e8a52cc807957634ea135eb31
  LIST_SEPARATOR @@
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -G ${CMAKE_GENERATOR} <SOURCE_DIR>
             -DTEST_LIST:STRING=1@@2@@3
  INSTALL_COMMAND ""
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/TAR")
ExternalProject_Add_Step(${proj} mypatch
  COMMAND ${CMAKE_COMMAND} -E echo "This is a custom external project step."
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/Step1Patch.cmake
  WORKING_DIRECTORY <SOURCE_DIR>
  DEPENDEES download
  DEPENDERS configure
  )


# Local TGZ:
#
set(proj TutorialStep1-LocalTGZ)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1.tgz"
  URL_MD5 c04edffa0520d5468d51ecd13a971828
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> -G ${CMAKE_GENERATOR} <SOURCE_DIR>
  INSTALL_COMMAND ""
  LOG_BUILD 1
  UPDATE_DISCONNECTED 1
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/TGZ")

set(proj TutorialStep1-LocalNoDirTGZ)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1NoDir.tgz"
  URL_HASH SHA256=b9aff8a865842b21cb3bc2ec8bed426b46ef560518962a81242c7f2e089c00de
  CMAKE_GENERATOR "${CMAKE_GENERATOR}"
  CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  INSTALL_COMMAND ""
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/TGZ")


# Local BZ2:
#
# (The bz2 tests are here just to verify that the bz2 decompression is executed
#  during a test suite run... The configure and build commands are set to
#  nothing to make the test quicker. To make this more complete, I should add
#  a diff between this and the TGZ source tree since that one does build...)
#
set(proj TutorialStep1-LocalBZ2)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1.tar.bz2"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/BZ2")

set(proj TutorialStep1-LocalNoDirBZ2)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1NoDir.tar.bz2"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/BZ2")


# Local ZIP:
#
# (The zip tests are here just to verify that the zip decompression is executed
#  during a test suite run... The configure and build commands are set to
#  nothing to make the test quicker. To make this more complete, I should add
#  a diff between this and the TGZ source tree since that one does build...)
#
set(proj TutorialStep1-LocalZIP)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1.zip"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/ZIP")

set(proj TutorialStep1-LocalNoDirZIP)
ExternalProject_Add(${proj}
  URL "${CMAKE_CURRENT_SOURCE_DIR}/Step1NoDir.zip"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
)
set_property(TARGET ${proj} PROPERTY FOLDER "Local/ZIP")


# Test the testable built/installed products:
#
enable_testing()


# Do at least a smoke test of a built executable from each
# project's build directory...
#
# BuildTree tests:
#
add_test(TutorialStep5-Local-BuildTreeTest
"${binary_base}/TutorialStep5-Local/Tutorial" 42)
set_property(TEST TutorialStep5-Local-BuildTreeTest
APPEND PROPERTY LABELS Step5 BuildTree)

add_test(TutorialStep1-LocalTAR-BuildTreeTest
  "${binary_base}/TutorialStep1-LocalTAR/EP-Tutorial" 36)
set_property(TEST TutorialStep1-LocalTAR-BuildTreeTest
  APPEND PROPERTY LABELS TAR)

add_test(TutorialStep1-LocalNoDirTAR-BuildTreeTest
  "${binary_base}/TutorialStep1-LocalNoDirTAR/EP-Tutorial" 25)

add_test(TutorialStep1-LocalTGZ-BuildTreeTest
  "${binary_base}/TutorialStep1-LocalTGZ/Tutorial" 16)
set_property(TEST TutorialStep1-LocalTGZ-BuildTreeTest
  APPEND PROPERTY LABELS TGZ)

add_test(TutorialStep1-LocalNoDirTGZ-BuildTreeTest
  "${binary_base}/TutorialStep1-LocalNoDirTGZ/Tutorial" 9)

# InstallTree tests:
#
add_test(TutorialStep5-InstallTreeTest
"${TutorialStep5_install_dir}/bin/Tutorial" 49)
set_property(TEST TutorialStep5-InstallTreeTest
APPEND PROPERTY LABELS Step5 InstallTree)
