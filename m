From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/4] arm64: KVM: set {v,}TCR_EL2 RES1 bits
Date: Sun, 13 Sep 2015 11:56:37 +0100
Message-ID: <1442141798-19191-4-git-send-email-marc.zyngier@arm.com>
References: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Suzuki Poulose <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, Alexander Spyridakis <a.spyridakis@virtualopensystems.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Currently we don't set the RES1 bits of TCR_EL2 and VTCR_EL2 when
configuring them, which could lead to unexpected behaviour when an
architectural meaning is defined for those bits.

Set the RES1 bits to avoid issues.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 7605e09..cbc5e1a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -95,6 +95,7 @@
 			 SCTLR_EL2_SA | SCTLR_EL2_I)
 
 /* TCR_EL2 Registers bits */
+#define TCR_EL2_RES1	((1 << 31) | (1 << 23))
 #define TCR_EL2_TBI	(1 << 20)
 #define TCR_EL2_PS	(7 << 16)
 #define TCR_EL2_PS_40B	(2 << 16)
@@ -106,9 +107,10 @@
 #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
 			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
 
-#define TCR_EL2_FLAGS	(TCR_EL2_PS_40B)
+#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
 
 /* VTCR_EL2 Registers bits */
+#define VTCR_EL2_RES1		(1 << 31)
 #define VTCR_EL2_PS_MASK	(7 << 16)
 #define VTCR_EL2_TG0_MASK	(1 << 14)
 #define VTCR_EL2_TG0_4K		(0 << 14)
@@ -147,7 +149,8 @@
  */
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
+				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
+				 VTCR_EL2_RES1)
 #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
 #else
 /*
@@ -158,7 +161,8 @@
  */
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
 				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
-				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
+				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
+				 VTCR_EL2_RES1)
 #define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
 #endif
 
-- 
2.1.4

