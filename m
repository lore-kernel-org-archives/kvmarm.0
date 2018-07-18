From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 18/20] kvm: arm64: Limit the minimum number of page table
 levels
Date: Wed, 18 Jul 2018 10:19:01 +0100
Message-ID: <1531905547-25478-19-git-send-email-suzuki.poulose@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57E2149E14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:07:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30f5o9uC37VZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Jul 2018 05:07:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 462E049F86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:07:09 -0400 (EDT)
In-Reply-To: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Since we are about to remove the lower limit on the IPA size,
make sure that we do not go to 1 level page table (e.g, with
32bit IPA on 64K host with concatenation) to avoid splitting
the host PMD huge pages at stage2.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/stage2_pgtable.h |  8 +++++++-
 arch/arm64/kvm/guest.c                  | 10 +++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 1d7d3d7..6743b76 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -72,8 +72,14 @@
 /*
  * The number of PTRS across all concatenated stage2 tables given by the
  * number of bits resolved at the initial level.
+ * If we force more number of levels than necessary, we may have
+ * stage2_pgdir_shift > IPA, in which case, stage2_pgd_ptrs will have
+ * one entry.
  */
-#define __s2_pgd_ptrs(ipa, lvls)	(1 << ((ipa) - pt_levels_pgdir_shift((lvls))))
+#define pgd_ptrs_shift(ipa, pgdir_shift)	\
+	((ipa) > (pgdir_shift) ? ((ipa) - (pgdir_shift)) : 0)
+#define __s2_pgd_ptrs(ipa, lvls)		\
+	(1 << (pgd_ptrs_shift((ipa), pt_levels_pgdir_shift(lvls))))
 #define __s2_pgd_size(ipa, lvls)	(__s2_pgd_ptrs((ipa), (lvls)) * sizeof(pgd_t))
 
 #define stage2_pgd_ptrs(kvm)		__s2_pgd_ptrs(kvm_phys_shift(kvm), kvm_stage2_levels(kvm))
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index af5520d..142e610 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -473,10 +473,18 @@ int kvm_arm_config_vm(struct kvm *kvm, u32 ipa_shift)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	u64 parange;
+	u8 lvls = stage2_pgtable_levels(ipa_shift);
 
 	if (ipa_shift != KVM_PHYS_SHIFT)
 		return -EINVAL;
 
+	/*
+	 * Use a minimum 2 level page table to prevent splitting
+	 * host PMD huge pages at stage2.
+	 */
+	if (lvls < 2)
+		lvls = 2;
+
 	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
 	if (parange > ID_AA64MMFR0_PARANGE_MAX)
 		parange = ID_AA64MMFR0_PARANGE_MAX;
@@ -494,7 +502,7 @@ int kvm_arm_config_vm(struct kvm *kvm, u32 ipa_shift)
 		VTCR_EL2_VS_16BIT :
 		VTCR_EL2_VS_8BIT;
 
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(stage2_pgtable_levels(ipa_shift));
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 	vtcr |= VTCR_EL2_T0SZ(ipa_shift);
 
 	kvm->arch.vtcr = vtcr;
-- 
2.7.4
