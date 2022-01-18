Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADC1C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 01:57:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB6749EB3;
	Mon, 17 Jan 2022 20:57:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XON-ood6QiLv; Mon, 17 Jan 2022 20:57:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 964CA49DF6;
	Mon, 17 Jan 2022 20:57:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B7449DF6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xclrejd8hL-8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jan 2022 20:57:07 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDAFB40FAB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 20:57:07 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 ij17-20020a17090af81100b001b498904910so2008622pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jan 2022 17:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=vJOiObhxu95/kxDXA87lBI0whmijrZSeIBoPadjg9mo=;
 b=Pt60whvLgekWJhH1GRWxJSl/e5HGmX1wB5gUdjm2pEz6QXWyaVd4fG5NFIZvX3th6k
 L6RyOu9Limw3r9t5JXd45PhYQ9KOT34iq8bQnDZe5fmCSotaFdD93kRGqcWtcGh/8DhI
 v1rx3CsjPK4ApY/SBPTbinMBBvHW5RruKG7y2Sf5ihfOmOAwPL4ZVEd6Cq/pALCWFc+5
 bfY3/QneI0cRibvCdD+yMAO0ZmlDCmNRhuK0QHy7oSAQnTZYUQ+vWgTJ8Wm0HPnL7K2+
 XPhdsddsnYC2TneQ79IVqcTOLR9F8lKHcBOrjvdfFX3rNUFJkrGZXrpxQm934/Luquu7
 AUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=vJOiObhxu95/kxDXA87lBI0whmijrZSeIBoPadjg9mo=;
 b=KcWf4GkCN/0UnNtwXy+V3PLF9/WVyE+sYy2+/Sf88cYJcr0ep/WvXj2lvivdGcLhfL
 6WRO3phqNpoE4QSIQ4KLSexL0aJp+BoGcplwroo0x84jtSxHtrZDbPA68JEmPIiejCVX
 Ml5Wkk8YJ08knX3AYfnalMkpt6wfk8nUqLcRcs1tknPEgh+serKWQ1wA4/bMwtWNgXtX
 55rXR5uKLuKivncvJnDreLKwtnT1wt7rcgm9XkazBApSuSfsEJL6tpGhvube1SynHNIB
 bN75Nagz1Og8wFAvtMidBC1zEqVmFkQ9J344KcPI9jQzuYy03CivTEclAi35CZD4vUmD
 C+/w==
X-Gm-Message-State: AOAM531HItISBfbKVvO7VMPxV36DhXm6HPGn5Pet5oYSbgyBt6PEE2d8
 A52G+uMig5JgC6Q5MeLJdey4jpl/KS/JyGbdoQ==
X-Google-Smtp-Source: ABdhPJwRk9u/XzSP0HuCbMjd6ti3DsYyIEU8xQCyhdJ7euIPihphq+67Gz5FH5UrKmUCSggrkREN7GbJpKNcZfeDlA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:902:e8c8:b0:149:eb6d:23fb with
 SMTP id v8-20020a170902e8c800b00149eb6d23fbmr25496710plg.53.1642471026898;
 Mon, 17 Jan 2022 17:57:06 -0800 (PST)
Date: Tue, 18 Jan 2022 01:57:00 +0000
Message-Id: <20220118015703.3630552-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 0/3] ARM64: Guest performance improvement during dirty
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Raghavendra Rao Ananta <rananta@google.com>
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

This patch is to reduce the performance degradation of guest workload during
dirty logging on ARM64. A fast path is added to handle permission relaxation
during dirty logging. The MMU lock is replaced with rwlock, by which all
permision relaxations on leaf pte can be performed under the read lock. This
greatly reduces the MMU lock contention during dirty logging. With this
solution, the source guest workload performance degradation can be improved
by more than 60%.

Problem:
  * A Google internal live migration test shows that the source guest workload
  performance has >99% degradation for about 105 seconds, >50% degradation
  for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
  This shows that most of the time, the guest workload degradtion is above
  99%, which obviously needs some improvement compared to the test result
  on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
  * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB, PageSize: 4K
  * VM spec: #vCPU: 48, #Mem/vCPU: 4GB, PageSize: 4K, 2M hugepage backed

Analysis:
  * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
    the number of contentions of MMU lock and the "dirty memory time" on
    various VM spec. The "dirty memory time" is the time vCPU threads spent
    in KVM after fault. Higher "dirty memory time" means higher degradation
    to guest workload.
    '-m 2' specifies the mode "PA-bits:48,  VA-bits:48,  4K pages".
    By using test command
    ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
    Below are the results:
    +-------+------------------------+-----------------------+
    | #vCPU | dirty memory time (ms) | number of contentions |
    +-------+------------------------+-----------------------+
    | 1     | 926                    | 0                     |
    +-------+------------------------+-----------------------+
    | 2     | 1189                   | 4732558               |
    +-------+------------------------+-----------------------+
    | 4     | 2503                   | 11527185              |
    +-------+------------------------+-----------------------+
    | 8     | 5069                   | 24881677              |
    +-------+------------------------+-----------------------+
    | 16    | 10340                  | 50347956              |
    +-------+------------------------+-----------------------+
    | 32    | 20351                  | 100605720             |
    +-------+------------------------+-----------------------+
    | 64    | 40994                  | 201442478             |
    +-------+------------------------+-----------------------+

  * From the test results above, the "dirty memory time" and the number of
    MMU lock contention scale with the number of vCPUs. That means all the
    dirty memory operations from all vCPU threads have been serialized by
    the MMU lock. Further analysis also shows that the permission relaxation
    during dirty logging is where vCPU threads get serialized.

Solution:
  * On ARM64, there is no mechanism as PML (Page Modification Logging) and
    the dirty-bit solution for dirty logging is much complicated compared to
    the write-protection solution. The straight way to reduce the guest
    performance degradation is to enhance the concurrency for the permission
    fault path during dirty logging.
  * In this patch, we only put leaf PTE permission relaxation for dirty
    logging under read lock, all others would go under write lock.
    Below are the results based on the fast path solution:
    +-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 965                    |
    +-------+------------------------+
    | 2     | 1006                   |
    +-------+------------------------+
    | 4     | 1128                   |
    +-------+------------------------+
    | 8     | 2005                   |
    +-------+------------------------+
    | 16    | 3903                   |
    +-------+------------------------+
    | 32    | 7595                   |
    +-------+------------------------+
    | 64    | 15783                  |
    +-------+------------------------+

  * Furtuer analysis shows that there is another bottleneck caused by the
    setup of the test code itself. The 3rd commit is meant to fix that by
    setting up vgic in the test code. With the test code fix, below are
    the results which show better improvement.
    +-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 803                    |
    +-------+------------------------+
    | 2     | 843                    |
    +-------+------------------------+
    | 4     | 942                    |
    +-------+------------------------+
    | 8     | 1458                   |
    +-------+------------------------+
    | 16    | 2853                   |
    +-------+------------------------+
    | 32    | 5886                   |
    +-------+------------------------+
    | 64    | 12190                  |
    +-------+------------------------+
    All "dirty memory time" has been reduced by more than 60% when the
    number of vCPU grows.
  * Based on the solution, the test results from the Google internal live
    migration test also shows more than 60% improvement with >99% for 30s,
    >50% for 58s and >10% for 76s.

---

* v1 -> v2
  - Renamed flag name from use_mmu_readlock to logging_perm_fault.
  - Removed unnecessary check for fault_granule to use readlock.
* RFC -> v1
  - Rebase to kvm/queue, commit fea31d169094
    (KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event)
  - Moved the fast path in user_mem_abort, as suggested by Marc.
  - Addressed other comments from Marc.

[v1] https://lore.kernel.org/all/20220113221829.2785604-1-jingzhangos@google.com
[RFC] https://lore.kernel.org/all/20220110210441.2074798-1-jingzhangos@google.com

---

Jing Zhang (3):
  KVM: arm64: Use read/write spin lock for MMU protection
  KVM: arm64: Add fast path to handle permission relaxation during dirty
    logging
  KVM: selftests: Add vgic initialization for dirty log perf test for
    ARM

 arch/arm64/include/asm/kvm_host.h             |  2 +
 arch/arm64/kvm/mmu.c                          | 49 ++++++++++++-------
 .../selftests/kvm/dirty_log_perf_test.c       | 10 ++++
 3 files changed, 43 insertions(+), 18 deletions(-)


base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
