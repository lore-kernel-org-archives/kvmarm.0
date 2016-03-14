From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 00/12] kvm-arm: Add stage2 page table walker
Date: Mon, 14 Mar 2016 16:52:59 +0000
Message-ID: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD90412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y61CS6AoEpzC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D481412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:02 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series adds support for stage2 page table helpers and makes
the core kvm-arm MMU code make use of it. At the moment we assume
that the host/hyp and the stage2 page tables have same number of
levels and hence use the host level accessors (except for some
hooks, e.g kvm_p.d_addr_end).

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

This series adds the support for stage2 translation helpers and plugs them
into the core KVM MMU code, switching between the hyp vs stage2 table
based on the 'kvm' parameter (i.e, kvm ? stage2_xxx : host_xxx )

And then we define the stage2 helpers based on the number of actual
hardware page table levels for arm64 (see Patch 10 for more details).

Finally we enable the KVM for 16K, which was depending on this series.

Patch 1: Abstracts the fake page table level handling code to arch
	 specific files.

Patch 2-4: Contains a fix and some cleanups

Patch 5,6: Prepares the existing kvm_p{g,u,m}d_ wrappers for choosing the
	 appropriate tables.

Patch 7,8: Adds kvm_ wrappers for the other page table helpers which differ
	 for hyp vs stage2, so that they can be later switched to the correct
	 table for arm and arm64.
Patch 9: Switches the kvm-arm MMU code to use the kvm_ wrappers for all page
	 table walks and explicit accessors wherever applicable.

Patch 10: Define the real stage2 helpers based on the hardware page table
	 and get rid of the fake page table levels.

Patch 11: Remove the fake pgd handling helpers from core code.
Patch 12: Enable KVM for 16K, now that we can support any configuration.

Applies on v4.5-rc5

Tested this series with LTP/Trinity/hackbench on VMs + host :

arm64 : with all possible PAGE_SIZE + VA_BITS for the host on real hardware(s) and FPGAs.
arm32: TC2

Suzuki K Poulose (12):
  kvm arm: Move fake PGD handling to arch specific files
  arm64: kvm: Fix {V}TCR_EL2_TG0 mask
  arm64: kvm: Cleanup VTCR_EL2/VTTBR computation
  kvm-arm: Rename kvm_pmd_huge to huge_pmd
  kvm-arm: Move kvm_pud_huge to arch specific headers
  kvm-arm: Pass kvm parameter for pagetable helpers
  kvm: arm: Introduce stage2 page table helpers
  kvm: arm64: Introduce stage2 page table helpers
  kvm-arm: Switch to kvm pagetable helpers
  kvm: arm64: Get rid of fake page table levels
  kvm-arm: Cleanup stage2 pgd handling
  arm64: kvm: Add support for 16K pages

 arch/arm/include/asm/kvm_mmu.h                |  121 ++++++++++++++---
 arch/arm/include/asm/stage2_pgtable.h         |   55 ++++++++
 arch/arm/kvm/arm.c                            |    2 +-
 arch/arm/kvm/mmu.c                            |  159 ++++++++--------------
 arch/arm64/include/asm/kvm_arm.h              |   37 +++--
 arch/arm64/include/asm/kvm_mmu.h              |  181 ++++++++++++++++---------
 arch/arm64/include/asm/stage2_pgtable-nopmd.h |   26 ++++
 arch/arm64/include/asm/stage2_pgtable-nopud.h |   23 ++++
 arch/arm64/include/asm/stage2_pgtable.h       |  134 ++++++++++++++++++
 arch/arm64/kvm/Kconfig                        |    1 -
 10 files changed, 538 insertions(+), 201 deletions(-)
 create mode 100644 arch/arm/include/asm/stage2_pgtable.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopmd.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable-nopud.h
 create mode 100644 arch/arm64/include/asm/stage2_pgtable.h

-- 
1.7.9.5
