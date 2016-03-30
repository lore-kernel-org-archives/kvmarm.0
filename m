From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] arm64: kvm: 4.6-rc1: Fix VTCR_EL2 VS setting
Date: Wed, 30 Mar 2016 14:33:59 +0100
Message-ID: <1459344839-14397-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

When we detect support for 16bit VMID in ID_AA64MMFR1, we set the
VTCR_EL2_VS field to 1 to make use of 16bit vmids. But, with
commit 3a3604bc5eb4 ("arm64: KVM: Switch to C-based stage2 init")
this is broken and we corrupt VTCR_EL2:T0SZ instead of updating the VS
field. VTCR_EL2_VS was actually defined to the field shift (19) and
not the real value for VS. This patch fixes the issue.

Fixes: commit 3a3604bc5eb4 ("arm64: KVM: Switch to C-based stage2 init")
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |    4 +++-
 arch/arm64/include/asm/sysreg.h  |    3 +++
 arch/arm64/kvm/hyp/s2-setup.c    |    6 ++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 0e391db..4150fd8 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -124,7 +124,9 @@
 #define VTCR_EL2_SL0_LVL1	(1 << 6)
 #define VTCR_EL2_T0SZ_MASK	0x3f
 #define VTCR_EL2_T0SZ_40B	24
-#define VTCR_EL2_VS		19
+#define VTCR_EL2_VS_SHIFT	19
+#define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
+#define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
 
 /*
  * We configure the Stage-2 page tables to always restrict the IPA space to be
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1a78d6e..1287416 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -141,6 +141,9 @@
 #define ID_AA64MMFR1_VMIDBITS_SHIFT	4
 #define ID_AA64MMFR1_HADBS_SHIFT	0
 
+#define ID_AA64MMFR1_VMIDBITS_8		0
+#define ID_AA64MMFR1_VMIDBITS_16	2
+
 /* id_aa64mmfr2 */
 #define ID_AA64MMFR2_UAO_SHIFT		4
 
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index bfc54fd..5a9f3bf 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -36,8 +36,10 @@ void __hyp_text __init_stage2_translation(void)
 	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS
 	 * bit in VTCR_EL2.
 	 */
-	tmp = (read_sysreg(id_aa64mmfr1_el1) >> 4) & 0xf;
-	val |= (tmp == 2) ? VTCR_EL2_VS : 0;
+	tmp = (read_sysreg(id_aa64mmfr1_el1) >> ID_AA64MMFR1_VMIDBITS_SHIFT) & 0xf;
+	val |= (tmp == ID_AA64MMFR1_VMIDBITS_16) ?
+			VTCR_EL2_VS_16BIT :
+			VTCR_EL2_VS_8BIT;
 
 	write_sysreg(val, vtcr_el2);
 }
-- 
1.7.9.5

