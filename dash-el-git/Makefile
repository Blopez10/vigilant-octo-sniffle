# $Thinkum$

DISTNAME=	dash-el-${_GIT_PKGVERSION:S/.//g}
PKGREVISION=	1
CATEGORIES=	devel

MAINTAINER=	qa@thinkum.space
HOMEPAGE=	https://github.com/magnars/dash.el
COMMENT=	Functional operations on sets and sequences
LICENSE=	gnu-gpl-v3

DASH_EL_BASE= 	${PKGBASE:S/-el$//}
DASH_EL_DEST=	${DESTDIR}${EMACS_LISPPREFIX}/${DASH_EL_BASE}
DASH_DOC_DEST=	${DESTDIR}${PREFIX}/share/doc/${PKGBASE}
DASH_EG_DEST=	${DASH_DOC_DEST}/examples
PLIST_SUBST+=	ELBASE=${DASH_EL_BASE}
PLIST_SUBST+=	DOCBASE=${PKGBASE}

GIT_REPOSITORIES=	dash
GIT_REPO.dash=		https://github.com/magnars/dash.el.git
GIT_EXTRACTDIR.dash=	${PKGBASE}
WRKSRC=			${WRKDIR}/${GIT_EXTRACTDIR.dash}

NO_CONFIGURE=	yes
USE_TOOLS+=	makeinfo
## cf. mk/pkgtasks/info_files.mk
INFO_FILES=	${DASH_INFO}
DASH_INFO_DEST= 

EMACS_BUILDLINK=	# Defined

.include "../../mk/bsd.prefs.mk"
#.include <bsd.info.mk>
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"

DASH_EL_SRC=	dash.el dash-functional.el 
.for EL in ${DASH_EL_SRC}
DASH_EL_ELC+=	${EL:S/.el$/.elc/}
.endfor

## NB: The file examples-to-docs.el defines the macro `def-examples-group'
##     as used in examples.el
DASH_EG_SRC=	dev/examples-to-docs.el dev/examples.el dev/examples-to-info.el
##
## Prototype - complimentary to the commented-out makefile declarations, below
##
#.for EL in ${DASH_EL_ELC}
#DASH_LOAD_EL+=-l ${EL}
#.endfor
#.for EL in ${DASH_EG_SRC} 
## NB: The example files will not be evaluated during the build, at this
## time, but will be installed as example source files.
#DASH_LOAD_EG+=-l ${EL}
#.endfor

DASH_INFO=	dash.info
DASH_TEXI=	dash.texi

do-build:
	cd ${WRKSRC} && ${EMACS_BIN} -batch -L ${WRKSRC} \
		-f batch-byte-compile ${DASH_EL_SRC}
## NB: The following would overwrite some upstream source files, and may 
## result in dash.texi being unparseable by makeinfo -- without further
## processing, to escape \([{}]\)=>@\1 at a certain line of source text,
## in the generated texinfo file. Lastly, it may result in a dash.info
## with some peculiarities in regards to the syntax of functions and
## macros documented in the file. 
##
## This pkg may reuse the existing dash.texi from upstream.
##
#	cd ${WRKSRC} && ${EMACS_BIN} -batch -L ${WRKSRC:Q} ${DASH_LOAD_EL} ${DASH_LOAD_EG} -f create-docs-file
#	cd ${WRKSRC} && ${EMACS_BIN} -batch -L ${WRKSRC:Q} ${DASH_LOAD_EL} ${DASH_LOAD_EG} -f create-info-file
## Rebuilding dash.info locally from the upstream dash.texi
## NB: INFOFLAGS is defined in the system mk-file bsd.info.mk
	cd ${WRKSRC} && ${TOOLS_CMD.makeinfo} ${INFOFLAGS} --no-split \
		-o ${DASH_INFO} ${DASH_TEXI}

do-install:
	${INSTALL_DATA_DIR} ${DASH_EL_DEST}
	cd ${WRKSRC} && ${INSTALL_DATA} ${DASH_EL_SRC} ${DASH_EL_ELC} ${DASH_EL_DEST}
	${INSTALL_DATA_DIR} ${DASH_EG_DEST}
	cd ${WRKSRC} && ${INSTALL_DATA} ${DASH_EG_SRC} ${DASH_EG_DEST}
	cd ${WRKSRC} && ${INSTALL_DATA} LICENSE ${DASH_DOC_DEST}
	${INSTALL} -d -o ${DOCOWN} -g ${DOCGRP} -m ${PKGDIRMODE} \
		${DESTDIR}${PREFIX}/${PKGINFODIR}
	${INSTALL} ${COPY} -o ${DOCOWN} -g ${DOCGRP} -m ${DOCMODE} \
		${WRKSRC}/${DASH_INFO} ${DESTDIR}${PREFIX}/${PKGINFODIR}


.include "../../wip/mk/git-package.mk"
.include "../../mk/bsd.pkg.mk"
