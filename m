From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 09/16] arm: allow creation of an MSI register frame region
Date: Fri,  4 Nov 2016 17:31:56 +0000
Message-ID: <20161104173203.21168-10-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 014BD40448
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uYiAqrsB+HdT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3018B40497
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:34 -0400 (EDT)
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
index 4d12f31..ed9016d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -8,6 +8,7 @@
 #include <linux/byteorder.h>
 #include <linux/kernel.h>
 #include <linux/kvm.h>
+#include <linux/sizes.h>
 
 /* Those names are not defined for ARM (yet) */
 #ifndef KVM_VGIC_V3_ADDR_TYPE_DIST
@@ -29,6 +30,8 @@
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
+static u64 gic_msi_base;
+static u64 gic_msi_size = 0;
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset)
 {
@@ -46,6 +49,56 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset)
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
@@ -75,6 +128,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
 		break;
 	case IRQCHIP_GICV3:
+	case IRQCHIP_GICV3_ITS:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
@@ -90,6 +144,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV2:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
 		break;
+	case IRQCHIP_GICV3_ITS:
 	case IRQCHIP_GICV3:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
@@ -101,6 +156,10 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	if (err)
 		goto out_err;
 
+	err = gic__create_msi_frame(kvm, type, gic_msi_base);
+	if (err)
+		goto out_err;
+
 	return 0;
 
 out_err:
@@ -144,9 +203,13 @@ int gic__create(struct kvm *kvm, enum irqchip_type type)
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
