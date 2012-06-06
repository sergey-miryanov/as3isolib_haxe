TARGET=flash

all: s01 s02 s03 s04 s05 s06 s07 s99

clean: s01-clean s02-clean s03-clean s04-clean s05-clean s06-clean s07-clean s99-clean

s01:
	make -C samples/01-Box/ -f ../../MakefileSample ${TARGET}

s02:
	make -C samples/02-Depth/ -f ../../MakefileSample ${TARGET}

s03:
	make -C samples/03-Styling/ -f ../../MakefileSample ${TARGET}

s04:
	make -C samples/04-Sprites/ -f ../../MakefileSample ${TARGET}

s05:
	make -C samples/05-View/ -f ../../MakefileSample ${TARGET}

s06:
	make -C samples/06-SceneRenderers/ -f ../../MakefileSample ${TARGET}

s07:
	make -C samples/07-Animation/ -f ../../MakefileSample ${TARGET}

s99:
	make -C samples/99-RenderTest/ -f ../../MakefileSample ${TARGET}

s01-clean:
	rm -rf samples/01-Box/bin/${TARGET}

s02-clean:
	rm -rf samples/02-Depth/bin/${TARGET}

s03-clean:
	rm -rf samples/03-Styling/bin/${TARGET}

s04-clean:
	rm -rf samples/04-Sprites/bin/${TARGET}

s05-clean:
	rm -rf samples/05-View/bin/${TARGET}

s06-clean:
	rm -rf samples/06-SceneRenderers/bin/${TARGET}

s07-clean:
	rm -rf samples/07-Animation/bin/${TARGET}

s99-clean:
	rm -rf samples/99-RenderTest/bin/${TARGET}

