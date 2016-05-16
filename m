From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 54/56] KVM: arm/arm64: vgic-new: Wire up irqfd injection
Date: Mon, 16 May 2016 10:54:39 +0100
Message-ID: <1463392481-26583-112-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6B949C6E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pAyezW6e8fZj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8DD749BE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:52 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Connect to the new VGIC to the irqfd framework, so that we can
inject IRQs.
GSI routing and MSI routing is not yet implemented.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-irqfd.c

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
new file mode 100644
index 0000000..c675513
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2015, 2016 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <trace/events/kvm.h>
+
+int kvm_irq_map_gsi(struct kvm *kvm,
+		    struct kvm_kernel_irq_routing_entry *entries,
+		    int gsi)
+{
+	return 0;
+}
+
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip,
+			 unsigned int pin)
+{
+	return pin;
+}
+
+int kvm_set_irq(struct kvm *kvm, int irq_source_id,
+		u32 irq, int level, bool line_status)
+{
+	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+
+	trace_kvm_set_irq(irq, level, irq_source_id);
+
+	BUG_ON(!vgic_initialized(kvm));
+
+	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+}
+
+/* MSI not implemented yet */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
+{
+	return 0;
+}
-- 
2.8.2
