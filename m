Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3C381741
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 19:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748029662; cv=none; b=btru1aYoN/oO8/wxmRsqTG8jKEepb6kFXsDPV1m6+A187Gq8DXstWpGY1bJqrAAvfLbpjuLpy08BIdK0LEATgywchOyOPSWpo5AkES1gvboAPK2qByUtsdbcAq9R0YVu8frL5EsXeQfozLlgUOSHA4CNs94x4ZILW+leuDCR8BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748029662; c=relaxed/simple;
	bh=m2Lf5MCJ2LQeNo59n9XB0DGjOUZ50pUi6MNKJKHavEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n3mpVp4bDI8ZhvvU7haECtmzufMQAhCqD+bljBQgAzuEvBV7ooO6ePEUCqWL7MpNlctbnBHvJTbiZoHQOWA8a62foNCY/NgGnZYDnDexpyoXxfhVK2O/t7nuakWC8/oNS7Pxp49YiI7yXNjhmU2ii8wKu/SFmGWFF5HR/HWZpzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vu4yFrIb; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vu4yFrIb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748029658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wTwkd+kNM9cM2XQRx4uLZEz8CBkzSJEpsK2ZVyS6ZeA=;
	b=vu4yFrIbeGN9OQFsox7w5qPZwVYQPaI8c6hlUeePWIuAVU2tKW2tQGEHhQKNSqu6825xKq
	W1Qnnhlba2m6EL6Lx8HUeRgzDG/hsGi9dGRUXBgLQ9FhPjubjSQdTrlt/X9EojROONTNQi
	0dYKu/sggyidfa3cFIZZgJGZWejh9UM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 4/5] KVM: arm64: Unmap vLPIs affected by changes to GSI routing information
Date: Fri, 23 May 2025 12:47:21 -0700
Message-Id: <20250523194722.4066715-5-oliver.upton@linux.dev>
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

KVM's interrupt infrastructure is dodgy at best, allowing for some ugly
'off label' usage of the various UAPIs. In one example, userspace can
change the routing entry of a particular "GSI" after configuring
irqbypass with KVM_IRQFD. KVM/arm64 is oblivious to this, and winds up
preserving the stale translation in cases where vLPIs are configured.

Honor userspace's intentions and tear down the vLPI mapping if affected
by a "GSI" routing change. Make no attempt to reconstruct vLPIs if the
new target is an MSI and just fall back to software injection.

Tested-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
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

