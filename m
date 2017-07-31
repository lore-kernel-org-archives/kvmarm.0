From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 40/59] KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain
Date: Mon, 31 Jul 2017 18:26:18 +0100
Message-ID: <20170731172637.29355-41-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to control the GICv4 view of virtual CPUs, we rely
on an irqdomain allocated for that purpose. Let's add a couple
of helpers to that effect.

At the same time, the vgic data structures gain new fields to
track all this... erm... wonderful stuff.

They way we hook into the vgic init is slightly convoluted. We
need the vgic to be initialized (in order to guarantee that
the number of vcpus is now fixed), and we must have a vITS
(otherwise this is all very pointless). So we end-up calling
the init from both sites...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Makefile         |  1 +
 arch/arm64/kvm/Makefile       |  1 +
 include/kvm/arm_vgic.h        |  8 +++++
 virt/kvm/arm/vgic/vgic-init.c |  9 ++++++
 virt/kvm/arm/vgic/vgic-its.c  |  8 +++++
 virt/kvm/arm/vgic/vgic-v4.c   | 74 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      |  2 ++
 7 files changed, 103 insertions(+)
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
index 84694b42373a..359eeffe9857 100644
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
@@ -236,6 +238,9 @@ struct vgic_dist {
 
 	/* used by vgic-debug */
 	struct vgic_state_iter *iter;
+
+	/* GICv4 ITS per-VM stuff */
+	struct its_vm		its_vm;
 };
 
 struct vgic_v2_cpu_if {
@@ -254,6 +259,9 @@ struct vgic_v3_cpu_if {
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
+
+	/* GICv4 vPE info */
+	struct its_vpe	its_vpe;
 };
 
 struct vgic_cpu {
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 5801261f3add..d1c6c775203d 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,6 +285,12 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
+	if (vgic_has_its(kvm) && vgic_is_v4_capable(kvm)) {
+		ret = vgic_v4_init(kvm);
+		if (ret)
+			goto out;
+	}
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
 
@@ -320,6 +326,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 
 	kfree(dist->spis);
 	dist->nr_spis = 0;
+
+	if (vgic_is_v4_capable(kvm))
+		vgic_v4_teardown(kvm);
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index fb7be8673bff..a2217f53bbe5 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1603,6 +1603,14 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
+	if (vgic_initialized(dev->kvm)) {
+		int ret = vgic_v4_init(dev->kvm);
+		if (ret) {
+			kfree(its);
+			return ret;
+		}
+	}
+	
 	mutex_init(&its->its_lock);
 	mutex_init(&its->cmd_lock);
 
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
new file mode 100644
index 000000000000..207e1fda0dcd
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -0,0 +1,74 @@
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
+	/*
+	 * We may be called each time a vITS is created, or when the
+	 * vgic is initialized. This relies on kvm->lock to be
+	 * held. In both cases, the number of vcpus should now be
+	 * fixed.
+	 */
+	if (dist->its_vm.vpes)
+		return 0;
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
+		kfree(dist->its_vm.vpes);
+		dist->its_vm.nr_vpes = 0;
+		dist->its_vm.vpes = NULL;
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
+	if (!its_vm->vpes)
+		return;
+
+	its_free_vcpu_irqs(its_vm);
+	kfree(its_vm->vpes);
+	its_vm->nr_vpes = 0;
+	its_vm->vpes = NULL;
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 90f6436a11aa..1356f485d7cf 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -230,5 +230,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 
 bool vgic_is_v4_capable(struct kvm *kvm);
+int vgic_v4_init(struct kvm *kvm);
+void vgic_v4_teardown(struct kvm *kvm);
 
 #endif
-- 
2.11.0
