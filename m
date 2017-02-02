From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 09/15] arm: allow creation of an MSI register frame region
Date: Thu,  2 Feb 2017 16:32:17 +0000
Message-ID: <20170202163223.15372-10-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The GICv3 ITS expects a separate 64K page to hold ITS registers.
Add a function to reserve such a page in the guest's I/O memory and
use that for the ITS vGIC type.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                    | 63 ++++++++++++++++++++++++++++++++++++++++++++
 arm/include/arm-common/gic.h |  1 +
 2 files changed, 64 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 8479b89..78fd583 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -8,10 +8,13 @@
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/kvm.h>
+#include <linux/sizes.h>
 
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
+static u64 gic_msi_base;
+static u64 gic_msi_size = 0;
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset)
 {
@@ -29,6 +32,56 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
+static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
+{
+	struct kvm_create_device its_device = {
+		.type = KVM_DEV_TYPE_ARM_VGIC_ITS,
+		.flags	= 0,
+	};
+	struct kvm_device_attr its_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	= KVM_VGIC_ITS_ADDR_TYPE,
+		.addr	= (u64)(unsigned long)&its_frame_addr,
+	};
+	struct kvm_device_attr its_init_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
+		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
+	};
+	int err;
+
+	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &its_device);
+	if (err) {
+		fprintf(stderr,
+			"GICv3 ITS requested, but kernel does not support it.\n");
+		fprintf(stderr, "Try --irqchip=gicv3 instead\n");
+		return err;
+	}
+
+	err = ioctl(its_device.fd, KVM_HAS_DEVICE_ATTR, &its_attr);
+	if (err) {
+		close(its_device.fd);
+		its_device.fd = -1;
+		return err;
+	}
+
+	err = ioctl(its_device.fd, KVM_SET_DEVICE_ATTR, &its_attr);
+	if (err)
+		return err;
+
+	return ioctl(its_device.fd, KVM_SET_DEVICE_ATTR, &its_init_attr);
+}
+
+static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
+				 u64 msi_frame_addr)
+{
+	switch (type) {
+	case IRQCHIP_GICV3_ITS:
+		return gic__create_its_frame(kvm, msi_frame_addr);
+	default:	/* No MSI frame needed */
+		return 0;
+	}
+}
+
 static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
@@ -58,6 +111,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
 		break;
 	case IRQCHIP_GICV3:
+	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
@@ -73,6 +127,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
 		break;
+	case IRQCHIP_GICV3_ITS:
 	case IRQCHIP_GICV3:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
@@ -84,6 +139,10 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	err = gic__create_msi_frame(kvm, type, gic_msi_base);
+	if (err)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -127,9 +186,13 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
 	switch (type) {
 	case IRQCHIP_GICV2:
 		break;
+	case IRQCHIP_GICV3_ITS:
+		gic_msi_size = KVM_VGIC_V3_ITS_SIZE;
+		/* fall through */
 	case IRQCHIP_GICV3:
 		gic_redists_size = kvm->cfg.nrcpus * ARM_GIC_REDIST_SIZE;
 		gic_redists_base = ARM_GIC_DIST_BASE - gic_redists_size;
+		gic_msi_base = gic_redists_base - gic_msi_size;
 		break;
 	default:
 		return -ENODEV;
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
2.9.0
