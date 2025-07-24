Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FDF2472A3
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 23:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753401113; cv=none; b=Ks4NceoFeJO306rq23XFeGnm9zjG/smeT65o94ttRmvlbslh5NpEAlZOEVt087B/Zetp84RNL5TIm98F0LRRS7Zg8jVAUhfK04luKp3E71FmOfHWWQcjryuMQWuMfSjqmMig2OJyjbRstneh7th9ZxzdbnykVbAKaC7AN6ErGfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753401113; c=relaxed/simple;
	bh=PbhuF28EjBx215+y3nH5KKOGVTzqm1E8HWrMnJyh3B4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WvAl+J/nXQFEEdqoS4o/9JHNV3IWmqBZb0RFZlrwpTYDIiU2oFMh4ndY2nCvOSquZX2waYRLKzH+F38xipvaXrOHkdKIZLjBdjMJ8SClqCzay9KVz6I/y36+W71hIneuRzfgIZgTwNNr1rUoXkep1w1t2kYsMBsooYvbSlBcV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vTwUj8G0; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vTwUj8G0"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-87c2bcfd156so181177839f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 16:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753401110; x=1754005910; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RYe5nu6TpLkMvmAmuxkk2nqtf0ZOE6ibYgo684ah5AQ=;
        b=vTwUj8G0v2H5YVMHg+zaBpgtG5hKRA6EgEpCXat8wcMh4lPkRSHG38EaJoS/D0JBJd
         NnJxqRhmQ6OdFHfIS0Itf08ufDykqI6V0zclrG5xDUAQW0o8uVwWJ/ncpvgqEJvdrN5x
         kHLzUdA/mutZGoxpg45IxIJPNzoXIcmsjE6LVCm/DLkwj51GHBf0qhImFESTrjqF+v/H
         P2x1zl85bH3nOw1XGFpsw0ju4GlxKQN9ZPHIssEkVbp2eak7zX9263biGQb63V2UHw4t
         6tPeZaMAFl+PgiiHyGl/MILtEmb8n9Vvj8mxVxdVg6W/Q0+RrVuUnr7JPDxOu1gPMiVu
         P16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753401110; x=1754005910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RYe5nu6TpLkMvmAmuxkk2nqtf0ZOE6ibYgo684ah5AQ=;
        b=o/EbSZRuioJys9dQl4Fb8a7yUxYS/Nn/bEo9zNkV5LVz9DOa5zOXWubFy62SkwSDB0
         6Ajbkl/Q6MSRJdTHUO1yWqJIAGR/A2EDHHBrwoucWO1YPCJDORt9aGWg50AGglvkuYe4
         3viCo9Ox/16E4PrPQXvTr3xhziUrRRdYKe9fkx17kQNMeFPqcW5aD6Bo8qadj5/JjIPy
         LhsmAE68ZNOxWmbGuMKybfdNdRn9T8u+Cv+y8qiDtJuZgPbXpAsuGCoNzZeLrwaz2amP
         ej6a7qZwMVI5o08XFCe8LmrYjxbrqRSXvzeTzqz4gG3wk7idzTC6HvgE/J9ddTtDLWag
         LTdA==
X-Forwarded-Encrypted: i=1; AJvYcCWkLGLbs8XdDkcuFRQCurOtbiMaXgMU9zCZ9AZMNzGmXX2bRulIWoiU7s6MA/wpwll3APqWdR0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQlB+7F7miU/LRnK6yOyk+1bP6y7XvJwYlwU2wycZXg1hLQpIH
	7OfwvkxcBP9QJB7TEk+MUYDaSVDCd+N/q1XtFvrCZdNutKIMHUfNHr7kceUJQ8h/CIqF14lL5US
	TsGols7vcAg==
X-Google-Smtp-Source: AGHT+IGf/ljX3JnjXsIdWRx5WECI21rxocKvZGW0v63GazO3Xk3AULXotlNLZG82JFTKddhPsrZEmgpTkGDk
X-Received: from iobfm16.prod.google.com ([2002:a05:6602:b90:b0:86c:9981:d21d])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:1486:b0:87c:1424:6189
 with SMTP id ca18e2360f4ac-87c761bf0famr649235039f.3.1753401110609; Thu, 24
 Jul 2025 16:51:50 -0700 (PDT)
Date: Thu, 24 Jul 2025 23:51:44 +0000
In-Reply-To: <20250724235144.2428795-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724235144.2428795-3-rananta@google.com>
Subject: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
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
---
 arch/arm64/kvm/mmu.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2942ec92c5a4..6c4b9fb1211b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -387,6 +387,40 @@ static void stage2_flush_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
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
+			      phys_addr_t end)
+{
+	u64 next;
+
+	do {
+		next = stage2_range_addr_end(addr, end);
+		kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
+
+		if (next != end)
+			cond_resched();
+	} while (addr = next, addr != end);
+}
+
+static void kvm_destroy_stage2_pgt(struct kvm_pgtable *pgt)
+{
+	if (!is_protected_kvm_enabled()) {
+		stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
+		kvm_pgtable_stage2_destroy_pgd(pgt);
+	} else {
+		pkvm_pgtable_stage2_destroy(pgt);
+	}
+}
+
 /**
  * free_hyp_pgds - free Hyp-mode page tables
  */
@@ -984,7 +1018,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return 0;
 
 out_destroy_pgtable:
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
+	kvm_destroy_stage2_pgt(pgt);
 out_free_pgtable:
 	kfree(pgt);
 	return err;
@@ -1081,7 +1115,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
+		kvm_destroy_stage2_pgt(pgt);
 		kfree(pgt);
 	}
 }
-- 
2.50.1.470.g6ba607880d-goog

