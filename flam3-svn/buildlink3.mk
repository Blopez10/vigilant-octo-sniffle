# $NetBSD: buildlink3.mk,v 1.1.1.1 2010/01/31 17:25:56 rhialto Exp $
#

BUILDLINK_TREE+=	flam3

.if !defined(FLAM3_BUILDLINK3_MK)
FLAM3_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.flam3+=	flam3>=2.7nb20100131
BUILDLINK_ABI_DEPENDS.flam3+=	flam3>=2.7nb20100131
BUILDLINK_PKGSRCDIR.flam3?=	../../wip/flam3-svn

.endif # FLAM3_BUILDLINK3_MK

BUILDLINK_TREE+=	-flam3
