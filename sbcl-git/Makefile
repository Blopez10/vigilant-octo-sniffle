# $NetBSD: Makefile,v 1.43 2014/10/09 14:06:30 thomasklausner Exp $

DISTNAME=		sbcl-source-${GIT_TAG.sbcl:S/^sbcl-//:U${_GIT_PKGVERSION:S/.//g}}
PKGNAME=		${DISTNAME:S/-source//}
PKGREVISION=		1
CATEGORIES=		lang

MAINTAINER=		asau@users.sourceforge.net
HOMEPAGE=		http://www.sbcl.org/
COMMENT=		SBCL, a Common Lisp implementation

GIT_REPOSITORIES=	sbcl
GIT_REPO.sbcl=		git://git.code.sf.net/p/sbcl/sbcl

.include "../../mk/bsd.prefs.mk"
.include "../../wip/mk/git-package.mk"

USE_TOOLS+=		gmake gtar:run patch

WRKSRC=			${WRKDIR}/${GIT_EXTRACTDIR.sbcl}

BUILD_DEFS+=		SBCL_BOOT_SYSTEM

MAKE_ENV+=		CCACHE_DISABLE=Defined

## FIXME:
## 1) make a port wip/sbcl-bin
## 2) use wip/sbcl-bin (no threads) to bootstrap wip/sbcl-git
##
## NB: Do similar, with CCL.
##
## NB: This may, in effect, emulate some of the support provided in the
## FreeBSD lang/sbcl port.


## Remarks about OPSYS support
##
## SBCL 1.2.7 is the last release denoted as supported for *BSD, at the
## SBCL web site.
##
## Overall, threaded builds may not be recommended for this pkg, on any BSD
##
## Threaded builds may be possible on some BSD, under such as
## GIT_TAG.sbcl=sbcl-1.5.6 - seen up to SBCL 1.5.6 with external builds
## under FreeBSD 11.2, bootstrapping with SBCL 1.5.5 or 1.5.6, clang 8
## as CC, LLVM LLD 8 as LD
##
## SBCL 1.5.7 may not build under most configurations, on some BSD.
##
## All of this should be fairly well supported in Linux environments,
## for any SBCL version and any toolchain configuration.
##
## TBD: Build testing under Linux ABI interoperability, on any non-Linux
## OPSYS
##
## How to ensure that this port uses SBCL 1.5.6 for any BSD
## - a mk.conf snippet
##
#  .if !empty(OPSYS:M*BSD)
#  GIT_TAG.sbcl		=sbcl-1.5.6
#  .endif
#


#
# Bootstrap section.
#
# SBCL needs an existing Common Lisp system to build it...
# Currently allowed systems are CLISP, CMUCL, OpenMCL, and SBCL itself.
#
#  If SBCL is installed in an unusual place when trying to build this
#  package, you may need to set the full path in SBCL_BOOT_SYSTEM and
#  build the package with "SBCL_HOME=/path/to/SBCL/core/image/ make"

#SBCL_BOOT_SYSTEM=	clisp			# CLisp
#SBCL_BOOT_SYSTEM=	"lisp -batch"		# CMUCL
#SBCL_BOOT_SYSTEM=	"openmcl --batch"	# OpenMCL
#SBCL_BOOT_SYSTEM=	sbcl			# SBCL

.if !defined(SBCL_BOOT_SYSTEM)
# Use "clisp -ansi -on-error abort" to make the build more reproducible,
# per Christophe Rhodes:
SBCL_BOOT_SYSTEM=	clisp -norc -ansi -on-error abort
BUILD_DEPENDS+=		clisp-[0-9]*:../../lang/clisp
UNLIMIT_RESOURCES=	datasize
.elif ${SBCL_BOOT_SYSTEM} == clisp
BUILD_DEPENDS+=		clisp-[0-9]*:../../lang/clisp
UNLIMIT_RESOURCES=	datasize
.elif ${SBCL_BOOT_SYSTEM} == sbcl
# Get bootstrap version:
BUILD_DEPENDS+=		sbcl-[0-9]*:../../lang/sbcl
.endif

SUBST_CLASSES+=			fix-paths
SUBST_STAGE.fix-paths=		pre-configure
SUBST_MESSAGE.fix-paths=	Fixing absolute paths.
SUBST_FILES.fix-paths=		doc/sbcl.1 doc/manual/intro.texinfo doc/manual/start-stop.texinfo
SUBST_VARS.fix-paths=		PREFIX
#SUBST_SED.fix-paths+=		-e 's,/var/log,${VARBASE}/log,g'

SUBST_CLASSES+=			trim-version
SUBST_STAGE.trim-version=	post-configure
SUBST_MESSAGE.trim-version=	Clean up version.lisp-expr
SUBST_FILES.trim-version=	version.lisp-expr
SUBST_SED.trim-version=		-e 's,-dirty",",'


.if !empty(OPSYS:MNetBSD)
## NB: This patch will probably fail w/ the current SBCL src.
##
## The newer asdf-module.mk system, now used in sb-prof, may need to be
## tested for the affected test tgt, on a NetBSD system. Ideally,
## the asdf-module.mk src may not need a patch for the build
_PKGSRC_PATCHES+= ${PATCHDIR}/nb-patch-revert-37d3828773e2f847bb1ed7522b0af4fb8e736fc8
.endif

.include "options.mk"

.for OPT in ${SBCL_BUILD_WITH_OPTIONS}
SBCL_BUILD_OPTIONS+=	--with-${OPT}
.endfor

.for OPT in ${SBCL_BUILD_WITHOUT_OPTIONS}
SBCL_BUILD_OPTIONS+=	--without-${OPT}
.endfor

.PHONY: do-docs-build

.if !empty(PKG_OPTIONS:Mdoc)
PLIST_SUBST+=		INFODIR=${PKGINFODIR}
INFO_FILES+=		${WRKSRC}/doc/manual/*.info ${WRKSRC}/doc/manual/*.info-[1-9]*
INFO_FILES+=		${WRKSRC}/doc/internals/*.info ${WRKSRC}/doc/internals/*.info-[1-9]*
## NB: PERL and graphviz (dot) will be needed for 'make info' in doc/internals/
USE_TOOLS+=		perl
TOOL_DEPENDS+=		graphviz-[0-9]*:../../graphics/graphviz

do-docs-build: ## NB: needs 'build' as an implicit prereq
	${GMAKE} -C ${WRKSRC}/doc/manual/ info MAKEINFO=${MAKEINFO}
	${GMAKE} -C ${WRKSRC}/doc/internals/ info MAKEINFO=${MAKEINFO}
.else
do-docs-build:
.endif

## NB - A synopsis for the following
##
## In pre-configure:
## - Patch make-config.sh to not re-run generate-version.sh
##   when the file version.lisp-expr exists
##
## Then, in do-configure:
## - Run generate-version.sh once (via make-config.sh)
##
## Subsequently, in post-configure:
## - Trim the '-dirty' flag from version.lisp-expr, using subst classes.
##   Assuming that the patches applied in this pkg will not modify
##   any souce files under SBCL 'src', the '-dirty' flag may appear
##   misleading, for some purposes of systems review.
##

do-configure:
	cd ${WRKSRC} && ${PKGSRC_SETENV} ${CONFIGURE_ENV} GNUMAKE=${GMAKE} ${SH} \
	  make-config.sh --prefix=${PREFIX} --xc-host=${SBCL_BOOT_SYSTEM:Q} ${SBCL_BUILD_OPTIONS}

post-configure:
	@SRC_VERSION=$$(${TAIL} -n1 ${WRKSRC}/version.lisp-expr); \
		VERSION=$$( ${ECHO} "$${SRC_VERSION}" | \
		${SED} -e 's@"\([1-9][0-9]*\.[1-9][0-9]*\.[1-9][0-9]*\).*"@\1@g;' ); \

## Primary Build, Install, Test

do-build:
	cd ${WRKSRC} && ${PKGSRC_SETENV} CC=${CC} GNUMAKE=${GMAKE} ${MAKE_ENV} ${SH} make.sh
post-build: do-docs-build
	cd ${WRKSRC} && ${RM} -f contrib/sb-cover/test-output/*

do-install:
	cd ${WRKSRC} && ${SETENV} ${INSTALL_ENV} BUILD_ROOT=${DESTDIR} INSTALL_ROOT=${PREFIX} \
		MAN_DIR=${PREFIX}/${PKGMANDIR} INFO_DIR=${PREFIX}/${PKGINFODIR} \
		${SH} install.sh
.if !empty(PKG_OPTIONS:Mdoc)
	${INSTALL} -d -o ${DOCOWN} -g ${DOCGRP} -m ${PKGDIRMODE} \
		${DESTDIR}${PREFIX}/${PKGINFODIR}
	${INSTALL} ${COPY} -o ${DOCOWN} -g ${DOCGRP} -m ${DOCMODE} \
		${WRKSRC}/doc/internals/sbcl-internals.info ${DESTDIR}${PREFIX}/${PKGINFODIR}
.endif
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/asdf-install/installer.lisp.orig
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/posix-tests.lisp.orig
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/test-output/write-test.txt
	rm -f ${DESTDIR}${PREFIX}/lib/sbcl/sb-posix/test-output/read-test.txt
	rm -f ${DESTDIR}${PREFIX}/bin/sbcl.old ${DESTDIR}${PREFIX}/lib/sbcl/sbcl.core.old
	find ${DESTDIR}${PREFIX}/lib/sbcl -type d -name CVS -exec rm -rf {} \+
	find ${DESTDIR}${PREFIX}/lib/sbcl -type f -name .cvsignore -exec rm -f {} \+

do-test:
	cd ${WRKSRC}/tests && ${SH} ./run-tests.sh

.if ${MACHINE_ARCH} == "x86_64"
PLIST_SUBST+=	SUFX64=-64
.else
PLIST_SUBST+=	SUFX64=
.endif

.include "../../mk/bsd.pkg.mk"
