From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v7 0/9] KVM: Support PUD hugepages at stage 2
Date: Mon, 24 Sep 2018 18:45:43 +0100
Message-ID: <20180924174552.8387-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series is an update to the PUD hugepage support previously posted
at [0]. This patchset adds support for PUD hugepages at stage 2 a
feature that is useful on cores that have support for large sized TLB
mappings (e.g., 1GB for 4K granule).

This version fixes two bugs -

* Corrects stage 2 fault handling for unsupported hugepage sizes (new
  patch 1/9). This is a long standing bug and needs backporting to
  earlier kernels

* Ensures that multiple vcpus faulting on the same hugepage doesn't
  hamper forward progress (patch 9)

The patches are based on dynamic IPA support which could lead to a
situation where the guest doesn't have PUD level. In this case, the
patches have been updated to fallback to the PTE level mappings at
stage 2.

The patches have been tested on AMD Seattle system with the following
hugepage sizes - 64K, 32M, 1G.

Thanks,
Punit

v6 -> v7

* Restrict thp check to exclude hugetlbfs pages - Patch 1
* Don't update PUD entry if there's no change - Patch 9
* Add check for PUD level in stage 2 - Patch 9

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

[0] https://www.spinics.net/lists/kvm-arm/msg32241.html
[1] https://www.spinics.net/lists/kvm-arm/msg32641.html


Punit Agrawal (9):
  KVM: arm/arm64: Ensure only THP is candidate for adjustment
  KVM: arm/arm64: Share common code in user_mem_abort()
  KVM: arm/arm64: Re-factor setting the Stage 2 entry to exec on fault
  KVM: arm/arm64: Introduce helpers to manipulate page table entries
  KVM: arm64: Support dirty page tracking for PUD hugepages
  KVM: arm64: Support PUD hugepage in stage2_is_exec()
  KVM: arm64: Support handling access faults for PUD hugepages
  KVM: arm64: Update age handlers to support PUD hugepages
  KVM: arm64: Add support for creating PUD hugepages at stage 2

 arch/arm/include/asm/kvm_mmu.h         |  61 +++++
 arch/arm64/include/asm/kvm_mmu.h       |  48 ++++
 arch/arm64/include/asm/pgtable-hwdef.h |   4 +
 arch/arm64/include/asm/pgtable.h       |   9 +
 virt/kvm/arm/mmu.c                     | 324 +++++++++++++++++++------
 5 files changed, 368 insertions(+), 78 deletions(-)

-- 
2.18.0
