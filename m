From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 4/8] KVM: arm/arm64: vgic: restructure
 kvm_vgic_(un)map_phys_irq
Date: Thu, 15 Jun 2017 14:52:36 +0200
Message-ID: <1497531160-29162-5-git-send-email-eric.auger@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B211840D4A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:50:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wm5kLrApOraE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jun 2017 08:50:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3E5E40D9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:50:31 -0400 (EDT)
In-Reply-To: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

We want to reuse the core of the map/unmap functions for IRQ
forwarding. Let's move the computation of the hwirq in
kvm_vgic_map_phys_irq and pass the linux IRQ as parameter.
the host_irq is added to struct vgic_irq.

We introduce kvm_vgic_map/unmap_irq which take a struct vgic_irq
handle as a parameter.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/kvm/arm_vgic.h    |  8 ++++---
 virt/kvm/arm/arch_timer.c | 24 +------------------
 virt/kvm/arm/vgic/vgic.c  | 60 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ef71858..cceb31d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -112,6 +112,7 @@ struct vgic_irq {
 	bool hw;			/* Tied to HW IRQ */
 	struct kref refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
+	unsigned int host_irq;		/* linux irq corresponding to hwintid */
 	union {
 		u8 targets;			/* GICv2 target VCPUs mask */
 		u32 mpidr;			/* GICv3 target VCPU */
@@ -301,9 +302,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level);
 int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			       bool level);
-int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
-int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
-bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
+int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
+			  u32 vintid);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid);
+bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid);
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5976609..57a30ab 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -617,9 +617,6 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct irq_desc *desc;
-	struct irq_data *data;
-	int phys_irq;
 	int ret;
 
 	if (timer->enabled)
@@ -632,26 +629,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (!vgic_initialized(vcpu->kvm))
 		return -ENODEV;
 
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
index 83b24d2..075f073 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -17,6 +17,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/list_sort.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include "vgic.h"
 
@@ -392,38 +394,66 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
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
 
@@ -726,9 +756,9 @@ void vgic_kick_vcpus(struct kvm *kvm)
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
2.5.5
