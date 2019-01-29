From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] kvm: arm64: Relax the restriction on using stage2 PUD huge mapping
Date: Tue, 29 Jan 2019 19:12:17 +0000
Message-ID: <1548789137-4446-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, cdall@kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We restrict mapping the PUD huge pages in stage2 to only when the
stage2 has 4 level page table, leaving the feature unused with
the default IPA size. But we could use it even with a 3
level page table, i.e, when the PUD level is folded into PGD,
just like the stage1. Relax the condition to allow using the
PUD huge page mappings at stage2 when it is possible.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fbdf3ac..30251e2 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1695,11 +1695,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vma_pagesize = vma_kernel_pagesize(vma);
 	/*
-	 * PUD level may not exist for a VM but PMD is guaranteed to
-	 * exist.
+	 * The stage2 has a minimum of 2 level table (For arm64 see
+	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
+	 * use PMD_SIZE huge mappings (even when the PMD is folded into PGD).
+	 * As for PUD huge maps, we must make sure that we have at least
+	 * 3 levels, i.e, PMD is not folded.
 	 */
 	if ((vma_pagesize == PMD_SIZE ||
-	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pud(kvm))) &&
+	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
 	    !force_pte) {
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 	}
-- 
2.7.4
