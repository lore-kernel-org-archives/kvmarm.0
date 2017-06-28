From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 37/52] KVM: arm/arm64: GICv4: Add init and teardown of the
 vPE irq domain
Date: Wed, 28 Jun 2017 16:03:56 +0100
Message-ID: <20170628150411.15846-38-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE9240DF9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hh47lm-l-Pid for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B74549BF8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:31 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

In order to control the GICv4 view of virtual CPUs, we rely
on an irqdomain allocated for that purpose. Let's add a couple
of helpers to that effect.

At the same time, the vgic data structures gain new fields to
track all this... erm... wonderful stuff.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Makefile       |  1 +
 arch/arm64/kvm/Makefile     |  1 +
 include/kvm/arm_vgic.h      | 11 +++++++++
 virt/kvm/arm/vgic/vgic-v4.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h    |  3 +++
 5 files changed, 75 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-v4.c

diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index d9beee652d36..0a1dd2cdb928 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -31,6 +31,7 @@ obj-y += $(KVM)/arm/vgic/vgic-init.o
 obj-y += $(KVM)/arm/vgic/vgic-irqfd.o
 obj-y += $(KVM)/arm/vgic/vgic-v2.o
 obj-y += $(KVM)/arm/vgic/vgic-v3.o
+obj-y += $(KVM)/arm/vgic/vgic-v4.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v3.o
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5d9810086c25..c30fd388ef80 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -26,6 +26,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-irqfd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v4.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ee8587c8c715..359eeffe9857 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -26,6 +26,8 @@
 #include <linux/list.h>
 #include <linux/jump_label.h>
 
+#include <linux/irqchip/arm-gic-v4.h>
+
 #define VGIC_V3_MAX_CPUS	255
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
@@ -73,6 +75,9 @@ struct vgic_global {
 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
 
+	/* Does have GICv4? */
+	bool			has_gicv4;
+
 	/* GIC system register CPU interface */
 	struct static_key_false gicv3_cpuif;
 
@@ -233,6 +238,9 @@ struct vgic_dist {
 
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
+
+	/* GICv4 ITS per-VM stuff */
+	struct its_vm		its_vm;
 };
 
 struct vgic_v2_cpu_if {
@@ -251,6 +259,9 @@ struct vgic_v3_cpu_if {
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
+
+	/* GICv4 vPE info */
+	struct its_vpe	its_vpe;
 };
 
 struct vgic_cpu {
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
new file mode 100644
index 000000000000..81f607f2f83b
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2017 ARM Ltd.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
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
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/kvm_host.h>
+
+#include "vgic.h"
+
+int vgic_v4_init(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu;
+	int i, nr_vcpus, ret;
+
+	nr_vcpus = atomic_read(&kvm->online_vcpus);
+
+	dist->its_vm.vpes = kzalloc(sizeof(*dist->its_vm.vpes) * nr_vcpus,
+				    GFP_KERNEL);
+	if (!dist->its_vm.vpes)
+		return -ENOMEM;
+
+	dist->its_vm.nr_vpes = nr_vcpus;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		dist->its_vm.vpes[i] = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+
+	ret = its_alloc_vcpu_irqs(&dist->its_vm);
+	if (ret < 0) {
+		kvm_err("VPE IRQ allocation failure\n");
+		dist->its_vm.nr_vpes = 0;
+		kfree(dist->its_vm.vpes);
+		return ret;
+	}
+
+	return ret;
+}
+
+void vgic_v4_teardown(struct kvm *kvm)
+{
+	struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
+
+	its_free_vcpu_irqs(its_vm);
+	kfree(its_vm->vpes);
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 3002b72d938b..4dc47edce672 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -229,4 +229,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 
+int vgic_v4_init(struct kvm *kvm);
+void vgic_v4_teardown(struct kvm *kvm);
+
 #endif
-- 
2.11.0
