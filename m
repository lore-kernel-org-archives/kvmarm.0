Return-Path: <SRS0=1gKC=AD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ECBC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A41D32075A
	for <kvmarm@archiver.kernel.org>; Mon, 22 Jun 2020 20:09:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A41D32075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 263664B0E7;
	Mon, 22 Jun 2020 16:09:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QnB3CnM7c2gp; Mon, 22 Jun 2020 16:09:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 022F24B0BE;
	Mon, 22 Jun 2020 16:09:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F024B0DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ozw7DuUP0jLn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2020 16:09:07 -0400 (EDT)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E8D34B07F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2020 16:09:07 -0400 (EDT)
IronPort-SDR: PaZTTqK0kLY6B24T4qjbouNheYfv9sfYXL/X21Q9oobrCgtrbmQl05UTDQ0+zRHiNaj1U6z2Sg
 mJmhbLcYUTiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142921232"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="142921232"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Jun 2020 13:09:05 -0700
IronPort-SDR: ACiGxnvdRH5yHzKRcBqEkHkrUW0Xmd5fP+wZakk5PUawdwmWwHSjFB8CI8ofv1H3JKPtVSPmv8
 o5YF/XigfYJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; d="scan'208";a="318877033"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 13:09:05 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 00/21] KVM: Cleanup and unify kvm_mmu_memory_cache usage
Date: Mon, 22 Jun 2020 13:08:01 -0700
Message-Id: <20200622200822.4426-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Junaid Shahid <junaids@google.com>,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Note, patch 18 will conflict with the p4d rework in 5.8.  I originally
stated I would send v2 only after that got pulled into Paolo's tree, but
I got my timing wrong, i.e. I was thinking that would have already
happened.  I'll send v3 if necessary.  I wanted to get v2 out there now
that I actually compile tested other architectures.

Marc, I interpreted your "nothing caught fire" as Tested-by for the arm64
patches, let me know if that's not what you intended.


This series resurrects Christoffer Dall's series[1] to provide a common
MMU memory cache implementation that can be shared by x86, arm64 and MIPS.

It also picks up a suggested change from Ben Gardon[2] to clear shadow
page tables during initial allocation so as to avoid clearing entire
pages while holding mmu_lock.

The front half of the patches do house cleaning on x86's memory cache
implementation in preparation for moving it to common code, along with a
fair bit of cleanup on the usage.  The middle chunk moves the patches to
common KVM, and the last two chunks convert arm64 and MIPS to the common
implementation.

Fully tested on x86 only.  Compile tested patches 14-21 on arm64, MIPS,
s390 and PowerPC.

v2:
  - Rebase to kvm-5.8-2, commit 49b3deaad345 ("Merge tag ...").
  - Use an asm-generic kvm_types.h for s390 and PowerPC instead of an
    empty arch-specific file. [Marc]
  - Explicit document "GFP_PGTABLE_USER == GFP_KERNEL_ACCOUNT | GFP_ZERO"
    in the arm64 conversion patch. [Marc]
  - Collect review tags. [Ben]

[1] https://lkml.kernel.org/r/20191105110357.8607-1-christoffer.dall@arm
[2] https://lkml.kernel.org/r/20190926231824.149014-4-bgardon@google.com

Sean Christopherson (21):
  KVM: x86/mmu: Track the associated kmem_cache in the MMU caches
  KVM: x86/mmu: Consolidate "page" variant of memory cache helpers
  KVM: x86/mmu: Use consistent "mc" name for kvm_mmu_memory_cache locals
  KVM: x86/mmu: Remove superfluous gotos from mmu_topup_memory_caches()
  KVM: x86/mmu: Try to avoid crashing KVM if a MMU memory cache is empty
  KVM: x86/mmu: Move fast_page_fault() call above
    mmu_topup_memory_caches()
  KVM: x86/mmu: Topup memory caches after walking GVA->GPA
  KVM: x86/mmu: Clean up the gorilla math in mmu_topup_memory_caches()
  KVM: x86/mmu: Separate the memory caches for shadow pages and gfn
    arrays
  KVM: x86/mmu: Make __GFP_ZERO a property of the memory cache
  KVM: x86/mmu: Zero allocate shadow pages (outside of mmu_lock)
  KVM: x86/mmu: Skip filling the gfn cache for guaranteed direct MMU
    topups
  KVM: x86/mmu: Prepend "kvm_" to memory cache helpers that will be
    global
  KVM: Move x86's version of struct kvm_mmu_memory_cache to common code
  KVM: Move x86's MMU memory cache helpers to common KVM code
  KVM: arm64: Drop @max param from mmu_topup_memory_cache()
  KVM: arm64: Use common code's approach for __GFP_ZERO with memory
    caches
  KVM: arm64: Use common KVM implementation of MMU memory caches
  KVM: MIPS: Drop @max param from mmu_topup_memory_cache()
  KVM: MIPS: Account pages used for GPA page tables
  KVM: MIPS: Use common KVM implementation of MMU memory caches

 arch/arm64/include/asm/kvm_host.h  |  11 ---
 arch/arm64/include/asm/kvm_types.h |   8 ++
 arch/arm64/kvm/arm.c               |   2 +
 arch/arm64/kvm/mmu.c               |  54 +++---------
 arch/mips/include/asm/kvm_host.h   |  11 ---
 arch/mips/include/asm/kvm_types.h  |   7 ++
 arch/mips/kvm/mmu.c                |  44 ++--------
 arch/powerpc/include/asm/Kbuild    |   1 +
 arch/s390/include/asm/Kbuild       |   1 +
 arch/x86/include/asm/kvm_host.h    |  14 +---
 arch/x86/include/asm/kvm_types.h   |   7 ++
 arch/x86/kvm/mmu/mmu.c             | 129 +++++++++--------------------
 arch/x86/kvm/mmu/paging_tmpl.h     |  10 +--
 include/asm-generic/kvm_types.h    |   5 ++
 include/linux/kvm_host.h           |   7 ++
 include/linux/kvm_types.h          |  19 +++++
 virt/kvm/kvm_main.c                |  55 ++++++++++++
 17 files changed, 175 insertions(+), 210 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 create mode 100644 arch/x86/include/asm/kvm_types.h
 create mode 100644 include/asm-generic/kvm_types.h

-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
