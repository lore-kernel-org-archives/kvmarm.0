From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 17/17] arm64: kvm: Add support for 16K pages
Date: Thu, 14 Apr 2016 14:21:05 +0100
Message-ID: <1460640065-27658-18-git-send-email-suzuki.poulose@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F1849BC2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b9FJPJO+uubQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 09:20:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DF6249BAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:21 -0400 (EDT)
In-Reply-To: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can handle stage-2 page tables independent
of the host page table levels, wire up the 16K page
support.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |   13 +++++++++++--
 arch/arm64/kvm/Kconfig           |    1 -
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1281d98..c6cbb36 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -114,6 +114,7 @@
 #define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
 #define VTCR_EL2_TG0_MASK	TCR_TG0_MASK
 #define VTCR_EL2_TG0_4K		TCR_TG0_4K
+#define VTCR_EL2_TG0_16K	TCR_TG0_16K
 #define VTCR_EL2_TG0_64K	TCR_TG0_64K
 #define VTCR_EL2_SH0_MASK	TCR_SH0_MASK
 #define VTCR_EL2_SH0_INNER	TCR_SH0_INNER
@@ -139,7 +140,7 @@
  * (see hyp-init.S).
  *
  * Note that when using 4K pages, we concatenate two first level page tables
- * together.
+ * together. With 16K pages, we concatenate 16 first level page tables.
  *
  * The magic numbers used for VTTBR_X in this patch can be found in Tables
  * D4-23 and D4-25 in ARM DDI 0487A.b.
@@ -157,7 +158,15 @@
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
 #define VTTBR_X_TGRAN_MAGIC		38
-#else
+#elif defined(CONFIG_ARM64_16K_PAGES)
+/*
+ * Stage2 translation configuration:
+ * 16kB pages (TG0 = 2)
+ * 2 level page tables (SL = 1)
+ */
+#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
+#define VTTBR_X_TGRAN_MAGIC		42
+#else	/* 4K */
 /*
  * Stage2 translation configuration:
  * 4kB pages (TG0 = 0)
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index de7450d..aa2e34e 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM_ARM_VGIC_V3
 config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
-	depends on !ARM64_16K_PAGES
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
-- 
1.7.9.5
