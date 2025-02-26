Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ED027455
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594709; cv=none; b=lO6/VcGEvysLM+kcMJ1crjwHb8aIfVDV3K2mTjyzX6GAGHiPw+CMmv6zZ+Itx/ktNwJpJq77pXzqT+fu/KksJG6lggegp9RyD6bU5sy9oEey7nDY4EV2/z4RvOrZYrcdQ1u2/n1aENysR6ZuTUx36dTfPbVKkJn3FM7k3m9iGfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594709; c=relaxed/simple;
	bh=Lfegny3eOvT9N4YkPMOyNnXEF3zYlaMY4eVuISdwuRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KnAc7RWfY3wCHwvGqa8mWGyYVWLzOKk7fc+E3AaPkOec/UqSpVZKbqJYEjSlRoC2+ApoQPvyGbwuEJSR3xTb6N+yUZqMcDkXIJ+YRbDTU591/eYW+UK3esMOxe4bza50rj2awyItphs2+qYffeUg+rcfchUGMfptgs/FN4yO0C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CgxhSXPe; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CgxhSXPe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740594706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HQp9xw3jhZFuSFur9PI/lmhmLUzzxpA+QzeC0vql340=;
	b=CgxhSXPehSnjpZQ/E35Q/3Arac8hhoQ6KUEi8c2qqfgydI/VRSREwPqbmGXNEWYqqAY6Oq
	/XLwgNlaeYOJGIoqXUExBbwvHZ/mMv9x99N8vvkwpVUsLP0b/fXCXzJZVmQ2b4YlG55r39
	PPlmEpKVvwQGVFWC2+ts0Ox0Xn0inlA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sudheer Dantuluri <dantuluris@google.com>
Subject: [PATCH 1/4] KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs
Date: Wed, 26 Feb 2025 10:31:21 -0800
Message-Id: <20250226183124.82094-2-oliver.upton@linux.dev>
In-Reply-To: <20250226183124.82094-1-oliver.upton@linux.dev>
References: <20250226183124.82094-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Some 'creative' VMMs out there may assign a VFIO MSI eventfd to an SPI
routing entry.

And yes, I can already hear you shouting about possibly driving a level
interrupt with an edge-sensitive one. You know who you are.

This works for the most part, and interrupt injection winds up taking
the software path. However, when running on GICv4-enabled hardware, KVM
erroneously attempts to setup LPI forwarding, even though the KVM
routing isn't an MSI.

Thanks to misuse of a union, the MSI destination is unlikely to match any
ITS in the VM and kvm_vgic_v4_set_forwarding() bails early. Later on when
the VM is being torn down, this half-configured state triggers the
WARN_ON() in kvm_vgic_v4_unset_forwarding() due to the fact that no HW
IRQ was ever assigned.

Avoid the whole mess by preventing SPI routing entries from getting into
the LPI forwarding helpers.

Reported-by: Sudheer Dantuluri <dantuluris@google.com>
Tested-by: Sudheer Dantuluri <dantuluris@google.com>
Fixes: 196b136498b3 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq bypass")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b8e55a441282..36d8dd80b431 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2717,6 +2717,14 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm_kernel_irq_routing_entry *irq_entry = &irqfd->irq_entry;
+
+	/*
+	 * The only thing we have a chance of directly-injecting is LPIs. Maybe
+	 * one day...
+	 */
+	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
+		return 0;
 
 	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
 					  &irqfd->irq_entry);
@@ -2726,6 +2734,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	struct kvm_kernel_irq_routing_entry *irq_entry = &irqfd->irq_entry;
+
+	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
+		return;
 
 	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
 				     &irqfd->irq_entry);
-- 
2.39.5

