# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindSDL_net
-----------

Locate SDL_net library

This module defines:

::

  SDL_NET_LIBRARIES, the name of the library to link against
  SDL_NET_INCLUDE_DIRS, where to find the headers
  SDL_NET_FOUND, if false, do not try to link against
  SDL_NET_VERSION_STRING - human-readable string containing the version of SDL_net



For backward compatibility the following variables are also set:

::

  SDLNET_LIBRARY (same value as SDL_NET_LIBRARIES)
  SDLNET_INCLUDE_DIR (same value as SDL_NET_INCLUDE_DIRS)
  SDLNET_FOUND (same value as SDL_NET_FOUND)



$SDLDIR is an environment variable that would correspond to the
./configure --prefix=$SDLDIR used in building SDL.
#]=======================================================================]

cmake_policy(PUSH)
cmake_policy(SET CMP0159 NEW) # file(STRINGS) with REGEX updates CMAKE_MATCH_<n>

if(NOT SDL_NET_INCLUDE_DIR AND SDLNET_INCLUDE_DIR)
  set(SDL_NET_INCLUDE_DIR ${SDLNET_INCLUDE_DIR} CACHE PATH "directory cache
entry initialized from old variable name")
endif()
find_path(SDL_NET_INCLUDE_DIR SDL_net.h
  HINTS
    ENV SDLNETDIR
    ENV SDLDIR
  PATH_SUFFIXES SDL
                # path suffixes to search inside ENV{SDLDIR}
                include/SDL include/SDL12 include/SDL11 include
)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(VC_LIB_PATH_SUFFIX lib/x64)
else()
  set(VC_LIB_PATH_SUFFIX lib/x86)
endif()

if(NOT SDL_NET_LIBRARY AND SDLNET_LIBRARY)
  set(SDL_NET_LIBRARY ${SDLNET_LIBRARY} CACHE FILEPATH "file cache entry
initialized from old variable name")
endif()
find_library(SDL_NET_LIBRARY
  NAMES SDL_net
  HINTS
    ENV SDLNETDIR
    ENV SDLDIR
  PATH_SUFFIXES lib ${VC_LIB_PATH_SUFFIX}
)

if(SDL_NET_INCLUDE_DIR AND EXISTS "${SDL_NET_INCLUDE_DIR}/SDL_net.h")
  file(STRINGS "${SDL_NET_INCLUDE_DIR}/SDL_net.h" SDL_NET_VERSION_MAJOR_LINE REGEX "^#define[ \t]+SDL_NET_MAJOR_VERSION[ \t]+[0-9]+$")
  file(STRINGS "${SDL_NET_INCLUDE_DIR}/SDL_net.h" SDL_NET_VERSION_MINOR_LINE REGEX "^#define[ \t]+SDL_NET_MINOR_VERSION[ \t]+[0-9]+$")
  file(STRINGS "${SDL_NET_INCLUDE_DIR}/SDL_net.h" SDL_NET_VERSION_PATCH_LINE REGEX "^#define[ \t]+SDL_NET_PATCHLEVEL[ \t]+[0-9]+$")
  string(REGEX REPLACE "^#define[ \t]+SDL_NET_MAJOR_VERSION[ \t]+([0-9]+)$" "\\1" SDL_NET_VERSION_MAJOR "${SDL_NET_VERSION_MAJOR_LINE}")
  string(REGEX REPLACE "^#define[ \t]+SDL_NET_MINOR_VERSION[ \t]+([0-9]+)$" "\\1" SDL_NET_VERSION_MINOR "${SDL_NET_VERSION_MINOR_LINE}")
  string(REGEX REPLACE "^#define[ \t]+SDL_NET_PATCHLEVEL[ \t]+([0-9]+)$" "\\1" SDL_NET_VERSION_PATCH "${SDL_NET_VERSION_PATCH_LINE}")
  set(SDL_NET_VERSION_STRING ${SDL_NET_VERSION_MAJOR}.${SDL_NET_VERSION_MINOR}.${SDL_NET_VERSION_PATCH})
  unset(SDL_NET_VERSION_MAJOR_LINE)
  unset(SDL_NET_VERSION_MINOR_LINE)
  unset(SDL_NET_VERSION_PATCH_LINE)
  unset(SDL_NET_VERSION_MAJOR)
  unset(SDL_NET_VERSION_MINOR)
  unset(SDL_NET_VERSION_PATCH)
endif()

set(SDL_NET_LIBRARIES ${SDL_NET_LIBRARY})
set(SDL_NET_INCLUDE_DIRS ${SDL_NET_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(SDL_net
                                  REQUIRED_VARS SDL_NET_LIBRARIES SDL_NET_INCLUDE_DIRS
                                  VERSION_VAR SDL_NET_VERSION_STRING)

# for backward compatibility
set(SDLNET_LIBRARY ${SDL_NET_LIBRARIES})
set(SDLNET_INCLUDE_DIR ${SDL_NET_INCLUDE_DIRS})
set(SDLNET_FOUND ${SDL_NET_FOUND})

mark_as_advanced(SDL_NET_LIBRARY SDL_NET_INCLUDE_DIR)

cmake_policy(POP)
