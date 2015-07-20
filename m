From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 07/14] arm: allow creation of an MSI register frame region
Date: Mon, 20 Jul 2015 14:02:09 +0100
Message-ID: <1437397336-21385-8-git-send-email-andre.przywara@arm.com>
References: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

The GICv3 ITS expects a separate 64K page to hold ITS registers.
Add a function to reserve such a page in the guest's I/O memory and
use that for the ITS vGIC type.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                    | 36 ++++++++++++++++++++++++++++++++++++
 arm/include/arm-common/gic.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 93a8a1d..f9a20bd 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -8,6 +8,7 @@
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/kvm.h>
+#include <linux/sizes.h>
 
 /* Those names are not defined for ARM (yet) */
 #ifndef KVM_VGIC_V3_ADDR_TYPE_DIST
@@ -42,6 +43,34 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
+				 u64 msi_frame_addr)
+{
+	struct kvm_device_attr msi_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.addr	= (u64)(unsigned long)&msi_frame_addr,
+	};
+	int err;
+
+	switch (type) {
+	case IRQCHIP_GICV3_ITS:
+		msi_attr.attr = KVM_VGIC_V3_ADDR_TYPE_ITS;
+		break;
+	default:
+		/* No MSI frame needed */
+		return 0;
+	}
+	err = ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &msi_attr);
+	if (err) {
+		fprintf(stderr,
+			"GICv3 ITS requested, but kernel does not support it.\n");
+		fprintf(stderr, "Try --irqchip=gicv3 instead\n");
+		return err;
+	}
+
+	return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &msi_attr);
+}
+
 static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
@@ -71,6 +100,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
 		break;
 	case IRQCHIP_GICV3:
+	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
@@ -86,6 +116,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
 		break;
+	case IRQCHIP_GICV3_ITS:
 	case IRQCHIP_GICV3:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
@@ -97,6 +128,10 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	err = gic__create_msi_frame(kvm, type, gic_redists_base - SZ_64K);
+	if (err)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -141,6 +176,7 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2:
 		break;
 	case IRQCHIP_GICV3:
+	case IRQCHIP_GICV3_ITS:
 		gic_redists_size = kvm->cfg.nrcpus * ARM_GIC_REDIST_SIZE;
 		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
 		break;
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index b43a180..433dd23 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -24,6 +24,7 @@
 enum irqchip_type {
 	IRQCHIP_GICV2,
 	IRQCHIP_GICV3,
+	IRQCHIP_GICV3_ITS,
 };
 
 struct kvm;
-- 
2.3.5

