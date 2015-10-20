From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 5/6] arm/arm64: KVM: Clear map->active on pend/active clear
Date: Tue, 20 Oct 2015 18:19:06 +0200
Message-ID: <1445357947-6022-6-git-send-email-christoffer.dall@linaro.org>
References: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF2348AF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z0ukLEV11utt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Oct 2015 12:16:11 -0400 (EDT)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C582D48AD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 12:16:10 -0400 (EDT)
Received: by lffz202 with SMTP id z202so8461054lff.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Oct 2015 09:18:42 -0700 (PDT)
In-Reply-To: <1445357947-6022-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When a guest reboots or offlines/onlines CPUs, it is not uncommon for it
to clear the pending and active states of an interrupt through the
emulated VGIC distributor.  However, since the architected timers are
defined by the architecture to be level triggered and the guest
rightfully expects them to be that, but we emulate them as
edge-triggered, we have to mimic level-triggered behavior for an
edge-triggered virtual implementation.

We currently do not signal the VGIC when the map->active field is true,
because it indicates that the guest has already been signalled of the
interrupt as required.  Normally this field is set to false when the
guest deactivates the virtual interrupt through the sync path.

We also need to catch the case where the guest deactivates the interrupt
through the emulated distributor, again allowing guests to boot even if
the original virtual timer signal hit before the guest's GIC
initialization sequence is run.

Reviewed-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index ea21bc2..58b1256 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -531,6 +531,34 @@ bool vgic_handle_set_pending_reg(struct kvm *kvm,
 	return false;
 }
 
+/*
+ * If a mapped interrupt's state has been modified by the guest such that it
+ * is no longer active or pending, without it have gone through the sync path,
+ * then the map->active field must be cleared so the interrupt can be taken
+ * again.
+ */
+static void vgic_handle_clear_mapped_irq(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct list_head *root;
+	struct irq_phys_map_entry *entry;
+	struct irq_phys_map *map;
+
+	rcu_read_lock();
+
+	/* Check for PPIs */
+	root = &vgic_cpu->irq_phys_map_list;
+	list_for_each_entry_rcu(entry, root, entry) {
+		map = &entry->map;
+
+		if (!vgic_dist_irq_is_pending(vcpu, map->virt_irq) &&
+		    !vgic_irq_is_active(vcpu, map->virt_irq))
+			map->active = false;
+	}
+
+	rcu_read_unlock();
+}
+
 bool vgic_handle_clear_pending_reg(struct kvm *kvm,
 				   struct kvm_exit_mmio *mmio,
 				   phys_addr_t offset, int vcpu_id)
@@ -561,6 +589,7 @@ bool vgic_handle_clear_pending_reg(struct kvm *kvm,
 					  vcpu_id, offset);
 		vgic_reg_access(mmio, reg, offset, mode);
 
+		vgic_handle_clear_mapped_irq(kvm_get_vcpu(kvm, vcpu_id));
 		vgic_update_state(kvm);
 		return true;
 	}
@@ -598,6 +627,7 @@ bool vgic_handle_clear_active_reg(struct kvm *kvm,
 			ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
 
 	if (mmio->is_write) {
+		vgic_handle_clear_mapped_irq(kvm_get_vcpu(kvm, vcpu_id));
 		vgic_update_state(kvm);
 		return true;
 	}
@@ -1406,7 +1436,7 @@ static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
 		return 0;
 
 	map = vgic_irq_map_search(vcpu, vlr.irq);
-	BUG_ON(!map || !map->active);
+	BUG_ON(!map);
 
 	ret = irq_get_irqchip_state(map->irq,
 				    IRQCHIP_STATE_ACTIVE,
-- 
2.1.2.330.g565301e.dirty
