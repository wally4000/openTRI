TARGET_LIB = libtri.a
OBJS = streams/streams.o triArchive.o triTexman.o triCamera.o triVAlloc.o triMemory.o triRefcount.o triImage.o rle.o triGraphics.o tri3d.o triLog.o triModel.o triInput.o triVMath_vfpu.o triTimer.o triWav.o triAt3.o triAudioLib.o triError.o triConsole.o triFont.o triHeap.o triNet.o triParticle.o

INCDIR = 
CFLAGS = -O3 -Wall -D__PSP__
CXXFLAGS = $(CFLAGS) -fno-exceptions -fno-rtti
ASFLAGS = $(CFLAGS)

LIBDIR =
LDFLAGS = -lpspgum -lpspgu -lpsprtc -lm -lz

ifeq ($(DEBUG),1)
	CFLAGS += -g -DDEBUG -D_DEBUG -D_DEBUG_LOG -D_DEBUG_MEMORY
endif

ifeq ($(PNG),1)
	CFLAGS += -DTRI_SUPPORT_PNG
	LDFLAGS += -lpng
endif

ifeq ($(FT),1)
	CFLAGS += -DTRI_SUPPORT_FT $(shell psp-pkgconf --cflags freetype2)
	LDFLAGS += -lfreetype $(shell psp-pkgconf --libs freetype2)
endif

PSPSDK=$(shell psp-config --pspsdk-path)
PSPDIR = $(shell psp-config --psp-prefix)
include $(PSPSDK)/lib/build.mak

release: clean install

install: $(TARGET_LIB)
	@echo Installing libtri to "$(PSPDIR)/lib"
	@$(CP) libtri.a $(PSPDIR)/lib
	@echo Installing headers to "$(PSPDIR)/include/openTri"
	@$(MKDIR) -p $(PSPDIR)/include/openTri
	@$(CP) *.h $(PSPDIR)/include/openTri
	@echo Installing headers to "$(PSPDIR)/include/streams"
	@$(MKDIR) -p $(PSPDIR)/include/streams
	@$(CP) streams/*.h $(PSPDIR)/include/streams
	@$(CP) streams/*.inc $(PSPDIR)/include/streams
	@echo Installing documentation to "$(PSPDIR)/share/doc/openTri"
	@$(MKDIR) -p $(PSPDIR)/share/doc/openTri
	@$(DOXYGEN) doxygen.ini
	@$(CP) -r doc/* $(PSPDIR)/share/doc/openTri
	@echo Done.
