# $NetBSD$

BUILDLINK_TREE+=        libudev

.if !defined(LIBUDEV_BUILDLINK3_MK)
LIBUDEV_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.libudev+=    libudev>=228
BUILDLINK_PKGSRCDIR.libudev?=      ../../wip/libudev
.endif # LIBUDEV_BUILDLINK3_MK

BUILDLINK_TREE+=        -libudev
