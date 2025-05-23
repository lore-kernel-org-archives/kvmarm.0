Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F78228382
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748016509; cv=none; b=X9c8wQAtoL/sOps116udTfOGs/sf3RGZ3YWZwjs8xsxG3q/H7wd2JRgnGhVIHBLLVK3VykbZ9e1uNeq+Hy/0R4qNlMv7lHDLczBFOXSQ1a0IOjb98jUjSdlS+0Kaxe3b6mD+AdgIQfQCC8gkStKswyZCXBQVIBoY7glleCd+HXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748016509; c=relaxed/simple;
	bh=INTki6G7WBXj6cA79wWXtDy5a4Qc0QG0V5WVryL1RnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZHyccz1KKcQjeE6a5V6Hzwp/jS+OYqw4jJ+2vU4/TVhFv5awZGf7k1CNzjzh0ccqgwxibh+pY6wj3b6gIuzm8k+osMSiWGyVQSUi2quYvikEaT3x4YVtJI+j9j+x4dR7+Weemo+Kgoh0APDwoNbPys4cbfCuGfhiTuz2Tljiq4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tZU9kPID; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tZU9kPID"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748016505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jBeQo8kyCGQqJmRvCJwZngMGGy51d1OiTuC7GDsl8k=;
	b=tZU9kPIDiepMmVJEt+VNt1YQmIScyWHqzZ+dThlj/IUSq6Wzh7qt+adh2IhFm+CO/AyT9k
	q4Gp6eaGPyZiDk9es3Ug0B8XunFnwiETH/EdkszDiX5bBLsHvs4a0MCtST8D82hZRhSccS
	iEtOtIg1x4ceUqEw998E4lNzfcesOUg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea@google.com>
Subject: [PATCH 3/5] KVM: arm64: Resolve vLPI by host IRQ in vgic_v4_unset_forwarding()
Date: Fri, 23 May 2025 09:08:08 -0700
Message-Id: <20250523160810.4049313-4-oliver.upton@linux.dev>
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

The virtual mapping and "GSI" routing of a particular vLPI is subject to
change in response to the guest / userspace. This can be pretty annoying
to deal with when KVM needs to track the physical state that's managed
for vLPI direct injection.

Make vgic_v4_unset_forwarding() resilient by using the host IRQ to
resolve the vgic IRQ.

Tested-by: Sweet Tea Dorminy <sweettea@google.com>
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

