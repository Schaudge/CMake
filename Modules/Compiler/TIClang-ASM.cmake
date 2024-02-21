include(Compiler/TIClang)

set(CMAKE_ASM_OUTPUT_EXTENSION ".o")
set(CMAKE_ASM_OUTPUT_EXTENSION_REPLACE 1)

set(CMAKE_ASM_COMPILE_OBJECT       "<CMAKE_ASM_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -c -o <OBJECT> <SOURCE>")
set(CMAKE_ASM_SOURCE_FILE_EXTENSIONS S;s;asm;msa)

__compiler_ticlang(ASM)