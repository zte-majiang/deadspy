CXX = g++
CFLAGS = -c -Wno-deprecated -Wall -Werror -Wno-unknown-pragmas -D__PIN__=1 -DPIN_CRT=1 -fno-stack-protector -funwind-tables -fasynchronous-unwind-tables -fno-rtti -DTARGET_IA32E -DHOST_IA32E -fPIC -DTARGET_LINUX -fabi-version=2   -O2 -fomit-frame-pointer -fno-strict-aliasing   -fexceptions -fno-rtti -save-temps -Wno-error

INCLUDES = -I$(SPARSEHASH_PATH)/src -I$(PIN_PATH)/source/include/pin -I$(PIN_PATH)/source/include/pin/gen -isystem $(PIN_PATH)/extras/stlport/include -isystem $(PIN_PATH)/extras/libstdc++/include -isystem $(PIN_PATH)/extras/crt/include -isystem $(PIN_PATH)/extras/crt/include/arch-x86_64 -isystem $(PIN_PATH)/extras/crt/include/kernel/uapi -isystem $(PIN_PATH)/extras/crt/include/kernel/uapi/asm-x86 -I$(PIN_PATH)/extras/components/include -I$(PIN_PATH)/extras/xed-intel64/include/xed -I$(PIN_PATH)/source/tools/InstLib
#LIBRARIES = -L$(PIN_PATH)/extras/xed2-intel64/lib -L$(PIN_PATH)/intel64/lib -L$(PIN_PATH)/intel64/lib-ext -lpin -lxed -ldwarf -lelf -ldl
LIBRARIES =  -L$(PIN_PATH)/extras/xed-intel64/lib -L$(PIN_PATH)/intel64/lib -L$(PIN_PATH)/intel64/lib-ext  -L$(PIN_PATH)/intel64/runtime/pincrt -lpin -lxed $(PIN_PATH)/intel64/runtime/pincrt/crtendS.o  -lelf -lpin3dwarf  -ldl-dynamic -nostdlib -lstlport-dynamic -lm-dynamic -lc-dynamic -lunwind-dynamic
LINKFLAGS = -fabi-version=2  -Wl,--hash-style=sysv -shared -Wl,-Bsymbolic -Wl,--version-script=$(PIN_PATH)/source/include/pin/pintool.ver $(PIN_PATH)/intel64/runtime/pincrt/crtbeginS.o  -fno-rtti


ifeq ($(IP_AND_CCT), 1)
 CFLAGS := -DIP_AND_CCT $(CFLAGS)
endif

ifeq ($(MULTI_THREADED), 1)
 CFLAGS := -DMULTI_THREADED $(CFLAGS)
endif

ifdef MAX_DEAD_CONTEXTS_TO_LOG
 CFLAGS := -DMAX_DEAD_CONTEXTS_TO_LOG=$(MAX_DEAD_CONTEXTS_TO_LOG) $(CFLAGS)
endif

ifeq ($(MERGE_SAME_LINES), 1)
 CFLAGS := -DMERGE_SAME_LINES $(CFLAGS)
endif


all: deadspy.so

deadspy.so: deadspy.cpp
ifndef  SPARSEHASH_PATH
	$(error echo "SPARSEHASH_PATH NOT SET!!")
endif
ifndef  PIN_PATH
	$(error echo "PIN_PATH NOT SET!!")
endif
	$(CXX)  $(CFLAGS) $(INCLUDES) -o deadspy.o deadspy.cpp
	$(CXX)  -c -o dummy_def.o dummy_def.c
	$(CXX)  $(LINKFLAGS) -o deadspy.so dummy_def.o deadspy.o  $(LIBRARIES)

clean:
	rm -f deadspy.o deadspy.so

