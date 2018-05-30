From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/6] KVM/arm64: Cache maintenance relaxations
Date: Wed, 30 May 2018 13:47:00 +0100
Message-ID: <20180530124706.25284-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93C604A0E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 May 2018 08:36:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TnjyEqITzLXc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 May 2018 08:36:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F222402AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 May 2018 08:36:18 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This small series makes use of features recently introduced in the
ARMv8 architecture to relax the cache maintenance operations on CPUs
that implement these features.

FWB is the most important one. It allows stage-2 to enforce the
cacheability of memory, no matter what the guest says. It also
mandates that the whole machine is cache coherent (no non-coherent
I/O), meaning we can drop a whole class of cache maintenance
operations.

FWB, when combined with CTL_EL0.{IDC,DIC} allows the removal of all
cache maintenance and tracking of pages being executed.

We also take the opportunity to drop a few useless CMOs that were
applied to the HYP page tables, but that were never necessary. This
ended up requiring quite a few changes in out page table accessors so
that they get consistent barriers. These barriers are a bit on the
heavy side, and could be further optimized, although that's probably
for a different patch series

* From v1:
  - Reordered the series in a slightly more consistent order
  - Added patches refactoring the PT accessors before dropping
    the CMOs
  - Removed final dsb(ishst) from the last patch, as all PT accessors
    now have their own barriers
  - Collected Acks from Catalin

Marc Zyngier (6):
  arm64: KVM: Add support for Stage-2 control of memory types and
    cacheability
  arm64: KVM: Handle Set/Way CMOs as NOPs if FWB is present
  arm64: KVM: Avoid marking pages as XN in Stage-2 if CTR_EL0.DIC is set
  KVM: arm/arm64: Consolidate page-table accessors
  KVM: arm/arm64: Stop using {pmd,pud,pgd}_populate
  KVM: arm/arm64: Remove unnecessary CMOs when creating HYP page tables

 arch/arm/include/asm/kvm_mmu.h        | 14 ++-------
 arch/arm64/include/asm/cpucaps.h      |  3 +-
 arch/arm64/include/asm/kvm_arm.h      |  1 +
 arch/arm64/include/asm/kvm_emulate.h  |  2 ++
 arch/arm64/include/asm/kvm_mmu.h      | 32 +++++++++++++------
 arch/arm64/include/asm/memory.h       |  7 +++++
 arch/arm64/include/asm/pgtable-prot.h | 24 ++++++++++++--
 arch/arm64/include/asm/sysreg.h       |  1 +
 arch/arm64/kernel/cpufeature.c        | 20 ++++++++++++
 arch/arm64/kvm/sys_regs.c             |  8 ++++-
 virt/kvm/arm/mmu.c                    | 45 ++++++++++++++++++++++-----
 11 files changed, 125 insertions(+), 32 deletions(-)

-- 
2.17.1
