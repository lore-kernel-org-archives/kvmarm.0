From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH 1/4] KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq
Date: Tue, 29 Aug 2017 11:38:59 +0200
Message-ID: <20170829093902.15379-2-cdall@linaro.org>
References: <20170829093902.15379-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170829093902.15379-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

We want to reuse the core of the map/unmap functions for IRQ forwarding.
Let's move the computation of the hwirq in kvm_vgic_map_phys_irq and
pass the linux IRQ as parameter.

The host_irq is added to struct vgic_irq because it is needed in later
patches which manipulate the physical GIC state to support forwarded
IRQs.

We introduce kvm_vgic_map/unmap_irq which take a struct vgic_irq handle
as a parameter.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_vgic.h    |  8 ++++---
 virt/kvm/arm/arch_timer.c | 24 +------------------
 virt/kvm/arm/vgic/vgic.c  | 60 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 34dba51..53f631b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -116,6 +116,7 @@ struct vgic_irq {
 	bool hw;			/* Tied to HW IRQ */
 	struct kref refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
+	unsigned int host_irq;		/* linux irq corresponding to hwintid */
 	union {
 		u8 targets;			/* GICv2 target VCPUs mask */
 		u32 mpidr;			/* GICv3 target VCPU */
@@ -307,9 +308,10 @@ void kvm_vgic_init_cpu_hardware(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level, void *owner);
-int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
+			  u32 vintid);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 8e89d63..b24e2f7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -647,9 +647,6 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct irq_desc *desc;
-	struct irq_data *data;
-	int phys_irq;
 	int ret;
 
 	if (timer->enabled)
@@ -667,26 +664,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
-	/*
-	 * Find the physical IRQ number corresponding to the host_vtimer_irq
-	 */
-	desc = irq_to_desc(host_vtimer_irq);
-	if (!desc) {
-		kvm_err("%s: no interrupt descriptor\n", __func__);
-		return -EINVAL;
-	}
-
-	data = irq_desc_get_irq_data(desc);
-	while (data->parent_data)
-		data = data->parent_data;
-
-	phys_irq = data->hwirq;
-
-	/*
-	 * Tell the VGIC that the virtual interrupt is tied to a
-	 * physical interrupt. We do that once per VCPU.
-	 */
-	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
+	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq);
 	if (ret)
 		return ret;
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index fed717e..9d557efd 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -17,6 +17,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/list_sort.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include "vgic.h"
 
@@ -403,38 +405,66 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	return 0;
 }
 
-int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
+/* @irq->irq_lock must be held */
+static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
+			    unsigned int host_irq)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	struct irq_desc *desc;
+	struct irq_data *data;
 
-	BUG_ON(!irq);
-
-	spin_lock(&irq->irq_lock);
+	/*
+	 * Find the physical IRQ number corresponding to @host_irq
+	 */
+	desc = irq_to_desc(host_irq);
+	if (!desc) {
+		kvm_err("%s: no interrupt descriptor\n", __func__);
+		return -EINVAL;
+	}
+	data = irq_desc_get_irq_data(desc);
+	while (data->parent_data)
+		data = data->parent_data;
 
 	irq->hw = true;
-	irq->hwintid = phys_irq;
+	irq->host_irq = host_irq;
+	irq->hwintid = data->hwirq;
+	return 0;
+}
+
+/* @irq->irq_lock must be held */
+static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
+{
+	irq->hw = false;
+	irq->hwintid = 0;
+}
+
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
+			  u32 vintid)
+{
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
+	int ret;
 
+	BUG_ON(!irq);
+
+	spin_lock(&irq->irq_lock);
+	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
 	spin_unlock(&irq->irq_lock);
 	vgic_put_irq(vcpu->kvm, irq);
 
-	return 0;
+	return ret;
 }
 
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 {
 	struct vgic_irq *irq;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return -EAGAIN;
 
-	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	BUG_ON(!irq);
 
 	spin_lock(&irq->irq_lock);
-
-	irq->hw = false;
-	irq->hwintid = 0;
-
+	kvm_vgic_unmap_irq(irq);
 	spin_unlock(&irq->irq_lock);
 	vgic_put_irq(vcpu->kvm, irq);
 
@@ -772,9 +802,9 @@ void vgic_kick_vcpus(struct kvm *kvm)
 	}
 }
 
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	bool map_is_active;
 
 	spin_lock(&irq->irq_lock);
-- 
2.9.0
