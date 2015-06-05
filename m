From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 4/8] AArch{32,64}: dynamically configure the number of GIC interrupts
Date: Fri,  5 Jun 2015 09:37:49 +0100
Message-ID: <1433493473-4002-5-git-send-email-andre.przywara@arm.com>
References: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com, penberg@kernel.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

In order to reduce the memory usage of large guests (as well
as improve performance), tell KVM about the number of interrupts
we require.

To avoid synchronization with the various device creation,
use a late_init callback to compute the GIC configuration.
[Andre: rename to gic__init_gic() to ease future expansion]

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index ce5f7fa..6277af8 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -1,10 +1,12 @@
 #include "kvm/fdt.h"
+#include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/virtio.h"
 
 #include "arm-common/gic.h"
 
 #include <linux/byteorder.h>
+#include <linux/kernel.h>
 #include <linux/kvm.h>
 
 static int gic_fd = -1;
@@ -87,6 +89,29 @@ int gic__create(struct kvm *kvm)
 	return err;
 }
 
+static int gic__init_gic(struct kvm *kvm)
+{
+	int lines = irq__get_nr_allocated_lines();
+	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
+	struct kvm_device_attr nr_irqs_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+		.addr	= (u64)(unsigned long)&nr_irqs,
+	};
+
+	/*
+	 * If we didn't use the KVM_CREATE_DEVICE method, KVM will
+	 * give us some default number of interrupts.
+	 */
+	if (gic_fd < 0)
+		return 0;
+
+	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &nr_irqs_attr))
+		return ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &nr_irqs_attr);
+
+	return 0;
+}
+late_init(gic__init_gic)
+
 void gic__generate_fdt_nodes(void *fdt, u32 phandle)
 {
 	u64 reg_prop[] = {
-- 
2.3.5

