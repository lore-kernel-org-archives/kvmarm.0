From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 17/18] kvm: arm64: Limit the minimum number of page table
 levels
Date: Wed, 26 Sep 2018 17:32:53 +0100
Message-ID: <20180926163258.20218-18-suzuki.poulose@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 131984A1DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Sep 2018 12:34:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTWOJrl-w7L3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Sep 2018 12:34:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C1549F86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Sep 2018 12:34:14 -0400 (EDT)
In-Reply-To: <20180926163258.20218-1-suzuki.poulose@arm.com>
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
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Since we are about to remove the lower limit on the IPA size,
make sure that we do not go to 1 level page table (e.g, with
32bit IPA on 64K host with concatenation) to avoid splitting
the host PMD huge pages at stage2.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Change since v5:
 - Cosmetic changes to the comment
 - Remove unnecessary new line
---
 arch/arm64/include/asm/stage2_pgtable.h |  7 ++++++-
 arch/arm64/kvm/reset.c                  | 10 +++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index c62fe118a898..2cce769ba4c6 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -72,8 +72,13 @@
 /*
  * The number of PTRS across all concatenated stage2 tables given by the
  * number of bits resolved at the initial level.
+ * If we force more levels than necessary, we may have (stage2_pgdir_shift > IPA),
+ * in which case, stage2_pgd_ptrs will have one entry.
  */
-#define __s2_pgd_ptrs(ipa, lvls)	(1 << ((ipa) - pt_levels_pgdir_shift((lvls))))
+#define pgd_ptrs_shift(ipa, pgdir_shift)	\
+	((ipa) > (pgdir_shift) ? ((ipa) - (pgdir_shift)) : 0)
+#define __s2_pgd_ptrs(ipa, lvls)		\
+	(1 << (pgd_ptrs_shift((ipa), pt_levels_pgdir_shift(lvls))))
 #define __s2_pgd_size(ipa, lvls)	(__s2_pgd_ptrs((ipa), (lvls)) * sizeof(pgd_t))
 
 #define stage2_pgd_ptrs(kvm)		__s2_pgd_ptrs(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 96b3f50101bc..f156e45760bc 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -190,6 +190,7 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	u32 parange, phys_shift;
+	u8 lvls;
 
 	if (type)
 		return -EINVAL;
@@ -203,7 +204,14 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
 	if (phys_shift > KVM_PHYS_SHIFT)
 		phys_shift = KVM_PHYS_SHIFT;
 	vtcr |= VTCR_EL2_T0SZ(phys_shift);
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(phys_shift));
+	/*
+	 * Use a minimum 2 level page table to prevent splitting
+	 * host PMD huge pages at stage2.
+	 */
+	lvls = stage2_pgtable_levels(phys_shift);
+	if (lvls < 2)
+		lvls = 2;
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
-- 
2.19.0
