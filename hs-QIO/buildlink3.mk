# $NetBSD: buildlink3.mk,v 1.2 2014/08/29 14:10:02 szptvlfn Exp $

BUILDLINK_TREE+=	hs-QIO

.if !defined(HS_QIO_BUILDLINK3_MK)
HS_QIO_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hs-QIO+=	hs-QIO>=1.2
BUILDLINK_ABI_DEPENDS.hs-QIO+=	hs-QIO>=1.2
BUILDLINK_PKGSRCDIR.hs-QIO?=	../../wip/hs-QIO

.endif	# HS_QIO_BUILDLINK3_MK

BUILDLINK_TREE+=	-hs-QIO
