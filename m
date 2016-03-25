From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 07/45] KVM: arm/arm64: vgic-new: Add vgic GICv2
 change_affinity
Date: Fri, 25 Mar 2016 02:04:30 +0000
Message-ID: <1458871508-17279-8-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F4A4412A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yCETC8ySclI1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:04:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1A6F40B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:35 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Introduce vgic-v2.c to contain GICv2 specific functions.
Add vgic_v2_irq_change_affinity() to change the target VCPU of a
particular interrupt.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 40 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 2 files changed, 42 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-v2.c

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
new file mode 100644
index 0000000..0bf6f27
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -0,0 +1,40 @@
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
+
+#include "vgic.h"
+
+void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 new_targets)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	int target;
+
+	BUG_ON(intid <= VGIC_MAX_PRIVATE);
+	BUG_ON(dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2);
+
+	irq = vgic_get_irq(kvm, NULL, intid);
+
+	spin_lock(&irq->irq_lock);
+	irq->targets = new_targets;
+
+	target = ffs(irq->targets);
+	target = target ? (target - 1) : 0;
+	irq->target_vcpu = kvm_get_vcpu(kvm, target);
+	spin_unlock(&irq->irq_lock);
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index e9f4aa6..b2faf00 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -20,4 +20,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 bool vgic_queue_irq(struct kvm *kvm, struct vgic_irq *irq);
 
+void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 target);
+
 #endif
-- 
2.7.3
