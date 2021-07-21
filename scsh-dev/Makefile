# $Thinkum$

DISTNAME=		scsh-dev-${SCSH_VERSION}
PKGREVISION=		1.${GIT_REVISION.scsh}.1
CATEGORIES=		shells lang

## NB: Reusing the present VERSION value from WRKSRC/Makefile.in
SCSH_VERSION=		0.7

MAINTAINER=		spchamp@users.noreply.github.com
HOMEPAGE=		http://www.scsh.net/
COMMENT=		A Unix shell embedded in Scheme - Development Release
LICENSE=		modified-bsd

GIT_REPOSITORIES+=	scsh
GIT_REPO.scsh=		https://github.com/scheme/scsh.git
GIT_REVISION.scsh=	1144324
GIT_EXTRACTDIR.scsh=	scsh-dev
GIT_SUBMODULES.scsh=	rx

WRKSRC=			${WRKDIR}/${GIT_EXTRACTDIR.scsh}

USE_TOOLS+=		autoconf gmake
GNU_CONFIGURE=		yes

CONFIGURE_ARGS+=	--with-scheme48=${LOCALBASE}
BUILD_TARGET=		enough
TEST_TARGET=		test

SCSH_DOC_DIR=		${DESTDIR}/${LOCALBASE}/share/doc/scsh

PATCH_STRIP=		-p1
PATCHDIR=		patches
## NB: The patch provided, here, in effect reverts the changeset
## introduced in 1144324 which in itself reverted cb44594 in
## changesets at the scsh repository at GitHub.
##
## Alternate to patching, this port could use
## GIT_REVISION.scsh=	5748401
## such that reprsents both a changeset between each of
## cb44594 and 1144324, and in effect, the changeset
## before 1144324

PKG_SHELL=		bin/scsh

SUBST_CLASSES+= 	shpath
SUBST_FILES.shpath=	build/build-image.sh
SUBST_SED.shpath=	-e 's@/bin/sh@${TOOLS_PLATFORM.sh}@'
SUBST_MESSAGE.shpath=	Update shell pathname for scripts
SUBST_STAGE.shpath=	post-patch

PLIST_SUBST+=		SCSH_VERSION=${SCSH_VERSION}

DEPENDS+=		scheme48>=1.9.2:../../lang/scheme48/

.if exists(../../lang/scheme48/buildlink3.mk)
.include "../../lang/scheme48/buildlink3.mk"
.else
## \ TBD: Add a buildlink3.mk for lang/scheme48:scheme48

BUILDLINK_TREE+=        scheme48

.if !defined(SCHEME48_BUILDLINK3_MK)
SCHEME48_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.scheme48+=    scheme48>=1.9.2
BUILDLINK_ABI_DEPENDS.scheme48+=    scheme48>=1.9.2
BUILDLINK_PKGSRCDIR.scheme48?=      ../../lang/scheme48

.endif # SCHEME48_BUILDLINK3_MK

BUILDLINK_TREE+=        -scheme48
## /
.endif ## exists lang/scheme48 buildink3.mk


pre-configure:
	(cd ${WRKSRC}; autoreconf)

## NB: The scsh repository at GitHub has published some documentation
## https://github.com/scheme/scsh/tree/master/doc
## such that uses a Scribble notation.
##
## See also
## https://scsh.net/docu/docu.html
## and for scsh 0.6.7
## https://github.com/rmloveland/scsh-manual-texinfo

post-build:
	${INSTALL_DATA_DIR} ${SCSH_DOC_DIR}; \
	  ${INSTALL_DATA} ${WRKSRC}/COPYING ${SCSH_DOC_DIR}/COPYING

.include "../../wip/mk/git-package.mk"
.include "../../mk/bsd.pkg.mk"
