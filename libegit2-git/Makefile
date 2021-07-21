# $Thinkum$

DISTNAME=	libegit2-${_GIT_PKGVERSION:S/.//g}
PKGREVISION=	1
CATEGORIES=	devel

MAINTAINER=	qa@thinkum.space
HOMEPAGE=	https://github.com/magit/libegit2
COMMENT=	Emacs bindings for libgit2
LICENSE=	gnu-gpl-v2

CONFLICTS+=	libgit2-[0-9]*

EGIT_EL_BASE= 	${PKGBASE}
EGIT_EL_DEST=	${DESTDIR}${EMACS_LISPPREFIX}/${EGIT_EL_BASE}
EGIT_DOC_DEST=	${DESTDIR}${PREFIX}/share/doc/${PKGBASE}
PLIST_SUBST+=	ELBASE=${EGIT_EL_BASE}
PLIST_SUBST+=	DOCBASE=${PKGBASE}

GIT_REPOSITORIES=		egit 
GIT_REPO.egit=			https://github.com/magit/libegit2.git
GIT_EXTRACTDIR.egit=		libegit2
GIT_FETCH_RECURSIVE.egit=	yes
GIT_SUBMODULES.egit=		libgit2
WRKSRC=				${WRKDIR}/${GIT_EXTRACTDIR.egit}

USE_CMAKE=	yes
USE_TOOLS+=	cmake ninja-build
USE_LANGUAGES+= c c++

EMACS_BUILDLINK=	# Defined

.include "../../mk/bsd.prefs.mk"
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"

.if empty(PKG_OPTIONS.emacs:Mmodules)
PKG_FAIL_REASON+="Dynamic module support not configured for Emacs: ${PKG_OPTIONS.emacs}"
.endif

EGIT_EL_SRC=	libgit.el
.for EL in ${EGIT_EL_SRC}
EGIT_EL_ELC+=	${EL:S/.el$/.elc/}
.endfor

EGIT_MOD_SO=	libegit2.so

##
## NB: ninja-build may support build parallelization, in some system
## configurations in which (by default) CMake itself may not, during the
## build. So, this pkg usees ninja-build.
##
BUILD_DEPENDS+=	ninja-build-[0-9]*:../../devel/ninja-build
CMAKE_ARGS+=	-GNinja
do-build:
	@cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ninja ${MAKE_JOBS:D-j ${MAKE_JOBS}}

do-install:
	@cd ${WRKSRC} && \
		 ${SETENV} ${INSTALL_ENV} ninja install ${MAKE_JOBS:D-j ${MAKE_JOBS}}
	cd ${WRKSRC} && ${EMACS_BIN} -batch -L ${WRKSRC} \
		-f batch-byte-compile ${EGIT_EL_SRC}
	${INSTALL_DATA_DIR} ${EGIT_EL_DEST}
	cd ${WRKSRC} && ${INSTALL_DATA} \
		${EGIT_EL_SRC} ${EGIT_EL_ELC} ${EGIT_EL_DEST}
	${INSTALL_DATA_DIR} ${EGIT_EL_DEST}/build
	cd ${WRKSRC} && ${INSTALL_DATA} \
		${EGIT_MOD_SO} ${EGIT_EL_DEST}/build
	${INSTALL_DATA_DIR} ${EGIT_DOC_DEST}
	cd ${WRKSRC} && ${INSTALL_DATA} LICENSE ${EGIT_DOC_DEST}

## NB: This reuses much of the configuration of devel/libgit2

.include "../../security/libssh2/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../www/http-parser/buildlink3.mk"
.include "../../wip/mk/git-package.mk"
.include "../../mk/bsd.pkg.mk"
