# $Thinkum$

PKG_OPTIONS_VAR=	PKG_OPTIONS.lttng-ust
PKG_SUPPORTED_OPTIONS=	python numa # systemtrap 
PKG_SUGGESTED_OPTIONS=	python

.include "../../mk/bsd.options.mk"

## TBD: Java support
## --enable-java-agent-jul | --enable-java-agent-log4j | --enable-java-agent-all
## cf. https://lttng.org/docs/v2.11/#doc-building-from-source
## furthermore https://adoptopenjdk.net/
## => configure --with-java-... args
## => buildlink
## => testing

PLIST_VARS+=	python
#PLIST_VARS+=	numa # TBD ...

.if !empty(PKG_OPTIONS:Mpython)
CONFIGURE_ARGS+=	--enable-python-agent
PLIST.python=		yes
REPLACE_PYTHON+=	doc/examples/python/hello.py python-lttngust/lttngust/agent.py
REPLACE_PYTHON+=	python-lttngust/lttngust/cmd.py python-lttngust/lttngust/debug.py
REPLACE_PYTHON+=	python-lttngust/lttngust/loghandler.py 
EGG_NAME=		lttngust
PYSETUPSUBDIR=		python-lttngust
PY_PATCHPLIST=		# Defined
.include "../../lang/python/distutils.mk"
.else
CONFIGURE_ARGS+=	--disable-python-agent
.endif

.if !empty(PKG_OPTIONS:Mnuma)
CONFIGURE_ARGS+=	--enable-numa
.include "../../wip/numactl/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-numa
.endif

##
## TBD w/ pkg build: SystemTrap, DTrace support
##
## SystemTrap may be supported with DTrace in such as
## the Debian package systemtap-sdt-dev
## https://packages.debian.org/buster/systemtap-sdt-dev
##
# .if !empty(PKG_OPTIONS:Msystemtrap)
# CONFIGURE_ARGS+=	--with-sdt
# .else
# CONFIGURE_ARGS+=	--without-sdt
# .endif
