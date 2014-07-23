<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:alto="http://www.loc.gov/standards/alto/ns-v2#" 
    version="2.0">
  
  <xsl:strip-space elements="*"/>
  <xsl:output indent="no" method="text" omit-xml-declaration="yes" />

  
  <xsl:template match="alto:alto">
    <xsl:apply-templates select="alto:Layout/alto:Page/alto:PrintSpace" />
  </xsl:template>

  <xsl:template match="alto:TextLine">
    <xsl:apply-templates />
    <xsl:text>&#xA;</xsl:text>	<!-- Put carriage return at end of line. -->
  </xsl:template>
  
  <xsl:template match="alto:String">
    <xsl:value-of select="@CONTENT"/>
    <xsl:text/>
  </xsl:template>
  
  <xsl:template match="alto:SP">
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="alto:HYP">
    <xsl:text>-</xsl:text>
  </xsl:template>

</xsl:stylesheet>



