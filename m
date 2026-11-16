Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794813209;
	b=21BXX2PzLBtyYLW6ekYoBBwxqE1p4Y7JB53uJDFeNMoxrf+ViO91CPkiES2HjBM2mz+x
	 OGSGGolFYUvjbkKy3vxUQwBKcGmN9go8TSDricPA4U0dP8GEoo+bdEV9RcY4P4X7pMQO4
	 Duqgq1c4ek8A+DzBNF5f9Yv+N3R9Ze+QuEOshNCfh8Flr2fSkMbw40xutyPEL22iSxeFA
	 Y3WmYYvbxEYXnZ8J3+vBC3TKUsYjf6wHyEQiMzVp/7aGcaYGXyxgzPXmpg/SOiOeLLyHW
	 PHrQqGpusuB22kHVwcWj4MxLWIsV4+K0ydYXBfUivCi3Sv0TNuu3dz0D7r/wTVnOiUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794813209;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lk80JFgg928CrLC0eQwio88WY0+Htp1D4M8ps95Hc3g=;
	b=V7pOgqjvBuV/tQoaasWFJ/wob3cWa5khjji65+XBJPAi2ceYfLzgOSMOigAb6UszcxFo
	 GnXjL42ghxT0m8XXOuBXCHNbBxVqzMXzPGLw6/ekvoToEp5vXKVcXfeaqI1OgfNPn+MZB
	 wZCoE42uyJrUqGzV3OFCFvcOLSOBDblShKFks9JP9FGhpYolCKfQLTBC0ThfwMi6sO9Ae
	 MpnWCCb/+zXG1S9F88T2/ApHRyxiOFlsbZMClQZzfVKjsDn9X+tah90jY8rBBTtvM2lk+
	 j4Vgw1YT2/6en4lyuUYg5ykfu8z/k5pIbmBW5PsEHvGoz/Cy6HVB/mao33wkNHi7uUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O4q2Zb4x;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFBF606A323;
	Mon, 16 Nov 2026 07:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EFBF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=O4q2Zb4x
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE87D1713;
	Sun, 15 Nov 2026 23:13:24 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 17BB73F673;
	Sun, 15 Nov 2026 23:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794813207; bh=P3UEMyn2wpBrgjmF9RmDIUq18+/S6PMreyCiNru93bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4q2Zb4xqJCVRY+nkfUjDNXrXhb5U87zLLYCIe81fNEv7Xy1hwW2GUnJ7d/MeDznc
	 tnCu+oiOty3/7CHE3960x54v6znRYHPXj2485K7H6+5RhfJnymIzMnwCLTgqoc6Sm3
	 ttJDiFOhvOg3XTfCMPaVzPjShvkappUiTKmK0YME=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	bigeasy@linutronix.de,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Jia He <justin.he@arm.com>
Subject: [PATCH 1/2] KVM: arm64: Give the host timer interrupts a separate lockdep class
Date: Mon, 16 Nov 2026 07:13:03 +0000
Message-Id: <20261116071304.2037895-2-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261116071304.2037895-1-justin.he@arm.com>
References: <20261116071304.2037895-1-justin.he@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With a GICv5 guest, kvm_timer_vcpu_put() clears the active state of the
host timer interrupts with irq_set_irqchip_state(), which takes their
irq_desc lock. On preemption this runs from kvm_sched_out() with the
runqueue lock held:

  &rq->__lock --> &irq_desc_lock_class

By default, all irq descriptors share a single lockdep class, so this
closes a cycle with any interrupt that queues affinity notifier work
under its own descriptor lock (mlx5, for example), as already seen with
the GICv4 vPE doorbells:

  &irq_desc_lock_class --> &pool->lock --> &p->pi_lock --> &rq->__lock

For the timer interrupts this is a false positive. Nothing that runs
under their descriptor lock leads back to the scheduler:

- They are requested only by KVM, with request_percpu_irq(). Per-CPU
  interrupts are never threaded (irq_set_percpu_devid() sets
  IRQ_NOTHREAD), so there is no irq thread to wake, unlike the vPE
  doorbells with threadirqs.

- Their affinity is fixed and never changed, so no affinity notifier
  work or thread affinity update is triggered.

- The irqchip callbacks reached under the lock (the KVM timer_chip,
  forwarding to the GIC) only access GIC registers.

Give them a separate lockdep class. This is done for all vGIC types, as
none of the above is specific to GICv5. Both timers share the class, so
dependencies between them are still checked.

Fixes: 9491c63b6cd7 ("KVM: arm64: gic-v5: Enlighten arch timer for GICv5")
Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/arch_timer.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index b2c5ba499aa5..1088563d32a3 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1362,6 +1362,17 @@ static void kvm_irq_fixup_flags(unsigned int virq, u32 *flags)
 	}
 }
 
+/*
+ * With a GICv5 guest, the timer interrupts' irq_desc lock is taken under
+ * the runqueue lock (kvm_sched_out() -> kvm_timer_vcpu_put()). Give them
+ * their own lockdep class, so that they are not mixed up with interrupts
+ * whose affinity notifier queues work under the irq_desc lock. Nothing
+ * under the timers' own irq_desc lock leads back to the scheduler: they
+ * are per-CPU (never threaded) and their affinity never changes.
+ */
+static struct lock_class_key kvm_timer_irq_lock_class;
+static struct lock_class_key kvm_timer_irq_request_class;
+
 static int kvm_irq_init(struct arch_timer_kvm_info *info)
 {
 	struct irq_domain *domain = NULL;
@@ -1374,6 +1385,8 @@ static int kvm_irq_init(struct arch_timer_kvm_info *info)
 
 	host_vtimer_irq = info->virtual_irq;
 	kvm_irq_fixup_flags(host_vtimer_irq, &host_vtimer_irq_flags);
+	irq_set_lockdep_class(host_vtimer_irq, &kvm_timer_irq_lock_class,
+			      &kvm_timer_irq_request_class);
 
 	if (kvm_vgic_global_state.no_hw_deactivation ||
 	    kvm_vgic_global_state.type == VGIC_V5) {
@@ -1401,6 +1414,8 @@ static int kvm_irq_init(struct arch_timer_kvm_info *info)
 	if (info->physical_irq > 0) {
 		host_ptimer_irq = info->physical_irq;
 		kvm_irq_fixup_flags(host_ptimer_irq, &host_ptimer_irq_flags);
+		irq_set_lockdep_class(host_ptimer_irq, &kvm_timer_irq_lock_class,
+				      &kvm_timer_irq_request_class);
 
 		if (domain)
 			WARN_ON(irq_domain_push_irq(domain, host_ptimer_irq,
-- 
2.34.1

