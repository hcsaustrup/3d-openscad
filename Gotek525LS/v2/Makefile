# See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment

TARGETS := base.stl base.png tray.stl tray.png test.stl
PHONY := edit
PRECIOUS := stl

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

all: ${TARGETS}

clean:
	rm -rf ${TARGETS} $(wildcard *.deps) *.gcode *.stl

%.stl: %.scad Makefile
	openscad -m make -o $@ -d $@.deps $<

%.gcode: %.stl Makefile
	flatpak run --command=prusa-slicer com.prusa3d.PrusaSlicer --export-gcode --save $@ $<

%.png: %.scad Makefile
	openscad -o $@ $< --render \
		--autocenter --viewall \
		--imgsize=1600,1200 \
		--colorscheme=BeforeDawn

edit:
	code .
	openscad tray.scad &


