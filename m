From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 04/10] AArch{32,
 64}: dynamically configure the number of GIC interrupts
Date: Wed, 17 Jun 2015 12:21:55 +0100
Message-ID: <1434540121-21283-5-git-send-email-andre.przywara@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC9755CE4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 07:11:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dwdz6fi8vpLM for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 07:11:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBD8855CDF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 07:11:15 -0400 (EDT)
In-Reply-To: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
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
index 1ff3663..8560c9b 100644
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
@@ -96,6 +98,29 @@ int gic__create(struct kvm *kvm)
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
