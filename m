From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 4/4] arm: Auto-detect guest GIC type
Date: Fri,  1 Feb 2019 12:37:16 +0000
Message-ID: <20190201123716.92901-5-andre.przywara@arm.com>
References: <20190201123716.92901-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F594A3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:37:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RIThviyZHBgP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 07:37:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 730384A399
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:37:26 -0500 (EST)
In-Reply-To: <20190201123716.92901-1-andre.przywara@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

At the moment kvmtool always tries to instantiate a virtual GICv2 for
the guest, and fails with some scary error message if that doesn't work.
The user has then to manually specify "--irqchip=gicv3", which is not
really obvious.
With the advent of more GICv3-only machines, let's try to be more
clever and implement some auto-detection of the GIC type needed:
We try gicv3-its, gicv3, gicv2m and gicv2, in that order. That first one
succeeding wins.
For GICv2 machines the first two will always fail. For GICv2-backwards
compatible GICv3 machines GICv3 is probably the better choice these days.

This algorithm is in effect is there is no explicit --irqchip parameter
on the command line. We still allow the GIC type to be set explicitly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                    | 25 +++++++++++++++++++++++++
 arm/include/arm-common/gic.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index abcbcc09..a86da20e 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -182,6 +182,8 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
 		dist_attr.attr  = KVM_VGIC_V3_ADDR_TYPE_DIST;
 		break;
+	case IRQCHIP_AUTO:
+		return -ENODEV;
 	}
 
 	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &gic_device);
@@ -199,6 +201,8 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 	case IRQCHIP_GICV3:
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
+	case IRQCHIP_AUTO:
+		return -ENODEV;
 	}
 	if (err)
 		goto out_err;
@@ -249,9 +253,30 @@ static int gic__create_irqchip(struct kvm *kvm)
 
 int gic__create(struct kvm *kvm, enum irqchip_type type)
 {
+	enum irqchip_type try;
 	int err;
 
 	switch (type) {
+	case IRQCHIP_AUTO:
+		try = IRQCHIP_GICV3_ITS;
+		err = gic__create(kvm, try);
+		if (err) {
+			try = IRQCHIP_GICV3;
+			err = gic__create(kvm, try);
+		}
+		if (err) {
+			try = IRQCHIP_GICV2M;
+			err = gic__create(kvm, try);
+		}
+		if (err) {
+			try = IRQCHIP_GICV2;
+			err = gic__create(kvm, try);
+		}
+		if (err)
+			return err;
+
+		kvm->cfg.arch.irqchip = try;
+		return 0;
 	case IRQCHIP_GICV2M:
 		gic_msi_size = KVM_VGIC_V2M_SIZE;
 		gic_msi_base = ARM_GIC_CPUI_BASE - gic_msi_size;
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index 1125d601..ec9cf31a 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -24,6 +24,7 @@
 #define KVM_VGIC_V2M_SIZE		0x1000
 
 enum irqchip_type {
+	IRQCHIP_AUTO,
 	IRQCHIP_GICV2,
 	IRQCHIP_GICV2M,
 	IRQCHIP_GICV3,
-- 
2.17.1
