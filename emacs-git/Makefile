# $NetBSD$

.include "Makefile.common"
.include "version.mk"

CONFLICTS=	emacs27-nox11-[0-9]*

WRKSRC=		${WRKDIR}/emacs

PLIST_SRC=	${PKGDIR}/../../${PKGPATH}/PLIST

.include "options.mk"

CHECK_WRKREF_SKIP+=	bin/emacs-${PKGVERSION_NOREV}
CHECK_WRKREF_SKIP+=	libexec/emacs/${PKGVERSION_NOREV}/${MACHINE_GNU_PLATFORM}/emacs.pdmp

CONFIGURE_ARGS+=	--without-mailutils

.include "../../fonts/harfbuzz/buildlink3.mk"
.include "../../graphics/hicolor-icon-theme/buildlink3.mk"
.include "../../graphics/libimagequant/buildlink3.mk"
.include "../../sysutils/desktop-file-utils/desktopdb.mk"
.include "../../mk/bsd.pkg.mk"
