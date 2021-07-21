# $NetBSD$

.include "../../wip/emacs-git/Makefile.common"
.include "version.mk"
.include "options.mk"

DISTNAME:=	${DISTNAME:S/-/-nox11-/}
PKGNAME:=	${PKGNAME:S/-/-nox11-/}
PKGREVISION=	${_GIT_PKGVERSION:S/.//g}

DISTINFO_FILE=	${PKGDIR}/../emacs-git/distinfo
PATCHDIR=	${PKGDIR}/../emacs-git/patches
DESCR_SRC=	${PKGDIR}/../emacs-git/DESCR
#MESSAGE_SRC=	${PKGDIR}/../emacs-git/MESSAGE
PLIST_SRC=	${PKGDIR}/../emacs-git/PLIST

COMMENT=	GNU editing macros (editor, no x11)

CONFLICTS=	emacs${_EMACS_VERSION_MAJOR}-nox11-[0-9]*

CONFIGURE_ARGS+=	--without-dbus
CONFIGURE_ARGS+=	--without-xml2
CONFIGURE_ARGS+=	--without-gnutls
CONFIGURE_ARGS+=	--without-rsvg
CONFIGURE_ARGS+=	--without-gconf
CONFIGURE_ARGS+=	--without-imagemagick
CONFIGURE_ARGS+=	--without-xaw3d
CONFIGURE_ARGS+=	--without-xft --without-libotf --without-m17n-flt
CONFIGURE_ARGS+=	--without-ns

CONFIGURE_ARGS+=	--without-x
CONFIGURE_ARGS+=	--without-xpm
CONFIGURE_ARGS+=	--without-jpeg
CONFIGURE_ARGS+=	--without-tiff
CONFIGURE_ARGS+=	--without-gif
CONFIGURE_ARGS+=	--without-png

#SUBST_CLASSES+=		test_equal
#SUBST_STAGE.test_equal=	pre-configure
#SUBST_MESSAGE.test_equal=	Fixing bashisms in test(1) usage.
#SUBST_FILES.test_equal=	mac/make-package
#SUBST_SED.test_equal=		-e 's/ == / = /g'

FILESDIR=	${.CURDIR}/../../wip/emacs-git/files

## Share _GIT_DISTFILE.default with wip/emacs-git
_GIT_DISTFILE.default=${_EMACS_FLAVOR}${_EMACS_VERSION_MAJOR}-default-gitarchive.tar.gz

.include "../../mk/bsd.pkg.mk"
