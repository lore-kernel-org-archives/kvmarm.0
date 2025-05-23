Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA176199EBB
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 19:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748029660; cv=none; b=NJUotq+kUBNQgxr5W17esQvtZjCrR6F6NgBsJM4jCSe0YTIWjdeCUiQZllh7eAxqS/MET0AcqiUf1Rqw8z+M0ubtGCho4iTZOgrFdEs5J4tqLOZ9RRask03nTjSQjRlbXm225lKJ/7E+a8uboeFLTqsPWieWY/Iui36dqtUaRfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748029660; c=relaxed/simple;
	bh=pBdyBjmhIzmOOInLM18XCW2DcvzD44Xn/cLbvOLptDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YEB7jBk1OP8BvQHT7JYN12H5j3DYp+gi5msfI54QEpD0fxRsEKCkKHSXE7ISUpTyTw4+IFemHgAM4489TUungKE2KYSsqzfApVW9HWczV5RR/ScfIW4Cvs4Tu5uFlcHFkbKg5bDR9y2a3lKbtqq6UbMOfLQ3NN8SApI9Xz0YBzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bkefIGxO; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bkefIGxO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748029656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J7cmPmqVtirOGa3NA06LDB/STB969Z4QTLdTXnP+azk=;
	b=bkefIGxOp11Sb3KQOLa1qF4uQ1Whn5BILrKWXdUlfW+uz240gCNl7VR+A+V/meBAIuVLRh
	Fpe0vtWszb1qztD1rXr27mr8PCQOr78gMAE0BxUOPA5phfpIo1nsMFBo5zMErH60oEpBhl
	bxzoS7NZ3I4Rr2hi1768gQhoJX/hpmo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 3/5] KVM: arm64: Resolve vLPI by host IRQ in vgic_v4_unset_forwarding()
Date: Fri, 23 May 2025 12:47:20 -0700
Message-Id: <20250523194722.4066715-4-oliver.upton@linux.dev>
In-Reply-To: <20250523194722.4066715-1-oliver.upton@linux.dev>
References: <20250523194722.4066715-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The virtual mapping and "GSI" routing of a particular vLPI is subject to
change in response to the guest / userspace. This can be pretty annoying
to deal with when KVM needs to track the physical state that's managed
for vLPI direct injection.

Make vgic_v4_unset_forwarding() resilient by using the host IRQ to
resolve the vgic IRQ. Since this uses the LPI xarray directly, finding
the ITS by doorbell address + grabbing it's its_lock is no longer
necessary. Note that matching the right ITS / ITE is already handled in
vgic_v4_set_forwarding(), and unless there's a bug in KVM's VGIC ITS
emulation the virtual mapping that should remain stable for the lifetime
of the vLPI mapping.

Tested-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c          |  3 +--
 arch/arm64/kvm/vgic/vgic-v4.c | 45 +++++++++++++++++++----------------
 include/kvm/arm_vgic.h        |  3 +--
 3 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 36cfcffb40d8..1de49b48e35e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2800,8 +2800,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
 		return;
 
-	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
-				     &irqfd->irq_entry);
+	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
 }
 
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 01a5de8e9e94..193946108192 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -508,10 +508,27 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	return ret;
 }
 
-int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
-				 struct kvm_kernel_irq_routing_entry *irq_entry)
+static struct vgic_irq *__vgic_host_irq_get_vlpi(struct kvm *kvm, int host_irq)
+{
+	struct vgic_irq *irq;
+	unsigned long idx;
+
+	guard(rcu)();
+	xa_for_each(&kvm->arch.vgic.lpi_xa, idx, irq) {
+		if (!irq->hw || irq->host_irq != host_irq)
+			continue;
+
+		if (!vgic_try_get_irq_kref(irq))
+			return NULL;
+
+		return irq;
+	}
+
+	return NULL;
+}
+
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 {
-	struct vgic_its *its;
 	struct vgic_irq *irq;
 	unsigned long flags;
 	int ret = 0;
@@ -519,31 +536,19 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	if (!vgic_supports_direct_msis(kvm))
 		return 0;
 
-	/*
-	 * Get the ITS, and escape early on error (not a valid
-	 * doorbell for any of our vITSs).
-	 */
-	its = vgic_get_its(kvm, irq_entry);
-	if (IS_ERR(its))
+	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);
+	if (!irq)
 		return 0;
 
-	mutex_lock(&its->its_lock);
-
-	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
-				   irq_entry->msi.data, &irq);
-	if (ret)
-		goto out;
-
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
-	WARN_ON(irq->hw && irq->host_irq != virq);
+	WARN_ON(irq->hw && irq->host_irq != host_irq);
 	if (irq->hw) {
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
-		ret = its_unmap_vlpi(virq);
+		ret = its_unmap_vlpi(host_irq);
 	}
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-out:
-	mutex_unlock(&its->its_lock);
+	vgic_put_irq(kvm, irq);
 	return ret;
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 714cef854c1c..4a34f7f0a864 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -434,8 +434,7 @@ struct kvm_kernel_irq_routing_entry;
 int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 			       struct kvm_kernel_irq_routing_entry *irq_entry);
 
-int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
-				 struct kvm_kernel_irq_routing_entry *irq_entry);
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq);
 
 int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
-- 
2.39.5

