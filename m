Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B18FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 15:23:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F004B099;
	Tue, 26 Apr 2022 11:23:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C4L7-ruvIIL5; Tue, 26 Apr 2022 11:23:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37F494B17C;
	Tue, 26 Apr 2022 11:23:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 781FF4B1C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yt1St-udItx3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 01:39:19 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22F624B1BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 01:39:19 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 m8-20020a62a208000000b0050593296139so11616780pff.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 22:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=wiy4ZFErG6M19mqQHUKpS1yTWJiAAlT4dR/xLvJk6Hw=;
 b=FnVqBEYT/x+/otkeQ3+MGU8nRgioALOZEJyWRms+DoU60vLvG4knvZ85+k1mr3tVc0
 vqArKWu7LcXihZYZOL7dZijR1qW/fUI1ogYdryU7KR30je7tEjpL7SWeqEnnd/Z0l+6p
 oQzkcbfWngpMAliZPhAsfXTSWCnwz8fWFa74DRSIzlIoZx+NC9CPJeMNUZ3R63A72PJf
 QZcKxPUm3H1SOIAqby7P9meP48e3oR4Bh8C/ma3u+fJEHhbZdFo9brPFPEbwbLiTho1C
 Qvh2BmXNRXBqnJccxzxqqdYZqemamQonwCzTKOX5d0cQHIkgbJ7rHfmHl0679wZSmYIx
 AFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=wiy4ZFErG6M19mqQHUKpS1yTWJiAAlT4dR/xLvJk6Hw=;
 b=F0py3sy1EEmEq8i2+B9LXF7GK2LGw9ApMWuYc+AkaBFk1l/IFH3QQwDPc0r4aXzY0H
 DXYTckoSxLy5C1lUUdc4RFXmAGqGp5vL6dxjeMriDbx9hbUkax/kN4gNTQB/ZXiccGXZ
 uY5LAtDQJ/lah+3/OKKSs7uk+X7PckQWp2tVx3rxmzvIfhgVekZvf2vG6/33F+Dp1F7/
 T9s1NOLuY/V9X0LpPY61hmD0uAZe/PduPC03G9m6+1EH+/g0J6ZKb8VTB05HNan6ZsuV
 yvlqdfMQxCKMaoxWeZ2xEHc+lm+JqfkxEZejPtg4MEJWiMo4//UZduPZQWNftxITARvR
 mkuw==
X-Gm-Message-State: AOAM5327GJT10CA0s7j+Mk+aBig2/kx8RfWtx+Cmm6x+rIec7nQDKYLD
 7yfwff47u8FceZw0ttyPcUKjst3gf0Kiv8DU
X-Google-Smtp-Source: ABdhPJxvg8pZpaAGbW2v0JTDOhNhWaI7b9G2UFmwsQAHLCDtYBjVtAQ+AyjheoLnE1s4SzV5HxUjB6H2aYquwIV1
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:8c8:b0:4fe:ecb:9b8f
 with SMTP
 id s8-20020a056a0008c800b004fe0ecb9b8fmr22623121pfu.55.1650951557634; Mon, 25
 Apr 2022 22:39:17 -0700 (PDT)
Date: Tue, 26 Apr 2022 05:38:58 +0000
Message-Id: <20220426053904.3684293-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 0/6] KVM: mm: count KVM page table pages in memory stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Sean Christopherson <seanjc@google.com>,
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, James Morse <james.morse@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Marc Zyngier <maz@kernel.org>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
X-Mailman-Approved-At: Tue, 26 Apr 2022 11:23:27 -0400
Cc: kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
 linux-mm@kvack.org, kvm-riscv@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

We keep track of several kernel memory stats (total kernel memory, page
tables, stack, vmalloc, etc) on multiple levels (global, per-node,
per-memcg, etc). These stats give insights to users to how much memory
is used by the kernel and for what purposes.

Currently, memory used by kvm for its page tables is not accounted in
any of those kernel memory stats. This patch series accounts the memory
pages used by KVM for page tables in those stats in a new
NR_SECONDARY_PAGETABLE stat.

The riscv and mips patches are not tested due to lack of
resources. Feel free to test or drop them.

Changes in V3:
- Added NR_SECONDARY_PAGETABLE instead of piggybacking on NR_PAGETABLE
  stats.

Changes in V2:
- Added accounting stats for other archs than x86.
- Changed locations in the code where x86 KVM page table stats were
  accounted based on suggestions from Sean Christopherson.


Yosry Ahmed (6):
  mm: add NR_SECONDARY_PAGETABLE stat
  KVM: mmu: add a helper to account page table pages used by KVM.
  KVM: x86/mmu: count KVM page table pages in pagetable stats
  KVM: arm64/mmu: count KVM page table pages in pagetable stats
  KVM: riscv/mmu: count KVM page table pages in pagetable stats
  KVM: mips/mmu: count KVM page table pages in pagetable stats

 arch/arm64/kernel/image-vars.h |  3 ++
 arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
 arch/mips/kvm/mips.c           |  1 +
 arch/mips/kvm/mmu.c            |  9 +++++-
 arch/riscv/kvm/mmu.c           | 26 +++++++++++++-----
 arch/x86/kvm/mmu/mmu.c         | 16 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c     | 16 +++++++++--
 drivers/base/node.c            |  2 ++
 fs/proc/meminfo.c              |  2 ++
 include/linux/kvm_host.h       |  9 ++++++
 include/linux/mmzone.h         |  1 +
 mm/memcontrol.c                |  1 +
 mm/page_alloc.c                |  6 +++-
 mm/vmstat.c                    |  1 +
 14 files changed, 111 insertions(+), 32 deletions(-)

-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
