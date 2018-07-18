From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 13/20] kvm: arm64: Configure VTCR_EL2.SL0 per VM
Date: Wed, 18 Jul 2018 10:18:56 +0100
Message-ID: <1531905547-25478-14-git-send-email-suzuki.poulose@arm.com>
References: <1531905547-25478-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65AFF4A106
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:06:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fnr2KANg76Uz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Jul 2018 05:06:56 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 159A74A0FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Jul 2018 05:06:56 -0400 (EDT)
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
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Christoffer Dall <cdall@arm.com>, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VTCR_EL2 holds the following key stage2 translation table
parameters:
  SL0  - Entry level in the page table lookup.
  T0SZ - Denotes the size of the memory addressed by the table.

We have been using fixed values for the SL0 depending on the
page size as we have a fixed IPA size. But since we are about
to make it dynamic, we need to calculate the SL0 at runtime
per VM. This patch adds a helper to compute the value of SL0
for a VM based on the IPA size.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v3:
 - Update reference to latest ARM ARM.
 - Update per-vm VTCR value of SL0.
 - Add helpers to decode levels from SL0.
 - Didn't pick up Reviewed-by tag from Eric, as there
   are some new changes in this version
---
 arch/arm64/include/asm/kvm_arm.h | 51 +++++++++++++++++++++++++++++++---------
 arch/arm64/kvm/guest.c           |  2 ++
 2 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 66cf1df..abc7107 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -120,7 +120,6 @@
 #define VTCR_EL2_IRGN0_WBWA	TCR_IRGN0_WBWA
 #define VTCR_EL2_SL0_SHIFT	6
 #define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
-#define VTCR_EL2_SL0_LVL1	(1 << VTCR_EL2_SL0_SHIFT)
 #define VTCR_EL2_T0SZ_MASK	0x3f
 #define VTCR_EL2_VS_SHIFT	19
 #define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
@@ -147,29 +146,59 @@
 /*
  * Stage2 translation configuration:
  * 64kB pages (TG0 = 1)
- * 2 level page tables (SL = 1)
  */
-#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		38
+#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_64K
+#define VTCR_EL2_TGRAN_SL0_BASE		3UL
+
 #elif defined(CONFIG_ARM64_16K_PAGES)
 /*
  * Stage2 translation configuration:
  * 16kB pages (TG0 = 2)
- * 2 level page tables (SL = 1)
  */
-#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		42
+#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_16K
+#define VTCR_EL2_TGRAN_SL0_BASE		3UL
 #else	/* 4K */
 /*
  * Stage2 translation configuration:
  * 4kB pages (TG0 = 0)
- * 3 level page tables (SL = 1)
  */
-#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		37
+#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_4K
+#define VTCR_EL2_TGRAN_SL0_BASE		2UL
 #endif
 
-#define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN_FLAGS)
+#define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
+/*
+ * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
+ * Interestingly, it depends on the page size.
+ * See D.10.2.121, VTCR_EL2, in ARM DDI 0487C.a
+ *
+ *	-----------------------------------------
+ *	| Entry level		|  4K  | 16K/64K |
+ *	------------------------------------------
+ *	| Level: 0		|  2   |   -     |
+ *	------------------------------------------
+ *	| Level: 1		|  1   |   2     |
+ *	------------------------------------------
+ *	| Level: 2		|  0   |   1     |
+ *	------------------------------------------
+ *	| Level: 3		|  -   |   0     |
+ *	------------------------------------------
+ *
+ * That table roughly translates to :
+ *
+ *	SL0(PAGE_SIZE, Entry_level) = SL0_BASE(PAGE_SIZE) - Entry_Level
+ *
+ * Where SL0_BASE(4K) = 2 and SL0_BASE(16K) = 3, SL0_BASE(64K) = 3, provided
+ * we take care of ruling out the unsupported cases and
+ * Entry_Level = 4 - Number_of_levels.
+ *
+ */
+#define VTCR_EL2_LVLS_TO_SL0(levels)	\
+	((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
+#define VTCR_EL2_SL0_TO_LVLS(sl0)	\
+	((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
+#define VTCR_EL2_LVLS(vtcr)		\
+	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
 /*
  * ARM VMSAv8-64 defines an algorithm for finding the translation table
  * descriptors in section D4.2.8 in ARM DDI 0487C.a.
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d24ee23..f7e1ece 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -491,6 +491,8 @@ int kvm_arm_config_vm(struct kvm *kvm)
 	vtcr |= (kvm_get_vmid_bits() == 16) ?
 		VTCR_EL2_VS_16BIT :
 		VTCR_EL2_VS_8BIT;
+
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(kvm_stage2_levels(kvm));
 	kvm->arch.vtcr = vtcr;
 	return 0;
 }
-- 
2.7.4
