<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:stop="https://standaarden.overheid.nl/lvbb/stop/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" prefix="ow-dc"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/owobject/v20190709" prefix="ow"/>
    <sch:ns uri="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
        prefix="sl"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regels/v20190901" prefix="r"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regels-ref/v20190901" prefix="r-ref"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/locatie/v20190901" prefix="l"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" prefix="l-ref"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" prefix="rol"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" prefix="rol-ref"/>
    <sch:ns uri="http://whatever" prefix="foo"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" prefix="ga"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" prefix="ga-ref"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" prefix="g-ref"/>
    <sch:ns uri="http://www.geostandaarden.nl/basisgeometrie/v20190901" prefix="geo"/>
    <sch:ns uri="http://www.opengis.net/gml/3.2" prefix="gml"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/vrijetekst/v20190901" prefix="vt"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/vrijetekst-ref/v20190901" prefix="vt-ref"/>
    <sch:ns uri="https://standaarden.overheid.nl/stop/imop/data/" prefix="data"/>
    <sch:ns uri="https://standaarden.overheid.nl/lvbb/stop/" prefix="stop"/>
    <sch:ns uri="https://standaarden.overheid.nl/stop/imop/tekst/" prefix="tekst"/>
    
    
    <!-- ====================================== GENERIC ============================================================================= -->
    <sch:let name="xmlDocuments" value="collection('.?select=*.xml;recurse=yes')"/>
    <sch:let name="gmlDocuments" value="collection('.?select=*.gml;recurse=yes')"/>
    <sch:let name="SOORT_REGELING" value="$xmlDocuments//stop:RegelingVersieInformatie/data:RegelingMetadata/data:soortRegeling/text()"/>
    
    <sch:let name="AMvB" value="'/join/id/stop/regelingtype_001'"/>
    <sch:let name="MR" value="'/join/id/stop/regelingtype_002'"/>
    <sch:let name="OP" value="'/join/id/stop/regelingtype_003'"/>
    <sch:let name="OV" value="'/join/id/stop/regelingtype_004'"/>
    <sch:let name="WV" value="'/join/id/stop/regelingtype_005'"/>
    <sch:let name="OVI_PB" value="''"/>
    
    <!-- ============TDOP_0400================================================================================================================ -->
    
    <sch:pattern id="TDOP_0400">
        <sch:rule context="//tekst:Kop">
            <sch:let name="APPLICABLE" value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="tekst:Label and tekst:Opschrift and tekst:Nummer"/>
            
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0400: Betreft
                (Label, Opschrift, Nummer): "<sch:value-of select="tekst:Label"/>", "<sch:value-of
                    select="tekst:Nummer"/>", "<sch:value-of select="tekst:Opschrift"/>": Een Kop
                moet bevatten een Label, een Nummer en een Opschrift. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TDOP_0410================================================================================================================ -->
    
    <sch:pattern id="TDOP_0410">
        <sch:rule context="//tekst:Hoofdstuk/tekst:Kop[lower-case(tekst:Label) ne 'hoofdstuk']">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="false()"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0410: Een Hoofdstuk moet worden geduid met de label Hoofdstuk. Betreft label: <sch:value-of select="tekst:Label"/> </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- =============TDOP_0420=============================================================================================================== -->
    
    <sch:pattern id="TDOP_0420">
        <sch:rule context="//tekst:Lichaam">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="volgorde" value="foo:volgordeTDOP_0420(.)">
            </sch:let>
            <sch:let name="CONDITION" value="string-length($volgorde) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0420: Hoofdstukken moeten oplopend worden genummerd in Arabische cijfers (betreft hoofdstukken):  <sch:value-of select="substring($volgorde,1,string-length($volgorde)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:volgordeTDOP_0420">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Hoofdstuk">
                <xsl:if test="not(string(tekst:Kop/tekst:Nummer)=string(position()))">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ============TDOP_0460================================================================================================================ -->
    
    <sch:pattern id="TDOP_0460">
        <sch:rule context="//tekst:Titel/tekst:Kop[lower-case(tekst:Label) ne 'titel']">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="false()"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0410: Een Titel moet worden geduid met de label Titel. Betreft label: <sch:value-of select="tekst:Label"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TDOP_0470================================================================================================================ -->
    
    <sch:pattern id="TDOP_0470">
        <sch:rule context="//tekst:Lichaam/tekst:Hoofdstuk">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(tekst:Kop/tekst:Nummer)"/>
            <sch:let name="fouten" value="foo:foutenTDOP_0470($hoofdstuk, .)"/>
            
            <sch:let name="CONDITION" value="string-length($fouten) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0470: De nummering van Titels moet beginnen met het nummer van het Hoofdstuk waarin de Titel voorkomt. (betreft hoofdstukken, titels):  <sch:value-of select="$hoofdstuk"/>: <sch:value-of select="substring($fouten,1,string-length($fouten)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:foutenTDOP_0470">
        <xsl:param name="hoofdstuk" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Titel">
                <xsl:if test="not(starts-with(tekst:Kop/tekst:Nummer, concat($hoofdstuk, '.')))">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ===========TDOP_0480================================================================================================================= -->
    
    <sch:pattern id="TDOP_0480">
        <sch:rule context="//tekst:Lichaam/tekst:Hoofdstuk">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(tekst:Kop/tekst:Nummer)"/>
            <sch:let name="volgorde" value="foo:volgordeTDOP_0480($hoofdstuk, .)"/>
            <sch:let name="CONDITION" value="string-length($volgorde) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0480: Titels moeten oplopend worden genummerd in Arabische cijfers. (betreft hoofdstukken, titels):  <sch:value-of select="$hoofdstuk"/>:   <sch:value-of select="substring($volgorde,1,string-length($volgorde)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:volgordeTDOP_0480">
        <xsl:param name="hoofdstuk" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Titel">
                <xsl:if test="not(string(tekst:Kop/tekst:Nummer)=concat($hoofdstuk, '.', string(position())))">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ============TDOP_0490================================================================================================================ -->
    
    <sch:pattern id="TDOP_0490">
        <sch:rule context="//tekst:Lichaam/tekst:Hoofdstuk">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(tekst:Kop/tekst:Nummer)"/>
            <sch:let name="fouten" value="foo:foutenTDOP_0490( .)"/>
            <sch:let name="CONDITION" value="string-length($fouten) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0490: Achter het cijfer van een titelnummer mag geen punt worden opgenomen. (betreft hoofdstukken, titels):  <sch:value-of select="$hoofdstuk"/>: <sch:value-of select="substring($fouten,1,string-length($fouten)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:foutenTDOP_0490">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Titel">
                <xsl:if test="ends-with(tekst:Kop/tekst:Nummer, '.')">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ===========TDOP_0510================================================================================================================= -->
    
    <sch:pattern id="TDOP_0510">
        <sch:rule context="//tekst:Afdeling/tekst:Kop[lower-case(tekst:Label) ne 'afdeling']">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="false()"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0510: Een Afdeling moet worden geduid met de label Afdeling. Betreft label: <sch:value-of select="tekst:Label"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TDOP_0520================================================================================================================ -->
    
    <sch:pattern id="TDOP_0520">
        <sch:rule context="//tekst:Hoofdstuk/tekst:Titel">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(../tekst:Kop/tekst:Nummer)"/>
            <sch:let name="titel" value="string(tekst:Titel/tekst:Kop/tekst:Nummer)"/>
            <sch:let name="volgorde" value="foo:volgordeTDOP_0520($titel, .)"/>
            <sch:let name="CONDITION" value="string-length($volgorde) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0520: Als tussen Hoofdstuk en Afdeling Titel voorkomt dan moet de nummering van Afdelingen beginnen met het samengestelde nummer van de Titel waarin de Afdeling voorkomt, gevolgd door een punt. (betreft hoofdstukken, titels, afdelingen):  <xsl:value-of select="$hoofdstuk"/>: <sch:value-of select="$titel"/>: <sch:value-of select="substring($volgorde,1,string-length($volgorde)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:volgordeTDOP_0520">
        <xsl:param name="titel" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Afdeling">
                <xsl:if test="not(string(tekst:Kop/tekst:Nummer)=concat($titel, '.', string(position())))">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ============TDOP_0530================================================================================================================ -->
    
    <sch:pattern id="TDOP_0530">
        <sch:rule context="//tekst:Lichaam/tekst:Hoofdstuk">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(tekst:Kop/tekst:Nummer)"/>
            <sch:let name="volgorde" value="foo:volgordeTDOP_0530($hoofdstuk, .)"/>
            <sch:let name="CONDITION" value="string-length($volgorde) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0530: Afdelingen moeten oplopend worden genummerd in Arabische cijfers. (betreft hoofdstukken, afdeling):  <sch:value-of select="$hoofdstuk"/>:   <sch:value-of select="substring($volgorde,1,string-length($volgorde)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:volgordeTDOP_0530">
        <xsl:param name="hoofdstuk" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Afdeling">
                <xsl:if test="not(string(tekst:Kop/tekst:Nummer)=concat($hoofdstuk, '.', string(position())))">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$context/tekst:Titel">
                <xsl:variable name="titel" select="string(tekst:Kop/tekst:Nummer)"/>
                <xsl:for-each select="tekst:Afdeling">
                    <xsl:if test="not(string(tekst:Kop/tekst:Nummer)=concat($titel, '.', string(position())))">
                        <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ===========TDOP_0540================================================================================================================= -->
    
    <sch:pattern id="TDOP_0540">
        <sch:rule context="//tekst:Lichaam/tekst:Hoofdstuk">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(tekst:Kop/tekst:Nummer)"/>
            <sch:let name="fouten" value="foo:foutenTDOP_0540(.)">
            </sch:let>
            <sch:let name="CONDITION" value="string-length($fouten) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0540: Achter het cijfer van een afdelingnummer mag geen punt worden opgenomen. (betreft hoofdstukken, afdeling):  <sch:value-of select="$hoofdstuk"/>: <sch:value-of select="substring($fouten,1,string-length($fouten)-2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:foutenTDOP_0540">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Afdeling">
                <xsl:if test="ends-with(tekst:Kop/tekst:Nummer, '.')">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$context/tekst:Titel">
                <sch:let name="titel" value="string(tekst:Kop/tekst:Nummer)"/>
                <xsl:for-each select="tekst:Afdeling">
                    <xsl:if test="ends-with(tekst:Kop/tekst:Nummer, '.')">
                        <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer),', ')"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ============TDOP_0560================================================================================================================ -->
    
    <sch:pattern id="TDOP_0560">
        <sch:rule context="//tekst:Lichaam/tekst:Hoofdstuk">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk" value="string(tekst:Kop/tekst:Nummer)"/>
            <sch:let name="fouten" value="foo:foutenTDOP_0560($hoofdstuk, .)"/>
            
            <sch:let name="CONDITION" value="string-length($fouten) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0560: Als
                tussen Hoofdstuk en Afdeling geen Titel voorkomt dan moet de nummering van
                Afdelingen beginnen met het nummer van het Hoofdstuk waarin de Afdeling voorkomt,
                gevolgd door een punt. (betreft hoofdstukken, titels): <sch:value-of
                    select="$hoofdstuk"/>: <sch:value-of
                        select="substring($fouten, 1, string-length($fouten) - 2)"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:foutenTDOP_0560">
        <xsl:param name="hoofdstuk"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="volgorde">
            <xsl:for-each select="$context/tekst:Afdeling">
                <xsl:if test="not(starts-with(tekst:Kop/tekst:Nummer, concat($hoofdstuk, '.')))">
                    <xsl:value-of select="concat(string(tekst:Kop/tekst:Nummer), ', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$volgorde"/>
    </xsl:function>
    
    <!-- ===========TDOP_0570================================================================================================================= -->
    
    <sch:pattern id="TDOP_0570">
        <sch:rule context="//tekst:Paragraaf/tekst:Kop[(lower-case(tekst:Label) ne '§') and (lower-case(tekst:Label) ne 'paragraaf')]">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="false()"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_0570: Een Paragraaf moet worden geduid met de label Paragraaf of het paragraaf-teken. Betreft label: <sch:value-of select="tekst:Label"/> </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TPOD880================================================================================================================ -->
    
    <sch:pattern id="TPOD880">
        <sch:rule context="//tekst:Hoofdstuk/tekst:Kop[string(tekst:Nummer) = '1']">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION"
                value="(lower-case(tekst:Label/text()) = 'hoofdstuk') and (lower-case(tekst:Opschrift/text()) = 'algemene bepaling')"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD880: Een
                OW-besluit moet minimaal één hoofdstuk 1 bevatten met het opschrift Algemene
                bepalingen. </sch:assert>
        </sch:rule>
        <sch:rule context="//tekst:Lichaam">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="hoofdstuk1" value="foo:hoofdstuk1TPOD880(.)" />
            
            <sch:let name="CONDITION" value="$hoofdstuk1=1 or $hoofdstuk1=-1"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD880: Een
                OW-besluit moet minimaal één hoofdstuk 1 bevatten met het opschrift Algemene
                bepalingen. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:hoofdstuk1TPOD880">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="hoofdstuk1">
            <xsl:choose>
                <xsl:when test="$context/tekst:Hoofdstuk/tekst:Kop">
                    <xsl:value-of select="0"/>
                    <xsl:for-each select="$context/tekst:Hoofdstuk/tekst:Kop">
                        <xsl:if test="string(tekst:Nummer) = '1'">
                            <xsl:value-of select="tekst:Nummer"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="-1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$hoofdstuk1"/>
    </xsl:function>
    
    <!-- ============TPOD_0940================================================================================================================ -->    
    
    <sch:pattern id="TPOD_0940">
        <sch:rule
            context="/geo:FeatureCollectionGeometrie/geo:featureMember/geo:Geometrie/geo:geometrie">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="crs" value="foo:crsTPOD_0940(.)"/>
            <sch:let name="crsses" value="foo:crssesTPOD_0940($crs, .)"/>
            <sch:let name="CONDITION" value="string-length($crsses) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                H:TP0D940: Een geometrie moet zijn
                opgebouwd middels één coordinate reference system (crs): EPSG:28992 (=RD new) of
                EPSG:4258 (=ETRS89). Id=<sch:value-of select="parent::*/geo:id"/>: </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:crsTPOD_0940">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="crs">
            <xsl:for-each select="$context/descendant-or-self::*/@srsName">
                <xsl:if test="position() = 1">
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$crs"/>
    </xsl:function>
    
    <xsl:function name="foo:crssesTPOD_0940">
        <xsl:param name="crs"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="crsses">
            <xsl:for-each select="$context/descendant-or-self::*/@srsName">
                <xsl:if test="not($crs = .)">
                    <xsl:value-of select="concat(., ', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$crsses"/>
    </xsl:function>
    
    <!-- ============TPOD_1650================================================================================================================ -->
    
    <sch:pattern id="TPOD_1650">
        <sch:rule
            context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Omgevingswaarde|rol:Omgevingsnorm">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="(rol:normwaarde/rol:Normwaarde/rol:kwantitatieveWaarde or rol:normwaarde/rol:Normwaarde/rol:kwalitatieveWaarde) and
                not(rol:normwaarde/rol:Normwaarde/rol:kwantitatieveWaarde and rol:normwaarde/rol:Normwaarde/rol:kwalitatieveWaarde)"/>
            <sch:assert
                test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1650: <sch:value-of select="rol:identificatie"/>: Het attribuut 'normwaarde'
                moet bestaan uit één van de twee mogelijke attributen; 'kwalitatieveWaarde' óf
                'kwantitatieveWaarde'. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TPOD_1670================================================================================================================ -->
    
    <sch:pattern id="TPOD_1670">
        <sch:rule
            context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/r:RegelVoorIedereen">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION" value="(r:activiteitaanduiding) or (not(r:activiteitaanduiding) and not(r:activiteitregelkwalificatie))"/>
            <sch:assert
                test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"
                > H:TPOD1670: behorend bij ArtikelOfLid <sch:value-of
                    select="r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>:
                Activiteitregelkwalificatie is alleen te gebruiken wanneer het object ‘Regel voor
                iedereen’ is geannoteerd met Activiteit. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TPOD_1700================================================================================================================ -->
    
    <sch:pattern id="TPOD_1700">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="activiteitenLijst" value="foo:activiteitenLijstTPOD_1700()"/>
            <sch:let name="bovenLiggend"
                value="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>
            <sch:let name="identificatie" value="rol:identificatie"/>
            <sch:let name="circulaireActivititeiten" value="foo:circulaireActiviteitenAanzetTPOD_1700($activiteitenLijst, $bovenLiggend, $identificatie, $identificatie)"/>
            <sch:let name="identificatie" value="rol:identificatie"/>
            <sch:let name="lokaalBovenliggend"
                value="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>
            <sch:let name="activiteitenTrajectNaarFunctioneleStructuur" value="foo:activiteitenTrajectNaarFunctioneleStructuurTPOD_1700($circulaireActivititeiten, $activiteitenLijst, $identificatie, $lokaalBovenliggend)"/>
            <sch:let name="CONDITION"
                value="string-length($activiteitenTrajectNaarFunctioneleStructuur) > 0"/>
            <sch:report test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                REPORT: H:TPOD1700:
                Activiteit-ids: <sch:value-of select="substring($activiteitenTrajectNaarFunctioneleStructuur,1,string-length($activiteitenTrajectNaarFunctioneleStructuur)-2)"/>: 
                Voor elke hiërarchie van nieuwe activiteiten geldt dat de hoogste activiteit in
                de hiërarchie een bovenliggende activiteit moet hebben die reeds bestaat in de
                functionele structuur. DIT LAATSTE WORDT NU NOG NIET GETEST </sch:report>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:activiteitenTrajectNaarFunctioneleStructuurTPOD_1700">
        <xsl:param name="circulaireActivititeiten"/>
        <xsl:param name="activiteitenLijst"/>
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="lokaalBovenliggend" as="xs:string"/>
        <xsl:variable name="activiteitenTrajectNaarFunctioneleStructuur">
            <xsl:if test="not(contains($circulaireActivititeiten, $identificatie))">
                <xsl:choose>
                    <xsl:when test="not(contains($activiteitenLijst, $lokaalBovenliggend))">
                        <xsl:value-of select="concat($identificatie, ', ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="foo:activiteitenPadTPOD_1700($identificatie, $lokaalBovenliggend, $activiteitenLijst)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$activiteitenTrajectNaarFunctioneleStructuur"/>
    </xsl:function>
    
    <xsl:function name="foo:circulaireActiviteitenAanzetTPOD_1700">
        <xsl:param name="activiteitenLijstForContains"/>
        <xsl:param name="bovenLiggendForContains" as="xs:string"/>
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="bovenLiggend" as="xs:string"/>
        <xsl:variable name="circulaireActiviteitenAanzet">
            <xsl:if test="contains($activiteitenLijstForContains, $bovenLiggendForContains)">
                <xsl:value-of
                    select="foo:circulaireActiviteitenTPOD_1700($identificatie, $bovenLiggend)"
                />
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$circulaireActiviteitenAanzet"/>
    </xsl:function>
    
    <xsl:function name="foo:circulaireActiviteitenTPOD_1700">
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="bovenLiggend" as="xs:string"/>
        <xsl:variable name="circulaireActiviteiten">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:if
                    test="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href = $bovenLiggend">
                    <xsl:variable name="lokaalBovenliggend" select="rol:identificatie"/>
                    <xsl:choose>
                        <xsl:when test="$identificatie = $lokaalBovenliggend">
                            <xsl:value-of select="concat($lokaalBovenliggend, ', ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="foo:circulaireActiviteitenTPOD_1700($identificatie, $lokaalBovenliggend)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$circulaireActiviteiten"/>
    </xsl:function>
    
    <xsl:function name="foo:activiteitenLijstTPOD_1700">
        <xsl:variable name="activiteitenLijst">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:value-of select="rol:identificatie"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$activiteitenLijst"/>
    </xsl:function>
    
    <xsl:function name="foo:activiteitenPadTPOD_1700">
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="bovenliggend" as="xs:string"/>
        <xsl:param name="activiteitenLijst" as="xs:string*"/>
        <xsl:variable name="activiteitenPad">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:if test="rol:identificatie = $bovenliggend">
                    <xsl:variable name="lokaalBovenliggend"
                        select="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>
                    <xsl:choose>
                        <xsl:when test="not(contains($activiteitenLijst, $lokaalBovenliggend))">
                            <xsl:value-of select="concat($identificatie, ', ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="foo:activiteitenPadTPOD_1700($identificatie, $lokaalBovenliggend, $activiteitenLijst)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$activiteitenPad"/>
    </xsl:function>
    
    <!-- ============TPOD_1710================================================================================================================ -->
    
    <sch:pattern id="TPOD_1710">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="activiteitenLijst" value="foo:activiteitenLijstTPOD_1710()"/>
            <sch:let name="circulaireActivititeiten"
                value="foo:circulaireActivititeitenTPOD_1710(., $activiteitenLijst)"/>
            <!-- TPOD1710  -->
            <sch:let name="CONDITION" value="string-length($circulaireActivititeiten) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                H:TP0D1710:
                Activiteit-ids: <sch:value-of select="substring($circulaireActivititeiten,1,string-length($circulaireActivititeiten)-2)"/>: Een
                bovenliggende activiteit mag niet naar een activiteit verwijzen die lager in de
                hiërarchie ligt.</sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    <xsl:function name="foo:circulaireActivititeitenTPOD_1710">
        <xsl:param name="context" as="node()"/>
        <xsl:param name="activiteitenLijst"/>
        <xsl:variable name="circulaireActivititeiten">
            <xsl:variable name="bovenLiggend"
                select="string($context/rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href)"/>
            <xsl:variable name="identificatie" select="$context/rol:identificatie/text()"/>
            <!-- hier worden de activiteiten uitgefilterd waarvan de bovenliggende activiteiten in de functionele structuur zitten -->
            <xsl:if test="contains($activiteitenLijst, $bovenLiggend)">
                <xsl:value-of
                    select="foo:selecteerCirculaireActiviteitenTPOD_1710($identificatie, $identificatie, $context)"
                />
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$circulaireActivititeiten"/>
    </xsl:function>
    
    <xsl:function name="foo:selecteerCirculaireActiviteitenTPOD_1710">
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="bovenliggend" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="selecteerCirculaireActiviteiten">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:if
                    test="string(rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href) = $bovenliggend">
                    <xsl:variable name="lokaalBovenliggend" select="rol:identificatie/text()"/>
                    <xsl:choose>
                        <xsl:when test="$identificatie = $lokaalBovenliggend">
                            <xsl:value-of select="concat($lokaalBovenliggend, ', ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="foo:selecteerCirculaireActiviteitenTPOD_1710($identificatie, $lokaalBovenliggend, $context)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$selecteerCirculaireActiviteiten"/>
    </xsl:function>
    
    
    <xsl:function name="foo:activiteitenLijstTPOD_1710">
        <xsl:variable name="activiteitenLijst">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:value-of select="rol:identificatie/text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$activiteitenLijst"/>
    </xsl:function>
    
    <!-- ============TPOD_1730================================================================================================================ -->
    
    <sch:pattern id="TPOD_1730">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="activiteitenLijst" value="foo:activiteitenLijstTPOD_1730()"/>
            <!-- TPOD1730  -->
            <sch:let name="CONDITION" value="contains($activiteitenLijst, rol:gerelateerdeActiviteit/rol-ref:ActiviteitRef/@xlink:href)"/>
            <sch:assert
                test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                H:TPOD1730: <sch:value-of select="rol:identificatie"/> Betreft verwijzing:
                <sch:value-of
                    select="rol:gerelateerdeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>:
                Gerelateerde activiteiten moeten bestaan indien er naar verwezen wordt.</sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    <xsl:function name="foo:activiteitenLijstTPOD_1730">
        <xsl:variable name="activiteitenLijst">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:value-of select="rol:identificatie/text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$activiteitenLijst"/>
    </xsl:function>
    
    <!-- ============TPOD_1740================================================================================================================ -->
    
    <sch:pattern id="TPOD_1740">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="activiteitenLijst" value="foo:activiteitenLijstTPOD_1740()"/>
            
            <!-- TPOD1740  -->
            <sch:let name="CONDITION" value="not(contains($activiteitenLijst, rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href))"/>
            <sch:report
                test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                REPORT: H:TPOD1740: <sch:value-of select="rol:identificatie"/>: Betreft
                verwijzing: <sch:value-of
                    select="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>:
                Bovenliggende activiteiten moeten bestaan indien er naar verwezen wordt. DIT LAATSTE
                WORDT NU NOG NIET GETEST</sch:report>
        </sch:rule>
        
    </sch:pattern>
    
    <xsl:function name="foo:activiteitenLijstTPOD_1740">
        <xsl:variable name="activiteitenLijst">
            <xsl:for-each
                select="$xmlDocuments/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
                <xsl:value-of select="rol:identificatie/text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$activiteitenLijst"/>
    </xsl:function>
    
    <!-- ============TPOD_1760================================================================================================================ -->
    
    <sch:pattern id="TPOD_1760">
        <sch:rule
            context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/ga:Gebiedsaanwijzing">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR or $SOORT_REGELING = $OP or $SOORT_REGELING = $OV or $SOORT_REGELING = $WV"/>
            <sch:let name="CONDITION"
                value="contains(ga:locatieaanduiding/l-ref:LocatieRef/@xlink:href, '.gebiedengroep.') or contains(ga:locatieaanduiding/l-ref:LocatieRef/@xlink:href, '.gebied.')"/>    
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1760: Betreft <sch:value-of select="ga:identificatie"
                />: Een gebiedsaanwijzing moet een gebied of gebiedengroep zijn (en mag geen punt,
                puntengroep, lijn of lijnengroep zijn). </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TPOD_1830================================================================================================================ -->    
    
    <sch:pattern id="TPOD_1830">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/ga:Gebiedsaanwijzing/ga:type">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR"/>
            <sch:let name="CONDITION" value="not(text()='functie')"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                H:TPOD1830: Binnen het object ‘Gebiedsaanwijzing’ is de waarde ‘functie’ van attribuut ‘type’
                (datatype TypeGebiedsaanwijzing) niet toegestaan. Het object waarom het
                gaat: <sch:value-of select="../ga:identificatie/text()"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TPOD_1840================================================================================================================ -->    
    
    <sch:pattern id="TPOD_1840">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/ga:Gebiedsaanwijzing/ga:type">
            <sch:let name="APPLICABLE"
                value="$SOORT_REGELING = $AMvB or $SOORT_REGELING = $MR"/>
            <sch:let name="CONDITION" value="not(text()='beperkingengebied')"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                H:TPOD1840: Binnen het object ‘Gebiedsaanwijzing’ is de waarde ‘beperkingengebied’ van attribuut ‘type’
                (datatype TypeGebiedsaanwijzing) niet toegestaan. Het object waarom het
                gaat: <sch:value-of select="../ga:identificatie/text()"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TDOP_1860================================================================================================================ -->
    
    <sch:pattern id="TDOP_1860">
        <sch:rule context="//r:Regeltekst">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="CONDITION"
                value="not(r:gerelateerdeRegeltekst/r-ref:RegeltekstRef/@xlink:href eq r:identificatie)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="name()"/>:
                <sch:value-of select="r:identificatie"/>: Iedere verwijzing naar een ander
                OwObject moet een bestaand (ander) OwObject zijn. (gerelateerdeRegeltekst verwijst
                naar zichzelf) </sch:assert>
        </sch:rule>
        <sch:rule context="//rol:Activiteit">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="CONDITION"
                value="not(rol:gerelateerdeActiviteit/rol-ref:ActiviteitRef/@xlink:href eq rol:identificatie)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="name()"/>:
                <sch:value-of select="rol:identificatie"/>: Iedere verwijzing naar een ander
                OwObject moet een bestaand (ander) OwObject zijn. (gerelateerdeActiviteit verwijst
                naar zichzelf) </sch:assert>
        </sch:rule>
        <sch:rule context="//r:artikelOfLid/r-ref:RegeltekstRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers"
                value="foo:getIdentifiersTDOP_1860($xmlDocuments//r:Regeltekst/r:identificatie)"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="../../name()"/>:
                <sch:value-of select="../../r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>,
                <sch:value-of select="@xlink:href"/>: Iedere verwijzing naar een ander OwObject
                moet een bestaand (ander) OwObject zijn. </sch:assert>
        </sch:rule>
        <sch:rule context="//r:RegelVoorIedereen/r:activiteitaanduiding/rol-ref:ActiviteitRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers"
                value="foo:getIdentifiersTDOP_1860($xmlDocuments//rol:Activiteit/rol:identificatie)"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="../../name()"/>:
                <sch:value-of select="../../r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>,
                <sch:value-of select="@xlink:href"/>: Iedere verwijzing naar een ander OwObject
                moet een bestaand (ander) OwObject zijn. </sch:assert>
        </sch:rule>
        <sch:rule context="//r:omgevingsnormaanduiding/rol-ref:OmgevingsnormRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers"
                value="foo:getIdentifiersTDOP_1860($xmlDocuments//rol:Omgevingsnorm/rol:identificatie)"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="../../name()"/>:
                <sch:value-of select="../../r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>,
                <sch:value-of select="@xlink:href"/>: Iedere verwijzing naar een ander OwObject
                moet een bestaand (ander) OwObject zijn. </sch:assert>
        </sch:rule>
        <sch:rule context="//r:gebiedsaanwijzing/ga-ref:GebiedsaanwijzingRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers"
                value="foo:getIdentifiersTDOP_1860($xmlDocuments//ga:Gebiedsaanwijzing/ga:identificatie)"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="../../name()"/>:
                <sch:value-of select="../../r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>,
                <sch:value-of select="@xlink:href"/>: Iedere verwijzing naar een ander OwObject
                moet een bestaand (ander) OwObject zijn. </sch:assert>
        </sch:rule>
        <sch:rule
            context="//l-ref:LocatieRef | l-ref:GebiedRef | l-ref:GebiedengroepRef | l-ref:PuntRef | l-ref:PuntengroepRef | l-ref:LijnengroepRef | l-ref:LijnRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers" value="foo:getLocationIdentifiersTDOP_1860()"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="../../name()"/>:
                <sch:value-of select="../../rol:identificatie"/>, <sch:value-of
                    select="@xlink:href"/>: Iedere verwijzing naar een ander OwObject moet een
                bestaand (ander) OwObject zijn. </sch:assert>
        </sch:rule>
        <sch:rule context="//rol:gerelateerdeActiviteit/rol-ref:ActiviteitRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers"
                value="foo:getIdentifiersTDOP_1860($xmlDocuments//rol:Activiteit/rol:identificatie)"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of select="../../name()"/>:
                <sch:value-of select="../../rol:identificatie"/>, <sch:value-of
                    select="@xlink:href"/>: Iedere verwijzing naar een ander OwObject moet een
                bestaand (ander) OwObject zijn. </sch:assert>
        </sch:rule>
        <sch:rule
            context="//rol:normwaarde/rol:Normwaarde/rol:locatieaanduiding/l-ref:LocatieRef | l-ref:GebiedRef | l-ref:GebiedengroepRef | l-ref:PuntRef | l-ref:PuntengroepRef | l-ref:LijnengroepRef | l-ref:LijnRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="identifiers" value="foo:getLocationIdentifiersTDOP_1860()"/>
            <sch:let name="CONDITION" value="contains($identifiers, @xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1860: Betreft <sch:value-of
                    select="../../../../name()"/>: <sch:value-of
                        select="../../../../rol:identificatie"/>, <sch:value-of select="@xlink:href"/>:
                Iedere verwijzing naar een ander OwObject moet een bestaand (ander) OwObject zijn.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:getLocationIdentifiersTDOP_1860">
        <xsl:variable name="identifiers">
            <xsl:for-each
                select="$xmlDocuments//(l:Gebied | l:Gebiedengroep | l:Punt | l:Puntengroep | l:Lijn | l:Lijnengroep)/l:identificatie">
                <xsl:value-of select="text()"/>
            </xsl:for-each>
        </xsl:variable>
        <sch:value-of select="$identifiers"/>
    </xsl:function>
    
    <xsl:function name="foo:getIdentifiersTDOP_1860">
        <xsl:param name="xpath" as="node()*"/>
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xpath">
                <xsl:value-of select="text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
    
    <!-- ============TDOP_1870================================================================================================================ -->    
    
    <sch:pattern id="TDOP_1870">
        <sch:rule context="//r:artikelOfLid">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="identifiers"
                value="foo:getRegelTekstIdentifiersTDOP_1870()"/>
            <sch:let name="CONDITION" value="contains($identifiers, r-ref:RegeltekstRef/@xlink:href)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1870: Betreft
                <sch:value-of select="../name()"/>: <sch:value-of select="../@ow:regeltekstId"/>, <sch:value-of
                    select="r-ref:RegeltekstRef/@xlink:href"/>: Een verwijzing naar ArtikelOfLid moet verwijzen naar een bestaand artikel of lid. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:getRegelTekstIdentifiersTDOP_1870">
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xmlDocuments//r:Regeltekst">
                <xsl:value-of select="r:identificatie/text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
    
    <!-- ============TDOP_1890================================================================================================================ -->    
    
    <sch:pattern id="TDOP_1890">
        <sch:rule context="//*:identificatie">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="CONDITION" value="contains(text(), concat('.', lower-case(tokenize(../name(), ':')[last()]), '.'))"/>
            <sch:assert
                test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1890: Betreft <sch:value-of select="../name()"/>: <sch:value-of
                    select="text()"/>: De identificatie van het OwObject moet de naam van het OwObject-element zelf bevatten.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TPOD_1910================================================================================================================ -->    
    
    <sch:pattern id="TPOD_1910">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:inhoud/sl:objectTypen/sl:objectType">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="objects" value="foo:owObjectenLijstTPOD_1910(.)"/>
            <sch:let name="CONDITION" value="contains($objects, concat('.',text(),'.'))"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                H:TPOD1910: De objecttypen in
                ow-dc:owBestand/sl:standBestand/sl:inhoud/sl:objectTypen dienen overeen te komen met
                de daadwerkelijke objecten in het betreffende Ow-bestand. Het objecttype waarom het
                gaat staan nu genoemd: <sch:value-of select="text()"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>
   
    <xsl:function name="foo:owObjectenLijstTPOD_1910">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="owObjectenLijst">
            <xsl:for-each select="$context/../../../sl:stand/ow-dc:owObject/*"> 
                <xsl:value-of select="concat('.',local-name(),'.')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$owObjectenLijst"/>
    </xsl:function>
    
    <!-- ============TPOD_1920================================================================================================================ -->
    
    <sch:pattern id="TPOD_1920">
        <sch:rule context="/Modules/RegelingVersie/Bestand">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="nfFOOT" value="foo:notfoundFileOrObjectTypeTPOD_1920(naam,.)"></sch:let>
            <sch:let name="CONDITION" value="string-length($nfFOOT) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                H:TPOD1920: De
                objecttypen in manifest-ow dienen overeen te komen met de objecttypen in het
                betreffende Ow-bestand. De objecttypen waarom het gaat staan nu genoemd:
                <sch:value-of select="$nfFOOT"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:notfoundFileOrObjectTypeTPOD_1920">
        <xsl:param name="naam"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="notfoundFileOrObjectType">
            <xsl:for-each select="$context/objecttype">
                <xsl:variable name="objecttype" select="text()"/>
                <xsl:choose>
                    <xsl:when test=". = 'Geometrie'">
                        <xsl:if test="not(document($naam)//geo:FeatureCollectionGeometrie)">
                            <xsl:value-of select="concat($naam, ': ', ., ', ')"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if
                            test="not(document($naam)//ow-dc:owBestand/sl:standBestand/sl:inhoud/sl:objectTypen[sl:objectType = $objecttype])">
                            <xsl:value-of select="concat($naam, ': ', ., ', ')"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$notfoundFileOrObjectType"/>
    </xsl:function>
    
    <!-- ============TDOP_1930================================================================================================================ -->
    
    <sch:pattern id="TDOP_1930">
        <sch:rule context="//l:Gebiedengroep/l:groepselement">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="notFound" value="foo:notFoundTDOP_1930(.)"/>
            <sch:let name="CONDITION" value="string-length($notFound) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_1930: Betreft
                <sch:value-of select="../../name()"/>: <sch:value-of select="../l:identificatie"
                />, <sch:value-of select="$notFound"/>: Iedere verwijzing naar een OwObject in een
                Gebiedengroep moet een bestaand (ander) OwObject van het type Gebied zijn.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:notFoundTDOP_1930">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="notFound">
            <xsl:variable name="identifiers"
                select="foo:getIdentifiersTDOP_1930($xmlDocuments//l:Gebied/l:identificatie)"/>
            <xsl:for-each select="$context/l-ref:GebiedRef">
                <xsl:if test="not(contains($identifiers, @xlink:href))">
                    <xsl:value-of select="concat(@xlink:href, ', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$notFound"/>
    </xsl:function>
    
    <xsl:function name="foo:getIdentifiersTDOP_1930">
        <xsl:param name="xpath" as="node()*"/>
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xpath">
                <xsl:value-of select="text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
    
    <!-- ============TDOP_1940================================================================================================================ -->    
    
    <sch:pattern id="TDOP_1940">
        <sch:rule
            context="//l:Puntengroep/l:groepselement">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="notFound" value="foo:notFoundTDOP_1940(.)"/>
            <sch:let name="CONDITION" value="string-length($notFound) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_1940: Betreft <sch:value-of
                    select="../../name()"/>: <sch:value-of select="../l:identificatie"/>,
                <sch:value-of select="$notFound"/>: Iedere verwijzing naar een OwObject
                in een Puntengroep moet een bestaand (ander) OwObject van het type Punt zijn. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:notFoundTDOP_1940">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="identifiers"
            select="foo:getIdentifiersTDOP_1940($xmlDocuments//l:Punt/l:identificatie)"/>
        <xsl:variable name="notFound">
            <xsl:for-each select="$context/l-ref:PuntRef">
                <xsl:if test="not(contains($identifiers, @xlink:href))">
                    <xsl:value-of select="concat(@xlink:href, ', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$notFound"/>
    </xsl:function>
    
    <xsl:function name="foo:getIdentifiersTDOP_1940">
        <xsl:param name="xpath" as="node()*"/>
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xpath">
                <xsl:value-of select="text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
    
    <!-- ============TDOP_1950================================================================================================================ -->    
    
    <sch:pattern id="TDOP_1950">
        <sch:rule
            context="//l:Lijnengroep/l:groepselement">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="notFound" value="foo:notFoundTDOP_1950(.)"/>
            <sch:let name="CONDITION" value="string-length($notFound) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_1950: Betreft <sch:value-of
                    select="../../name()"/>: <sch:value-of select="../l:identificatie"/>,
                <sch:value-of select="$notFound"/>: Iedere verwijzing naar een OwObject
                in een Lijnengroep moet een bestaand (ander) OwObject van het type Lijn zijn. </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:notFoundTDOP_1950">
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="notFound">
            <xsl:variable name="identifiers"
                select="foo:getIdentifiersTDOP_1950($xmlDocuments//l:Lijn/l:identificatie)"/>
            <xsl:for-each select="$context/l-ref:LijnRef">
                <xsl:if test="not(contains($identifiers, @xlink:href))">
                    <xsl:value-of select="concat(@xlink:href, ', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$notFound"/>
    </xsl:function>
    
    <xsl:function name="foo:getIdentifiersTDOP_1950">
        <xsl:param name="xpath" as="node()*"/>
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xpath">
                <xsl:value-of select="text()"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
    
    <!-- ============TDOP_1960================================================================================================================ -->    
    
    <sch:pattern id="TDOP_1960">
        <sch:rule context="//l:Lijn/l:geometrie/g-ref:GeometrieRef">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="href" value="string(@xlink:href)"/>
            <sch:let name="geometrie" value="foo:geometrieTDOP_1960($href)"/>
            <sch:let name="CONDITION" value="not($geometrie//gml:MultiPoint || $geometrie//gml:Point || $geometrie//gml:MultiSurface)"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                TDOP_1960: Betreft <sch:value-of
                    select="../../name()"/>: <sch:value-of select="../../l:identificatie"/>,
                <sch:value-of select="@xlink:href"/>: Iedere verwijzing naar een gmlObject
                vanuit een Lijn moet een lijn-geometrie zijn. 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:geometrieTDOP_1960">
        <xsl:param name="href"/>
        <xsl:for-each select="$gmlDocuments//geo:Geometrie">
            <xsl:if test="string(geo:id/text())=$href">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <!-- ============TDOP_1970================================================================================================================ -->    
    
    <sch:pattern id="TDOP_1970">
        <sch:rule context="//l:Punt/l:geometrie/g-ref:GeometrieRef">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="href" value="string(@xlink:href)"/>
            <sch:let name="geometrie" value="$gmlDocuments//geo:Geometrie[geo:id/text() eq $href]"/>
            <sch:let name="CONDITION" value="$geometrie//gml:MultiPoint || $geometrie//gml:Point"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)">
                TDOP_1970: Betreft <sch:value-of
                    select="../../name()"/>: <sch:value-of select="../../l:identificatie"/>,
                <sch:value-of select="@xlink:href"/>: Iedere verwijzing naar een gmlObject
                vanuit een Punt moet een punt-geometrie zijn. 
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ============TDOP_1980================================================================================================================ -->
    
    <sch:pattern id="TDOP_1980">
        <sch:rule context="//l:Gebied/l:geometrie/g-ref:GeometrieRef">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="href" value="string(@xlink:href)"/>
            <sch:let name="gebied" value="foo:calculateConditionTDOP_1980($href)" />
            <sch:let name="CONDITION" value="$gebied=1"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TDOP_1980: Betreft <sch:value-of select="string($CONDITION)"/>
                <sch:value-of select="../../name()"/>: <sch:value-of
                    select="../../l:identificatie"/>, <sch:value-of select="@xlink:href"/>: Iedere
                verwijzing naar een gmlObject vanuit een Gebied moet een gebied-geometrie zijn.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <xsl:function name="foo:calculateConditionTDOP_1980">
        <xsl:param name="href"/>
        <xsl:for-each select="$gmlDocuments">
            <xsl:value-of select="0"/>
            <xsl:if test="//geo:Geometrie[geo:id/text() eq $href]/geo:geometrie/gml:MultiSurface">
                <xsl:message select="'gevonden'"/>
                <xsl:value-of select="1"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <!-- ============TDOP_1990================================================================================================================ -->
    
    <sch:pattern id="TPOD_1990">
        <sch:rule context="/">
            <sch:let name="APPLICABLE"
                value="true()"/>
            <sch:let name="geoLocationGeoReferenceIdentifiers"
                value="foo:getLocationGeoReferenceIdentifiersTPOD_1990()"/>
            <sch:let name="nietGerefereerdeGeometrieen" value="foo:nietGerefereerdeGeometrieenTPOD_1990($geoLocationGeoReferenceIdentifiers)"/>
            <sch:let name="CONDITION" value="string-length($nietGerefereerdeGeometrieen) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TPOD_1990: Ieder OwObject, behalve Activiteit heeft minstens een OwObject dat ernaar verwijst.:
                <sch:value-of select="substring($nietGerefereerdeGeometrieen,1,string-length($nietGerefereerdeGeometrieen)-2)"/>
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//r:Regeltekst/r:identificatie">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="regeltekstReferenties"
                value="foo:getReferencesTPOD_1990(//r-ref:RegeltekstRef)"/>
            <sch:let name="nietGerefereerdeReferenties" value="foo:nietGerefereerdeReferentiesTPOD_1990($regeltekstReferenties, .)"/>
            <sch:let name="CONDITION" value="string-length($nietGerefereerdeReferenties) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TPOD_1990: Ieder OwObject, behalve Activiteit heeft minstens een OwObject dat ernaar verwijst.:
                <sch:value-of select="substring($nietGerefereerdeReferenties,1,string-length($nietGerefereerdeReferenties)-2)"/>
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//(vt:FormeleDivisie|vt:Hoofdlijn)/vt:identificatie">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="formeleDivisieReferenties"
                value="foo:getReferencesTPOD_1990(//(vt-ref:FormeleDivisieRef|vt-ref:HoofdlijnRef))"/>
            <sch:let name="nietGerefereerdeReferenties" value="foo:nietGerefereerdeReferentiesTPOD_1990($formeleDivisieReferenties, .)"/>
            <sch:let name="CONDITION" value="string-length($nietGerefereerdeReferenties) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TPOD_1990: Ieder OwObject, behalve Activiteit heeft minstens een OwObject dat ernaar verwijst.:
                <sch:value-of select="substring($nietGerefereerdeReferenties,1,string-length($nietGerefereerdeReferenties)-2)"/>
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="//l:identificatie">
            <sch:let name="APPLICABLE" value="true()"/>
            <sch:let name="locatieReferenties"
                value="foo:getLocationReferenceIdentifiersTPOD_1990()"/>
            <sch:let name="nietGerefereerdeReferenties">
                <xsl:if
                    test="not(contains($locatieReferenties, concat('.', text(), '.')))">
                    <xsl:value-of select="concat(string(text()), ', ')"/>
                </xsl:if>
            </sch:let>
            <sch:let name="CONDITION" value="string-length($nietGerefereerdeReferenties) = 0"/>
            <sch:assert test="($APPLICABLE and $CONDITION) or not($APPLICABLE)"> 
                TPOD_1990: Ieder OwObject, behalve Activiteit heeft minstens een OwObject dat ernaar verwijst.:
                <sch:value-of select="substring($nietGerefereerdeReferenties,1,string-length($nietGerefereerdeReferenties)-2)"/>
            </sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    
    <xsl:function name="foo:nietGerefereerdeGeometrieenTPOD_1990">
        <xsl:param name="identifiers"/>
        <xsl:variable name="nietGerefereerdeGeometrieen">
            <xsl:for-each select="$gmlDocuments//geo:Geometrie">
                <xsl:if
                    test="not(contains($identifiers, concat('.', string(geo:id/text()), '.')))">
                    <xsl:value-of select="concat(string(geo:id/text()), ', ')"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$nietGerefereerdeGeometrieen"/>
    </xsl:function>
    
    <xsl:function name="foo:nietGerefereerdeReferentiesTPOD_1990">
        <xsl:param name="referenties"/>
        <xsl:param name="context" as="node()"/>
        <xsl:variable name="nietGerefereerdeReferenties">
            <xsl:if
                test="not(contains($referenties, concat('.', $context/text(), '.')))">
                <xsl:value-of select="concat(string($context/text()), ', ')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$nietGerefereerdeReferenties"/>
    </xsl:function>
    
    <xsl:function name="foo:getReferencesTPOD_1990">
        <xsl:param name="xpath" as="node()*"/>
        <xsl:variable name="references">
            <xsl:for-each select="$xmlDocuments//$xpath">
                <xsl:value-of select="concat('.', string(@xlink:href), '.')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$references"/>
    </xsl:function>
    
    <xsl:function name="foo:getLocationGeoReferenceIdentifiersTPOD_1990">
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xmlDocuments//g-ref:GeometrieRef">
                <xsl:value-of select="concat('.', string(@xlink:href), '.')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
    
    <xsl:function name="foo:getLocationReferenceIdentifiersTPOD_1990">
        <xsl:variable name="identifiers">
            <xsl:for-each select="$xmlDocuments//(l-ref:LocatieRef|l-ref:GebiedRef|l-ref:LijnRef|l-ref:PuntRef|l-ref:GebiedengroepRef|l-ref:PuntengroepRef|l-ref:LijnengroepRef)">
                <xsl:value-of select="concat('.', string(@xlink:href), '.')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$identifiers"/>
    </xsl:function>
</sch:schema>