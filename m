Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E408C433E3
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4AEED206FA
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 21:39:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AEED206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F8E4B1C2;
	Fri,  5 Jun 2020 17:39:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8h19lrj5+-Ua; Fri,  5 Jun 2020 17:39:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF5A84B202;
	Fri,  5 Jun 2020 17:39:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7A44B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id utDJqSzjOAkN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 17:39:14 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BAF44B07F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 17:39:13 -0400 (EDT)
IronPort-SDR: pxPfw/mg+DjlEpzyNOGRnOIBM6nWvmHnjiL4rwSLqbMkeIWo1bomEq+r8d0qoaO38c9xjm4/YG
 1dNYjZO0wzJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 05 Jun 2020 14:39:07 -0700
IronPort-SDR: 3kU6BlJ3ZElEdj1AHWXLHsdk52pJvqNGjfnKdDIaTU1hErrl7iwvq5Lps986iLm32Az8kC2WKh
 ius/kdGV8mzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; d="scan'208";a="287860865"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:07 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 00/21] KVM: Cleanup and unify kvm_mmu_memory_cache usage
Date: Fri,  5 Jun 2020 14:38:32 -0700
Message-Id: <20200605213853.14959-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Ben Gardon <bgardon@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Joerg Roedel <joro@8bytes.org>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>
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

Cleanup aside, the notable difference from Christoffer and Ben's proposed
patches is to make __GFP_ZERO optional, e.g. to allow x86 to skip zeroing
for its gfns array and to provide line of sight for my
cannot-yet-be-discussed-in-detail use case for non-zero initialized shadow
page tables[3].

Tested on x86 only, no testing whatsoever on arm64 or MIPS.

[1] https://lkml.kernel.org/r/20191105110357.8607-1-christoffer.dall@arm.com
[2] https://lkml.kernel.org/r/20190926231824.149014-4-bgardon@google.com
[3] https://lkml.kernel.org/r/20191127180731.GC16845@linux.intel.com

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

 arch/arm64/include/asm/kvm_host.h    |  11 ---
 arch/arm64/include/asm/kvm_types.h   |   8 ++
 arch/arm64/kvm/arm.c                 |   2 +
 arch/arm64/kvm/mmu.c                 |  54 +++--------
 arch/mips/include/asm/kvm_host.h     |  11 ---
 arch/mips/include/asm/kvm_types.h    |   7 ++
 arch/mips/kvm/mmu.c                  |  44 ++-------
 arch/powerpc/include/asm/kvm_types.h |   5 ++
 arch/s390/include/asm/kvm_types.h    |   5 ++
 arch/x86/include/asm/kvm_host.h      |  14 +--
 arch/x86/include/asm/kvm_types.h     |   7 ++
 arch/x86/kvm/mmu/mmu.c               | 129 +++++++++------------------
 arch/x86/kvm/mmu/paging_tmpl.h       |  10 +--
 include/linux/kvm_host.h             |   7 ++
 include/linux/kvm_types.h            |  19 ++++
 virt/kvm/kvm_main.c                  |  55 ++++++++++++
 16 files changed, 178 insertions(+), 210 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 create mode 100644 arch/powerpc/include/asm/kvm_types.h
 create mode 100644 arch/s390/include/asm/kvm_types.h
 create mode 100644 arch/x86/include/asm/kvm_types.h

-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
