From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 05/13] arm64: KVM: VHE: macroize VTCR_EL2 setup
Date: Wed,  8 Jul 2015 17:19:08 +0100
Message-ID: <1436372356-30410-6-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBBB558128
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vyviP3ABjzvh for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:08:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57293580D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:02 -0400 (EDT)
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On a VHE-capable system, there is no point in setting VTCR_EL2
at KVM init time. We can perfectly set it up when the kernel
boots, removing the need for a more complicated configuration.

In order to allow this, turn VTCR_EL2 setup into a macro that
we'll be able to reuse at boot time.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 14 ++++++++++++++
 arch/arm64/kvm/hyp-init.S        |  9 +--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6150567..b525cd2 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -55,6 +55,20 @@
 
 #ifdef __ASSEMBLY__
 
+#include <asm/kvm_arm.h>
+
+.macro setup_vtcr tmp1, tmp2
+	mov	\tmp1, #(VTCR_EL2_FLAGS & 0xffff)
+	movk	\tmp1, #(VTCR_EL2_FLAGS >> 16), lsl #16
+	/*
+	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
+	 * VTCR_EL2.
+	 */
+	mrs	\tmp2, id_aa64mmfr0_el1
+	bfi	\tmp1, \tmp2, #16, #3
+	msr	vtcr_el2, \tmp1
+	isb
+.endm
 /*
  * Convert a kernel VA into a HYP VA.
  * reg: VA to be converted.
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 178ba22..4143e2c 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -87,14 +87,7 @@ __do_hyp_init:
 #endif
 	msr	tcr_el2, x4
 
-	ldr	x4, =VTCR_EL2_FLAGS
-	/*
-	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
-	 * VTCR_EL2.
-	 */
-	mrs	x5, ID_AA64MMFR0_EL1
-	bfi	x4, x5, #16, #3
-	msr	vtcr_el2, x4
+	setup_vtcr x4, x5
 
 	mrs	x4, mair_el1
 	msr	mair_el2, x4
-- 
2.1.4
