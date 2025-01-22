# See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment

TARGETS := base.stl base.png

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

all: ${TARGETS}

clean:
	rm -rf ${TARGETS} $(wildcard *.deps)

%.stl: %.scad Makefile
	openscad -m make -o $@ -d $@.deps $<

%.png: %.scad Makefile
	openscad -o $@ $< --render \
		--autocenter --viewall \
		--imgsize=1600,1200 \
		--colorscheme=BeforeDawn
