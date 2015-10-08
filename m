From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Keep mapped, disabled interrupts quiet
Date: Thu,  8 Oct 2015 13:36:09 +0100
Message-ID: <1444307769-11400-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98CE34130B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:34:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H7Rbw8LB+TsL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 08:34:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 475C141300
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:34:16 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

If a mapped interrupt is disabled, we must make sure the
corresponding physical interrupt cannot fire, as we are not
injecting the interrupt, and not setting the active bit.

For example, a guest disabling its timer interrupt at the GIC level
but leaving the timer firing would stop making progress as noone
would be able to prevent this timer from firing and interrupting
the host. Not quite what is expected. And if we're rebooting
or turning a vcpu off while the interrupt is about to fire,
we're exactly going to face this.

In order to cope with this, parse the list of mapped interrupts,
and mark it as active if we're about to run the guest (or inactive
if we've exited). Hopefully, nobody is going to run with zillions
of disabled, mapped interrupts, right?

Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
My gut feeling is that this vgic_dist_irq_set_pending should always
be done, but I'd like some other eyes to have a look at it.

Tested on Seattle (running 4.3-rc4) with a script hammering CPU hotplug.

 virt/kvm/arm/vgic.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6bd1c9b..0ad3f7e 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1092,6 +1092,11 @@ static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
+	if (vlr.state & LR_HW) {
+		vgic_dist_irq_set_pending(vcpu, irq);
+		vlr.hwirq = 0;
+	}
+
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
 	clear_bit(lr_nr, vgic_cpu->lr_used);
@@ -1232,6 +1237,57 @@ static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
 }
 
 /*
+ * If a mapped interrupt is disabled, we must make sure the
+ * corresponding physical interrupt cannot fire, as we are not
+ * injecting the interrupt, and not setting the active bit.
+ *
+ * Parse the list of mapped interrupts, and mark it as active if we're
+ * about to run the guest (or inactive if we've exited). Hopefully,
+ * nobody is going to run with zillions of disabled, mapped
+ * interrupts...
+ */
+static void vgic_handle_disabled_mapped_irq(struct kvm_vcpu *vcpu, bool enter)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_bitmap *spi_bitmap;
+	struct list_head *root;
+	struct irq_phys_map_entry *entry;
+	struct irq_phys_map *map;
+	int ret;
+
+	rcu_read_lock();
+
+	/* Check for PPIs */
+	root = &vgic_cpu->irq_phys_map_list;
+	list_for_each_entry_rcu(entry, root, entry) {
+		map = &entry->map;
+		if (!vgic_irq_is_enabled(vcpu, map->virt_irq)) {
+			ret = irq_set_irqchip_state(map->irq,
+						    IRQCHIP_STATE_ACTIVE,
+						    enter);
+			WARN_ON(ret);
+		}
+	}
+
+	/* Check for SPIs routed to this vcpu */
+	root = &dist->irq_phys_map_list;
+	spi_bitmap = &dist->irq_spi_target[vcpu->vcpu_id];
+	list_for_each_entry_rcu(entry, root, entry) {
+		map = &entry->map;
+		if (!vgic_irq_is_enabled(vcpu, map->virt_irq) &&
+		    vgic_bitmap_get_irq_val(spi_bitmap, 0, map->virt_irq)) {
+			ret = irq_set_irqchip_state(map->irq,
+						    IRQCHIP_STATE_ACTIVE,
+						    enter);
+			WARN_ON(ret);
+		}
+	}
+
+	rcu_read_unlock();
+}
+
+/*
  * Fill the list registers with pending interrupts before running the
  * guest.
  */
@@ -1320,6 +1376,8 @@ epilog:
 			WARN_ON(ret);
 		}
 	}
+
+	vgic_handle_disabled_mapped_irq(vcpu, true);
 }
 
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
@@ -1484,6 +1542,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 		vgic_cpu->vgic_irq_lr_map[vlr.irq] = LR_EMPTY;
 	}
 
+	vgic_handle_disabled_mapped_irq(vcpu, false);
+
 	/* Check if we still have something up our sleeve... */
 	pending = find_first_zero_bit(elrsr_ptr, vgic->nr_lr);
 	if (level_pending || pending < vgic->nr_lr)
-- 
2.1.4
