<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns:marc="http://www.loc.gov/MARC21/slim"
		xmlns:mets="http://www.loc.gov/METS/"
		exclude-result-prefixes="mods xlink"
		>

  <xsl:include href="MODS3-4_MARC21slim_XSLT2-0.xsl" />
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select="mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE='MODS']/mets:xmlData/mods:mods" />
  </xsl:template>
  
</xsl:stylesheet>
