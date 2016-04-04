From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 00/17] kvm-arm: Add stage2 page table walker
Date: Mon,  4 Apr 2016 17:26:00 +0100
Message-ID: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4DAF40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D+D5cn4Za7+X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 12:25:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58131409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 12:25:29 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This series adds support for stage2 page table helpers and makes
the core kvm-arm MMU code make use of it. At the moment we assume
that the host/hyp and the stage2 page tables have same number of
levels and hence use the host level accessors (except for some
hooks, e.g kvm_p.d_addr_end) and shares the routines for unmapping
the page table ranges.

On arm32, the only change w.r.t the page tables is dealing
with > 32bit physical addresses.

However on arm64, the hardware supports concatenation of tables (upto 16)
at the entry level, which could affect :
 1) number of entries in the PGD table (upto 16 * PTRS_PER_PTE)
 2) number of page table levels (reduced number of page table levels).

Also depending on the VA_BITS for the host kernel, the number of page table
levels for both host and stage2(40bit IPA) could differ. At present, we insert
(upto) one fake software page table(as the hardware is not aware of it and is
only used by the OS to walk the table) level to bring the number of levels to
that of the host/hyp table. However, with 16K + 48bit, and 40bit IPA, we could
end up in 2 fake levels, which complicates the code.

This series introduces explicit stage2 page table helpers and also defines
separate set of routines for unmapping hyp and stage2 tables.

On arm64 stage2 page table helpers are defined based on the number of levels
required to map the IPA bits. See patch 15 for more details.

Tested on TC2 (arm32), Fast models(with VHE) and real hardwares.

Changes since RFC:
 * Rebased to rc2
 * Use explicit routines for modifying the hyp/stage2 page tables
 * Add pmd_thp_or_huge() for arm64 and use that for KVM
 * Reuse TCR_EL definitions

Suzuki K Poulose (17):
  arm64: Reuse TCR field definitions for EL1 and EL2
  arm64: Cleanup VTCR_EL2 and VTTBR field values
  kvm arm: Move fake PGD handling to arch specific files
  arm64: Introduce pmd_thp_or_huge
  kvm-arm: Replace kvm_pmd_huge with pmd_thp_or_huge
  kvm-arm: Remove kvm_pud_huge()
  kvm-arm: arm32: Introduce stage2 page table helpers
  kvm-arm: arm: Introduce hyp page table empty checks
  kvm-arm: arm64: Introduce stage2 page table helpers
  kvm-arm: arm64: Introduce hyp page table empty checks
  kvm-arm: Use explicit stage2 helper routines
  kvm-arm: Add explicit hyp page table modifiers
  kvm-arm: Add stage2 page table modifiers
  kvm-arm: Cleanup kvm_* wrappers
  kvm: arm64: Get rid of fake page table levels
  kvm-arm: Cleanup stage2 pgd handling
  arm64: kvm: Add support for 16K pages

 arch/arm/include/asm/kvm_mmu.h                |   35 +--
 arch/arm/include/asm/stage2_pgtable.h         |   59 +++++
 arch/arm/kvm/arm.c                            |    2 +-
 arch/arm/kvm/mmu.c                            |  354 ++++++++++++++-----------
 arch/arm64/include/asm/kvm_arm.h              |   82 +++---
 arch/arm64/include/asm/kvm_mmu.h              |   84 +-----
 arch/arm64/include/asm/pgtable-hwdef.h        |   80 ++++--
 arch/arm64/include/asm/pgtable.h              |    2 +
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |   42 +++
 arch/arm64/include/asm/stage2_pgtable-nopud.h |   39 +++
 arch/arm64/include/asm/stage2_pgtable.h       |  133 ++++++++++
 arch/arm64/kvm/Kconfig                        |    1 -
 12 files changed, 599 insertions(+), 314 deletions(-)
 create mode 100644 arch/arm/include/asm/stage2_pgtable.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable.h

-- 
1.7.9.5
