From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 05/10] arm: finish VGIC initialisation explicitly
Date: Wed, 17 Jun 2015 12:21:56 +0100
Message-ID: <1434540121-21283-6-git-send-email-andre.przywara@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Since Linux 3.19-rc1 there is a new API to explicitly initialise
the in-kernel GIC emulation by a userland KVM device call.
Use that to tell the kernel we are finished with the GIC
initialisation, since the automatic GIC init will only be provided
as a legacy functionality in the future.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arm/gic.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 8560c9b..99f0d2b 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -98,24 +98,43 @@ int gic__create(struct kvm *kvm)
 	return err;
 }
 
+/*
+ * Sets the number of used interrupts and finalizes the GIC init explicitly.
+ */
 static int gic__init_gic(struct kvm *kvm)
 {
+	int ret;
+
 	int lines = irq__get_nr_allocated_lines();
 	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
 	struct kvm_device_attr nr_irqs_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	= (u64)(unsigned long)&nr_irqs,
 	};
+	struct kvm_device_attr vgic_init_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
+		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
+	};
 
 	/*
 	 * If we didn't use the KVM_CREATE_DEVICE method, KVM will
-	 * give us some default number of interrupts.
+	 * give us some default number of interrupts. The GIC initialization
+	 * will be done automatically in this case.
 	 */
 	if (gic_fd < 0)
 		return 0;
 
-	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &nr_irqs_attr))
-		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &nr_irqs_attr);
+	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &nr_irqs_attr)) {
+		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &nr_irqs_attr);
+		if (ret)
+			return ret;
+	}
+
+	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
+		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &vgic_init_attr);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.3.5

