Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27141366
	for <kvmarm@lists.linux.dev>; Wed, 28 Feb 2024 00:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709078494; cv=none; b=FSGGPA6sLZqJ5o5N6ZFAv38t1/Ok/dyF41Md0iLNGnXK/jLOJQepJPM4gm40bzcYFE1DeY9E9ZD34VDw8VVdF7mzkFE8ivalr7bvuweQZbQXuptcYlBWgqUMPc62SGG9SduYcXdzbfVhad05JYyv9Su0pjsXRIewAeqzIRgo9jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709078494; c=relaxed/simple;
	bh=uamqDXIqdZYw+0FNMX/IBNcVIqq24ZJB6a8e8S7mgMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pRWR3FESWlTXLnASd8IVB7eM74F3wRBhIClocPYs89Tw72rFdJQbOB9OgVqO032V6wPGAbayfVcnn1uKN5JwOzz0w2flwX0cYTWGnrJUn/HHgAQR+k3c1DOREWdX7qbjZYjfvkBFokO83FWDOw6zY4io1lMSTI1Cfy6CFGgP/+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CmMlMPRd; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CmMlMPRd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709078489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LhqjVfAUACvSzmbp1QQXBY3KxrDsN4eRTxmJccGrh+U=;
	b=CmMlMPRdvkmnwL7qYXIlWR5rXteIHoMCWUVZODmBIZ8Zl7ovxb7H96YXDUdEPkFVsxd2wI
	7I5E04/LHaUPuw3YfBvZ2UgfJoPPXz0IEkDzpK2HmEHZ717WdJLwAc0bgwIdfKQtLsa2NA
	Oh4+xx9vacG6PwnmVEcdStqcNBYd7AU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: vgic-v3: Don't load pending state when enabling LPIs on RD
Date: Wed, 28 Feb 2024 00:01:17 +0000
Message-ID: <20240228000117.2297982-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reality check: KVM's GIC/ITS emulation does not handle pending LPI state
to the letter of the architecture!

Although the GIC spec defines LPI pending state on a per-redistributor
basis, KVM's view of the LPIs in a VM are global by design. This is
intentional, as it is a massive simplification to the way KVM organizes
interrupts and deals with the interactions between the vCPUs and ITSes.

So, with that in mind, the KVM emulation of PENDBASE is completely wrong,
as unmapped INTIDs (i.e. not mapped in any ITS) are silently ignored,
even though the expecatation is that IRQs would be generated in real
hardware. Even more hilarious things can happen for the LPIs that are
actually mapped, as an update to global LPI state can pend an interrupt
on a different vCPU.

vgic_add_lpi() fetches pending state when creating the global
representation of an LPI. Both VM save/restore and guest interactions
with the ITS find their way here, so the pending state will get loaded
into KVM one way or another. That flow is slightly more correct, as it
consults the pending table of the targeted redistributor.

Anyway, it is clear that this code can never be correct and doesn't
serve a purpose. If bisection led you here you've probably got a *very*
funky guest, and should bring it up on the list...

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c     | 60 ------------------------------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  8 +---
 arch/arm64/kvm/vgic/vgic.h         |  1 -
 3 files changed, 2 insertions(+), 67 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e2764d0ffa9f..c114dde3739b 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -426,59 +426,6 @@ static u32 max_lpis_propbaser(u64 propbaser)
 	return 1U << min(nr_idbits, INTERRUPT_ID_BITS_ITS);
 }
 
-/*
- * Sync the pending table pending bit of LPIs targeting @vcpu
- * with our own data structures. This relies on the LPI being
- * mapped before.
- */
-static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
-{
-	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
-	struct vgic_irq *irq;
-	int last_byte_offset = -1;
-	int ret = 0;
-	u32 *intids;
-	int nr_irqs, i;
-	unsigned long flags;
-	u8 pendmask;
-
-	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, vcpu, &intids);
-	if (nr_irqs < 0)
-		return nr_irqs;
-
-	for (i = 0; i < nr_irqs; i++) {
-		int byte_offset, bit_nr;
-
-		byte_offset = intids[i] / BITS_PER_BYTE;
-		bit_nr = intids[i] % BITS_PER_BYTE;
-
-		/*
-		 * For contiguously allocated LPIs chances are we just read
-		 * this very same byte in the last iteration. Reuse that.
-		 */
-		if (byte_offset != last_byte_offset) {
-			ret = kvm_read_guest_lock(vcpu->kvm,
-						  pendbase + byte_offset,
-						  &pendmask, 1);
-			if (ret) {
-				kfree(intids);
-				return ret;
-			}
-			last_byte_offset = byte_offset;
-		}
-
-		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = pendmask & (1U << bit_nr);
-		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-		vgic_put_irq(vcpu->kvm, irq);
-	}
-
-	kfree(intids);
-
-	return ret;
-}
-
 static unsigned long vgic_mmio_read_its_typer(struct kvm *kvm,
 					      struct vgic_its *its,
 					      gpa_t addr, unsigned int len)
@@ -1857,13 +1804,6 @@ static struct vgic_register_region its_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
-/* This is called on setting the LPI enable bit in the redistributor. */
-void vgic_enable_lpis(struct kvm_vcpu *vcpu)
-{
-	if (!(vcpu->arch.vgic_cpu.pendbaser & GICR_PENDBASER_PTZ))
-		its_sync_lpi_pending_table(vcpu);
-}
-
 static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
 				   u64 addr)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index c15ee1df036a..b555b1b424d3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -280,12 +280,8 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
 		vgic_its_invalidate_cache(vcpu->kvm);
 		atomic_set_release(&vgic_cpu->ctlr, 0);
 	} else {
-		ctlr = atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
-					      GICR_CTLR_ENABLE_LPIS);
-		if (ctlr != 0)
-			return;
-
-		vgic_enable_lpis(vcpu);
+		atomic_cmpxchg_acquire(&vgic_cpu->ctlr, 0,
+				       GICR_CTLR_ENABLE_LPIS);
 	}
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 8d134569d0a1..b79c586343c0 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -250,7 +250,6 @@ void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu);
 
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
-void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.44.0.rc1.240.g4c46232300-goog

