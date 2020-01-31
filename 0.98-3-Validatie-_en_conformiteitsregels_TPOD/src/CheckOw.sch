<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
    xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901"
    xmlns:ow="http://www.geostandaarden.nl/imow/owobject/v20190709"
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901"
    xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:foo="http://whatever"
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901"
    xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901"
    xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901"
    xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" 
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb"
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    >


    <sch:ns uri="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
        prefix="sl"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regels/v20190901" prefix="r"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" prefix="ow-dc"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/owobject/v20190709" prefix="ow"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" prefix="rol"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" prefix="rol-ref"/>
    <sch:ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    <sch:ns uri="http://whatever" prefix="foo"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" prefix="ga"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/locatie/v20190901" prefix="l"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/regels-ref/v20190901" prefix="r-ref"/>
    <sch:ns uri="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" prefix="g-ref"/>
    
    <xsl:variable name="regelTeksten">
        <xsl:variable name="documents"
            select="document('manifest-ow.xml')//Modules/RegelingVersie/Bestand/naam"/>
        <xsl:for-each select="$documents">
            <xsl:for-each select="document(.)//sl:standBestand/sl:stand/ow-dc:owObject/r:Regeltekst">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="gebieden">
        <xsl:variable name="documents"
            select="document('manifest-ow.xml')//Modules/RegelingVersie/Bestand/naam"/>
        <xsl:for-each select="$documents">
            <xsl:for-each select="document(.)//sl:standBestand/sl:stand/ow-dc:owObject/l:Gebied">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    <xsl:variable name="gebiedenGroepen">
        <xsl:variable name="documents"
            select="document('manifest-ow.xml')//Modules/RegelingVersie/Bestand/naam"/>
        <xsl:for-each select="$documents">
            <xsl:for-each select="document(.)//sl:standBestand/sl:stand/ow-dc:owObject/l:Gebiedengroep">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    <sch:pattern id="TPOD1650">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Omgevingswaarde">
            <sch:assert
                test="
                    (rol:normwaarde/rol:Normwaarde/rol:kwantitatieveWaarde or rol:normwaarde/rol:Normwaarde/rol:kwalitatieveWaarde) and
                    not(rol:normwaarde/rol:Normwaarde/rol:kwantitatieveWaarde and rol:normwaarde/rol:Normwaarde/rol:kwalitatieveWaarde)"
                > H:TPOD1650: <sch:value-of select="rol:identificatie"/>: Het attribuut 'normwaarde' moet bestaan uit één van de twee mogelijke
                attributen; 'kwalitatieveWaarde' óf 'kwantitatieveWaarde'. </sch:assert>
        </sch:rule>
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Omgevingsnorm">
            <sch:assert
                test="
                (rol:normwaarde/rol:Normwaarde/rol:kwantitatieveWaarde or rol:normwaarde/rol:Normwaarde/rol:kwalitatieveWaarde) and
                not(rol:normwaarde/rol:Normwaarde/rol:kwantitatieveWaarde and rol:normwaarde/rol:Normwaarde/rol:kwalitatieveWaarde)"
                > H:TPOD1650: <sch:value-of select="rol:identificatie"/>: Het attribuut 'normwaarde' moet bestaan uit één van de twee mogelijke
                attributen; 'kwalitatieveWaarde' óf 'kwantitatieveWaarde'. </sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="TPOD1630_TPOD1690">
        <sch:rule
            context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/r:Instructieregel">
            <sch:assert
                test="
                    (r:instructieregelInstrument or r:instructieregelTaakuitoefening) and
                    not(r:instructieregelInstrument and r:instructieregelTaakuitoefening)"
                > H:TPOD1630_TPOD1690: behorend bij ArtikelOfLid <sch:value-of select="r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>:Een instructie heeft een instructieregelInstrument of een instructieTaakUitoefening, maar nooit beiden. </sch:assert>
            <!-- Instructieregel is een taak -->
            <sch:assert
                test="
                (r:instructieregelTaakuitoefening) and not(r:instructieregelInstrument)"
                > H:TPOD1630: behorend bij ArtikelOfLid <sch:value-of select="r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>:Het attribuut 'instructieregelTaakuitoefening' binnen het object
                'Instructieregel' is verplicht wanneer Instructieregel gaat over de uitoefening van
                een taak. </sch:assert>
            <!-- Instructieregel is een instrument -->
            <sch:assert
                test="
                (r:instructieregelInstrument) and not(r:instructieregelTaakuitoefening)"
                > H:TPOD1690: behorend bij ArtikelOfLid <sch:value-of select="r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>:instructieregelInstrument is alleen te gebruiken wanneer de Instructieregel zich richt tot een instrument. </sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="TPOD1670">
        <sch:rule
            context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/r:RegelVoorIedereen">
            <sch:assert
                test="(r:activiteitaanduiding) or (not(r:activiteitaanduiding) and not(r:activiteitregelkwalificatie))"
                > H:TPOD1670: behorend bij ArtikelOfLid <sch:value-of select="r:artikelOfLid/r-ref:RegeltekstRef/@xlink:href"/>: Activiteitregelkwalificatie is alleen te gebruiken wanneer het object
                ‘Regel voor iedereen’ is geannoteerd met Activiteit. </sch:assert>
        </sch:rule>
    </sch:pattern>


    <!-- de activiteitenlijst bevat alle activiteiten ids -->
    <xsl:variable name="activiteitenLijst">
        <xsl:for-each
            select="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <xsl:value-of select="rol:identificatie"/>
            <xsl:message><xsl:value-of select="rol:identificatie"/></xsl:message>
        </xsl:for-each>
    </xsl:variable>

    <xsl:function name="foo:circulaireActiviteiten">
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="bovenliggend" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:for-each
            select="$context/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <xsl:if
                test="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href = $bovenliggend">
                <xsl:variable name="lokaalBovenliggend" select="rol:identificatie"/>
                <xsl:choose>
                    <xsl:when test="$identificatie = $lokaalBovenliggend">
                        <xsl:value-of select="concat($lokaalBovenliggend, ', ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="foo:circulaireActiviteiten($identificatie, $lokaalBovenliggend, /)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="foo:activiteitenPad">
        <xsl:param name="identificatie" as="xs:string"/>
        <xsl:param name="bovenliggend" as="xs:string"/>
        <xsl:param name="activiteitenLijst" as="xs:string*"/>
        <xsl:param name="context" as="node()"/>
        <xsl:for-each
            select="$context/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <xsl:if test="rol:identificatie = $bovenliggend">
                <xsl:variable name="lokaalBovenliggend"
                    select="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>
                <xsl:choose>
                    <xsl:when test="not(contains($activiteitenLijst, $lokaalBovenliggend))">
                        <xsl:value-of select="concat($identificatie, ', ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="foo:activiteitenPad($identificatie, $lokaalBovenliggend, $activiteitenLijst, /)"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <sch:pattern id="TPOD1700_TPOD1710_TPOD1730">
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/rol:Activiteit">
            <!-- TPOD1710  -->
            <!-- Er wordt uitgegaan van een maximale diepte van Ow-Activiteiten-hierarchie binnen een besluit context van 6 lagen (in werkelijkheid komen er
            in een OW-set maar enkele lagen van hierarchie voor voordat er naar een functionele structuur wordt verwezen).
            
            Waarom niet in een functie?
            Dit kan eventueel ook binnen een recursieve functie worden gedaan, maar dan moet er worden gecontroleerd op circulaire structuren, 
            dat veroorzaakt extra code, binnen schematron een ingewikkeld algoritme, de functie kan in latere optimalisatie worden geschreven.
            -->
            <!-- Uiteindelijk bevatten de offendingIds activiteiten die circulair over andere activiteiten naar zichzelf verwijzen -->

            <xsl:variable name="circulaireActivititeiten">
                <xsl:variable name="bovenLiggend"
                    select="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>
                <xsl:variable name="identificatie" select="rol:identificatie"/>
                <!-- hier worden de activiteiten uitgefilterd waarvan de bovenliggende activiteiten in de functionele structuur zitten -->
                <xsl:if test="contains($activiteitenLijst, $bovenLiggend)">
                    <xsl:value-of
                        select="foo:circulaireActiviteiten($identificatie, $identificatie, /)"/>
                </xsl:if>
            </xsl:variable>

            <!-- TPOD1700  -->
            <!-- Omdat de offendingIds circuliaire verwijzingen zijn worden ze niet gebruikt bij de volgende test waarbij gekeken wordt of iedere activiteit
            uiteindelijk bij een functionele activiteit uitkomt -->

            <xsl:variable name="activiteitenTrajectNaarFunctioneleStructuur">
                <xsl:variable name="identificatie" select="rol:identificatie"/>
                <xsl:variable name="lokaalBovenliggend"
                    select="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>
                <!-- hier worden de activiteiten uitgefilterd waarvan de bovenliggende activiteiten in de functionele structuur zitten -->
                <xsl:if test="not(contains($circulaireActivititeiten, $identificatie))">
                    <xsl:choose>
                        <xsl:when test="not(contains($activiteitenLijst, $lokaalBovenliggend))">
                            <xsl:value-of select="concat($identificatie, ', ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="foo:activiteitenPad($identificatie, $lokaalBovenliggend, $activiteitenLijst, /)"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>

            <!-- TPOD1700  -->
            <sch:report test="string-length($activiteitenTrajectNaarFunctioneleStructuur) > 0"
                >REPORT: ZH:TPOD1700: Activiteit-ids: <sch:value-of
                    select="$activiteitenTrajectNaarFunctioneleStructuur"/>: Voor elke hiërarchie
                van nieuwe activiteiten geldt dat de hoogste activiteit in de hiërarchie een
                bovenliggende activiteit moet hebben die reeds bestaat in de functionele structuur.
                DIT LAATSTE WORDT NU NOG NIET GETEST </sch:report>
            <!-- TPOD1710  -->
            <sch:assert test="string-length($circulaireActivititeiten) = 0">ZH:TP0D1710:
                Activiteit-ids: <sch:value-of select="$circulaireActivititeiten"/>: Een
                bovenliggende activiteit mag niet naar een activiteit verwijzen die lager in de
                hiërarchie ligt.</sch:assert>
            <!-- TPOD1730  -->
            <sch:assert
                test="contains($activiteitenLijst, rol:gerelateerdeActiviteit/rol-ref:ActiviteitRef/@xlink:href)"
                >H:TPOD1730: <sch:value-of
                    select="rol:identificatie"/> Betreft verwijzing: 
                <sch:value-of select="rol:gerelateerdeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>: Gerelateerde activiteiten moeten
                bestaan indien er naar verwezen wordt.</sch:assert>
            <!-- TPOD1740  -->
            <sch:report test="not(contains($activiteitenLijst, rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href))"> REPORT: H:TPOD1740: <sch:value-of
                select="rol:identificatie"
            />:  Betreft verwijzing: <sch:value-of select="rol:bovenliggendeActiviteit/rol-ref:ActiviteitRef/@xlink:href"/>: Bovenliggende 
                activiteiten moeten bestaan indien er naar verwezen wordt. DIT LAATSTE WORDT NU NOG
                NIET GETEST</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="TPOD1760">
        <xsl:variable name="featureMembers">
            <xsl:variable name="xmlDocumenten"
                select="document('manifest.xml')//lvbb:manifest/lvbb:bestand/lvbb:bestandsnaam"/>
            <xsl:message><xsl:value-of select="."/></xsl:message>
            <xsl:for-each select="$xmlDocumenten">
                <xsl:variable name="filename" select="."/>
                <xsl:if test="document($filename)//geo:FeatureCollectionGeometrie">
                    <xsl:copy-of
                        select="document($filename)//geo:FeatureCollectionGeometrie/geo:featureMember"
                    />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <sch:rule context="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/ga:Gebiedsaanwijzing">
            <sch:assert test="string-length(foo:isGebiedaanwijzingvanTypegebied(., $featureMembers))=0">
                H:TPOD1760: Betreft <sch:value-of select="ga:identificatie"/>: Een gebiedsaanwijzing moet een gebied of gebiedengroep zijn (en mag
                geen punt, puntengroep, lijn of lijnengroep zijn).
            </sch:assert>
        </sch:rule>
    </sch:pattern>


    <xsl:function name="foo:isGebiedaanwijzingvanTypegebied"> 
        <xsl:param name="context" as="node()"/>
        <xsl:param name="featureMembers" as="node()*"/>
        <xsl:for-each select="$context/ga:locatieaanduiding/l-ref:LocatieRef">
        <xsl:choose>
            <xsl:when test="contains(@xlink:href, 'gebiedengroep')">
                <xsl:for-each select="$gebiedenGroepen">
                    <xsl:if test="$gebiedenGroepen/l:identificatie=$context/ga:locatieaanduiding/l-ref:LocatieRef/@xlink:href">
                        <xsl:value-of select="foo:isGebiedvanTypegebied(l:groepselement/l-ref:GebiedRef/@xlink:href, $featureMembers)"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="foo:isGebiedvanTypegebied($context/ga:locatieaanduiding/l-ref:LocatieRef/@xlink:href, $featureMembers)"/>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="foo:isGebiedvanTypegebied"> 
        <xsl:param name="id" as="xs:string"/>
        <xsl:param name="featureMembers" as="node()*"/>
        <xsl:for-each select="$gebieden">
            <xsl:if test="l:geometrie/g-ref:GeometrieRef/@xlink:href = $id">
                <xsl:value-of select="foo:isGeometrievanTypegebied($id, $featureMembers)"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <xsl:function name="foo:isGeometrievanTypegebied">
        <xsl:param name="geoId" as="xs:string"/>
        <xsl:param name="featureMembers" as="node()*"/>
        <xsl:for-each select="$featureMembers/geo:Geometrie/geo:id ">
            <xsl:if test=". eq $geoId">
                <xsl:if test="not(descendant::gml:Polygon)">
                    <xsl:value-of select="false()"/> 
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    
</sch:schema>
