From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 17/29] arm64: kvm: Add support for 16K pages
Date: Wed, 11 May 2016 15:30:10 +0200
Message-ID: <1462973422-10021-18-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Now that we can handle stage-2 page tables independent
of the host page table levels, wire up the 16K page
support.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 13 +++++++++++--
 arch/arm64/kvm/Kconfig           |  1 -
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
2.1.2.330.g565301e.dirty

