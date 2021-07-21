# $NetBSD$: Makefile,v 1.4 2014/10/08 04:20:15 makoto Exp $

DISTNAME=	magit-${_GIT_PKGVERSION:S/.//g}
PKGREVISION=	1
CATEGORIES=	devel

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/magit/magit/
COMMENT=	Emacs client for scm Git
LICENSE=	gnu-gpl-v3

GIT_REPOSITORIES=	magit transient with-editor
.for PROJ in ${GIT_REPOSITORIES}
GIT_REPO.${PROJ}= 	https://github.com/magit/${PROJ}.git
GIT_MODULE.${PROJ}=	${PROJ}
.endfor

WRKSRC=		${WRKDIR}/${GIT_EXTRACTDIR.magit}
NO_CONFIGURE=	yes
USE_LANGUAGES=	# none
USE_TOOLS+=	gmake makeinfo

INFO_FILES+=	magit.info
#BUILD_TARGET=	all
TEST_TARGET=	test

EMACS_BUILDLINK=	# Defined

.include "../../mk/bsd.prefs.mk"
##
## NB: libegit2 needs an Emacs built with shared module support, which
## may be available with default options in wip/emacs*git pkgs (patched)
##
## Granted, magit can be used without libegit2. 
##
## Presently, this port requires libegit2 - it may be trivial to make
## this an optional feature, with a conditional form in a port options.mk
##
## TBD: Message text cf. magit-inhibit-libgit in magit-git.el
##      Mostly relevant for Magit builds with libegit2 support
##
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"
.include "../../wip/dash-el-git/buildlink3.mk"
.include "../../wip/libegit2-git/buildlink3.mk"

ALL_ENV+=		EMACS=${EMACS_BIN:Q} 	## used in transient, with-editor
ALL_ENV+=		EMACSBIN=${EMACS_BIN:Q} ## used in magit
ALL_ENV+=		MAKEINFO=${MAKEINFO:Q}
ALl_ENV+=		INSTALL_INFO=${INSTALL_INFO:Q}

MAGIT_BLNK_DEPS=	dash libegit2

.for CDEP in ${MAGIT_BLNK_DEPS}
MAGIT_DIR.${CDEP}=	${EMACS_LISPPREFIX}/${CDEP}
.endfor

###
### Build/Install for local dependencies
###
### NB: This pkg might function as something like a meta-pkg - or simply
###     a bundled package - for the source code, Emacs bytecode, and
###     documentation for the transient, with-editor, and magit
###     projects.
###
###     Insofar as for building the transient and with-editor components
###     as dependencies local to this bundled port, these bundled
###     components will be built and staged under DESTDIR, using a common
###     set of makefile clauses, defined below.
###
### TBD: Buildlink3 declarations for transient.el and with-editor.el
###      (This port does provide a buildlink3.mk for magit itself)
###

MAGIT_LOCAL_DEPS=		transient with-editor

MAGIT_LISP_FILES.transient=	lisp/transient.el
MAGIT_LISP_DEPS.transient=	dash
MAGIT_INFO_FILES.transient=	docs/transient.info
MAGIT_LISP_FILES.with-editor=	with-editor.el
MAGIT_LISP_DEPS.with-editor=	# empty
MAGIT_INFO_FILES.with-editor=	with-editor.info

.for LDEP in ${MAGIT_LOCAL_DEPS}
INFO_FILES+=			${MAGIT_INFO_FILES.${LDEP}:C/^.*\///}
MAGIT_DIR.${LDEP}=		${WRKDIR}/${LDEP}
MAGIT_DEP_BUILD_TGTS+=		magit-build-${LDEP}
MAGIT_DEP_INSTALL_TGTS+=	magit-install-${LDEP}

magit-build-${LDEP}:
	@${PKG_SETENV} ${MAKE_ENV} ${GMAKE} -C ${WRKDIR}/${LDEP} lisp info \
		LOAD_PATH=${MAGIT_LISP_DEPS.${LDEP}:@DIR@-L ${EMACS_LISPPREFIX}/${DIR}@:Q}

magit-install-${LDEP}: magit-ldep-install-common
	@${PKG_SETENV} ${INSTALL_ENV} \
		${INSTALL_DATA_DIR} ${DESTDIR}${EMACS_LISPPREFIX}/${LDEP}
	@cd ${WRKDIR}/${LDEP} && ${PKG_SETENV} ${INSTALL_ENV} ${INSTALL_DATA} \
		${MAGIT_LISP_FILES.${LDEP}} ${MAGIT_LISP_FILES.${LDEP}:S/.el$/.elc/} \
		${DESTDIR}${EMACS_LISPPREFIX}/${LDEP}
	@cd ${WRKDIR}/${LDEP} && ${PKG_SETENV} ${INSTALL_ENV} \
		${INSTALL} ${COPY} -o ${DOCOWN} -g ${DOCGRP} -m ${DOCMODE} \
		${MAGIT_INFO_FILES.${LDEP}} ${DESTDIR}${PREFIX}/${PKGINFODIR}
	@${PKG_SETENV} ${INSTALL_ENV} \
		${INSTALL} -d -o ${DOCOWN} -g ${DOCGRP} -m ${PKGDIRMODE} \
		${DESTDIR}${PREFIX}/share/doc/${LDEP}
	@cd ${WRKDIR}/${LDEP} && ${PKG_SETENV} ${INSTALL_ENV} \
		${INSTALL_DATA} LICENSE ${DESTDIR}${PREFIX}/share/doc/${LDEP}
.endfor


magit-ldep-install-common:
	@${PKG_SETENV} ${INSTALL_ENV} \
		${INSTALL} -d -o ${DOCOWN} -g ${DOCGRP} -m ${PKGDIRMODE} \
		${DESTDIR}${PREFIX}/${PKGINFODIR}

###
### Build/Install for magit
###

MAGIT_ENV+=	lispdir=${EMACS_LISPPREFIX}/magit
MAGIT_ENV+=	infodir=${PREFIX}/${PKGINFODIR}
MAGIT_ENV+=	docdir=${PREFIX}/share/doc/magit

## TBD: Build options + deps for magit documentation in HTML and PDF formats

do-build: ${MAGIT_DEP_BUILD_TGTS}
	@${PKG_SETENV} ${MAKE_ENV} ${MAGIT_ENV} \
		${GMAKE} -C ${WRKDIR}/${GIT_MODULE.magit} lisp info \
		DASH_DIR=${MAGIT_DIR.dash:Q} LIBGIT_DIR=${MAGIT_DIR.libegit2:Q} \
		TRANSIENT_DIR=${MAGIT_DIR.transient:Q}/lisp \
		WITH_EDITOR_DIR=${MAGIT_DIR.with-editor:Q}

do-install: ${MAGIT_DEP_INSTALL_TGTS}
	@${PKG_SETENV} ${INSTALL_ENV} ${MAGIT_ENV} \
		${GMAKE} -C ${WRKDIR}/${GIT_MODULE.magit} \
		install-lisp install-docs install-info 

.include "../../wip/mk/git-package.mk"
.include "../../mk/bsd.pkg.mk"
