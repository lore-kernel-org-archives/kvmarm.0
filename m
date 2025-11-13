Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3468248C
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 05:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763011502; cv=none; b=SI33sI1YpMW5e+vRgsix0JNYJf2VzfIw8MpSmwJc4GR/TgAOYpAa5l/qbhU+u3J2hxPGJUo3zxcuh1FbK5Lm1CE9Eu8uwI6VfZeK+rc4vXebwLIJD6p0XkXhu+DHzjxlPXQuDZ6E3nvDkDqYI8OnbN8Nmp2jv54wOuNQ+8aYmTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763011502; c=relaxed/simple;
	bh=JRpVSsu65muOPw+ZR6pM7QRh8sMT33lr34qzVyXY/os=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NZf7TAcQVr269cnHylMzCnh9Ggq5H9cU3Yl+4ZYe1IvXUgjz4p8WgQzj3/d/8pLjxwWw7cSz3elpD2Jwg5KRhIOp9F4y3RayUJR2AYovKaH5VdNJhLptqFCgAdY4lXKWhG9hJ7Hyu0iDtRIGb57JcPBH9qjwxg8b0EFk3P7lBgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i9khdZN5; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i9khdZN5"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-432f8352633so15419405ab.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 21:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763011500; x=1763616300; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ITLN6DrW4j9W1gRe4G0SjKiXKIkSq/9JXCq9e/dhlsU=;
        b=i9khdZN5cXZ/bwFjLQCyzEuKR0++aGm/l3Qpf3XKP3OxMWU8n1PqkT5ni/BoFQZ7It
         iixWjZYBCtTp1+1LVQdgrLfWQ64Pmz3mP2XnG/OPBnz05mcxnmked96XAjIrsSlcgDBy
         BO2de7PVk0t0gJLxfvOWyLOO25dOLuxbOtOjMnkiFpmShvO99GCWLAqRV8nvZ2YD90t3
         FnEc+FMaJ4aMEhLAwdKxkO5bHnI2gMDrRxxvJAUvmyOygrvxhH9QqkIop0gwHzGPDHB+
         wv8msPfGY7iHAdaC16gAEqgotCKjl5/0x5PadwraaQpy1wNmUvFmQDYEzID4Bc0ceuWe
         Q35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763011500; x=1763616300;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ITLN6DrW4j9W1gRe4G0SjKiXKIkSq/9JXCq9e/dhlsU=;
        b=S8253A1gbE7R8rrYtV5JCQ0sIQ/x7Nakf37JIHVIF9MqPA7TiqSvlgXcZNQNDwiB4Q
         d3c4AF3TNXpqZeO5c4GVjPLA6jf2LeV8k45Ae5w3EbzcqxZ6WYugLD/Gb5TLha7nh0Es
         CEX1g4XETxz2jgt8UDfZRrNcl5p2QnCoZM1wi3STF2ZeBQzOtFMKM0DRSXi6PHl4PeVv
         Fr1OA2r+KH1hDbIDeIi9CmPk7M/J9iR31KPoedDxtflMWdXUGS7A4U1brkkoePhmnF1Q
         +H8ExrOwQ0DoPyW7DOhHTp5MT9fuBBiXeSAsBCdk39kjaepw/7eYud5+6kEnqTv5qaGx
         a8mg==
X-Forwarded-Encrypted: i=1; AJvYcCUOI+xEt4DqffqPc4jCznjbbHuxF2jf8Oeh6SUmYMdnKPDOZ0AI0lWJDDP5Atavl+yp2Asc+bk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoOAejgbctKNiBJtIlCrOpn//7qIxVxmHM8usa1HKvt0xLJlhS
	09o0HDCAV6yZdybYLfgDLBKodXXgIrjiPdB8az1sPGIkERyFiuPSMt+t7JcyOf2rLe4b+hHCf8I
	hG4XlrqqAUA==
X-Google-Smtp-Source: AGHT+IFL6UP4YmlKx250LyiOtTQeJ7J1ke7xQcOZuRjsBn2ACx0ONuYF1IJLK61YzRE922HtvlvNEGnRGSBI
X-Received: from jaa26.prod.google.com ([2002:a05:6638:ae1a:b0:5ad:7f49:aa05])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a92:c245:0:b0:433:78b8:943a
 with SMTP id e9e14a558f8ab-43473d15984mr90010315ab.10.1763011500033; Wed, 12
 Nov 2025 21:25:00 -0800 (PST)
Date: Thu, 13 Nov 2025 05:24:49 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251113052452.975081-1-rananta@google.com>
Subject: [PATCH 0/3] KVM: arm64: Reschedule as needed when destroying the
 stage-2 page-tables
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

When destroying a fully-mapped 128G VM abruptly, the following scheduler
warning is observed:

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

The host kernel was running with CONFIG_PREEMPT_NONE=y, and since the
page-table walk operation takes considerable amount of time for a VM
with such a large number of PTEs mapped, the warning is seen.

To mitigate this, split the walk into smaller ranges, by checking for
cond_resched() between each range. Since the path is executed during
VM destruction, after the page-table structure is unlinked from the
KVM MMU, relying on cond_resched_rwlock_write() isn't necessary.

Patch-1 kills the assumption that the page-table hierarchy under the
table is free (in stage2_free_walker()). Instead, drop and clear the
references only on empty tables.

Patch-2 splits the kvm_pgtable_stage2_destroy() function into separate
'walk' and 'free PGD' parts.

Patch-3 leverages the split and performs the walk periodically over
smaller ranges and calls cond_resched() between them.

The series was originally posted and merged [1], but was later reverted
due to syzkaller catching a UAF bug [2]. This series fixes the issue, and
the original need_resched warning is addressed.

[1]: https://lore.kernel.org/all/175582091313.1266576.4329884314263043118.b4-ty@linux.dev/
[2]: https://lore.kernel.org/all/20250910180930.3679473-1-oliver.upton@linux.dev/ 

Oliver Upton (1):
  KVM: arm64: Only drop references on empty tables in stage2_free_walker

Raghavendra Rao Ananta (2):
  KVM: arm64: Split kvm_pgtable_stage2_destroy()
  KVM: arm64: Reschedule as needed when destroying the stage-2
    page-tables

 arch/arm64/include/asm/kvm_pgtable.h | 30 +++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  4 +-
 arch/arm64/kvm/hyp/pgtable.c         | 63 +++++++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 36 +++++++++++++++-
 arch/arm64/kvm/pkvm.c                | 11 ++++-
 5 files changed, 129 insertions(+), 15 deletions(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.51.2.1041.gc1ab5b90ca-goog

