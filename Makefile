.PHONY: test fonts images atlases spine_images music

HAXE_ARGS=

test:
	haxe test.hxml $(HAXE_ARGS) && hl test.hl

fonts: assets/fonts/8bit.fnt

assets/fonts/8bit.fnt: assets/fonts/8bit.ttf
	python -m bmfg $< --size 6 --padding 1 --border 1 --border-color 808080ff -o assets/fonts/8bit

images: \
	$(patsubst %.svg, %.png, $(shell find assets/graphics -name '*.svg')) \
	$(patsubst %.svg, %.png, $(shell find assets/pack -name '*.svg')) \

atlases: assets/graphics/pack.atlas

assets/graphics/pack.atlas assets/graphics/pack.png: $(shell find assets/pack/ -name '*.png') $(shell find assets/pack/ -name 'pack.json')
	rm -f assets/graphics/pack.png assets/graphics/pack.atlas
	haxelib run hxpk assets/pack/ assets/graphics pack

%.png: %.svg
	inkscape --without-gui --export-png=$@ --export-dpi=96 $<
	convert $@ -channel A -threshold 1 $@

assets/graphics/terrain.png: assets/graphics/terrain.svg
	inkscape --without-gui --export-png=$@ --export-dpi=96 $<
	python -m tile_padder $@ --padding 4 --tile_size 128 --alpha 255 --square

assets/graphics/overworld.png: assets/graphics/overworld.svg
	inkscape --without-gui --export-png=$@ --export-dpi=96 $<
	#python -m tile_padder $@ --padding 2 --tile_size 64 --alpha 0 --square

spine_images: assets/spine/fighter.svg
	python -m inkscape_split assets/spine/fighter.svg && for i in `ls assets/spine/*.png`; do convert $$i -channel A -threshold 254 $$i; done

music: $(patsubst assets/music/%.xm, assets/music/%.ogg, $(wildcard assets/music/*.xm))

%.wav: %.xm
	xmp $< -a 3 -D gain=255 -o $@
%.ogg: %.wav
	rm -f $@
	ffmpeg -i $< -acodec libvorbis $@
