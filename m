From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 12/12] arm64: kvm: Add support for 16K pages
Date: Mon, 14 Mar 2016 16:53:11 +0000
Message-ID: <1457974391-28456-13-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can handle stage-2 page tables independent
of the host page table levels, wire up the 16K page
support.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |   11 ++++++++++-
 arch/arm64/kvm/Kconfig           |    1 -
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d49dd50..aa2e1d4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -113,6 +113,7 @@
 #define VTCR_EL2_TG0_MASK	(3 << 14)
 #define VTCR_EL2_TG0_4K		(0 << 14)
 #define VTCR_EL2_TG0_64K	(1 << 14)
+#define VTCR_EL2_TG0_16K	(2 << 14)
 #define VTCR_EL2_SH0_MASK	(3 << 12)
 #define VTCR_EL2_SH0_INNER	(3 << 12)
 #define VTCR_EL2_ORGN0_MASK	(3 << 10)
@@ -134,7 +135,7 @@
  * (see hyp-init.S).
  *
  * Note that when using 4K pages, we concatenate two first level page tables
- * together.
+ * together. With 16K pages, we concatenate 16 first level page tables.
  *
  * The magic numbers used for VTTBR_X in this patch can be found in Tables
  * D4-23 and D4-25 in ARM DDI 0487A.b.
@@ -150,6 +151,14 @@
  */
 #define VTCR_EL2_TGRAN_FLAGS	(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
 #define VTTBR_X_TGRAN_MAGIC		38
+#elif defined(CONFIG_ARM64_16K_PAGES)
+/*
+ * Stage2 translation configuration:
+ * 16kB pages (TG0 = 2)
+ * 2 level page tables (SL = 1)
+ */
+#define VTCR_EL2_TGRAN_FLAGS	(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
+#define VTTBR_X_TGRAN_MAGIC	42
 #else
 /*
  * Stage2 translation configuration:
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a5272c0..e63022c 100644
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

