Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FE8C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 15:48:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FE574B2AB;
	Sat, 30 Apr 2022 11:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wFAi+p4UAxjf; Sat, 30 Apr 2022 11:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 003454B27D;
	Sat, 30 Apr 2022 11:48:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 786E14B0C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3TX2WZfrmUjk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 16:11:46 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5213D40BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:46 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 x9-20020a056a000bc900b0050d919e9c9bso3362561pfu.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 13:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=an+yRArve5ZrSQoHDO73aNF7aPP+aWpAaWAPrlB9pIk=;
 b=rVCOmuzI6Jkg0VCtxq3Vv4tNhvcYa/7dy0aktfX+JU+3ABY/r1NuUYg6gNufzdzZyl
 TDx1/jOeHCUYV9kesQSDCM7gJuIkuCPZ3CI4xBiGyBYzao4KJxWyjV/wpOnUty7d2gkO
 xxgzezsPH49IA+C2wqMwqPUxHg+sr/u2pJ62e25BKh1gnBlY4tBxVuP6uCBRMMN8Bn0A
 o1aa0m514YE3U+J37NsZZ2A48FIIXDI4WlykXmRNEDZ9x5sTM9dO2kFgrvtI4EV9z//v
 PwFQ3hahtu5wgS2IyOj4qxw1dMwLZ0jJ58K/MjgmBn8W0hkXkDKsnnvkTtmina/ADpu8
 G4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=an+yRArve5ZrSQoHDO73aNF7aPP+aWpAaWAPrlB9pIk=;
 b=o79QauoGAgNRNThGilGt7XFTCcuk4LjSZ9e3ZvaGGRw65ANpsQ2ZlFlowSosumySzc
 PJ6iHhXk36oGvjU5jK5kJoTi8P/RrzlZY+AMEsbtPzsCWyhaXobOLx8pxW9aD3j8T0rx
 WgQWoll9M9BMa3U5N9KH9jno95A4so6Vn1gJj4uqdovBpe2xWQbrBs2XyloldOUaXZym
 tEuXWnsve6IuzOZw6sMQRCMahrfp+K8Gn6XUp808IPE7o4bVRK9w7SlBOl1Bd83hxmJV
 mTKlEj48QtnBV9rAXy1lRBatJGEWCJWZ3a05Mw4Snoec9P3nRiwoxua34xsbMTkFqcCl
 jVVw==
X-Gm-Message-State: AOAM531c1lx2CP5fqL/2SO5mMTFi9/H6uUEzpvVqVVFHrpc4V234wZdL
 8cDXtuehz5XQYDVwIWbgjuxqlyGc5Ow4i6I4
X-Google-Smtp-Source: ABdhPJxGZ1WYv4PcG6KKKG7/eOxb6RjoyzIw3GgB/7NGUVZUE3/7d2UGeWsMnv6NDpe3G1grI1WrkTwZdxjSyZ2c
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by
 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr438392pjy.0.1651263104394; Fri, 29
 Apr 2022 13:11:44 -0700 (PDT)
Date: Fri, 29 Apr 2022 20:11:27 +0000
Message-Id: <20220429201131.3397875-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 0/4] KVM: mm: count KVM mmu usage in memory stats
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Sat, 30 Apr 2022 11:48:22 -0400
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Currently, memory used by kvm mmu is not accounted in any of those
kernel memory stats. This patch series accounts the memory pages
used by KVM for page tables in those stats in a new
NR_SECONDARY_PAGETABLE stat.

---

Changes in V4:
- Changed accounting hooks in arm64 to only account s2 page tables and
  refactored them to a much cleaner form, based on recommendations from
  Oliver Upton and Marc Zyngier.
- Dropped patches for mips and riscv. I am not interested in those archs
  anyway and don't have the resources to test them. I posted them for
  completeness but it doesn't seem like anyone was interested.

Changes in V3:
- Added NR_SECONDARY_PAGETABLE instead of piggybacking on NR_PAGETABLE
  stats.

Changes in V2:
- Added accounting stats for other archs than x86.
- Changed locations in the code where x86 KVM page table stats were
  accounted based on suggestions from Sean Christopherson.

---

Yosry Ahmed (4):
  mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
  KVM: mmu: add a helper to account memory used by KVM mmu.
  KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
  KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats

 Documentation/admin-guide/cgroup-v2.rst |  5 ++++
 Documentation/filesystems/proc.rst      |  4 +++
 arch/arm64/kvm/mmu.c                    | 35 ++++++++++++++++++++++---
 arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c              | 16 +++++++++--
 drivers/base/node.c                     |  2 ++
 fs/proc/meminfo.c                       |  2 ++
 include/linux/kvm_host.h                |  9 +++++++
 include/linux/mmzone.h                  |  1 +
 mm/memcontrol.c                         |  1 +
 mm/page_alloc.c                         |  6 ++++-
 mm/vmstat.c                             |  1 +
 12 files changed, 89 insertions(+), 9 deletions(-)

-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
