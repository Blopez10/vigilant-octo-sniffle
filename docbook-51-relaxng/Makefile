# $Thinkum$

DISTNAME=	docbook-51-relaxng
PKGNAME=	${DISTNAME}-5.1.os
PKGREVISION=	1
CATEGORIES=	textproc

MAINTAINER=	qa@thinkum.space
HOMEPAGE=	https://www.docbook.org/
COMMENT=	DocBook 5.1 grammar in RELAX NG XML and Compact notations
LICENSE=	docbook-5.1

## FIXME files/COPYING or a subset of text from the 5.1-os OASIS
## standard for DocBook 5.1 should be included in pkgsrc/licenses
## subsequent of any adoption of this pkg in pkgsrc main, as e.g
## /usr/pkgsrc/licenses/docbook-5.1
##
## In effect, the file file/COPYING may serve as providing an interim,
## pkg-visible representation of the licensing terms for this software.

MASTER_SITES=	https://docbook.org/xml/5.1/
DISTFILES=	docbook-v5.1-os.zip

EXTRACT_DIR=	${WRKDIR}/${PKGNAME_NOREV}

NO_CONFIGURE=	# Defined
NO_BUILD=	# Defined

DB5_XML_PREFIX= ${PREFIX}/share/xml/docbook/5.1
DB5_DOC_PREFIX= ${PREFIX}/share/doc/docbook-51-relaxng

DB5_XML_SRC=	docbook.nvdl catalog.xml

.for MOD in docbook assembly dbits docbookxi
.  for TYP in rnc rng
DB5_RNG_SRC+=	${MOD}.${TYP}
.  endfor
DB5_SCH_SRC+=	${MOD}.sch
.endfor

DB5_DOC_SRC=	docbook-v5.1-os.html docbook-v5.1-os.pdf docbook-v5.1-os.xml

XML_CATALOGS=	${DB5_XML_PREFIX}/catalog.xml

do-install:
	${INSTALL_DATA_DIR} ${DESTDIR}${DB5_XML_PREFIX} \
		${DESTDIR}${DB5_XML_PREFIX}/rng ${DESTDIR}${DB5_XML_PREFIX}/sch
	cd ${EXTRACT_DIR}/schemas && ${INSTALL_DATA} \
		${DB5_XML_SRC} ${DESTDIR}${DB5_XML_PREFIX}
	cd ${EXTRACT_DIR}/schemas/rng && ${INSTALL_DATA} \
		${DB5_RNG_SRC} ${DESTDIR}${DB5_XML_PREFIX}/rng
	cd ${EXTRACT_DIR}/schemas/sch && ${INSTALL_DATA} \
		${DB5_SCH_SRC} ${DESTDIR}${DB5_XML_PREFIX}/sch
	${INSTALL} -d -o ${DOCOWN} -g ${DOCGRP} -m ${PKGDIRMODE} ${DESTDIR}${DB5_DOC_PREFIX}
	cd ${EXTRACT_DIR} && ${INSTALL} ${COPY} -o ${DOCOWN} -g ${DOCGRP} -m ${DOCMODE} \
		${DB5_DOC_SRC} ${DESTDIR}${DB5_DOC_PREFIX}
	${INSTALL_DATA} files/COPYING ${DESTDIR}${DB5_DOC_PREFIX}

.include "../../textproc/xmlcatmgr/catalogs.mk"
.include "../../mk/bsd.pkg.mk"
