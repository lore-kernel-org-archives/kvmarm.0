From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v5 05/20] KVM: arm/arm64: Support calling
 vgic_update_irq_pending from irq context
Date: Fri, 27 Oct 2017 10:34:26 +0200
Message-ID: <1509093281-15225-6-git-send-email-cdall@linaro.org>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16A3B40795
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:34:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tO706sh3dtMr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 04:34:05 -0400 (EDT)
Received: from mail-lf0-f67.google.com (mail-lf0-f67.google.com
 [209.85.215.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC9E641185
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 04:34:04 -0400 (EDT)
Received: by mail-lf0-f67.google.com with SMTP id b190so6534735lfg.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 01:35:29 -0700 (PDT)
In-Reply-To: <1509093281-15225-1-git-send-email-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We are about to optimize our timer handling logic which involves
injecting irqs to the vgic directly from the irq handler.

Unfortunately, the injection path can take any AP list lock and irq lock
and we must therefore make sure to use spin_lock_irqsave where ever
interrupts are enabled and we are taking any of those locks, to avoid
deadlocking between process context and the ISR.

This changes a lot of the VGIC code, but the good news are that the
changes are mostly mechanical.

Acked-by: Marc Zyngier <marc,zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c     | 17 +++++++-----
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 22 +++++++++------
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 17 +++++++-----
 virt/kvm/arm/vgic/vgic-mmio.c    | 44 ++++++++++++++++++------------
 virt/kvm/arm/vgic/vgic-v2.c      |  5 ++--
 virt/kvm/arm/vgic/vgic-v3.c      | 12 ++++----
 virt/kvm/arm/vgic/vgic.c         | 59 ++++++++++++++++++++++++----------------
 virt/kvm/arm/vgic/vgic.h         |  3 +-
 8 files changed, 107 insertions(+), 72 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f51c1e1..9f5e347 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -278,6 +278,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
 	u8 prop;
 	int ret;
+	unsigned long flags;
 
 	ret = kvm_read_guest(kvm, propbase + irq->intid - GIC_LPI_OFFSET,
 			     &prop, 1);
@@ -285,15 +286,15 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
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
@@ -393,6 +394,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 	int ret = 0;
 	u32 *intids;
 	int nr_irqs, i;
+	unsigned long flags;
 
 	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
 	if (nr_irqs < 0)
@@ -420,9 +422,9 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 		}
 
 		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = pendmask & (1U << bit_nr);
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
@@ -515,6 +517,7 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 {
 	struct kvm_vcpu *vcpu;
 	struct its_ite *ite;
+	unsigned long flags;
 
 	if (!its->enabled)
 		return -EBUSY;
@@ -530,9 +533,9 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
-	spin_lock(&ite->irq->irq_lock);
+	spin_lock_irqsave(&ite->irq->irq_lock, flags);
 	ite->irq->pending_latch = true;
-	vgic_queue_irq_unlock(kvm, ite->irq);
+	vgic_queue_irq_unlock(kvm, ite->irq, flags);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index b3d4a10..e21e2f4 100644
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
 		irq->pending_latch = true;
 		irq->source |= 1U << source_vcpu->vcpu_id;
 
-		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
+		vgic_queue_irq_unlock(source_vcpu->kvm, irq, flags);
 		vgic_put_irq(source_vcpu->kvm, irq);
 	}
 }
@@ -131,6 +132,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
 	u8 cpu_mask = GENMASK(atomic_read(&vcpu->kvm->online_vcpus) - 1, 0);
 	int i;
+	unsigned long flags;
 
 	/* GICD_ITARGETSR[0-7] are read-only */
 	if (intid < VGIC_NR_PRIVATE_IRQS)
@@ -140,13 +142,13 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
 		int target;
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->targets = (val >> (i * 8)) & cpu_mask;
 		target = irq->targets ? __ffs(irq->targets) : 0;
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -174,17 +176,18 @@ static void vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
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
 			irq->pending_latch = false;
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -195,19 +198,20 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
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
 			irq->pending_latch = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq);
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
-			spin_unlock(&irq->irq_lock);
+			spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 408ef06..8378610 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -129,6 +129,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
 	struct vgic_irq *irq;
+	unsigned long flags;
 
 	/* The upper word is WI for us since we don't implement Aff3. */
 	if (addr & 4)
@@ -139,13 +140,13 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
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
 
@@ -241,11 +242,12 @@ static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		if (test_bit(i, &val)) {
 			/*
 			 * pending_latch is set irrespective of irq type
@@ -253,10 +255,10 @@ static void vgic_v3_uaccess_write_pending(struct kvm_vcpu *vcpu,
 			 * restore irq config before pending info.
 			 */
 			irq->pending_latch = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq);
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		} else {
 			irq->pending_latch = false;
-			spin_unlock(&irq->irq_lock);
+			spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 
 		vgic_put_irq(vcpu->kvm, irq);
@@ -799,6 +801,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 	int sgi, c;
 	int vcpu_id = vcpu->vcpu_id;
 	bool broadcast;
+	unsigned long flags;
 
 	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
 	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
@@ -837,10 +840,10 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 
 		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index c1e4bdd..deb51ee 100644
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
@@ -126,14 +128,15 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = true;
 
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -144,15 +147,16 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
+	unsigned long flags;
 
 	for_each_set_bit(i, &val, len * 8) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		irq->pending_latch = false;
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -181,7 +185,8 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool new_active_state)
 {
 	struct kvm_vcpu *requester_vcpu;
-	spin_lock(&irq->irq_lock);
+	unsigned long flags;
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	/*
 	 * The vcpu parameter here can mean multiple things depending on how
@@ -216,9 +221,9 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 
 	irq->active = new_active_state;
 	if (new_active_state)
-		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 	else
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 }
 
 /*
@@ -352,14 +357,15 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
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
@@ -390,6 +396,7 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 2);
 	int i;
+	unsigned long flags;
 
 	for (i = 0; i < len * 4; i++) {
 		struct vgic_irq *irq;
@@ -404,14 +411,14 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 			continue;
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		if (test_bit(i * 2 + 1, &val))
 			irq->config = VGIC_CONFIG_EDGE;
 		else
 			irq->config = VGIC_CONFIG_LEVEL;
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
@@ -443,6 +450,7 @@ void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
 {
 	int i;
 	int nr_irqs = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+	unsigned long flags;
 
 	for (i = 0; i < 32; i++) {
 		struct vgic_irq *irq;
@@ -459,12 +467,12 @@ void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
 		 * restore irq config before line level.
 		 */
 		new_level = !!(val & (1U << i));
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->line_level = new_level;
 		if (new_level)
-			vgic_queue_irq_unlock(vcpu->kvm, irq);
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		else
-			spin_unlock(&irq->irq_lock);
+			spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index e4187e5..8089710 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -62,6 +62,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
 	int lr;
+	unsigned long flags;
 
 	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
 
@@ -77,7 +78,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
@@ -104,7 +105,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 				irq->pending_latch = false;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 96ea597..863351c 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -44,6 +44,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	int lr;
+	unsigned long flags;
 
 	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
 
@@ -66,7 +67,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (!irq)	/* An LPI could have been unmapped. */
 			continue;
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
@@ -94,7 +95,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 				irq->pending_latch = false;
 		}
 
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
@@ -278,6 +279,7 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	bool status;
 	u8 val;
 	int ret;
+	unsigned long flags;
 
 retry:
 	vcpu = irq->target_vcpu;
@@ -296,13 +298,13 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 
 	status = val & (1 << bit_nr);
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	if (irq->target_vcpu != vcpu) {
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		goto retry;
 	}
 	irq->pending_latch = status;
-	vgic_queue_irq_unlock(vcpu->kvm, irq);
+	vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
 	if (status) {
 		/* clear consumed data */
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e1f7dbc..e54ef2f 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -53,6 +53,10 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  *   vcpuX->vcpu_id < vcpuY->vcpu_id:
  *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
  *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
+ *
+ * Since the VGIC must support injecting virtual interrupts from ISRs, we have
+ * to use the spin_lock_irqsave/spin_unlock_irqrestore versions of outer
+ * spinlocks for any lock that may be taken while injecting an interrupt.
  */
 
 /*
@@ -261,7 +265,8 @@ static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owne
  * Needs to be entered with the IRQ lock already held, but will return
  * with all locks dropped.
  */
-bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
+bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+			   unsigned long flags)
 {
 	struct kvm_vcpu *vcpu;
 
@@ -279,7 +284,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 		 * not need to be inserted into an ap_list and there is also
 		 * no more work for us to do.
 		 */
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		/*
 		 * We have to kick the VCPU here, because we could be
@@ -301,11 +306,11 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
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
@@ -322,9 +327,9 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 
 	if (unlikely(irq->vcpu || vcpu != vgic_target_oracle(irq))) {
 		spin_unlock(&irq->irq_lock);
-		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+		spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
-		spin_lock(&irq->irq_lock);
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		goto retry;
 	}
 
@@ -337,7 +342,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 	irq->vcpu = vcpu;
 
 	spin_unlock(&irq->irq_lock);
-	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 	kvm_vcpu_kick(vcpu);
@@ -367,6 +372,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 {
 	struct kvm_vcpu *vcpu;
 	struct vgic_irq *irq;
+	unsigned long flags;
 	int ret;
 
 	trace_vgic_update_irq_pending(cpuid, intid, level);
@@ -383,11 +389,11 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	if (!irq)
 		return -EINVAL;
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 
 	if (!vgic_validate_injection(irq, level, owner)) {
 		/* Nothing to see here, move along... */
-		spin_unlock(&irq->irq_lock);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(kvm, irq);
 		return 0;
 	}
@@ -397,7 +403,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 	else
 		irq->pending_latch = true;
 
-	vgic_queue_irq_unlock(kvm, irq);
+	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
 
 	return 0;
@@ -406,15 +412,16 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
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
@@ -423,6 +430,7 @@ int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	struct vgic_irq *irq;
+	unsigned long flags;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return -EAGAIN;
@@ -430,12 +438,12 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
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
@@ -486,9 +494,10 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
+	unsigned long flags;
 
 retry:
-	spin_lock(&vgic_cpu->ap_list_lock);
+	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
@@ -528,7 +537,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		/* This interrupt looks like it has to be migrated. */
 
 		spin_unlock(&irq->irq_lock);
-		spin_unlock(&vgic_cpu->ap_list_lock);
+		spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 
 		/*
 		 * Ensure locking order by always locking the smallest
@@ -542,7 +551,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			vcpuB = vcpu;
 		}
 
-		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		spin_lock_irqsave(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
 		spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
 				 SINGLE_DEPTH_NESTING);
 		spin_lock(&irq->irq_lock);
@@ -566,11 +575,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 		spin_unlock(&irq->irq_lock);
 		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
-		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		spin_unlock_irqrestore(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
 		goto retry;
 	}
 
-	spin_unlock(&vgic_cpu->ap_list_lock);
+	spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 }
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
@@ -703,6 +712,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
 
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
+
 	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
@@ -735,11 +746,12 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
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
@@ -750,7 +762,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 			break;
 	}
 
-	spin_unlock(&vgic_cpu->ap_list_lock);
+	spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 
 	return pending;
 }
@@ -776,13 +788,14 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
 	bool map_is_active;
+	unsigned long flags;
 
 	if (!vgic_initialized(vcpu->kvm))
 		return false;
 
-	spin_lock(&irq->irq_lock);
+	spin_lock_irqsave(&irq->irq_lock, flags);
 	map_is_active = irq->hw && irq->active;
-	spin_unlock(&irq->irq_lock);
+	spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(vcpu->kvm, irq);
 
 	return map_is_active;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index bf9ceab..4f8aecb 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -140,7 +140,8 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
-bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
+bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+			   unsigned long flags);
 void vgic_kick_vcpus(struct kvm *kvm);
 
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
-- 
2.7.4
