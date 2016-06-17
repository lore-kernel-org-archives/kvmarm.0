From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 05/15] KVM: arm/arm64: VGIC: add refcounting for IRQs
Date: Fri, 17 Jun 2016 13:08:37 +0100
Message-ID: <1466165327-32060-6-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BEB249B6F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0m3ndGaj1roE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2016 08:04:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B5F949B83
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:08 -0400 (EDT)
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In the moment our struct vgic_irq's are statically allocated at guest
creation time. So getting a pointer to an IRQ structure is trivial and
safe. LPIs are more dynamic, they can be mapped and unmapped at any time
during the guest's _runtime_.
In preparation for supporting LPIs we introduce reference counting to
those structures. Since private IRQs and SPIs are statically allocated,
the reqcount never drops to 0 at the moment, but we increase it when an
IRQ gets onto a VCPU list and decrease it when it gets removed.
Also vgic_get_irq() gets changed to take the irq_lock already, this is
later needed to avoid a race between a potential LPI unmap and the
window between us getting the pointer and locking the IRQ.
This introduces vgic_put_irq(), which just does the unlock and makes
the new locking sequence look more symmetrical.
This approach deviates from the classical Linux refcounting with using
atomic_* types and functions, because the users of vgic_get_irq() take
the irq_lock anyway, so we just use an int and adjust the refcount while
holding the lock.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h          |  1 +
 virt/kvm/arm/vgic/vgic-init.c    |  2 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 21 +++++------
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 26 ++++++-------
 virt/kvm/arm/vgic/vgic-mmio.c    | 55 ++++++++++++++++-----------
 virt/kvm/arm/vgic/vgic-v2.c      |  4 +-
 virt/kvm/arm/vgic/vgic-v3.c      |  4 +-
 virt/kvm/arm/vgic/vgic.c         | 81 +++++++++++++++++++++++++---------------
 virt/kvm/arm/vgic/vgic.h         |  7 +++-
 9 files changed, 116 insertions(+), 85 deletions(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 2f26f37..e488a369 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -96,6 +96,7 @@ struct vgic_irq {
 	bool active;			/* not used for LPIs */
 	bool enabled;
 	bool hw;			/* Tied to HW IRQ */
+	int refcnt;			/* Used only for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	union {
 		u8 targets;			/* GICv2 target VCPUs mask */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 90cae48..c4a8df6 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -177,6 +177,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 		spin_lock_init(&irq->irq_lock);
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu0;
+		irq->refcnt = 1;
 		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
 			irq->targets = 0;
 		else
@@ -211,6 +212,7 @@ static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 		irq->vcpu = NULL;
 		irq->target_vcpu = vcpu;
 		irq->targets = 1U << vcpu->vcpu_id;
+		irq->refcnt = 1;
 		if (vgic_irq_is_sgi(i)) {
 			/* SGIs */
 			irq->enabled = 1;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a213936..7bb3e94 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -97,11 +97,10 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 
 		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
 		irq->pending = true;
 		irq->source |= 1U << source_vcpu->vcpu_id;
 
-		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
+		vgic_queue_irq_put(source_vcpu->kvm, irq);
 	}
 }
 
@@ -116,6 +115,8 @@ static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		val |= (u64)irq->targets << (i * 8);
+
+		vgic_put_irq(irq);
 	}
 
 	return val;
@@ -136,13 +137,11 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
 		int target;
 
-		spin_lock(&irq->irq_lock);
-
 		irq->targets = (val >> (i * 8)) & 0xff;
 		target = irq->targets ? __ffs(irq->targets) : 0;
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 	}
 }
 
@@ -157,6 +156,8 @@ static unsigned long vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		val |= (u64)irq->source << (i * 8);
+
+		vgic_put_irq(irq);
 	}
 	return val;
 }
@@ -171,13 +172,11 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
-
 		irq->source &= ~((val >> (i * 8)) & 0xff);
 		if (!irq->source)
 			irq->pending = false;
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 	}
 }
 
@@ -191,15 +190,13 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
-
 		irq->source |= (val >> (i * 8)) & 0xff;
 
 		if (irq->source) {
 			irq->pending = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq);
+			vgic_queue_irq_put(vcpu->kvm, irq);
 		} else {
-			spin_unlock(&irq->irq_lock);
+			vgic_put_irq(irq);
 		}
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index fc7b6c9..c38302d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -80,15 +80,17 @@ static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
+	unsigned long ret = 0;
 
 	if (!irq)
 		return 0;
 
 	/* The upper word is RAZ for us. */
-	if (addr & 4)
-		return 0;
+	if (!(addr & 4))
+		ret = extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
 
-	return extract_bytes(READ_ONCE(irq->mpidr), addr & 7, len);
+	vgic_put_irq(irq);
+	return ret;
 }
 
 static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
@@ -102,16 +104,13 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 		return;
 
 	/* The upper word is WI for us since we don't implement Aff3. */
-	if (addr & 4)
-		return;
-
-	spin_lock(&irq->irq_lock);
-
-	/* We only care about and preserve Aff0, Aff1 and Aff2. */
-	irq->mpidr = val & GENMASK(23, 0);
-	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
+	if (!(addr & 4)) {
+		/* We only care about and preserve Aff0, Aff1 and Aff2. */
+		irq->mpidr = val & GENMASK(23, 0);
+		irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
+	}
 
-	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(irq);
 }
 
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
@@ -441,9 +440,8 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 
 		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
 
-		spin_lock(&irq->irq_lock);
 		irq->pending = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_put(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 9f6fab7..4050c1c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -56,6 +56,8 @@ unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
 
 		if (irq->enabled)
 			value |= (1U << i);
+
+		vgic_put_irq(irq);
 	}
 
 	return value;
@@ -71,9 +73,9 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
 		irq->enabled = true;
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+
+		vgic_queue_irq_put(vcpu->kvm, irq);
 	}
 }
 
@@ -87,11 +89,9 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
-
 		irq->enabled = false;
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 	}
 }
 
@@ -108,6 +108,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 
 		if (irq->pending)
 			value |= (1U << i);
+
+		vgic_put_irq(irq);
 	}
 
 	return value;
@@ -123,12 +125,11 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
 		irq->pending = true;
 		if (irq->config == VGIC_CONFIG_LEVEL)
 			irq->soft_pending = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_put(vcpu->kvm, irq);
 	}
 }
 
@@ -142,8 +143,6 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
-
 		if (irq->config == VGIC_CONFIG_LEVEL) {
 			irq->soft_pending = false;
 			irq->pending = irq->line_level;
@@ -151,7 +150,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			irq->pending = false;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 	}
 }
 
@@ -168,15 +167,17 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 
 		if (irq->active)
 			value |= (1U << i);
+
+		vgic_put_irq(irq);
 	}
 
 	return value;
 }
 
-static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				    bool new_active_state)
+static void vgic_mmio_change_active_put(struct kvm_vcpu *vcpu,
+					struct vgic_irq *irq,
+					bool new_active_state)
 {
-	spin_lock(&irq->irq_lock);
 	/*
 	 * If this virtual IRQ was written into a list register, we
 	 * have to make sure the CPU that runs the VCPU thread has
@@ -190,15 +191,17 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	 * IRQ, so we release and re-acquire the spin_lock to let the
 	 * other thread sync back the IRQ.
 	 */
+	irq->refcnt++;
 	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
+	irq->refcnt--;
 	irq->active = new_active_state;
 	if (new_active_state)
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_put(vcpu->kvm, irq);
 	else
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 }
 
 /*
@@ -241,7 +244,8 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
 	vgic_change_active_prepare(vcpu, intid);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		vgic_mmio_change_active(vcpu, irq, false);
+
+		vgic_mmio_change_active_put(vcpu, irq, false);
 	}
 	vgic_change_active_finish(vcpu, intid);
 }
@@ -256,7 +260,8 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	vgic_change_active_prepare(vcpu, intid);
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		vgic_mmio_change_active(vcpu, irq, true);
+
+		vgic_mmio_change_active_put(vcpu, irq, true);
 	}
 	vgic_change_active_finish(vcpu, intid);
 }
@@ -272,6 +277,8 @@ unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		val |= (u64)irq->priority << (i * 8);
+
+		vgic_put_irq(irq);
 	}
 
 	return val;
@@ -294,10 +301,10 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
 		/* Narrow the priority range to what we actually support */
 		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
-		spin_unlock(&irq->irq_lock);
+
+		vgic_put_irq(irq);
 	}
 }
 
@@ -313,6 +320,8 @@ unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
 
 		if (irq->config == VGIC_CONFIG_EDGE)
 			value |= (2U << (i * 2));
+
+		vgic_put_irq(irq);
 	}
 
 	return value;
@@ -326,7 +335,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 	int i;
 
 	for (i = 0; i < len * 4; i++) {
-		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		struct vgic_irq *irq;
 
 		/*
 		 * The configuration cannot be changed for SGIs in general,
@@ -337,14 +346,16 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 		if (intid + i < VGIC_NR_PRIVATE_IRQS)
 			continue;
 
-		spin_lock(&irq->irq_lock);
+		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
 		if (test_bit(i * 2 + 1, &val)) {
 			irq->config = VGIC_CONFIG_EDGE;
 		} else {
 			irq->config = VGIC_CONFIG_LEVEL;
 			irq->pending = irq->line_level | irq->soft_pending;
 		}
-		spin_unlock(&irq->irq_lock);
+
+		vgic_put_irq(irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 80313de..2147576 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -94,8 +94,6 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
-
 		/* Always preserve the active bit */
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
 
@@ -123,7 +121,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 			irq->pending = irq->line_level || irq->soft_pending;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index e48a22e..21d84e9 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -82,8 +82,6 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 			intid = val & GICH_LR_VIRTUALID;
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
-
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
@@ -112,7 +110,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 			irq->pending = irq->line_level || irq->soft_pending;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 69b61ab..90f2543 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -48,13 +48,20 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid)
 {
-	/* SGIs and PPIs */
-	if (intid <= VGIC_MAX_PRIVATE)
-		return &vcpu->arch.vgic_cpu.private_irqs[intid];
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
 
-	/* SPIs */
-	if (intid <= VGIC_MAX_SPI)
-		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
+	if (intid <= VGIC_MAX_PRIVATE) {        /* SGIs and PPIs */
+		irq = &vcpu->arch.vgic_cpu.private_irqs[intid];
+		spin_lock(&irq->irq_lock);
+		return irq;
+	}
+
+	if (intid <= VGIC_MAX_SPI) {            /* SPIs */
+		irq = &dist->spis[intid - VGIC_NR_PRIVATE_IRQS];
+		spin_lock(&irq->irq_lock);
+		return irq;
+	}
 
 	/* LPIs are not yet covered */
 	if (intid >= VGIC_MIN_LPI)
@@ -183,9 +190,10 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
  * Needs to be entered with the IRQ lock already held, but will return
  * with all locks dropped.
  */
-bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
+bool vgic_queue_irq_put(struct kvm *kvm, struct vgic_irq *irq)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *irq_vcpu = irq->target_vcpu;
+	u32 intid = irq->intid;
 
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));
 
@@ -201,7 +209,7 @@ retry:
 		 * not need to be inserted into an ap_list and there is also
 		 * no more work for us to do.
 		 */
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 		return false;
 	}
 
@@ -209,12 +217,18 @@ retry:
 	 * We must unlock the irq lock to take the ap_list_lock where
 	 * we are going to insert this new pending interrupt.
 	 */
-	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(irq);
 
 	/* someone can do stuff here, which we re-check below */
 
 	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
-	spin_lock(&irq->irq_lock);
+	irq = vgic_get_irq(kvm, irq_vcpu, intid);
+
+	if (!irq) {
+		/* The LPI has been unmapped, nothing left to do. */
+		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+		return false;
+	}
 
 	/*
 	 * Did something change behind our backs?
@@ -229,17 +243,21 @@ retry:
 	 */
 
 	if (unlikely(irq->vcpu || vcpu != vgic_target_oracle(irq))) {
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 
-		spin_lock(&irq->irq_lock);
+		irq = vgic_get_irq(kvm, irq_vcpu, intid);
+		if (!irq)
+			return false;
+
 		goto retry;
 	}
 
 	list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
+	irq->refcnt++;
 	irq->vcpu = vcpu;
 
-	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(irq);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 
 	kvm_vcpu_kick(vcpu);
@@ -269,14 +287,14 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	if (!irq)
 		return -EINVAL;
 
-	if (irq->hw != mapped_irq)
+	if (irq->hw != mapped_irq) {
+		vgic_put_irq(irq);
 		return -EINVAL;
-
-	spin_lock(&irq->irq_lock);
+	}
 
 	if (!vgic_validate_injection(irq, level)) {
 		/* Nothing to see here, move along... */
-		spin_unlock(&irq->irq_lock);
+		vgic_put_irq(irq);
 		return 0;
 	}
 
@@ -287,7 +305,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		irq->pending = true;
 	}
 
-	vgic_queue_irq_unlock(kvm, irq);
+	vgic_queue_irq_put(kvm, irq);
 
 	return 0;
 }
@@ -324,31 +342,28 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
 
 	BUG_ON(!irq);
 
-	spin_lock(&irq->irq_lock);
-
 	irq->hw = true;
 	irq->hwintid = phys_irq;
 
-	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(irq);
 
 	return 0;
 }
 
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
-	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
-
-	BUG_ON(!irq);
+	struct vgic_irq *irq;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return -EAGAIN;
 
-	spin_lock(&irq->irq_lock);
+	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	BUG_ON(!irq);
 
 	irq->hw = false;
 	irq->hwintid = 0;
 
-	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(irq);
 
 	return 0;
 }
@@ -378,14 +393,21 @@ retry:
 
 		target_vcpu = vgic_target_oracle(irq);
 
-		if (!target_vcpu) {
+		if (!target_vcpu || irq->refcnt == 1) {
+			bool free_irq = false;
+
 			/*
 			 * We don't need to process this interrupt any
 			 * further, move it off the list.
 			 */
 			list_del(&irq->ap_list);
 			irq->vcpu = NULL;
+			irq->refcnt--;
+			if (!irq->refcnt)
+				free_irq = true;
 			spin_unlock(&irq->irq_lock);
+			if (free_irq)
+				kfree(irq);
 			continue;
 		}
 
@@ -611,9 +633,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
 	bool map_is_active;
 
-	spin_lock(&irq->irq_lock);
 	map_is_active = irq->hw && irq->active;
-	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(irq);
 
 	return map_is_active;
 }
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c752152..fa2d225 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -38,7 +38,12 @@ struct vgic_vmcr {
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
-bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
+static inline void vgic_put_irq(struct vgic_irq *irq)
+{
+	spin_unlock(&irq->irq_lock);
+}
+
+bool vgic_queue_irq_put(struct kvm *kvm, struct vgic_irq *irq);
 void vgic_kick_vcpus(struct kvm *kvm);
 
 void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
-- 
2.8.2
