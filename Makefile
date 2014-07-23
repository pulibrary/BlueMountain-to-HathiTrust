txts := $(patsubst %.alto.xml, %.txt, $(wildcard alto/*.alto.xml))
jp2s := $(patsubst %.tif, %.jp2, $(wildcard *.tif))


txtfiles : $(txts)

%.txt : %.alto.xml
	saxon -s:$< -xsl:xsl/alto2txt.xsl -o:$@

%.xmp : %.tif
	exiftool -xmp -b $< > $@


.PHONY: clean
clean:
	rm checksum.md5

checksum:
	md5deep -l alto/*.* > checksum.md5
