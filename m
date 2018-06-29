From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 08/20] kvm: arm/arm64: Abstract stage2 pgd table allocation
Date: Fri, 29 Jun 2018 12:15:28 +0100
Message-ID: <1530270944-11351-9-git-send-email-suzuki.poulose@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Abstract the allocation of stage2 entry level tables for
given VM, so that later we can choose to fall back to the
normal page table levels (i.e, avoid entry level table
concatenation) on arm64.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since V2:
 - New patch
---
 arch/arm/include/asm/kvm_mmu.h   | 6 ++++++
 arch/arm64/include/asm/kvm_mmu.h | 6 ++++++
 virt/kvm/arm/mmu.c               | 2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index f36eb20..b2da5a4 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -372,6 +372,12 @@ static inline int hyp_map_aux_data(void)
 	return 0;
 }
 
+static inline void *stage2_alloc_pgd(struct kvm *kvm)
+{
+	return alloc_pages_exact(stage2_pgd_size(kvm),
+				 GFP_KERNEL | __GFP_ZERO);
+}
+
 #define kvm_phys_to_vttbr(addr)		(addr)
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5da8f52..dbaf513 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -501,5 +501,11 @@ static inline int hyp_map_aux_data(void)
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
 
+static inline void *stage2_alloc_pgd(struct kvm *kvm)
+{
+	return alloc_pages_exact(stage2_pgd_size(kvm),
+				 GFP_KERNEL | __GFP_ZERO);
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 82dd571..a339e00 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -868,7 +868,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	}
 
 	/* Allocate the HW PGD, making sure that each page gets its own refcount */
-	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
+	pgd = stage2_alloc_pgd(kvm);
 	if (!pgd)
 		return -ENOMEM;
 
-- 
2.7.4
