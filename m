From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 3/7] KVM: arm/arm64: Support calling
 vgic_update_irq_pending from irq context
Date: Sat, 10 Dec 2016 21:47:08 +0100
Message-ID: <20161210204712.21830-4-christoffer.dall@linaro.org>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F195A404E2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kr9NWSNGL9XO for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Dec 2016 15:46:08 -0500 (EST)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
 [209.85.215.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BDEB40423
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:06 -0500 (EST)
Received: by mail-lf0-f48.google.com with SMTP id y21so21797151lfa.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 12:47:09 -0800 (PST)
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We are about to optimize our timer handling logic which involves
injecting irqs to the vgic directly from the irq handler.

Unfortunately, the injection path can take any AP list lock and irq lock
and we must therefore make sure to use spin_lock_irqsave whereever
interrupts are enabled and we are taking any of those locks, to avoid
deadlocking between process context and the ISR.

This changes a lot of the VGIC code, but The good news are that the
changes are mostly mechanichal.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c     | 17 +++++++-----
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 +++++++++-------
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 10 ++++---
 virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++-----------
 virt/kvm/arm/vgic/vgic-v2.c      |  5 ++--
 virt/kvm/arm/vgic/vgic-v3.c      |  5 ++--
 virt/kvm/arm/vgic/vgic.c         | 56 +++++++++++++++++++++++++---------------
 virt/kvm/arm/vgic/vgic.h         |  3 ++-
 8 files changed, 95 insertions(+), 61 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8c2b3cd..140ee78 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -207,6 +207,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
 	u8 prop;
 	int ret;
+	unsigned long flags;
 
 	ret = kvm_read_guest(kvm, propbase + irq->intid - GIC_LPI_OFFSET,
 			     &prop, 1);
@@ -214,15 +215,15 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	if (ret)
 		return ret;
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	if (!filter_vcpu || filter_vcpu == irq->target_vcpu) {
 		irq->priority = LPI_PROP_PRIORITY(prop);
 		irq->enabled = LPI_PROP_ENABLE_BIT(prop);
 
-		vgic_queue_irq_unlock(kvm, irq);
+		vgic_queue_irq_unlock(kvm, irq, flags);
 	} else {
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 	}
 
 	return 0;
@@ -322,6 +323,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	int ret = 0;
 	u32 *intids;
 	int nr_irqs, i;
+	unsigned long flags;
 
 	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, &intids);
 	if (nr_irqs < 0)
@@ -349,9 +351,9 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 		}
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending = pendmask & (1U << bit_nr);
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
@@ -449,6 +451,7 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 {
 	struct kvm_vcpu *vcpu;
 	struct its_itte *itte;
+	unsigned long flags;
 
 	if (!its->enabled)
 		return -EBUSY;
@@ -464,9 +467,9 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
-	spin_lock(&itte->irq->irq_lock);
+	spin_lock_irqsave(&itte->irq->irq_lock, flags);
 	itte->irq->pending = true;
-	vgic_queue_irq_unlock(kvm, itte->irq);
+	vgic_queue_irq_unlock(kvm, itte->irq, flags);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index b44b359..f08d3e6 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -74,6 +74,7 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 	int mode = (val >> 24) & 0x03;
 	int c;
 	struct kvm_vcpu *vcpu;
+	unsigned long flags;
 
 	switch (mode) {
 	case 0x0:		/* as specified by targets */
@@ -97,11 +98,11 @@ static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 
 		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending = true;
 		irq->source |= 1U << source_vcpu->vcpu_id;
 
-		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
+		vgic_queue_irq_unlock(source_vcpu->kvm, irq, flags);
 		vgic_put_irq(source_vcpu->kvm, irq);
 	}
 }
@@ -130,6 +131,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
 	int i;
+	unsigned long flags;
 
 	/* GICD_ITARGETSR[0-7] are read-only */
 	if (intid < VGIC_NR_PRIVATE_IRQS)
@@ -139,13 +141,13 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
 		int target;
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->targets = (val >> (i * 8)) & 0xff;
 		target = irq->targets ? __ffs(irq->targets) : 0;
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -173,17 +175,18 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
 {
 	u32 intid = addr & 0x0f;
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->source &= ~((val >> (i * 8)) & 0xff);
 		if (!irq->source)
 			irq->pending = false;
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -194,19 +197,20 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 {
 	u32 intid = addr & 0x0f;
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->source |= (val >> (i * 8)) & 0xff;
 
 		if (irq->source) {
 			irq->pending = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq);
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
-			spin_unlock(&irq->irq_lock);
+			spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 50f42f0..b1c2676 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -127,6 +127,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
 	struct vgic_irq *irq;
+	unsigned long flags;
 
 	/* The upper word is WI for us since we don't implement Aff3. */
 	if (addr & 4)
@@ -137,13 +138,13 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	if (!irq)
 		return;
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	/* We only care about and preserve Aff0, Aff1 and Aff2. */
 	irq->mpidr = val & GENMASK(23, 0);
 	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
 
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
@@ -607,6 +608,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 	int sgi, c;
 	int vcpu_id = vcpu->vcpu_id;
 	bool broadcast;
+	unsigned long flags;
 
 	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
 	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
@@ -645,10 +647,10 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 
 		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ebe1b9f..a7b7dc5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -69,13 +69,14 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->enabled = true;
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -87,15 +88,16 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->enabled = false;
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -126,16 +128,17 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending = true;
 		if (irq->config == VGIC_CONFIG_LEVEL)
 			irq->soft_pending = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -146,11 +149,12 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (irq->config == VGIC_CONFIG_LEVEL) {
 			irq->soft_pending = false;
@@ -159,7 +163,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			irq->pending = false;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -187,7 +191,9 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
 static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool new_active_state)
 {
-	spin_lock(&irq->irq_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	/*
 	 * If this virtual IRQ was written into a list register, we
 	 * have to make sure the CPU that runs the VCPU thread has
@@ -207,9 +213,9 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 
 	irq->active = new_active_state;
 	if (new_active_state)
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 	else
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 }
 
 /*
@@ -305,14 +311,15 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		/* Narrow the priority range to what we actually support */
 		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -343,6 +350,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 2);
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < len * 4; i++) {
 		struct vgic_irq *irq;
@@ -357,7 +365,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 			continue;
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (test_bit(i * 2 + 1, &val)) {
 			irq->config = VGIC_CONFIG_EDGE;
@@ -366,7 +374,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 			irq->pending = irq->line_level | irq->soft_pending;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 0a063af..95cbc9f 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -86,6 +86,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
 	int lr;
+	unsigned long flags;
 
 	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
@@ -94,7 +95,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
@@ -123,7 +124,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 			irq->pending = irq->line_level || irq->soft_pending;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9f0dae3..9edeffd 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -70,6 +70,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	int lr;
+	unsigned long flags;
 
 	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
@@ -84,7 +85,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (!irq)	/* An LPI could have been unmapped. */
 			continue;
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
@@ -114,7 +115,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 			irq->pending = irq->line_level || irq->soft_pending;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 6440b56..67d231d 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -50,6 +50,10 @@ struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif =
  *   vcpuX->vcpu_id < vcpuY->vcpu_id:
  *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
  *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
+ *
+ * Since the VGIC must support injecting virtual interrupts from ISRs, we have
+ * to use the spin_lock_irqsave/spin_unlock_irqrestore versions of outer
+ * spinlocks for any lock that may be taken while injecting an interrupt.
  */
 
 /*
@@ -254,7 +258,8 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
  * Needs to be entered with the IRQ lock already held, but will return
  * with all locks dropped.
  */
-bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
+bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+			   unsigned long flags)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -272,7 +277,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 		 * not need to be inserted into an ap_list and there is also
 		 * no more work for us to do.
 		 */
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		/*
 		 * We have to kick the VCPU here, because we could be
@@ -292,11 +297,11 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 	 * We must unlock the irq lock to take the ap_list_lock where
 	 * we are going to insert this new pending interrupt.
 	 */
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 	/* someone can do stuff here, which we re-check below */
 
-	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 	spin_lock(&irq->irq_lock);
 
 	/*
@@ -313,9 +318,9 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 
 	if (unlikely(irq->vcpu || vcpu != vgic_target_oracle(irq))) {
 		spin_unlock(&irq->irq_lock);
-		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+		spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		goto retry;
 	}
 
@@ -328,7 +333,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 	irq->vcpu = vcpu;
 
 	spin_unlock(&irq->irq_lock);
-	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
 	kvm_vcpu_kick(vcpu);
 
@@ -341,6 +346,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 {
 	struct kvm_vcpu *vcpu;
 	struct vgic_irq *irq;
+	unsigned long flags;
 	int ret;
 
 	trace_vgic_update_irq_pending(cpuid, intid, level);
@@ -362,11 +368,11 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		return -EINVAL;
 	}
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	if (!vgic_validate_injection(irq, level)) {
 		/* Nothing to see here, move along... */
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(kvm, irq);
 		return 0;
 	}
@@ -378,7 +384,7 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		irq->pending = true;
 	}
 
-	vgic_queue_irq_unlock(kvm, irq);
+	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
 
 	return 0;
@@ -413,15 +419,16 @@ int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
+	unsigned long flags;
 
 	BUG_ON(!irq);
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	irq->hw = true;
 	irq->hwintid = phys_irq;
 
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
 	return 0;
@@ -430,6 +437,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	struct vgic_irq *irq;
+	unsigned long flags;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return -EAGAIN;
@@ -437,12 +445,12 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
 	BUG_ON(!irq);
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	irq->hw = false;
 	irq->hwintid = 0;
 
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
 	return 0;
@@ -460,9 +468,10 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
+	unsigned long flags;
 
 retry:
-	spin_lock(&vgic_cpu->ap_list_lock);
+	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
@@ -502,7 +511,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		/* This interrupt looks like it has to be migrated. */
 
 		spin_unlock(&irq->irq_lock);
-		spin_unlock(&vgic_cpu->ap_list_lock);
+		spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 
 		/*
 		 * Ensure locking order by always locking the smallest
@@ -516,7 +525,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			vcpuB = vcpu;
 		}
 
-		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		spin_lock_irqsave(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
 		spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
 				 SINGLE_DEPTH_NESTING);
 		spin_lock(&irq->irq_lock);
@@ -540,11 +549,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 		spin_unlock(&irq->irq_lock);
 		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
-		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		spin_unlock_irqrestore(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
 		goto retry;
 	}
 
-	spin_unlock(&vgic_cpu->ap_list_lock);
+	spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 }
 
 static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
@@ -671,6 +680,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (unlikely(!vgic_initialized(vcpu->kvm)))
 		return;
 
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+
 	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
@@ -681,11 +692,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 	bool pending = false;
+	unsigned long flags;
 
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
 
-	spin_lock(&vgic_cpu->ap_list_lock);
+	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		spin_lock(&irq->irq_lock);
@@ -696,7 +708,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 			break;
 	}
 
-	spin_unlock(&vgic_cpu->ap_list_lock);
+	spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 
 	return pending;
 }
@@ -721,6 +733,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
 	bool map_is_active;
 
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+
 	spin_lock(&irq->irq_lock);
 	map_is_active = irq->hw && irq->active;
 	spin_unlock(&irq->irq_lock);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 859f65c..2132c66 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -40,7 +40,8 @@ struct vgic_vmcr {
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
-bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
+bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+			   unsigned long flags);
 void vgic_kick_vcpus(struct kvm *kvm);
 
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-- 
2.9.0
