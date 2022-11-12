Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23527C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 741364B812;
	Sat, 12 Nov 2022 03:17:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s1+2Tsuu14VV; Sat, 12 Nov 2022 03:17:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 074D74B7EF;
	Sat, 12 Nov 2022 03:17:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0D914B7ED
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oeZXRTZuMmcU for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:17 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBC974B7B6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:17 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 204-20020a250fd5000000b006ccc0e91098so6382858ybp.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=gM/dBldMXVFW9soqs/jk7IijfuRELVPgZiXOzT/Jgp4=;
 b=VSKs17BFbJf1BzRdZ3xUYqWdm3hM8VYDeO6g4U/HqpUMqWfY67VagjnOmlciJ6UUGq
 +wcPkeOWnUDxxNhx7BEW51ExxhHgzjGadpJ0c825xaW2avZTX2xU8QHNfhns4A0AF2+M
 y4RifNBfRGEuOgM2Qf4GyChxWY2MchBmr3+FtZa7bqo6ctWgUYZfPENTSBZ1s12MJUC4
 zQ8dfO9vSvEnny6vg7V4ovEI/OI11xGQ4TRECuSrVqPBbkw1lX6hZWSLG4UK7q+LVw0s
 QTyItfs6qMr6+C/0IC6q4liv8oCrWVVq+fgj2Zi+Mezu0GLzwuVUDaATJJKql0bm/Zja
 JUIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=gM/dBldMXVFW9soqs/jk7IijfuRELVPgZiXOzT/Jgp4=;
 b=t/iBhyExHeT8ruuqJN1u7ZBpSaA0ZQRa+NEBuagtoNA7Tvt/JZxd6471odIjcFKx4f
 vAz1aAWkBm4ZprbJcohj+m+s7vpgwU3v0NgC9YBW9VO3eLGOPC+9iAZOhF3Bin6LZrK5
 yWePeOy4TbU84Dfr6oNGT+JF9mKJCgHut+kDsu+I+Nvhmams0ZLcGBqCKv1aCxFRFRqA
 NGTZAoH4ENEUNBLGlX/TYpRwfvp7u0sC5sfHcKPKIoQwfxgTW0SGY7uXcWrIAnkP5+U+
 OEcu/WsaFHL8BMmDHUtXFcqEVij2HUqat+6vHT4SBNbHBCwoHWDzV3pWMAAU4wLwk0w3
 0frA==
X-Gm-Message-State: ANoB5pnjo6Q6p0eeh2TVamLHEVW3oxEDqS5Qyj/CrVszbBGuZst7pSkG
 06qYyFVBnxhq2lYf0TNej0RxK76wyTip2Q==
X-Google-Smtp-Source: AA0mqf4rUZKlmT19yHtgPj4PMQ3I9NSOIrqenW8ALo8RJGd+u41z9SR3u9J2320QaFwrzq1vLAM9FwbICVmFFA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:dd44:0:b0:6dd:da8f:de8d with SMTP id
 u65-20020a25dd44000000b006ddda8fde8dmr5174432ybg.454.1668241037390; Sat, 12
 Nov 2022 00:17:17 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:02 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-1-ricarkol@google.com>
Subject: [RFC PATCH 00/12] KVM: arm64: Eager huge-page splitting for
 dirty-logging
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

I'm sending this RFC mainly to get some early feedback on the approach used
for implementing "Eager Page Splitting" on ARM.  "Eager Page Splitting"
improves the performance of dirty-logging (used in live migrations) when
guest memory is backed by huge-pages.  It's an optimization used in Google
Cloud since 2016 on x86, and for the last couple of months on ARM.

I tried multiple ways of implementing this optimization on ARM: from
completely reusing the stage2 mapper, to implementing a new walker from
scratch, and some versions in between. This RFC is one of those in
between. They all have similar performance benefits, based on some light
performance testing (mainly dirty_log_perf_test).

Background and motivation
=========================
Dirty logging is typically used for live-migration iterative copying.  KVM
implements dirty-logging at the PAGE_SIZE granularity (will refer to 4K
pages from now on).  It does it by faulting on write-protected 4K pages.
Therefore, enabling dirty-logging on a huge-page requires breaking it into
4K pages in the first place.  KVM does this breaking on fault, and because
it's in the critical path it only maps the 4K page that faulted; every
other 4K page is left unmapped.  This is not great for performance on ARM
for a couple of reasons:

- Splitting on fault can halt vcpus for milliseconds in some
  implementations. Splitting a block PTE requires using a broadcasted TLB
  invalidation (TLBI) for every huge-page (due to the break-before-make
  requirement). Note that x86 doesn't need this. We observed some
  implementations that take millliseconds to complete broadcasted TLBIs
  when done in parallel from multiple vcpus.  And that's exactly what
  happens when doing it on fault: multiple vcpus fault at the same time
  triggering TLBIs in parallel.

- Read intensive guest workloads end up paying for dirty-logging.  Only
  mapping the faulting 4K page means that all the other pages that were
  part of the huge-page will now be unmapped. The effect is that any
  access, including reads, now has to fault.

Eager Page Splitting (on ARM)
=============================
Eager Page Splitting fixes the above two issues by eagerly splitting
huge-pages when enabling dirty logging. The goal is to avoid doing it while
faulting on write-protected pages. This is what the TDP MMU does for x86
[0], except that x86 does it for different reasons: to avoid grabbing the
MMU lock on fault. Note that taking care of write-protection faults still
requires grabbing the MMU lock on ARM, but not on x86 (with the
fast_page_fault path).

An additional benefit of eagerly splitting huge-pages is that it can be
done in a controlled way (e.g., via an IOCTL). This series provides two
knobs for doing it, just like its x86 counterpart: when enabling dirty
logging, and when using the KVM_CLEAR_DIRTY_LOG ioctl. The benefit of doing
it on KVM_CLEAR_DIRTY_LOG is that this ioctl takes ranges, and not complete
memslots like when enabling dirty logging. This means that the cost of
splitting (mainly broadcasted TLBIs) can be throttled: split a range, wait
for a bit, split another range, etc. The benefits of this approach were
presented by Oliver Upton at KVM Forum 2022 [1].

Implementation
==============
Patches 1-4 add a pgtable utility function for splitting huge block PTEs:
kvm_pgtable_stage2_split(). Patches 5-6 add support for not doing
break-before-make on huge-page breaking when FEAT_BBM level 2 is supported.
Patches 7-11 add support for eagerly splitting huge-pages when enabling
dirty-logging and when using the KVM_CLEAR_DIRTY_LOG ioctl. Note that this
is just like what x86 does, and the code is actually based on it.  And
finally, patch 12:

	KVM: arm64: Use local TLBI on permission relaxation

adds support for using local TLBIs instead of broadcasts when doing
permission relaxation. This last patch is key to achieving good performance
during dirty-logging, as eagerly breaking huge-pages replaces mapping new
pages with permission relaxation. Got this patch (indirectly) from Marc Z.
and took the liberty of adding a commit message.

Note: this applies on top of kvmarm/next at 3ba3e7266ab6. Although most of
the tests were done using [2] (v6.1-rc1 + [3]).

Performance evaluation
======================
The performance benefits were tested on an Ampere AmpereOne using the
dirty_log_perf_test selftest with 2M huge-pages.

The first test uses a write-only sequential workload where the stride is 2M
instead of 4K [2]. The idea with this experiment is to emulate a random
access pattern writing a different huge-page at every access. Observe that
the benefit increases with the number of vcpus: up to 5.76x for 152 vcpus.

./dirty_log_perf_test_sparse -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2

	+-------+----------+---------------+
	| vCPUs |    next  | next + series |
	|       |    (ms)  |          (ms) |
	+-------+----------+---------------+
	|    1  |    3.34  |       1.85    |
	|    2  |    3.51  |       1.92    |
	|    4  |    3.93  |       1.99    |
	|    8  |    5.78  |       1.97    |
	|   16  |   10.06  |       2.08    |
	|   32  |   21.07  |       3.06    |
	|   64  |   41.75  |       6.92    |
	|  128  |   86.09  |      12.07    |
	|  152  |  109.72  |      18.94    |
	+-------+----------+---------------+

This second test measures the benefit of eager page splitting on read
intensive workloads (1 write for every 10 reads). As in the other test, the
benefit increases with the number of vcpus, up to 8.82x for 152 vcpus.

./dirty_log_perf_test -s anonymous_hugetlb_2mb -b 1G -v $i -i 3 -m 2 -f 10

	+-------+----------+---------------+
	| vCPUs |   next   | next + series |
	|       |  (sec)   |         (sec) |
	+-------+----------+---------------+
	|    1  |    0.65  |       0.09    |
	|    2  |    0.70  |       0.09    |
	|    4  |    0.71  |       0.09    |
	|    8  |    0.72  |       0.10    |
	|   16  |    0.76  |       0.10    |
	|   32  |    1.61  |       0.15    |
	|   64  |    3.46  |       0.36    |
	|  128  |    5.49  |       0.74    |
	|  152  |    6.44  |       0.73    |
	+-------+----------+---------------+

Thanks,
Ricardo

[0] https://lore.kernel.org/kvm/20220119230739.2234394-1-dmatlack@google.com/
[1] https://kvmforum2022.sched.com/event/15jJq/kvmarm-at-scale-improvements-to-the-mmu-in-the-face-of-hardware-growing-pains-oliver-upton-google
[2] https://github.com/ricarkol/linux/commit/f78e9102b2bff4fb7f30bee810d7d611a537b46d
[3] https://lore.kernel.org/kvmarm/20221107215644.1895162-1-oliver.upton@linux.dev/

Marc Zyngier (1):
  KVM: arm64: Use local TLBI on permission relaxation

Ricardo Koller (11):
  KVM: arm64: Relax WARN check in stage2_make_pte()
  KVM: arm64: Allow visiting block PTEs in post-order
  KVM: arm64: Add stage2_create_removed()
  KVM: arm64: Add kvm_pgtable_stage2_split()
  arm64: Add a capability for FEAT_BBM level 2
  KVM: arm64: Split block PTEs without using break-before-make
  KVM: arm64: Refactor kvm_arch_commit_memory_region()
  KVM: arm64: Add kvm_uninit_stage2_mmu()
  KVM: arm64: Split huge pages when dirty logging is enabled
  KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
  KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG

 arch/arm64/include/asm/esr.h         |   1 +
 arch/arm64/include/asm/kvm_arm.h     |   1 +
 arch/arm64/include/asm/kvm_asm.h     |   4 +
 arch/arm64/include/asm/kvm_host.h    |  30 ++++
 arch/arm64/include/asm/kvm_mmu.h     |   1 +
 arch/arm64/include/asm/kvm_pgtable.h |  33 ++++-
 arch/arm64/kernel/cpufeature.c       |  11 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  10 ++
 arch/arm64/kvm/hyp/nvhe/setup.c      |   2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c        |  54 +++++++
 arch/arm64/kvm/hyp/pgtable.c         | 205 +++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c         |  32 +++++
 arch/arm64/kvm/mmu.c                 | 177 +++++++++++++++++++----
 arch/arm64/tools/cpucaps             |   1 +
 14 files changed, 517 insertions(+), 45 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
