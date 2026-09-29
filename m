Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD8B4E1C9A
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717372; cv=none; b=kGAe0baJfobS2HgiDzZFF91pMhW/ZBoigIrJXJjGl4L/MlJLmKize3UVxcDwU12p84OqH9Ejnjs+coGZ+WHnMdlK1fUhWEDO9mGf+/PpkNFFIVMewhl44XF9c7YSpvEMpKQWRcilzOco8XBf1lslf0tGI1iPuHUjX7kkWrJ/ndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717372; c=relaxed/simple;
	bh=MF17aGnTvkiT48dr1/jHrCSOCye5CdpKAJMggQ9JoHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvinaV1vCFU1o+3aAvM6tp2bXzcYrQ+swcMe69vtrhj39O57nEFn+rMqM3U8z5ZBJSb/RUNJ8R51ImCd9pqzrwLfzHdZPL4GN+c/veZwbB12sSTRm3V8Gjxf96tocoQkE7aK8w9fh8UHZU+eObvuO/AjKbTiqdsEIeNY4Q0KM/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4NUBTN4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4NUBTN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98A11F0089C;
	Tue, 29 Sep 2026 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717370;
	bh=ELlYtwAlT4Pc6rm6ufy5uDtoanbz2LEolxLdOys6lts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4NUBTN4eFkRsHEsFWhaVC5oLPAEpiWXJRCbDX/Eo9zr7bwcRnmcZk88O4xukwI7Z
	 ZB3Y9iPleVAgQU9in+5AleVpsTkx/lpgxhpik1WWhpg1RtUhR3MtxETbiKF6MW3rP9
	 6W7yhh2PuPNhHATBGRPrhOoxzJGz4zLga2uHuqooXYZGHKTcy9DgcxS5kTj3QoO8eH
	 24mGLWn5jz4ZYFv4JLx6333j7RxUZTxpa4isVdgFZ8JqmUHEfDkTC/ToAxVIbhs5MW
	 5Cmd+IX5T/cjUF/bB8A95cip8u5Rw1RTsPNlGbuEq73LFz7b4RybW6dJJZ2Pd9niUb
	 65Ie8GQcU0cWA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 2/4] KVM: arm64: vgic: Move IRQ migrations out of vgic_prune_ap_list()
Date: Tue, 29 Sep 2026 14:29:23 -0700
Message-ID: <20260929212925.31775-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929212925.31775-1-oupton@kernel.org>
References: <20260929212925.31775-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an IRQ is migrated between vCPUs, the routing information is updated
synchronously whereas the literal transfer of an active/pending IRQ is
deferred to the next vCPU exit. At least in the case of a MOVI command
this violates the architecture as after a subsequent SYNC command the
effects of the MOVI are said to be globally-visible, including the
transfer of pending state to the new redistributor.

In KVM it is possible to then take an IRQ on the old vCPU after the
migration command retires as there could be a stale LR on the CPU with
pending state. Additionally, it is vulnerable to guest-induced lock
contention as vgic_prune_ap_list() potentially takes *both* vCPU's
ap_list_locks. And yes, this happens before we have the opportunity to
even re-enable IRQs on the CPU.

Align our emulation with the architecture and ensure that active/pending
IRQs are actually on the correct destination vCPU synchronously with the
migration itself. Eliminate the need to nest ap_list_locks in so doing
as the implementation now only needs to inspect a single vCPU's AP list
at a time to detach the IRQ and later requeue it.

Just directly update the IRQ's target if the IRQ is inactive, as there's
no AP list to go modify. Otherwise, halt the owning vCPU and re-attempt
the migration, this time removing it from the AP list and re-queueing it
with vgic_queue_irq_unlock().

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c     |   9 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  11 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  10 +-
 arch/arm64/kvm/vgic/vgic.c         | 184 +++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic.h         |  24 ++++
 include/kvm/arm_vgic.h             |   1 +
 6 files changed, 139 insertions(+), 100 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 094eede267e5..585df69d1ffe 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -325,13 +325,10 @@ static int update_affinity(struct vgic_irq *irq,
 	struct its_vlpi_map map;
 	int ret;
 
+	/* Must be called outside of @irq->irq_lock */
+	vgic_update_lpi_affinity(vcpu->kvm, irq, from_vcpu, vcpu);
 	guard(raw_spinlock_irqsave)(&irq->irq_lock);
-	if (from_vcpu && irq->target_vcpu != from_vcpu)
-		return 0;
-
-	irq->target_vcpu = vcpu;
-
-	if (!irq->hw)
+	if (!(irq->target_vcpu == vcpu && irq->hw))
 		return 0;
 
 	ret = its_get_vlpi(irq->host_irq, &map);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index 0643e333db35..ac789c372b7f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -184,7 +184,6 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
 	u8 cpu_mask = GENMASK(atomic_read(&vcpu->kvm->online_vcpus) - 1, 0);
 	int i;
-	unsigned long flags;
 
 	/* GICD_ITARGETSR[0-7] are read-only */
 	if (intid < VGIC_NR_PRIVATE_IRQS)
@@ -192,15 +191,9 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 
 	for (i = 0; i < len; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, intid + i);
-		int target;
-
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		int targets = (val >> (i * 8)) & cpu_mask;
 
-		irq->targets = (val >> (i * 8)) & cpu_mask;
-		target = irq->targets ? __ffs(irq->targets) : 0;
-		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
-
-		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		vgic_v2_update_spi_affinity(vcpu->kvm, irq, targets);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index adefc4296473..e5fd7a0002b5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -241,7 +241,7 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 {
 	int intid = VGIC_ADDR_TO_INTID(addr, 64);
 	struct vgic_irq *irq;
-	unsigned long flags;
+	u64 mpidr;
 
 	/* The upper word is WI for us since we don't implement Aff3. */
 	if (addr & 4)
@@ -252,13 +252,9 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	if (!irq)
 		return;
 
-	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-
 	/* We only care about and preserve Aff0, Aff1 and Aff2. */
-	irq->mpidr = val & GENMASK(23, 0);
-	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, irq->mpidr);
-
-	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	mpidr = val & GENMASK(23, 0);
+	vgic_v3_update_spi_affinity(vcpu->kvm, irq, mpidr);
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 5cf5a1ef86cd..e82889033691 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -739,6 +739,98 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
 	return ret;
 }
 
+/*
+ * Updates the affinity of the specified IRQ to the new vCPU (which may be NULL)
+ * and handles the tricky business of moving the IRQ between AP lists if
+ * necessary.
+ */
+void __vgic_update_irq_affinity(struct kvm *kvm, struct vgic_irq *irq,
+				struct kvm_vcpu *old, struct kvm_vcpu *new,
+				u32 data)
+{
+	struct kvm_vcpu *tmp;
+	unsigned long flags;
+	bool pruned = false;
+
+retry:
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		/*
+		 * We could be filtering migrations by source vCPU (e.g. ITS
+		 * MOVALL command). Bail if the IRQ is affined somewhere we
+		 * don't expect.
+		 */
+		if (old && irq->target_vcpu != old)
+			return;
+
+		/*
+		 * The IRQ we're trying to migrate isn't on any AP list, meaning
+		 * all we need to do is update the target and bail.
+		 */
+		if (!irq->vcpu) {
+			irq->target_vcpu = new;
+
+			/*
+			 * Cheap trick to keep this somewhat generic: demux data
+			 * to the correct field based on whether or not we're
+			 * dealing with GICv2.
+			 */
+			if (vgic_is_v2(kvm))
+				irq->targets = data;
+			else
+				irq->mpidr = data;
+			return;
+		}
+
+		/*
+		 * If not, the IRQ exists on another vCPU. Choose our target
+		 * and set phasers to stun: we need the old vCPU to synchronize
+		 * the LR state back into the AP list. Prepare to drop the
+		 * irq_lock so we may reacquire it behind the ap_list_lock.
+		 */
+		tmp = irq->vcpu;
+	}
+
+	/* Fire! */
+	kvm_pause_vcpu(tmp);
+
+	scoped_guard(raw_spinlock_irqsave, &tmp->arch.vgic_cpu.ap_list_lock) {
+		scoped_guard(raw_spinlock, &irq->irq_lock) {
+			/*
+			 * The IRQ could've been moved to another AP list after
+			 * dropping the irq_lock. Make sure it's where we expect
+			 * it to be, remove from the list and retain the implied
+			 * reference until we queue it on the new vCPU.
+			 */
+			if (irq->vcpu == tmp) {
+				list_del(&irq->ap_list);
+				irq->vcpu = NULL;
+				irq->target_vcpu = new;
+				if (vgic_is_v2(kvm))
+					irq->targets = data;
+				else
+					irq->mpidr = data;
+				pruned = true;
+			}
+		}
+	}
+
+	/*
+	 * Release the stunned vCPU and retry the whole operation if we weren't
+	 * able to move the IRQ off of the old AP list.
+	 */
+	kvm_resume_vcpu(tmp);
+	if (!pruned)
+		goto retry;
+
+	/*
+	 * Finally, queue the IRQ onto the destination AP list (if there is one)
+	 * and drop the retained reference.
+	 */
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	vgic_queue_irq_unlock(kvm, irq, flags);
+	vgic_put_irq(kvm, irq);
+}
+
 /**
  * vgic_prune_ap_list - Remove non-relevant interrupts from the list
  *
@@ -755,102 +847,38 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
-retry:
 	raw_spin_lock(&vgic_cpu->ap_list_lock);
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
-		bool target_vcpu_needs_kick = false;
-
-		raw_spin_lock(&irq->irq_lock);
+		struct kvm_vcpu *target_vcpu;
 
 		BUG_ON(vcpu != irq->vcpu);
 
-		target_vcpu = vgic_target_oracle(irq);
-
-		if (!target_vcpu) {
-			/*
-			 * We don't need to process this interrupt any
-			 * further, move it off the list.
-			 */
-			list_del(&irq->ap_list);
-			irq->vcpu = NULL;
-			raw_spin_unlock(&irq->irq_lock);
-
-			/*
-			 * This vgic_put_irq call matches the
-			 * vgic_get_irq_ref in vgic_queue_irq_unlock,
-			 * where we added the LPI to the ap_list. As
-			 * we remove the irq from the list, we drop
-			 * also drop the refcount.
-			 */
-			deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
-			continue;
-		}
+		raw_spin_lock(&irq->irq_lock);
 
-		if (target_vcpu == vcpu) {
-			/* We're on the right CPU */
+		target_vcpu = vgic_target_oracle(irq);
+		if (target_vcpu) {
+			KVM_BUG_ON(target_vcpu != vcpu, vcpu->kvm);
 			raw_spin_unlock(&irq->irq_lock);
 			continue;
 		}
 
 		/*
-		 * This interrupt looks like it has to be migrated,
-		 * make sure it is kept alive while locks are dropped.
+		 * We don't need to process this interrupt any
+		 * further, move it off the list.
 		 */
-		vgic_get_irq_ref(irq);
-
+		list_del(&irq->ap_list);
+		irq->vcpu = NULL;
 		raw_spin_unlock(&irq->irq_lock);
-		raw_spin_unlock(&vgic_cpu->ap_list_lock);
 
 		/*
-		 * Ensure locking order by always locking the smallest
-		 * ID first.
+		 * This vgic_put_irq call matches the
+		 * vgic_get_irq_ref in vgic_queue_irq_unlock,
+		 * where we added the LPI to the ap_list. As
+		 * we remove the irq from the list, we drop
+		 * also drop the refcount.
 		 */
-		if (vcpu->vcpu_id < target_vcpu->vcpu_id) {
-			vcpuA = vcpu;
-			vcpuB = target_vcpu;
-		} else {
-			vcpuA = target_vcpu;
-			vcpuB = vcpu;
-		}
-
-		raw_spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
-		raw_spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
-				      SINGLE_DEPTH_NESTING);
-		raw_spin_lock(&irq->irq_lock);
-
-		/*
-		 * If the interrupt is still ours and its affinity has
-		 * been preserved, move it around. Otherwise, it means
-		 * things have changed while the interrupt was unlocked
-		 * (it may even have been taken off the list with its
-		 * affinity left untouched), and we need to replay this.
-		 *
-		 * In all cases, we cannot trust the list not to have
-		 * changed, so we restart from the beginning.
-		 */
-		if (irq->vcpu == vcpu && target_vcpu == vgic_target_oracle(irq)) {
-			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
-
-			list_del(&irq->ap_list);
-			irq->vcpu = target_vcpu;
-			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
-			target_vcpu_needs_kick = true;
-		}
-
-		raw_spin_unlock(&irq->irq_lock);
-		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
-		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
-
 		deleted_lpis |= vgic_put_irq_norelease(vcpu->kvm, irq);
-
-		if (target_vcpu_needs_kick) {
-			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
-			kvm_vcpu_kick(target_vcpu);
-		}
-
-		goto retry;
 	}
 
 	/*
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b71d486ae514..18437620e198 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -515,4 +515,28 @@ static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
 
+void __vgic_update_irq_affinity(struct kvm *kvm, struct vgic_irq *irq,
+				struct kvm_vcpu *old, struct kvm_vcpu *new,
+				u32 data);
+
+static inline void vgic_v2_update_spi_affinity(struct kvm *kvm, struct vgic_irq *irq,
+					       u8 targets)
+{
+	int target = targets ? __ffs(targets) : 0;
+
+	__vgic_update_irq_affinity(kvm, irq, NULL, kvm_get_vcpu(kvm, target), targets);
+}
+
+static inline void vgic_v3_update_spi_affinity(struct kvm *kvm, struct vgic_irq *irq,
+					       u32 mpidr)
+{
+	__vgic_update_irq_affinity(kvm, irq, NULL, kvm_mpidr_to_vcpu(kvm, mpidr), mpidr);
+}
+
+static inline void vgic_update_lpi_affinity(struct kvm *kvm, struct vgic_irq *irq,
+					    struct kvm_vcpu *old, struct kvm_vcpu *new)
+{
+	__vgic_update_irq_affinity(kvm, irq, old, new, 0);
+}
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 086b7578e5f3..e161f2e3a07c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -123,6 +123,7 @@
 #define vgic_v5_make_lpi(x) (__vgic_v5_set_type(LPI) | vgic_v5_set_hwirq_id(x))
 
 #define __vgic_is_v(k, v) ((k)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V##v)
+#define vgic_is_v2(k) (__vgic_is_v(k, 2))
 #define vgic_is_v3(k) (__vgic_is_v(k, 3))
 #define vgic_is_v5(k) (__vgic_is_v(k, 5))
 
-- 
2.47.3

