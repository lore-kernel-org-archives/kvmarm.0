From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 2/4] KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a raw_spinlock
Date: Mon, 26 Nov 2018 18:26:45 +0000
Message-ID: <1543256807-9768-3-git-send-email-julien.thierry@arm.com>
References: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Christoffer.Dall@arm.com, linux-arm-kernel@lists.infradead.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, bigeasy@linutronix.de, Julien Thierry <julien.thierry@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

vgic_irq->irq_lock must always be taken with interrupts disabled as
it is used in interrupt context.

For configurations such as PREEMPT_RT_FULL, this means that it should
be a raw_spinlock since RT spinlocks are interruptible.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h           |  2 +-
 virt/kvm/arm/vgic/vgic-debug.c   |  4 +--
 virt/kvm/arm/vgic/vgic-init.c    |  4 +--
 virt/kvm/arm/vgic/vgic-its.c     | 14 ++++----
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 14 ++++----
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 12 +++----
 virt/kvm/arm/vgic/vgic-mmio.c    | 34 +++++++++---------
 virt/kvm/arm/vgic/vgic-v2.c      |  4 +--
 virt/kvm/arm/vgic/vgic-v3.c      |  8 ++---
 virt/kvm/arm/vgic/vgic.c         | 77 ++++++++++++++++++++--------------------
 10 files changed, 86 insertions(+), 87 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4f31f96..b542605 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -100,7 +100,7 @@ enum vgic_irq_config {
 };
 
 struct vgic_irq {
-	spinlock_t irq_lock;		/* Protects the content of the struct */
+	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
 	struct list_head lpi_list;	/* Used to link all LPIs together */
 	struct list_head ap_list;
 
diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index 07aa900..1f62f2b 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -251,9 +251,9 @@ static int vgic_debug_show(struct seq_file *s, void *v)
 		return 0;
 	}
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	print_irq_state(s, irq, vcpu);
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	vgic_put_irq(kvm, irq);
 	return 0;
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index c0c0b88..1128e97 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -171,7 +171,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 
 		irq->intid = i + VGIC_NR_PRIVATE_IRQS;
 		INIT_LIST_HEAD(&irq->ap_list);
-		spin_lock_init(&irq->irq_lock);
+		raw_spin_lock_init(&irq->irq_lock);
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
 		kref_init(&irq->refcount);
@@ -216,7 +216,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
 
 		INIT_LIST_HEAD(&irq->ap_list);
-		spin_lock_init(&irq->irq_lock);
+		raw_spin_lock_init(&irq->irq_lock);
 		irq->intid = i;
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index eb2a390..911ba61 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -65,7 +65,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 
 	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
-	spin_lock_init(&irq->irq_lock);
+	raw_spin_lock_init(&irq->irq_lock);
 
 	irq->config = VGIC_CONFIG_EDGE;
 	kref_init(&irq->refcount);
@@ -287,7 +287,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	if (ret)
 		return ret;
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 	if (!filter_vcpu || filter_vcpu == irq->target_vcpu) {
 		irq->priority = LPI_PROP_PRIORITY(prop);
@@ -299,7 +299,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 		}
 	}
 
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	if (irq->hw)
 		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
@@ -352,9 +352,9 @@ static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 	int ret = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->target_vcpu = vcpu;
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	if (irq->hw) {
 		struct its_vlpi_map map;
@@ -455,7 +455,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 		}
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = pendmask & (1U << bit_nr);
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
@@ -612,7 +612,7 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 		return irq_set_irqchip_state(irq->host_irq,
 					     IRQCHIP_STATE_PENDING, true);
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 738b65d..b535fff 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -147,7 +147,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 
 		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = true;
 		irq->source |= 1U << source_vcpu->vcpu_id;
 
@@ -191,13 +191,13 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
 		int target;
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->targets = (val >> (i * 8)) & cpu_mask;
 		target = irq->targets ? __ffs(irq->targets) : 0;
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -230,13 +230,13 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->source &= ~((val >> (i * 8)) & 0xff);
 		if (!irq->source)
 			irq->pending_latch = false;
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -252,7 +252,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->source |= (val >> (i * 8)) & 0xff;
 
@@ -260,7 +260,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 			irq->pending_latch = true;
 			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
-			spin_unlock_irqrestore(&irq->irq_lock, flags);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index b3d1f09..4a12322 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -169,13 +169,13 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	if (!irq)
 		return;
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 	/* We only care about and preserve Aff0, Aff1 and Aff2. */
 	irq->mpidr = val & GENMASK(23, 0);
 	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
 
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
@@ -281,7 +281,7 @@ static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (test_bit(i, &val)) {
 			/*
 			 * pending_latch is set irrespective of irq type
@@ -292,7 +292,7 @@ static int vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
 			irq->pending_latch = false;
-			spin_unlock_irqrestore(&irq->irq_lock, flags);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 
 		vgic_put_irq(vcpu->kvm, irq);
@@ -957,7 +957,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 
 		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		/*
 		 * An access targetting Group0 SGIs can only generate
@@ -968,7 +968,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 			irq->pending_latch = true;
 			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
-			spin_unlock_irqrestore(&irq->irq_lock, flags);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 
 		vgic_put_irq(vcpu->kvm, irq);
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 5c76a92..a104e93 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -77,7 +77,7 @@ void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->group = !!(val & BIT(i));
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
@@ -120,7 +120,7 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->enabled = true;
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
@@ -139,11 +139,11 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->enabled = false;
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -160,10 +160,10 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 		unsigned long flags;
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq_is_pending(irq))
 			value |= (1U << i);
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -215,7 +215,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq->hw)
 			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
 		else
@@ -262,14 +262,14 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (irq->hw)
 			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
 		else
 			irq->pending_latch = false;
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -311,7 +311,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	unsigned long flags;
 	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 	if (irq->hw) {
 		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
@@ -327,7 +327,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	if (irq->active)
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 	else
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 }
 
 /*
@@ -481,10 +481,10 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		/* Narrow the priority range to what we actually support */
 		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -530,14 +530,14 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 			continue;
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (test_bit(i * 2 + 1, &val))
 			irq->config = VGIC_CONFIG_EDGE;
 		else
 			irq->config = VGIC_CONFIG_LEVEL;
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -586,12 +586,12 @@ void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
 		 * restore irq config before line level.
 		 */
 		new_level = !!(val & (1U << i));
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->line_level = new_level;
 		if (new_level)
 			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		else
-			spin_unlock_irqrestore(&irq->irq_lock, flags);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 69b892a..d91a893 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -84,7 +84,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
@@ -127,7 +127,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9c0dd23..4ee0aeb 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -76,7 +76,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (!irq)	/* An LPI could have been unmapped. */
 			continue;
 
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
@@ -119,7 +119,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
@@ -347,9 +347,9 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 
 	status = val & (1 << bit_nr);
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	if (irq->target_vcpu != vcpu) {
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		goto retry;
 	}
 	irq->pending_latch = status;
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 7cfdfbc..aab8dba 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -196,7 +196,7 @@ void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active)
  */
 static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 {
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+	DEBUG_SPINLOCK_BUG_ON(!raw_spin_is_locked(&irq->irq_lock));
 
 	/* If the interrupt is active, it must stay on the current vcpu */
 	if (irq->active)
@@ -244,8 +244,8 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	bool penda, pendb;
 	int ret;
 
-	spin_lock(&irqa->irq_lock);
-	spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
+	raw_spin_lock(&irqa->irq_lock);
+	raw_spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 
 	if (irqa->active || irqb->active) {
 		ret = (int)irqb->active - (int)irqa->active;
@@ -263,8 +263,8 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	/* Both pending and enabled, sort by priority */
 	ret = irqa->priority - irqb->priority;
 out:
-	spin_unlock(&irqb->irq_lock);
-	spin_unlock(&irqa->irq_lock);
+	raw_spin_unlock(&irqb->irq_lock);
+	raw_spin_unlock(&irqa->irq_lock);
 	return ret;
 }
 
@@ -311,7 +311,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 {
 	struct kvm_vcpu *vcpu;
 
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+	DEBUG_SPINLOCK_BUG_ON(!raw_spin_is_locked(&irq->irq_lock));
 
 retry:
 	vcpu = vgic_target_oracle(irq);
@@ -325,7 +325,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 		 * not need to be inserted into an ap_list and there is also
 		 * no more work for us to do.
 		 */
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		/*
 		 * We have to kick the VCPU here, because we could be
@@ -347,12 +347,12 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 * We must unlock the irq lock to take the ap_list_lock where
 	 * we are going to insert this new pending interrupt.
 	 */
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	/* someone can do stuff here, which we re-check below */
 
 	spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
-	spin_lock(&irq->irq_lock);
+	raw_spin_lock(&irq->irq_lock);
 
 	/*
 	 * Did something change behind our backs?
@@ -367,10 +367,10 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	 */
 
 	if (unlikely(irq->vcpu || vcpu != vgic_target_oracle(irq))) {
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 		spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		goto retry;
 	}
 
@@ -382,7 +382,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
 	irq->vcpu = vcpu;
 
-	spin_unlock(&irq->irq_lock);
+	raw_spin_unlock(&irq->irq_lock);
 	spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
@@ -430,11 +430,11 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	if (!irq)
 		return -EINVAL;
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
 	if (!vgic_validate_injection(irq, level, owner)) {
 		/* Nothing to see here, move along... */
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(kvm, irq);
 		return 0;
 	}
@@ -494,9 +494,9 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
 
 	BUG_ON(!irq);
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	ret = kvm_vgic_map_irq(vcpu, irq, host_irq, get_input_level);
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
 	return ret;
@@ -519,11 +519,11 @@ void kvm_vgic_reset_mapped_irq(struct kvm_vcpu *vcpu, u32 vintid)
 	if (!irq->hw)
 		goto out;
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->active = false;
 	irq->pending_latch = false;
 	irq->line_level = false;
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 out:
 	vgic_put_irq(vcpu->kvm, irq);
 }
@@ -539,9 +539,9 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
 	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
 	BUG_ON(!irq);
 
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	kvm_vgic_unmap_irq(irq);
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
 	return 0;
@@ -571,12 +571,12 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 		return -EINVAL;
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	if (irq->owner && irq->owner != owner)
 		ret = -EEXIST;
 	else
 		irq->owner = owner;
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	return ret;
 }
@@ -603,7 +603,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
 		bool target_vcpu_needs_kick = false;
 
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 
 		BUG_ON(vcpu != irq->vcpu);
 
@@ -616,7 +616,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			 */
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
-			spin_unlock(&irq->irq_lock);
+			raw_spin_unlock(&irq->irq_lock);
 
 			/*
 			 * This vgic_put_irq call matches the
@@ -631,13 +631,13 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 		if (target_vcpu == vcpu) {
 			/* We're on the right CPU */
-			spin_unlock(&irq->irq_lock);
+			raw_spin_unlock(&irq->irq_lock);
 			continue;
 		}
 
 		/* This interrupt looks like it has to be migrated. */
 
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 		spin_unlock(&vgic_cpu->ap_list_lock);
 
 		/*
@@ -655,7 +655,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 		spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
 				 SINGLE_DEPTH_NESTING);
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 
 		/*
 		 * If the affinity has been preserved, move the
@@ -675,7 +675,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			target_vcpu_needs_kick = true;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
 		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
@@ -702,7 +702,7 @@ static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
 static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
 				    struct vgic_irq *irq, int lr)
 {
-	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
+	DEBUG_SPINLOCK_BUG_ON(!raw_spin_is_locked(&irq->irq_lock));
 
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_populate_lr(vcpu, irq, lr);
@@ -741,10 +741,10 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		int w;
 
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 		/* GICv2 SGIs can count for more than one... */
 		w = vgic_irq_get_lr_count(irq);
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 
 		count += w;
 		*multi_sgi |= (w > 1);
@@ -770,7 +770,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	count = 0;
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 
 		/*
 		 * If we have multi-SGIs in the pipeline, we need to
@@ -780,7 +780,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		 * the AP list has been sorted already.
 		 */
 		if (multi_sgi && irq->priority > prio) {
-			spin_unlock(&irq->irq_lock);
+			_raw_spin_unlock(&irq->irq_lock);
 			break;
 		}
 
@@ -791,7 +791,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 				prio = irq->priority;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 
 		if (count == kvm_vgic_global_state.nr_lr) {
 			if (!list_is_last(&irq->ap_list,
@@ -918,9 +918,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
-		spin_lock(&irq->irq_lock);
+		raw_spin_lock(&irq->irq_lock);
 		pending = irq_is_pending(irq) && irq->enabled;
-		spin_unlock(&irq->irq_lock);
+		raw_spin_unlock(&irq->irq_lock);
 
 		if (pending)
 			break;
@@ -958,11 +958,10 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 		return false;
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
-	spin_lock_irqsave(&irq->irq_lock, flags);
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	map_is_active = irq->hw && irq->active;
-	spin_unlock_irqrestore(&irq->irq_lock, flags);
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
 	return map_is_active;
 }
-
-- 
1.9.1
