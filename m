Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A35C30BB96
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 05:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763011516; cv=none; b=h6kCcH8H24pLdC7w9IXRIftFrL1hwx7T9v7UAJIe47lgciE4gq9aTJ2IdWUiiNhUsBC/Qsb47GhqTl2mTYT+kf8GrJtiFHWl1Cz0l/6TkG9+aJ7dCUxJDrA8QGWAEfSV7BBoCd8/st0ebuezGAy2YODtE15NW3PImJzT4Nc+cDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763011516; c=relaxed/simple;
	bh=P9X8/pKAhvG/wWkSjOkEiXdGNBedfO9mFofKaMhghnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ucUBBMGJtcBmiymK1oL6+u8iOfujtNlGTy6vz3qeypflKwQPRESp5YnyuMuTJ5pkllyyU6c6GvB66qCGqbPFYjoRKTiVQ072STAipMayAReXRk9q4O3TGqyWf8dVuQ3/fKdWBpWuTgBql8JXbcg0ICmN3mYOeFB+lVwKkrub1Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kiSW8TkR; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kiSW8TkR"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-43373c85296so6804625ab.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 21:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763011514; x=1763616314; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YR4PqSCoKUZHQwNLH+ibXY+eaMViVtVOUHNqTtgOoNw=;
        b=kiSW8TkRPhD5xSkKomaWoWYxtK4vsB8K6uL3lQsZgqA0ad1DtW77rkFT29jnTIUM47
         QnX/lAVjICOIhpdEFFeMzkw3jFOn7cj+Lw/o64Brw+sM70YYxe7OQpZo+X9A7WfcpEiI
         K0D0JTDqzAXF00Onndjg+C3CuqN+Y1DYX8yWfyOwzrW5uXw64osfLhfDqpMPxfajQqho
         MLiDuZhi4w3or9j82Cg6hY5/URF2XRq9x1dJu0lN+92H1wRmv17qjv81iXEKnCJN9fNX
         S6P7DfWf9qSPrbNsoKHQ//V6TiHu2chB7uzuvOAULBhKiaWmmzDUCtEJwim5bEYAIYWG
         p74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763011514; x=1763616314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YR4PqSCoKUZHQwNLH+ibXY+eaMViVtVOUHNqTtgOoNw=;
        b=Fabg9cVfyjA6tTgigRcPFUYO45NgkLbMeV9Y+1d13kpNfDFdYnwM6hUAE9IQG+M0uh
         kC+8TmaohXWbEMChezh/3+qns7lHdKjuPIJixNEZxrAytGCK1+rSHAtsrNfrglMYZKjO
         b5FEU14/Wt82nHT/27JTxVQQtbvWAQu27TReoFJx9+M3stZ4mBbRRK80cuV29mXj13e5
         C8XngdnEkaPCnbHEc3ls0/BVJFNMiV8XS7PwwUZu9ca0n9c1cEyZf49TqOSCt7SSwong
         s5E/xKMqY5jmCq5LBYO5JM/Wvd1xvRZU9FyOKVSN0ebCyWJmJS+yhytxNkjhBerAEqq2
         ACiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGkjeu8N+r35h8YMBww3GGPOXOi9B8nA1qBKP7SyF/VnO/b2l5tTtAfVVddpNGy6yqc/E77UU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIe/QszSsghv6BtU4m93/i1X+a7UGoEj4Z1D6JKOYrHdt4srCJ
	EtFYwk6M4cHx4G+1Qyg0ZTIGh345UCad22A7XnkBPugSjRKiuViquz3uAsrz+fE7tOTSCMhkjJa
	mYINANE0oEw==
X-Google-Smtp-Source: AGHT+IFRYF4zNyv9Ly6pBzYTZfMV1gbB624Cl5TmoplavbzHX+2MSvXvATj641ux/60yeM2/PvFgItVBduUS
X-Received: from ilbbm14.prod.google.com ([2002:a05:6e02:330e:b0:433:2091:8e7e])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:1a83:b0:433:2072:9d2c
 with SMTP id e9e14a558f8ab-43473d2a3a5mr86726965ab.10.1763011514189; Wed, 12
 Nov 2025 21:25:14 -0800 (PST)
Date: Thu, 13 Nov 2025 05:24:52 +0000
In-Reply-To: <20251113052452.975081-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251113052452.975081-1-rananta@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251113052452.975081-4-rananta@google.com>
Subject: [PATCH 3/3] KVM: arm64: Reschedule as needed when destroying the
 stage-2 page-tables
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

When a large VM, specifically one that holds a significant number of PTEs,
gets abruptly destroyed, the following warning is seen during the
page-table walk:

 sched: CPU 0 need_resched set for > 100018840 ns (100 ticks) without schedule
 CPU: 0 UID: 0 PID: 9617 Comm: kvm_page_table_ Tainted: G O 6.16.0-smp-DEV #3 NONE
 Tainted: [O]=OOT_MODULE
 Call trace:
  show_stack+0x20/0x38 (C)
  dump_stack_lvl+0x3c/0xb8
  dump_stack+0x18/0x30
  resched_latency_warn+0x7c/0x88
  sched_tick+0x1c4/0x268
  update_process_times+0xa8/0xd8
  tick_nohz_handler+0xc8/0x168
  __hrtimer_run_queues+0x11c/0x338
  hrtimer_interrupt+0x104/0x308
  arch_timer_handler_phys+0x40/0x58
  handle_percpu_devid_irq+0x8c/0x1b0
  generic_handle_domain_irq+0x48/0x78
  gic_handle_irq+0x1b8/0x408
  call_on_irq_stack+0x24/0x30
  do_interrupt_handler+0x54/0x78
  el1_interrupt+0x44/0x88
  el1h_64_irq_handler+0x18/0x28
  el1h_64_irq+0x84/0x88
  stage2_free_walker+0x30/0xa0 (P)
  __kvm_pgtable_walk+0x11c/0x258
  __kvm_pgtable_walk+0x180/0x258
  __kvm_pgtable_walk+0x180/0x258
  __kvm_pgtable_walk+0x180/0x258
  kvm_pgtable_walk+0xc4/0x140
  kvm_pgtable_stage2_destroy+0x5c/0xf0
  kvm_free_stage2_pgd+0x6c/0xe8
  kvm_uninit_stage2_mmu+0x24/0x48
  kvm_arch_flush_shadow_all+0x80/0xa0
  kvm_mmu_notifier_release+0x38/0x78
  __mmu_notifier_release+0x15c/0x250
  exit_mmap+0x68/0x400
  __mmput+0x38/0x1c8
  mmput+0x30/0x68
  exit_mm+0xd4/0x198
  do_exit+0x1a4/0xb00
  do_group_exit+0x8c/0x120
  get_signal+0x6d4/0x778
  do_signal+0x90/0x718
  do_notify_resume+0x70/0x170
  el0_svc+0x74/0xd8
  el0t_64_sync_handler+0x60/0xc8
  el0t_64_sync+0x1b0/0x1b8

The warning is seen majorly on the host kernels that are configured
not to force-preempt, such as CONFIG_PREEMPT_NONE=y. To avoid this,
instead of walking the entire page-table in one go, split it into
smaller ranges, by checking for cond_resched() between each range.
Since the path is executed during VM destruction, after the
page-table structure is unlinked from the KVM MMU, relying on
cond_resched_rwlock_write() isn't necessary.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250820162242.2624752-3-rananta@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/mmu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c2bc1eba032cd..f86d17ad50a7f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,11 +904,35 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	return 0;
 }
 
+/*
+ * Assume that @pgt is valid and unlinked from the KVM MMU to free the
+ * page-table without taking the kvm_mmu_lock and without performing any
+ * TLB invalidations.
+ *
+ * Also, the range of addresses can be large enough to cause need_resched
+ * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
+ * cond_resched() periodically to prevent hogging the CPU for a long time
+ * and schedule something else, if required.
+ */
+static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
+				   phys_addr_t end)
+{
+	u64 next;
+
+	do {
+		next = stage2_range_addr_end(addr, end);
+		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
+							     next - addr);
+		if (next != end)
+			cond_resched();
+	} while (addr = next, addr != end);
+}
+
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
 
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, 0, BIT(ia_bits));
+	stage2_destroy_range(pgt, 0, BIT(ia_bits));
 	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
 }
 
-- 
2.51.2.1041.gc1ab5b90ca-goog

