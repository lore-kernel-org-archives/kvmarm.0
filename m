From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 08/13] KVM: arm/arm64: vgic: adapt state machine for non
 shared mapped interrupts
Date: Thu, 19 Nov 2015 14:53:58 +0000
Message-ID: <1447944843-17731-9-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5166499D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QrdOx9Abz4eP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:44 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADC92499F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:44 -0500 (EST)
Received: by wmec201 with SMTP id c201so121306300wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:24 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

So far, the only user of the mapped interrupt facility was the timer:
the physical distributor active state needed to be context-switched
for each vcpu, as the device is shared across all vcpus.

This patch allows to indicate whether a mapped IRQ originates from a
device shared between several VMs (typically the architected timer) or
from a device assigned to a single VM.

A new "shared" flag is added to irq_phys_map and passed to the
mapping function.

the VGIC state machine is adapted to support the non shared mapped IRQs:
- only can be sampled when it is pending
- when queueing the IRQ (programming the LR), the pending state is
  removed as for edge sensitive IRQs
- queued state is not modelled. Level state is not modelled
- its injection with high level always is valid since steming from the HW.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

---

v3 -> v4:
- reword the patch title
- rebase on [PATCH v2 0/8] Rework architected timer and forwarded IRQs
  handling
- renamed shared_hw into non_shared_mapped_irq;
- handle edge-sensitive unshared mapped IRQs
- vgic_validate_injection rejects mapped unshared edge with
  level == 0
---
 include/kvm/arm_vgic.h    |  3 ++-
 virt/kvm/arm/arch_timer.c |  2 +-
 virt/kvm/arm/vgic.c       | 37 ++++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9c747cb..9bf6a30 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -158,6 +158,7 @@ struct irq_phys_map {
 	u32			virt_irq;
 	u32			phys_irq;
 	u32			irq;
+	bool			shared;
 };
 
 struct irq_phys_map_entry {
@@ -344,7 +345,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq);
+					   int virt_irq, int irq, bool shared);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 21a0ab2..9eea751 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -289,7 +289,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
+	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq, true);
 	if (WARN_ON(IS_ERR(map)))
 		return PTR_ERR(map);
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index bc30d93..dba8eb6 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -410,7 +410,11 @@ void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
 
 static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
 {
-	return !vgic_irq_is_queued(vcpu, irq);
+	struct irq_phys_map *map = vgic_irq_map_search(vcpu, irq);
+	bool non_shared_mapped_irq = map && !map->shared;
+
+	return !vgic_irq_is_queued(vcpu, irq) ||
+		(non_shared_mapped_irq && vgic_dist_irq_is_pending(vcpu, irq));
 }
 
 /**
@@ -1205,11 +1209,14 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 
 static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
 {
+	struct irq_phys_map *map = vgic_irq_map_search(vcpu, irq);
+	bool non_shared_mapped_irq = map && !map->shared;
+
 	if (!vgic_can_sample_irq(vcpu, irq))
 		return true; /* level interrupt, already queued */
 
 	if (vgic_queue_irq(vcpu, 0, irq)) {
-		if (vgic_irq_is_edge(vcpu, irq)) {
+		if (vgic_irq_is_edge(vcpu, irq) || non_shared_mapped_irq) {
 			vgic_dist_irq_clear_pending(vcpu, irq);
 			vgic_cpu_irq_clear(vcpu, irq);
 		} else {
@@ -1292,6 +1299,8 @@ static int process_queued_irq(struct kvm_vcpu *vcpu,
 				   int lr, struct vgic_lr vlr)
 {
 	int pending = 0;
+	struct irq_phys_map *map = vgic_irq_map_search(vcpu, vlr.irq);
+	bool non_shared_mapped_irq = map && !map->shared;
 
 	/*
 	 * If the IRQ was EOIed (called from vgic_process_maintenance) or it
@@ -1312,8 +1321,7 @@ static int process_queued_irq(struct kvm_vcpu *vcpu,
 	vgic_irq_clear_queued(vcpu, vlr.irq);
 
 	/* Any additional pending interrupt? */
-	if (vgic_irq_is_edge(vcpu, vlr.irq)) {
-		BUG_ON(!(vlr.state & LR_HW));
+	if (vgic_irq_is_edge(vcpu, vlr.irq) || non_shared_mapped_irq) {
 		pending = vgic_dist_irq_is_pending(vcpu, vlr.irq);
 	} else {
 		if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
@@ -1506,18 +1514,23 @@ void vgic_kick_vcpus(struct kvm *kvm)
 	}
 }
 
-static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
+static int vgic_validate_injection(struct kvm_vcpu *vcpu,
+				   struct irq_phys_map *map,
+				   int irq, int level)
 {
 	int edge_triggered = vgic_irq_is_edge(vcpu, irq);
 
 	/*
 	 * Only inject an interrupt if:
 	 * - edge triggered and we have a rising edge
-	 * - level triggered and we change level
+	 * - level triggered and we change level (except for
+	 *   mapped unshared IRQs where level is not modelled)
 	 */
 	if (edge_triggered) {
 		int state = vgic_dist_irq_is_pending(vcpu, irq);
 		return level > state;
+	} else if (map && !map->shared) {
+		return true;
 	} else {
 		int state = vgic_dist_irq_get_level(vcpu, irq);
 		return level != state;
@@ -1545,7 +1558,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	edge_triggered = vgic_irq_is_edge(vcpu, irq_num);
 	level_triggered = !edge_triggered;
 
-	if (!vgic_validate_injection(vcpu, irq_num, level)) {
+	if (!vgic_validate_injection(vcpu, map, irq_num, level)) {
 		ret = false;
 		goto out;
 	}
@@ -1718,16 +1731,20 @@ static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
  * @vcpu: The VCPU pointer
  * @virt_irq: The virtual irq number
  * @irq: The Linux IRQ number
+ * @shared: Indicates if the interrupt has to be context-switched or
+ *          if it is private to a VM
  *
  * Establish a mapping between a guest visible irq (@virt_irq) and a
  * Linux irq (@irq). On injection, @virt_irq will be associated with
  * the physical interrupt represented by @irq. This mapping can be
  * established multiple times as long as the parameters are the same.
+ * If @shared is true, the active state of the interrupt will be
+ * context-switched.
  *
  * Returns a valid pointer on success, and an error pointer otherwise
  */
 struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
-					   int virt_irq, int irq)
+					   int virt_irq, int irq, bool shared)
 {
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
@@ -1761,7 +1778,8 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	if (map) {
 		/* Make sure this mapping matches */
 		if (map->phys_irq != phys_irq	||
-		    map->irq      != irq)
+		    map->irq      != irq ||
+		    map->shared   != shared)
 			map = ERR_PTR(-EINVAL);
 
 		/* Found an existing, valid mapping */
@@ -1772,6 +1790,7 @@ struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
 	map->virt_irq = virt_irq;
 	map->phys_irq = phys_irq;
 	map->irq      = irq;
+	map->shared   = shared;
 
 	list_add_tail_rcu(&entry->entry, root);
 
-- 
1.9.1
