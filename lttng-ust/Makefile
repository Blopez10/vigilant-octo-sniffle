# $Thinkum$

DISTNAME=	lttng-ust-2.11.0
CATEGORIES=	devel
MASTER_SITES=	http://lttng.org/files/lttng-ust/

EXTRACT_SUFX=	.tar.bz2

MAINTAINER=	lab@thinkum.spce
HOMEPAGE=	https://lttng.org/
# HOMEPAGE.github= https://github.com/lttng/lttng-ust
COMMENT=	Userspace Tracing Library - Linux Trace Toolkit: next generation
LICENSE=	gnu-lgpl-v2.1 AND mit AND gnu-gpl-v2

ONLY_FOR_PLATFORM=	Linux-*-*
## NB: The configure may succeed on a non-Linux OS.
##     The main build requires glibc headers.

GNU_CONFIGURE=	yes
USE_LIBTOOL=	yes
USE_TOOLS+=	gmake pkg-config


.include "../../lang/python/application.mk"
REPLACE_PYTHON+=		tools/lttng-gen-tp
## Prevent a warning when PKG_DEVELOPER is set,
## assuming /usr/bin/env must be available on the host
## per common conventions in systems distributions.
CHECK_INTERPRETER_SKIP+=	bin/lttng-gen-tp

PKGCONFIG_OVERRIDE+=		lttng-ust.pc.in

## TBD - host integration for the following
CONFIGURE_ARGS+=	--with-lttng-system-rundir=${VARBASE}/run/lttng

.include "../../mk/bsd.prefs.mk"
.include "options.mk"

#
# When applicable, run the same shell commands for build, install that
# are used in python extensions.mk, subsequent to the main build/install
#
do-build:
	${RUN} cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${GMAKE} all
.if !empty(PKG_OPTIONS:Mpython)
	(cd ${WRKSRC}/${PYSETUPSUBDIR} && ${SETENV} ${MAKE_ENV} ${PYTHONBIN} \
	 ${PYSETUP} ${PYSETUPARGS} ${PYSETUPBUILDTARGET} ${PYSETUPBUILDARGS})
.endif

do-install:
	${RUN} cd ${WRKSRC} && ${SETENV} ${INSTALL_ENV} ${GMAKE} install
.if !empty(PKG_OPTIONS:Mpython)
	(cd ${WRKSRC}/${PYSETUPSUBDIR} && ${SETENV} ${INSTALL_ENV} ${MAKE_ENV} \
	 ${PYTHONBIN} ${PYSETUP} ${PYSETUPARGS} "install" ${_PYSETUPINSTALLARGS})
.endif

.include "../../devel/userspace-rcu/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
