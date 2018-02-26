From: Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 51/52] arm: KVM: Invalidate icache on guest exit for Cortex-A15
Date: Mon, 26 Feb 2018 16:20:25 +0800
Message-ID: <1519633227-29832-52-git-send-email-alex.shi@linaro.org>
References: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>, "moderated list:KERNEL VIRTUAL
        MACHINE KVM FOR ARM" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE KVM
        FOR ARM" <kvmarm@lists.cs.columbia.edu>, "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

** Not yet queued for inclusion in mainline **

In order to avoid aliasing attacks against the branch predictor
on Cortex-A15, let's invalidate the BTB on guest exit, which can
only be done by invalidating the icache (with ACTLR[0] being set).

We use the same hack as for A12/A17 to perform the vector decoding.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h |  5 +++++
 arch/arm/kvm/hyp/hyp-entry.S   | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 2887129..a602467 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -235,6 +235,11 @@ static inline void *kvm_get_hyp_vector(void)
 		return kvm_ksym_ref(__kvm_hyp_vector_bp_inv);
 	}
 
+	case ARM_CPU_PART_CORTEX_A15:
+	{
+		extern char __kvm_hyp_vector_ic_inv[];
+		return kvm_ksym_ref(__kvm_hyp_vector_ic_inv);
+	}
 #endif
 	default:
 	{
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index b6b8cb1..4492768 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -73,6 +73,28 @@ __kvm_hyp_vector:
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	.align 5
+__kvm_hyp_vector_ic_inv:
+	.global __kvm_hyp_vector_ic_inv
+
+	/*
+	 * We encode the exception entry in the bottom 3 bits of
+	 * SP, and we have to guarantee to be 8 bytes aligned.
+	 */
+	W(add)	sp, sp, #1	/* Reset 	  7 */
+	W(add)	sp, sp, #1	/* Undef	  6 */
+	W(add)	sp, sp, #1	/* Syscall	  5 */
+	W(add)	sp, sp, #1	/* Prefetch abort 4 */
+	W(add)	sp, sp, #1	/* Data abort	  3 */
+	W(add)	sp, sp, #1	/* HVC		  2 */
+	W(add)	sp, sp, #1	/* IRQ		  1 */
+	W(nop)			/* FIQ		  0 */
+
+	mcr	p15, 0, r0, c7, c5, 0	/* ICIALLU */
+	isb
+
+	b	decode_vectors
+
+	.align 5
 __kvm_hyp_vector_bp_inv:
 	.global __kvm_hyp_vector_bp_inv
 
@@ -92,6 +114,8 @@ __kvm_hyp_vector_bp_inv:
 	mcr	p15, 0, r0, c7, c5, 6	/* BPIALL */
 	isb
 
+decode_vectors:
+
 #ifdef CONFIG_THUMB2_KERNEL
 	/*
 	 * Yet another silly hack: Use VPIDR as a temp register.
-- 
2.7.4
