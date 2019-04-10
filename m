From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2] kvm: arm: Skip stage2 huge mappings for unaligned ipa backed by THP
Date: Wed, 10 Apr 2019 16:14:57 +0100
Message-ID: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, julien.thierry@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, andrew.murray@arm.com, eric.auger@redhat.com, zhengxiang9@huawei.com, yuzenghui@huawei.com, wanghaibin.wang@huawei.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

With commit a80868f398554842b14, we no longer ensure that the
THP page is properly aligned in the guest IPA. Skip the stage2
huge mapping for unaligned IPA backed by transparent hugepages.

Fixes: a80868f398554842b14 ("KVM: arm/arm64: Enforce PTE mappings at stage2 when needed")
Reported-by: Eric Auger <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Chirstoffer Dall <christoffer.dall@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Andrew Murray <andrew.murray@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

---
Changes since V1:
 - Zenghui Yu reported that the first version misses the boundary
   check for the end address. Lets reuse the existing helper to
   check it.
---
 virt/kvm/arm/mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..a39dcfd 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1781,8 +1781,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * Only PMD_SIZE transparent hugepages(THP) are
 		 * currently supported. This code will need to be
 		 * updated to support other THP sizes.
+		 *
+		 * Make sure the host VA and the guest IPA are sufficiently
+		 * aligned and that the block is contained within the memslot.
 		 */
-		if (transparent_hugepage_adjust(&pfn, &fault_ipa))
+		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
+		    transparent_hugepage_adjust(&pfn, &fault_ipa))
 			vma_pagesize = PMD_SIZE;
 	}
 
-- 
2.7.4
