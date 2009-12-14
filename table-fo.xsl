<?xml version="1.0" encoding="us-ascii"?>

<!-- $Id: table-fo.xsl,v 1.8 2008/05/24 03:56:10 mayhewn Exp $ -->

<!-- Format labels as an FO table -->

<!-- Neil Mayhew - 25 Apr 2006 -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml" encoding="us-ascii" indent="yes"/>

<!-- Label dimension parameters -->
<xsl:param name="label-width"   select="'4.00in'"/>
<xsl:param name="label-height"  select="'1.33in'"/>
<xsl:param name="gutter"        select="'0.20in'"/>
<xsl:param name="margin-top"    select="'0.35in'"/>
<xsl:param name="margin-bottom" select="'0.81in'"/>
<xsl:param name="margin-left"   select="'0.15in'"/>
<xsl:param name="margin-right"  select="'0.15in'"/>
<xsl:param name="font-size"     select="'12.5pt'"/>

<!-- Title -->
<xsl:param name="title" select="''"/>

<!-- Styling information -->
<xsl:attribute-set name="title-style">
 	<xsl:attribute name="font-family">Verdana,sans-serif</xsl:attribute>
 	<xsl:attribute name="font-size">10pt</xsl:attribute>
	<xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="table-style">
	<xsl:attribute name="font-family">sans-serif</xsl:attribute>
	<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
	<xsl:attribute name="border-collapse">collapse</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="table-cell-style">
	<xsl:attribute name="padding-top">2pt</xsl:attribute>
	<xsl:attribute name="padding-left">8pt</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="/">

	<!-- Output document -->
	<fo:root>

		<fo:layout-master-set>
			<fo:simple-page-master
					master-name="main"
					page-width="8.5in" page-height="11in"
					margin-top ="{$margin-top}"  margin-bottom="{$margin-bottom}"
					margin-left="{$margin-left}" margin-right ="{$margin-right}">
				<fo:region-body margin-top="0.5in" margin-bottom="0in"/>
				<fo:region-before extent="0.25in"/>
			</fo:simple-page-master>
		</fo:layout-master-set>

		<fo:page-sequence master-reference="main">
	
			<fo:static-content flow-name="xsl-region-before">
				<fo:block xsl:use-attribute-sets="title-style" text-align-last="justify">
					<xsl:value-of select="$title"/>
					<fo:leader/>
					<xsl:text>Page </xsl:text>
					<fo:page-number/>
				</fo:block>
			</fo:static-content>

			<fo:flow flow-name="xsl-region-body">

				<fo:table table-layout="fixed" width="100%"
						xsl:use-attribute-sets="table-style">

					<fo:table-column column-width="{$label-width}"/>
					<fo:table-column column-width="{$gutter}"/>
					<fo:table-column column-width="{$label-width}"/>

					<fo:table-body>
						<xsl:for-each select="*/label[position() mod 2 = 1]">
							<fo:table-row>
								<xsl:apply-templates select="."/>
								<fo:table-cell>
									<fo:block/>
								</fo:table-cell>
								<xsl:apply-templates select="following-sibling::label[1]"/>
							</fo:table-row>
						</xsl:for-each>
					</fo:table-body>

				</fo:table>

			</fo:flow>

		</fo:page-sequence>

	</fo:root>

</xsl:template>

<xsl:template match="label">
	<!-- I think the "- 2pt" (to compensate for padding) is needed only because of a bug in fop -->
	<fo:table-cell xsl:use-attribute-sets="table-cell-style" height="{$label-height} - 2pt">
		<xsl:for-each select="line">
			<fo:block text-align="left"><xsl:value-of select="."/></fo:block>
		</xsl:for-each>
	</fo:table-cell>
</xsl:template>

</xsl:stylesheet>
