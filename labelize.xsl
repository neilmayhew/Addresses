<?xml version="1.0"?>

<!--
	$Id: labelize.xsl,v 1.9 2007/01/25 05:47:07 mayhewn Exp $
	
	Format address records into labels containing lines
	
	Neil Mayhew - 25 Apr 2006
  -->

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:data="http://homepage.mac.com/neil_mayhew/namespace/data"
	exclude-result-prefixes="data">

	<xsl:output method="xml" encoding="utf-8" indent="yes"/>

	<xsl:strip-space elements="*"/>
	
	<xsl:param name="origin" select="''"/>
	<xsl:param name="list" select="'newsletter'"/>

	<xsl:template match="/*">
		<labels>
			<xsl:apply-templates select="*"/>
		</labels>
	</xsl:template>

	<data:convention country="UK"               >UK</data:convention>
	<data:convention country="USA"              >USA</data:convention>
	<data:convention country="Canada"           >Canada</data:convention>
	<data:convention country="Australia"        >PostState</data:convention>
	<data:convention country="France"           >PreCity</data:convention>
	<data:convention country="Finland"          >PreCity</data:convention>
	<data:convention country="Hellas-Greece"    >PreCity</data:convention>
	<data:convention country="Greece"           >PreCity</data:convention>
	<data:convention country="Lithuania"        >PostCity</data:convention>
	<data:convention country="Malaysia"         >PreCity</data:convention>
	<data:convention country="Pakistan"         >PostCity</data:convention>
	<data:convention country="Peru"             >PostCity</data:convention>
	<data:convention country="Portugal"         >PreCity</data:convention>
	<data:convention country="Spain"            >PreCity</data:convention>
	<data:convention country="South Africa"     >PostCity</data:convention>
	<data:convention country="RSA"              >PostCity</data:convention>
	<data:convention country="Sweden"           >PreCity</data:convention>
	<data:convention country="Switzerland"      >PreCity</data:convention>
	<data:convention country="The Netherlands"  >PreCity</data:convention>
	<!-- The rest should get PostCountry -->

	<xsl:template match="record">
		<label>
			<line>
				<xsl:choose>
					<xsl:when test="title">
						<xsl:value-of select="title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="first"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="title or first">
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="last"/>
			</line>
			<xsl:if test="address[1]">
				<line><xsl:value-of select="address[1]"/></line>
			</xsl:if>
			<xsl:if test="address[2]">
				<line><xsl:value-of select="address[2]"/></line>
			</xsl:if>
			<xsl:if test="address[3]">
				<line><xsl:value-of select="address[3]"/></line>
			</xsl:if>
			<xsl:if test="address[4]">
				<xsl:message>Too many lines for <xsl:value-of select="concat(last, ', ', first)"/>&#10;</xsl:message>
			</xsl:if>

			<xsl:variable name="convention"
				select="document('')/*/data:convention[@country = current()/country]"/>
	
			<xsl:variable name="state-before">
				<xsl:value-of select="state"/><xsl:if test="state"><xsl:text> </xsl:text></xsl:if>
			</xsl:variable>
			<xsl:variable name="state-after">
				<xsl:if test="state"><xsl:text>, </xsl:text></xsl:if><xsl:value-of select="state"/>
			</xsl:variable>
	
			<xsl:choose>
				<xsl:when test="$convention = 'UK'">
					<xsl:call-template name="UK"/>
				</xsl:when>
				<xsl:when test="$convention = 'USA'">
					<line><xsl:value-of select="concat(city, $state-after, ' ', zip)"/></line>
					<line><xsl:value-of select="country"/></line>
				</xsl:when>
				<xsl:when test="$convention = 'Canada'">
					<line><xsl:value-of select="concat(city, ' ', state, '  ', zip)"/></line>
					<line><xsl:value-of select="country"/></line>
				</xsl:when>
				<xsl:when test="$convention = 'PreCity'">
					<line><xsl:value-of select="concat(zip, ' ', city, $state-after)"/></line>
					<line><xsl:value-of select="country"/></line>
				</xsl:when>
				<xsl:when test="$convention = 'PostCity'">
					<line><xsl:value-of select="concat(city, ' ', zip, $state-after)"/></line>
					<line><xsl:value-of select="country"/></line>
				</xsl:when>
				<xsl:when test="$convention = 'PostState'">
					<line><xsl:value-of select="concat(city, $state-after, ' ', zip)"/></line>
					<line><xsl:value-of select="country"/></line>
				</xsl:when>
				<xsl:when test="$convention = 'PreCountry'">
					<line><xsl:value-of select="concat(city, $state-after)"/></line>
					<line><xsl:value-of select="concat(zip, ' ', country)"/></line>
				</xsl:when>
				<xsl:when test="$convention = 'PostCountry' or not($convention)">
					<line><xsl:value-of select="concat(city, $state-after)"/></line>
					<line><xsl:value-of select="concat(country, ' ', zip)"/></line>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message terminate="yes">
						<xsl:text>Unknown country convention: </xsl:text>
						<xsl:value-of select="$convention"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:copy-of select="count"/>
		</label>
	</xsl:template>

	<xsl:template name="UK">
		<xsl:variable name="state-before">
			<xsl:value-of select="state"/><xsl:if test="state"><xsl:text> </xsl:text></xsl:if>
		</xsl:variable>
		<xsl:variable name="state-after">
			<xsl:if test="state"><xsl:text>, </xsl:text></xsl:if><xsl:value-of select="state"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$origin = 'UK'">
				<line><xsl:value-of select="city"/></line>
				<xsl:choose>
					<xsl:when test="count(address) &lt; 3">
						<line><xsl:value-of select="state"/></line>
						<line><xsl:value-of select="zip"/></line>
					</xsl:when>
					<xsl:otherwise>
						<line><xsl:value-of select="concat($state-before, zip)"/></line>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="count(address) &lt; 3">
						<line><xsl:value-of select="city"/></line>
						<line><xsl:value-of select="concat($state-before, zip)"/></line>
					</xsl:when>
					<xsl:otherwise>
						<line><xsl:value-of select="concat(city, $state-after, ' ', zip)"/></line>
					</xsl:otherwise>
				</xsl:choose>
				<line><xsl:value-of select="country"/></line>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
