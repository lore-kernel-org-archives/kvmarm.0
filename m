From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/28] KVM: arm64: Clarify explanation of STAGE2_PGTABLE_LEVELS
Date: Wed, 19 Dec 2018 18:03:36 +0000
Message-ID: <20181219180349.242681-16-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 373884A380
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id stS4Fmi0Hw2C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31ED4A369
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:51 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

In attempting to re-construct the logic for our stage 2 page table
layout I found the reasoning in the comment explaining how we calculate
the number of levels used for stage 2 page tables a bit backwards.

This commit attempts to clarify the comment, to make it slightly easier
to read without having the Arm ARM open on the right page.

While we're at it, fixup a typo in a comment that was recently changed.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/stage2_pgtable.h | 16 +++++++---------
 virt/kvm/arm/mmu.c                      |  2 +-
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index d352f6df8d2c..5412fa40825e 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -30,16 +30,14 @@
 #define pt_levels_pgdir_shift(lvls)	ARM64_HW_PGTABLE_LEVEL_SHIFT(4 - (lvls))
 
 /*
- * The hardware supports concatenation of up to 16 tables at stage2 entry level
- * and we use the feature whenever possible.
+ * The hardware supports concatenation of up to 16 tables at stage2 entry
+ * level and we use the feature whenever possible, which means we resolve 4
+ * additional bits of address at the entry level.
  *
- * Now, the minimum number of bits resolved at any level is (PAGE_SHIFT - 3).
- * On arm64, the smallest PAGE_SIZE supported is 4k, which means
- *             (PAGE_SHIFT - 3) > 4 holds for all page sizes.
- * This implies, the total number of page table levels at stage2 expected
- * by the hardware is actually the number of levels required for (IPA_SHIFT - 4)
- * in normal translations(e.g, stage1), since we cannot have another level in
- * the range (IPA_SHIFT, IPA_SHIFT - 4).
+ * This implies, the total number of page table levels required for
+ * IPA_SHIFT at stage2 expected by the hardware can be calculated using
+ * the same logic used for the (non-collapsable) stage1 page tables but for
+ * (IPA_SHIFT - 4).
  */
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
 #define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 2dcff38868d4..f605514395a1 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1356,7 +1356,7 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 	struct page *page = pfn_to_page(pfn);
 
 	/*
-	 * PageTransCompoungMap() returns true for THP and
+	 * PageTransCompoundMap() returns true for THP and
 	 * hugetlbfs. Make sure the adjustment is done only for THP
 	 * pages.
 	 */
-- 
2.19.2
