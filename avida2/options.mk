# $NetBSD: options.mk,v 1.1 2013/01/20 01:10:40 othyro Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.avida2
PKG_SUPPORTED_OPTIONS=	debug ncurses tests
PKG_SUGGESTED_OPTIONS+=	${PKG_SUPPORTED_OPTIONS} #ncurses

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mdebug)
CMAKE_ARGS+=		-DCMAKE_BUILD_TYPE=Debug
.else
CMAKE_ARGS+=		-DCMAKE_BUILD_TYPE=Release
.endif

.if !empty(PKG_OPTIONS:Mncurses)
.include "../../devel/ncurses/buildlink3.mk"
CMAKE_ARGS+=		-DAVD_GUI_NCURSES=ON
CMAKE_ARGS+=		-DNCURSES_INCLUDE_PATH=${BUILDLINK_PREFIX.ncurses}/include
.else
CMAKE_ARGS+=		-DAVD_GUI_NCURSES=OFF
.endif

.if !empty(PKG_OPTIONS:Mtests)
CMAKE_ARGS+=		-DAVD_UNIT_TESTS=ON
.else
CMAKE_ARGS+=		-DAVD_UNIT_TESTS=OFF
.endif
