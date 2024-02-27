Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1F155788
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073787; cv=none; b=spJAeUy7FXU7I8jYo7dqD+ia0huaXJmsii6KcEDgb/FwE9m2kQ6O3jT7U50alH1RBOEznIySezn/uNmeP/9ES/ZYZ2NExIdE8QPpIvWrncpMAoGqupvrS6HBFv+u4BKiurXuFX4pYv0GA9Ngu4AcLKOr1aVQWNDCNhfb6xtoFuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073787; c=relaxed/simple;
	bh=2y461LO9Zw1XJ/eiGEi4ZDn0/X4Ziom37WeaA7L03pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcqBUkSuq9GVIIkUF4iEl/yKGgf+RWS08TWURLgox00eQ7VGxElLTU4EsNus6ZU7q9lr5iLMg8Zqr79Wt7lALamlCL67poyGapzmSIhjKwmbj820ieZpNNDpXoFVuAwMkH4SgEBC8tTniQjN025q8/MVK2VJo8unbWNYHbwZS9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C7G5hqxa; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C7G5hqxa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GrZBaOHbuN25cH8D42vG5hlQ8haPjtjNmo4E27B5Ng=;
	b=C7G5hqxahlv3tYpSYWWnTkyskxeZGQGgbdSVMleVx7PloBYf3zHfdy3zkeZW3vOIGdONiN
	ET2FWI6PKUoDM05YnI9KsIsJI5dRwpueyN90LUhWkT//N4bOP6qlfFiDRRcp223+2Nhw5c
	od3lUgqn22AlbwWbvx2AcH6L3RcCB/w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 02/20] KVM: arm64: vgic-its: Walk LPI xarray in its_sync_lpi_pending_table()
Date: Tue, 27 Feb 2024 22:42:31 +0000
Message-ID: <20240227224249.2209194-3-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/vgic/vgic-its.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 901a7e7166ea..af183eea8631 100644
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
@@ -472,22 +467,21 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
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
+
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
2.44.0.rc1.240.g4c46232300-goog

