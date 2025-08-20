Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5490732A3F6
	for <kvmarm@lists.linux.dev>; Wed, 20 Aug 2025 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755706973; cv=none; b=XwaNajty2wCdnd+sOLO3lz7aLdjdJQZ1EJrgGT6Iefj18hcdYXxXqBepbfzoKRWOwrqx+oYyFvP4PlWjg9C8ileI31N6m4oiHAeY/t3fN6eGHSUz1XIIhcls6g9kNwRvoiPsXUy12BQp9hcS+aZYJdWLmRaON8pNor2nKGoh2UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755706973; c=relaxed/simple;
	bh=6Ji2BMWpHylbG3Gk41TqRwy1xuilBvKN/0gbdpGP9KY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QaMygRWcD2VYm/QI4wD9KQJUgZarmLpX2ZUhbycq6mXNgBwvVJGpnWBsR/wXFWBX2gjl2MaqxO+PJoN1R1RsgvbCjAfdOj60bcuvDSHe7TH5pKSTL8AwbOFPibePZZo1aRyV2USM+FYfgaKBM8e5qxddLeuUmeK+Mh4Zw5CMOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qs2UR2Kj; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qs2UR2Kj"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-30cce9b093bso236894fac.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Aug 2025 09:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755706969; x=1756311769; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxgL3AzDrrZHKcYrme0egJ79bqapQGokq5EDgAEIJ+c=;
        b=qs2UR2Kjbheg0e+RYXjtvFddNGD6yfDiAkOUyhoOw8v5zpII0q1aCM3/kp/6WvXf6V
         r9LqkdZuT9hNvQQ6aGQHq4h4UJuFG12mcztxGRS3eHLjUX6XFqh1Ur0Vtukq/A25wMam
         lvPmn8SjzLevZQ5BXIKne8ZWXm/6M3Jf4ZVBBdM5FR85e+7PUFvT7rfNwuj9i4IXKqek
         plMVSyLg9n5VmVIyu8WgZrx5Zr+vG2dc7kbbSAFf6W1IfvEZUb3VDTDWLHrKlu1J9Afe
         UKEijwIo1FCFlTm1o9m7+vD0TM+3d9H0b9OWINrQpA807FnyHhZ3WD8aqSo0RzuhAgvG
         NfXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755706969; x=1756311769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IxgL3AzDrrZHKcYrme0egJ79bqapQGokq5EDgAEIJ+c=;
        b=IrTbxsIl0QBWvRBR8hhd+o0qpwXvjE/vz1gGnwKe+vRBmoTbxmlZhR8Z17fwWXbU7V
         c30xCoC6AS6jtiIAQN234uv4cZXueQpIZO9snc5pjr4PX9LF6M6WbEEIsi2GKDtXZnRs
         GIQUybQ8yuGoQYL6hTHU/Uvq50qv5nWmlklgRHPCXiNfSk8ihEV4JER5FpYUuuV2oRG0
         i+lN6zNXQvEqcS4c5hT1VEFih/6dri5563pPj4F0sOvEj0JA5lyOMgfLe+QuX14D+Mwu
         GQRl7ZXuCyBGuUEL174Ch6aGSQpdlUo1xhPxDR23jTps8qZKTmSc5Za+VJxOY++MEbLT
         RgVw==
X-Forwarded-Encrypted: i=1; AJvYcCXnUsh7ojmQlvNo7cEqrDk64fe9jvPp08z46XJ+1NuvJTKs3thsu0dGd245smY8L3ah4OIcI6E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyANo32Tat5qq9VrHMjEn2NSQuyi7NMsv0v7psNO3pDfiem0HfO
	yAEev9SJrEDxjh8xVuX/NHbTKvP3ts9gZv6kfPpgTagmSSJ4TMz3RrXS1fWM9NpETGA/mhPoB7m
	y3NdFXAno3A==
X-Google-Smtp-Source: AGHT+IGHN40LChKmW4U+xn4mYc2JbS9gSROkMCaEkVyOWl8ZTwAYUdz9gBc8qFeauFM0HFD3Zo+x0vJsjUGN
X-Received: from oabxe23.prod.google.com ([2002:a05:6870:ce97:b0:29d:f69c:1743])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:687c:2be8:b0:306:9f1d:da2a
 with SMTP id 586e51a60fabf-31122769fd5mr2072917fac.5.1755706969532; Wed, 20
 Aug 2025 09:22:49 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:22:42 +0000
In-Reply-To: <20250820162242.2624752-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250820162242.2624752-1-rananta@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250820162242.2624752-3-rananta@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Reschedule as needed when destroying the
 stage-2 page-tables
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
---
 arch/arm64/kvm/mmu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e41fc7bcee24..0d6d42a86126 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -903,11 +903,35 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
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
+								next - addr);
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
2.51.0.rc2.233.g662b1ed5c5-goog

