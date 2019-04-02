From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa backed by THP
Date: Tue,  2 Apr 2019 12:06:16 +0100
Message-ID: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, eric.auger@redhat.com, Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Chirstoffer Dall <christoffer.dall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Zheng Xiang <zhengxiang9@huawei.com>
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
Tested-by: Eric Auger <eric.auger@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..4a22f5b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1412,7 +1412,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 		 * page accordingly.
 		 */
 		mask = PTRS_PER_PMD - 1;
-		VM_BUG_ON((gfn & mask) != (pfn & mask));
+		/* Skip memslots with unaligned IPA and user address */
+		if ((gfn & mask) != (pfn & mask))
+			return false;
 		if (pfn & mask) {
 			*ipap &= PMD_MASK;
 			kvm_release_pfn_clean(pfn);
-- 
2.7.4
