From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v6 0/8] KVM: Support PUD hugepages at stage 2
Date: Mon, 16 Jul 2018 12:08:49 +0100
Message-ID: <20180716110857.19310-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This series is an update to the PUD hugepage support previously posted
at [0]. This patchset adds support for PUD hugepages at stage 2 a
feature that is useful on cores that have support for large sized TLB
mappings (e.g., 1GB for 4K granule).

This version adds tags and addresses feedback received on
v5. Additionally, Patch 1 (1 & 2 in this version) has been split to
help make it easy to review.

Support is added to code that is shared between arm and arm64. Dummy
helpers for arm are provided as the port does not support PUD hugepage
sizes.

The patches have been tested on an A57 based system. The patchset is
based on v4.18-rc5. The are a few conflicts with the support for 52
bit IPA[1] - I'll work with Suzuki to resolve this once the code is in
the right shape.

Thanks,
Punit

v5 -> v6

* Split Patch 1 to move out the refactoring of exec permissions on
  page table entries.
* Patch 4 - Initialise p*dpp pointers in stage2_get_leaf_entry()
* Patch 5 - Trigger a BUG() in kvm_pud_pfn() on arm

v4 -> v5:
* Patch 1 - Drop helper stage2_should_exec() and refactor the
  condition to decide if a page table entry should be marked
  executable
* Patch 4-6 - Introduce stage2_get_leaf_entry() and use it in this and
  latter patches
* Patch 7 - Use stage 2 accessors instead of using the page table
  helpers directly
* Patch 7 - Add a note to update the PUD hugepage support when number
  of levels of stage 2 tables differs from stage 1

v3 -> v4:
* Patch 1 and 7 - Don't put down hugepages pte if logging is enabled
* Patch 4-5 - Add PUD hugepage support for exec and access faults
* Patch 6 - PUD hugepage support for aging page table entries

v2 -> v3:
* Update vma_pagesize directly if THP [1/4]. Previsouly this was done
  indirectly via hugetlb
* Added review tag [4/4]

v1 -> v2:
* Create helper to check if the page should have exec permission [1/4]
* Fix broken condition to detect THP hugepage [1/4]
* Fix in-correct hunk resulting from a rebase [4/4]

[0] https://www.spinics.net/lists/arm-kernel/msg664276.html
[1] https://www.spinics.net/lists/kvm/msg171065.html

Punit Agrawal (8):
  KVM: arm/arm64: Share common code in user_mem_abort()
  KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault
  KVM: arm/arm64: Introduce helpers to manipulate page table entries
  KVM: arm64: Support dirty page tracking for PUD hugepages
  KVM: arm64: Support PUD hugepage in stage2_is_exec()
  KVM: arm64: Support handling access faults for PUD hugepages
  KVM: arm64: Update age handlers to support PUD hugepages
  KVM: arm64: Add support for creating PUD hugepages at stage 2

 arch/arm/include/asm/kvm_mmu.h         |  61 +++++
 arch/arm64/include/asm/kvm_mmu.h       |  47 ++++
 arch/arm64/include/asm/pgtable-hwdef.h |   4 +
 arch/arm64/include/asm/pgtable.h       |   9 +
 virt/kvm/arm/mmu.c                     | 294 ++++++++++++++++++-------
 5 files changed, 341 insertions(+), 74 deletions(-)

-- 
2.17.1
