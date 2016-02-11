From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] arm64: KVM: Configure TCR_EL2.PS at runtime
Date: Thu, 11 Feb 2016 15:59:46 +0000
Message-ID: <1455206386-24997-3-git-send-email-marc.zyngier@arm.com>
References: <1455206386-24997-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455206386-24997-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Cosmin Gorgovan <cosmin@linux-geek.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>

Setting TCR_EL2.PS to 40 bits is wrong on systems with less that
less than 40 bits of physical addresses. and breaks KVM on systems
where the RAM is above 40 bits.

This patch uses ID_AA64MMFR0_EL1.PARange to set TCR_EL2.PS dynamically,
just like we already do for VTCR_EL2.PS.

[Marc: rewrote commit message, patch tidy up]

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  2 --
 arch/arm64/kvm/hyp-init.S        | 12 +++++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index bef6e92..d201d4b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -107,8 +107,6 @@
 #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
 			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
 
-#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
-
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_RES1		(1 << 31)
 #define VTCR_EL2_PS_MASK	(7 << 16)
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3e568dc..d073b5a 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -64,7 +64,7 @@ __do_hyp_init:
 	mrs	x4, tcr_el1
 	ldr	x5, =TCR_EL2_MASK
 	and	x4, x4, x5
-	ldr	x5, =TCR_EL2_FLAGS
+	mov	x5, #TCR_EL2_RES1
 	orr	x4, x4, x5
 
 #ifndef CONFIG_ARM64_VA_BITS_48
@@ -85,15 +85,17 @@ __do_hyp_init:
 	ldr_l	x5, idmap_t0sz
 	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 #endif
-	msr	tcr_el2, x4
-
-	ldr	x4, =VTCR_EL2_FLAGS
 	/*
 	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
-	 * VTCR_EL2.
+	 * TCR_EL2 and VTCR_EL2.
 	 */
 	mrs	x5, ID_AA64MMFR0_EL1
 	bfi	x4, x5, #16, #3
+
+	msr	tcr_el2, x4
+
+	ldr	x4, =VTCR_EL2_FLAGS
+	bfi	x4, x5, #16, #3
 	/*
 	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
 	 * VTCR_EL2.
-- 
2.1.4

