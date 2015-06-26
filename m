From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 05/10] arm: finish VGIC initialisation explicitly
Date: Fri, 26 Jun 2015 14:16:13 +0100
Message-ID: <1435324578-21832-6-git-send-email-andre.przywara@arm.com>
References: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A20B75714D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 09:05:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oyZrVGeqN7P8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2015 09:05:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 808735714B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2015 09:05:36 -0400 (EDT)
In-Reply-To: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
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
