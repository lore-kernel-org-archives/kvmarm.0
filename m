Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65BA293739
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748016510; cv=none; b=QF2wOjbRB3ZK45/RPjavjhZfm0IFd1PHQg0eNadjnaWrA9vY304vDvfUc9QbFUOEEGXS4CcDk/HtPu+0DXSBpiJI3bojW5G86eTxTBpZy7W4/K3yGMEcz2j/QHXnMu73Hg/U6mhMYRa1qrnIqMWiTcksTfOFMCdZw1ZRE4Y1h/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748016510; c=relaxed/simple;
	bh=QB74p9Cfpib0Ybkh/T5GC1Px46oC7sU46z/LZ+NL7Js=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jQ6SScyGXdugTKwLfh+Q2GWYiHgIwpfVofODUSJqH4x3AtjbTYO4OM/DnddkzEET3tECfv2RfqAgDxkQpZDXSYOnFq1Sfrt425qMECxdlpc0mM2h7x/6Z/vgiU9M02sNXw2tOCqRUnLrRrREE6f2qgl86euO9uutqf0ssP2WzOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MFMvGEGI; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MFMvGEGI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748016503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lPBnu+KPAL6yB4ssu2XCKZrQ7LI+CLjrIF8KYHn6eq8=;
	b=MFMvGEGIYpRwllZ46M6KSCa8dLaGWRhhv5fubJ9KZ26tE84VjThyQ8J2nkXzbgkQEcy7h0
	eth1EYp7ritjak3ZA7I2X2Zi2zfuUZBVs8GrWcLBFZ3LZGuoPVz413KddLNp0pvSLsCaFH
	xnz5nRPoz9IlV7dglkjoumcHmj94Wy8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea@google.com>
Subject: [PATCH 2/5] KVM: arm64: Protect vLPI translation with vgic_irq::irq_lock
Date: Fri, 23 May 2025 09:08:07 -0700
Message-Id: <20250523160810.4049313-3-oliver.upton@linux.dev>
In-Reply-To: <20250523160810.4049313-1-oliver.upton@linux.dev>
References: <20250523160810.4049313-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Though undocumented, KVM generally protects the translation of a vLPI
with the its_lock. While this makes perfectly good sense, as the ITS
itself contains the guest translation, an upcoming change will require
twiddling the vLPI mapping in an atomic context.

Switch to using the vIRQ's irq_lock to protect the translation.

Tested-by: Sweet Tea Dorminy <sweettea@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 48 +++++++++++++++++-----------------
 arch/arm64/kvm/vgic/vgic-v4.c  | 41 ++++++++++++++++-------------
 2 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 569f9da9049f..beca12dae779 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -306,39 +306,34 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 		}
 	}
 
-	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-
 	if (irq->hw)
-		return its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
+		ret = its_prop_update_vlpi(irq->host_irq, prop, needs_inv);
 
-	return 0;
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	return ret;
 }
 
 static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
-	unsigned long flags;
+	struct its_vlpi_map map;
+	int ret;
 
-	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	guard(raw_spinlock_irqsave)(&irq->irq_lock);
 	irq->target_vcpu = vcpu;
-	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
-	if (irq->hw) {
-		struct its_vlpi_map map;
-
-		ret = its_get_vlpi(irq->host_irq, &map);
-		if (ret)
-			return ret;
+	if (!irq->hw)
+		return 0;
 
-		if (map.vpe)
-			atomic_dec(&map.vpe->vlpi_count);
-		map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
-		atomic_inc(&map.vpe->vlpi_count);
+	ret = its_get_vlpi(irq->host_irq, &map);
+	if (ret)
+		return ret;
 
-		ret = its_map_vlpi(irq->host_irq, &map);
-	}
+	if (map.vpe)
+		atomic_dec(&map.vpe->vlpi_count);
 
-	return ret;
+	map.vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
+	atomic_inc(&map.vpe->vlpi_count);
+	return its_map_vlpi(irq->host_irq, &map);
 }
 
 static struct kvm_vcpu *collection_to_vcpu(struct kvm *kvm,
@@ -756,12 +751,17 @@ int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 /* Requires the its_lock to be held. */
 static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 {
+	struct vgic_irq *irq = ite->irq;
 	list_del(&ite->ite_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	if (ite->irq) {
-		if (ite->irq->hw)
-			WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+	if (irq) {
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+			if (irq->hw)
+				WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+
+			irq->hw = false;
+		}
 
 		vgic_put_irq(kvm, ite->irq);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 8b25e7650998..01a5de8e9e94 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -457,9 +457,11 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 				 irq_entry->msi.data, &irq))
 		return 0;
 
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
 	/* Silently exit if the vLPI is already mapped */
 	if (irq->hw)
-		return 0;
+		goto out_unlock_irq;
 
 	/*
 	 * Emit the mapping request. If it fails, the ITS probably
@@ -479,30 +481,30 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 
 	ret = its_map_vlpi(virq, &map);
 	if (ret)
-		return ret;
+		goto out_unlock_irq;
 
 	irq->hw		= true;
 	irq->host_irq	= virq;
 	atomic_inc(&map.vpe->vlpi_count);
 
 	/* Transfer pending state */
-	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	if (irq->pending_latch) {
-		ret = irq_set_irqchip_state(irq->host_irq,
-					    IRQCHIP_STATE_PENDING,
-					    irq->pending_latch);
-		WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
+	if (!irq->pending_latch)
+		goto out_unlock_irq;
 
-		/*
-		 * Clear pending_latch and communicate this state
-		 * change via vgic_queue_irq_unlock.
-		 */
-		irq->pending_latch = false;
-		vgic_queue_irq_unlock(kvm, irq, flags);
-	} else {
-		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-	}
+	ret = irq_set_irqchip_state(irq->host_irq, IRQCHIP_STATE_PENDING,
+				    irq->pending_latch);
+	WARN_RATELIMIT(ret, "IRQ %d", irq->host_irq);
+
+	/*
+	 * Clear pending_latch and communicate this state
+	 * change via vgic_queue_irq_unlock.
+	 */
+	irq->pending_latch = false;
+	vgic_queue_irq_unlock(kvm, irq, flags);
+	return ret;
 
+out_unlock_irq:
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	return ret;
 }
 
@@ -511,7 +513,8 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 {
 	struct vgic_its *its;
 	struct vgic_irq *irq;
-	int ret;
+	unsigned long flags;
+	int ret = 0;
 
 	if (!vgic_supports_direct_msis(kvm))
 		return 0;
@@ -531,6 +534,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	if (ret)
 		goto out;
 
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	WARN_ON(irq->hw && irq->host_irq != virq);
 	if (irq->hw) {
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
@@ -538,6 +542,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 		ret = its_unmap_vlpi(virq);
 	}
 
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 out:
 	mutex_unlock(&its->its_lock);
 	return ret;
-- 
2.39.5

