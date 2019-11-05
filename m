Return-Path: <SRS0=uMsW=Y5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AFEC5DF63
	for <kvmarm@archiver.kernel.org>; Tue,  5 Nov 2019 20:30:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A02D4222C6
	for <kvmarm@archiver.kernel.org>; Tue,  5 Nov 2019 20:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A02D4222C6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65EF04AE8D;
	Tue,  5 Nov 2019 15:30:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s+MMN7r6wHPW; Tue,  5 Nov 2019 15:30:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2EC14AE8F;
	Tue,  5 Nov 2019 15:29:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6843B4AE87
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Nov 2019 15:29:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j2pdCXcT0+IA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Nov 2019 15:29:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BDE34AC8D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Nov 2019 15:29:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9120064F;
 Tue,  5 Nov 2019 12:29:56 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C9EE3FE14;
 Tue,  5 Nov 2019 03:04:00 -0800 (PST)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvm@vger.kernel.org
Subject: [PATCH v4 0/5] KVM: Unify mmu_memory_cache functionality across
 architectures
Date: Tue,  5 Nov 2019 12:03:52 +0100
Message-Id: <20191105110357.8607-1-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
Cc: Wanpeng Li <wanpengli@tencent.com>, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

We currently have duplicated functionality for the mmu_memory_cache used
to pre-allocate memory for the page table manipulation code which cannot
allocate memory while holding spinlocks.  This functionality is
duplicated across x86, arm/arm64, and mips.

This was motivated by a debate of modifying the arm code to be more in
line with the x86 code and some discussions around changing the page
flags used for allocation.  This series should make it easier to take a
uniform approach across architectures.

While there's not a huge amount of code sharing, we come out with a net
gain, and the real win is in the consistency of how we allocate memory
for page tables used by secondary MMUs driven by KVM in Linux.

Only tested on arm/arm64, and only compile-tested on x86 and mips.  I'm
especially curious on getting feedback on the change of GFP flags for
x86 (patch 1) and on the use of __GFP_ACCOUNT for mips.

Changes since v3:
 - Moved to common GFP_PGTABLE_USER definition for page allocations in
   the MMU cache for all three architectures.  This follows recent work
   which already did this for arm/arm64.
 - Rebased on v5.4-rc4.

Changes since v2:
 - Simplified kalloc flag definitions as per Paolo's review comment.

Changes since v1:
 - Split out rename from initial x86 patch to have separate patches to
   move the logic to common code and to rename.
 - Introduce KVM_ARCH_WANT_MMU_MEMCACHE to avoid compile breakage on
   architectures that don't use this functionality.
 - Rename KVM_NR_MEM_OBJS to KVM_MMU_NR_MEMCACHE_OBJS

Christoffer Dall (5):
  KVM: x86: Move memcache allocation to GFP_PGTABLE_USER
  KVM: x86: Move mmu_memory_cache functions to common code
  KVM: x86: Rename mmu_memory_cache to kvm_mmu_memcache
  KVM: arm/arm64: Move to common kvm_mmu_memcache infrastructure
  KVM: mips: Move to common kvm_mmu_memcache infrastructure

 arch/arm/include/asm/kvm_host.h      | 13 +---
 arch/arm/include/asm/kvm_mmu.h       |  2 +-
 arch/arm/include/asm/kvm_types.h     |  9 +++
 arch/arm64/include/asm/kvm_host.h    | 13 +---
 arch/arm64/include/asm/kvm_mmu.h     |  2 +-
 arch/arm64/include/asm/kvm_types.h   |  9 +++
 arch/mips/include/asm/kvm_host.h     | 15 +----
 arch/mips/include/asm/kvm_types.h    |  9 +++
 arch/mips/kvm/mips.c                 |  2 +-
 arch/mips/kvm/mmu.c                  | 54 +++-------------
 arch/powerpc/include/asm/kvm_types.h |  5 ++
 arch/s390/include/asm/kvm_types.h    |  5 ++
 arch/x86/include/asm/kvm_host.h      | 17 +----
 arch/x86/include/asm/kvm_types.h     |  9 +++
 arch/x86/kvm/mmu.c                   | 97 ++++++----------------------
 arch/x86/kvm/paging_tmpl.h           |  4 +-
 include/linux/kvm_host.h             | 11 ++++
 include/linux/kvm_types.h            | 13 ++++
 virt/kvm/arm/arm.c                   |  2 +-
 virt/kvm/arm/mmu.c                   | 68 +++++--------------
 virt/kvm/kvm_main.c                  | 61 +++++++++++++++++
 21 files changed, 190 insertions(+), 230 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_types.h
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 create mode 100644 arch/powerpc/include/asm/kvm_types.h
 create mode 100644 arch/s390/include/asm/kvm_types.h
 create mode 100644 arch/x86/include/asm/kvm_types.h

-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
