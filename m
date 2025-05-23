Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471C7178372
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748016512; cv=none; b=UPu8q6w00UQwBzY53YACuSGDRb6k7+Ob3RtCEBd3l37AGMXnXTw9z0avQy+Qd3jDvLyf46O6gXOyl8+u0v39wYsWrDhHQOtRZvpyTCpz56jFN9rzZfK19ShYkkmvmb/35kbDfwIQsOiXQiQiSMOe3+9vVIZt1LjO2sG77MsmL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748016512; c=relaxed/simple;
	bh=5Mn2VX3Qi/n/Ft9oegIAHQba23a4+hjXftiqYVBj+EM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jZlF2h0+XvDqFvtiCl8+LoMNuVOL/94bDnPYTt7pMNIlf/BvRiWptmICUqhxtI/GK1Ss9j0PCn1/R3NmBhTo6jX6ZmNEw8DwpocU7GJMmbEdTLL+LPn6fbAsNhn/LBzHZR++yBhpgWYhIHC72GYT81ydSJmGzpbBL5BIimsIhHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HcpgaMiC; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HcpgaMiC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748016507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fbOME1NnprD0AGO0HcXD7XEnwm5Jc4Ui6GasBYzgRnU=;
	b=HcpgaMiCuDEq+GvRwYuWzSWm1v8nvpWwRvtZqu6QXQ18Y5MEXj90Lt5KRdZxMovoJNxp0b
	URMgE/3kIKQ+Sv9gG1N/XzQZfNb86whXtzELcomOmVzqISgEb8+Xhg6udHzZnE1vSGPWMf
	wCQE3/+V5mG9iTNgaZC2tkBvtIA3UTU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea@google.com>
Subject: [PATCH 4/5] KVM: arm64: Unmap vLPIs affected by changes to GSI routing information
Date: Fri, 23 May 2025 09:08:09 -0700
Message-Id: <20250523160810.4049313-5-oliver.upton@linux.dev>
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

KVM's interrupt infrastructure is dodgy at best, allowing for some ugly
'off label' usage of the various UAPIs. In one example, userspace can
change the routing entry of a particular "GSI" after configuring
irqbypass with KVM_IRQFD. KVM/arm64 is oblivious to this, and winds up
preserving the stale translation in cases where vLPIs are configured.

Honor userspace's intentions and tear down the vLPI mapping if affected
by a "GSI" routing change. Make no attempt to reconstruct vLPIs if the
new target is an MSI and just fall back to software injection.

Tested-by: Sweet Tea Dorminy <sweettea@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1de49b48e35e..505d504b52b5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2790,6 +2790,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
 					  &irqfd->irq_entry);
 }
+
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
@@ -2803,6 +2804,28 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
 }
 
+bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
+				  struct kvm_kernel_irq_routing_entry *new)
+{
+	if (new->type != KVM_IRQ_ROUTING_MSI)
+		return true;
+
+	return memcmp(&old->msi, &new->msi, sizeof(new->msi));
+}
+
+int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
+				  uint32_t guest_irq, bool set)
+{
+	/*
+	 * Remapping the vLPI requires taking the its_lock mutex to resolve
+	 * the new translation. We're in spinlock land at this point, so no
+	 * chance of resolving the translation.
+	 *
+	 * Unmap the vLPI and fall back to software LPI injection.
+	 */
+	return kvm_vgic_v4_unset_forwarding(kvm, host_irq);
+}
+
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
 {
 	struct kvm_kernel_irqfd *irqfd =
-- 
2.39.5

