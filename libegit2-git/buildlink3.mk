# $Thinkum$

BUILDLINK_TREE+=        libegit2

.if !defined(LIBEGIT2_BUILDLINK3_MK)
LIBEGIT2_BUILDLINK3_MK:=	# Defined

BUILDLINK_API_DEPENDS.libegit2+=    libegit2>=20190928
BUILDLINK_ABI_DEPENDS.libegit2+=    libegit2>=20190928
BUILDLINK_PKGSRCDIR.libegit2?=      ../../wip/libegit2-git

## NB: using libegit2's internal libgit2 module
.include "../../devel/zlib/buildlink3.mk"

EMACS_BUILDLINK?=		# Defined
.include "../../mk/bsd.prefs.mk"
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"

.endif # LIBEGIT2_BUILDLINK3_MK

BUILDLINK_TREE+=        -libegit2
