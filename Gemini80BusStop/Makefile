# See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment

MAKEFLAGS += -j16

STL_TARGETS := $(patsubst %.scad,%.stl,$(wildcard *.scad))
PNG_TARGETS := $(patsubst %.scad,%.png,$(wildcard *.scad))
TARGETS := ${STL_TARGETS} ${PNG_TARGETS}
PHONY := edit png stl
PRECIOUS := stl

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

all: ${TARGETS}

stl: ${STL_TARGETS}

png: ${PNG_TARGETS}

clean:
	rm -rf ${TARGETS} $(wildcard *.deps) *.gcode

%.stl: %.scad Makefile
	openscad -m make -o $@ --export-format binstl -d $@.deps $<

# %.gcode: %.stl Makefile
# 	flatpak run --command=prusa-slicer com.prusa3d.PrusaSlicer --export-gcode --save $@ $<

%.png: %.scad Makefile
	openscad -o $@ $< --render \
		--autocenter --viewall \
		--imgsize=1600,1200 \
		--colorscheme=BeforeDawn

edit:
	code .
	openscad tray.scad &


