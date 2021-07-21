# $Thinkum$

BUILDLINK_TREE+=        magit

.if !defined(MAGIT_BUILDLINK3_MK)
MAGIT_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.magit+=    magit>=20190928
BUILDLINK_ABI_DEPENDS.magit+=    magit>=20190928
BUILDLINK_PKGSRCDIR.magit?=      ../../wip/magit-git

EMACS_BUILDLINK?=		# Defined

.include "../../mk/bsd.prefs.mk"
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"
.include "../../wip/dash-el-git/buildlink3.mk"
.incldde "../../wip/libegit2-git/buildlink3.mk"

.endif # MAGIT_BUILDLINK3_MK

BUILDLINK_TREE+=        -magit
