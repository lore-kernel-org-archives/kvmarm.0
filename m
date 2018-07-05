From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v4 0/7] KVM: Support PUD hugepages at stage 2
Date: Thu,  5 Jul 2018 15:08:43 +0100
Message-ID: <20180705140850.5801-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This series is an update to the PUD hugepage support previously posted
at [0][1][2][3]. This patchset adds support for PUD hugepages at stage
2. This feature is useful on cores that have support for large sized
TLB mappings (e.g., 1GB for 4K granule).

There are a three new patches to support PUD hugepages for execute
permission faults, access faults and handling aging of PUD page table
entries (patches 4-6). This addresses Suzuki's feedback on the
previous version.

Also, live migration didn't work with earlier versions. This has now
been addressed by updating patch 1 & 7 to ensure that hugepages are
dissolved correctly when dirty logging is enabled.

Support is added to code that is shared between arm and arm64. Dummy
helpers for arm are provided as the port does not support PUD hugepage
sizes.

The patches have been tested on an A57 based system. The patchset is
based on v4.18-rc3. The are a few conflicts with the support for 52
bit IPA[4] due to change in number of parameters for
stage2_pmd_offset().

Thanks,
Punit

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

[0] https://lkml.org/lkml/2018/5/14/907
[1] https://www.spinics.net/lists/arm-kernel/msg628053.html
[2] https://lkml.org/lkml/2018/4/20/566
[3] https://lkml.org/lkml/2018/5/1/133
[4] https://www.spinics.net/lists/kvm/msg171065.html

Punit Agrawal (7):
  KVM: arm/arm64: Share common code in user_mem_abort()
  KVM: arm/arm64: Introduce helpers to manupulate page table entries
  KVM: arm64: Support dirty page tracking for PUD hugepages
  KVM: arm64: Support PUD hugepage in stage2_is_exec()
  KVM: arm64: Support handling access faults for PUD hugepages
  KVM: arm64: Update age handlers to support PUD hugepages
  KVM: arm64: Add support for creating PUD hugepages at stage 2

 arch/arm/include/asm/kvm_mmu.h         |  60 +++++++
 arch/arm64/include/asm/kvm_mmu.h       |  47 ++++++
 arch/arm64/include/asm/pgtable-hwdef.h |   4 +
 arch/arm64/include/asm/pgtable.h       |   9 ++
 virt/kvm/arm/mmu.c                     | 214 ++++++++++++++++++++-----
 5 files changed, 291 insertions(+), 43 deletions(-)

-- 
2.17.1
