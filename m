Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26DA13D277
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566356; cv=none; b=ATKIIrGs41ihlF97486yzK2GV0H4li86g/gPny+WskaO8tVvM+tKXH219rBbBxD1STnhO12Rc7o12ZcGglEAxEyhViYQEdeN/BODfAQb05Z1sYmZXCoofbLTTcp3NliSuNENspCPVhWdiMJ5Muf42I/5HOpQUixxsKtfdA7SIAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566356; c=relaxed/simple;
	bh=RK/yM6qsOPw3n0OH0gCLys55qhO8zYpWnFFNNWH/wDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEoAXZ0SR2ZvQAVpOYhgCN9B17qh1vll9CIt7WgpwqA/6vLKOuCcsMzFP4dCuQmlKt9lXJUYbys8n/MvSPtPkeo4HgCeu8SH3nUW5L0NjP/29wXRiKfrPUa18wggbCaMmUYdrW5R5JaBTcBoNenbd2m8/GiYsXIhVTHm6mXrNs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ea5ALDfP; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ea5ALDfP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQTl/Amd80cS3RGpOqQqk/wdPqY6PhjicfoJOM1VxG4=;
	b=Ea5ALDfPwPNul1Rf0LoJ2rG50p+OxDdOaHnyET6mI20Y5pbsN4amnP5rcUllFqwtmNIeFc
	SdiGfPrQViKs7vpT/Gx0xEb6+Kg+EvthxmOQkEsoVxZ981zcK6JbLAJmioN4oHIUHsPdwN
	QPARe1ihjz11F2LhfFsKtfvIMzHEVeE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 02/19] KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
Date: Fri, 19 Apr 2024 22:38:25 +0000
Message-ID: <20240419223842.951452-3-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The new LPI xarray makes it possible to walk the VM's LPIs without
holding a lock, meaning that vgic_copy_lpi_list() is no longer
necessary. Prepare for the deletion by walking the LPI xarray directly
in its_sync_lpi_pending_table().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e85a495ada9c..bdb7718b923a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -446,23 +446,18 @@ static u32 max_lpis_propbaser(u64 propbaser)
 static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 {
 	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	unsigned long intid, flags;
 	struct vgic_irq *irq;
 	int last_byte_offset = -1;
 	int ret = 0;
-	u32 *intids;
-	int nr_irqs, i;
-	unsigned long flags;
 	u8 pendmask;
 
-	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, vcpu, &intids);
-	if (nr_irqs < 0)
-		return nr_irqs;
-
-	for (i = 0; i < nr_irqs; i++) {
+	xa_for_each(&dist->lpi_xa, intid, irq) {
 		int byte_offset, bit_nr;
 
-		byte_offset = intids[i] / BITS_PER_BYTE;
-		bit_nr = intids[i] % BITS_PER_BYTE;
+		byte_offset = intid / BITS_PER_BYTE;
+		bit_nr = intid % BITS_PER_BYTE;
 
 		/*
 		 * For contiguously allocated LPIs chances are we just read
@@ -472,25 +467,23 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
 			ret = kvm_read_guest_lock(vcpu->kvm,
 						  pendbase + byte_offset,
 						  &pendmask, 1);
-			if (ret) {
-				kfree(intids);
+			if (ret)
 				return ret;
-			}
+
 			last_byte_offset = byte_offset;
 		}
 
-		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
+		irq = vgic_get_irq(vcpu->kvm, NULL, intid);
 		if (!irq)
 			continue;
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = pendmask & (1U << bit_nr);
+		if (irq->target_vcpu == vcpu)
+			irq->pending_latch = pendmask & (1U << bit_nr);
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
-	kfree(intids);
-
 	return ret;
 }
 
-- 
2.44.0.769.g3c40516874-goog

