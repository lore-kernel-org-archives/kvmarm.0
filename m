From: Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 48/52] arm: KVM: Invalidate BTB on guest exit for Cortex-A12/A17
Date: Mon, 26 Feb 2018 16:20:22 +0800
Message-ID: <1519633227-29832-49-git-send-email-alex.shi@linaro.org>
References: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519633227-29832-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Russell King <linux@armlinux.org.uk>, "open list:KERNEL VIRTUAL MACHINE KVM" <kvm@vger.kernel.org>, "moderated list:KERNEL VIRTUAL
        MACHINE KVM FOR ARM" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE KVM
        FOR ARM" <kvmarm@lists.cs.columbia.edu>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

** Not yet queued for inclusion in mainline **

In order to avoid aliasing attacks against the branch predictor,
let's invalidate the BTB on guest exit. This is made complicated
by the fact that we cannot take a branch before invalidating the
BTB.

We only apply this to A12 and A17, which are the only two ARM
cores on which this useful.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Alex Shi <alex.shi@linaro.org>

Conflicts:
	no hvc stub in hyp_hvc in arch/arm/kvm/hyp/hyp-entry.S
---
 arch/arm/include/asm/kvm_asm.h |  2 --
 arch/arm/include/asm/kvm_mmu.h | 18 ++++++++++-
 arch/arm/kvm/hyp/hyp-entry.S   | 71 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 8ef0538..24f3ec7 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -61,8 +61,6 @@ struct kvm_vcpu;
 extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
-extern char __kvm_hyp_vector[];
-
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index d10e362..2887129 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -37,6 +37,7 @@
 
 #include <linux/highmem.h>
 #include <asm/cacheflush.h>
+#include <asm/cputype.h>
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
 
@@ -225,7 +226,22 @@ static inline unsigned int kvm_get_vmid_bits(void)
 
 static inline void *kvm_get_hyp_vector(void)
 {
-	return kvm_ksym_ref(__kvm_hyp_vector);
+	switch(read_cpuid_part()) {
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	case ARM_CPU_PART_CORTEX_A12:
+	case ARM_CPU_PART_CORTEX_A17:
+	{
+		extern char __kvm_hyp_vector_bp_inv[];
+		return kvm_ksym_ref(__kvm_hyp_vector_bp_inv);
+	}
+
+#endif
+	default:
+	{
+		extern char __kvm_hyp_vector[];
+		return kvm_ksym_ref(__kvm_hyp_vector);
+	}
+	}
 }
 
 static inline int kvm_map_vectors(void)
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 96beb53..b6b8cb1 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -71,6 +71,66 @@ __kvm_hyp_vector:
 	W(b)	hyp_irq
 	W(b)	hyp_fiq
 
+#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
+	.align 5
+__kvm_hyp_vector_bp_inv:
+	.global __kvm_hyp_vector_bp_inv
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
+	mcr	p15, 0, r0, c7, c5, 6	/* BPIALL */
+	isb
+
+#ifdef CONFIG_THUMB2_KERNEL
+	/*
+	 * Yet another silly hack: Use VPIDR as a temp register.
+	 * Thumb2 is really a pain, as SP cannot be used with most
+	 * of the bitwise instructions. The vect_br macro ensures
+	 * things gets cleaned-up.
+	 */
+	mcr	p15, 4, r0, c0, c0, 0	/* VPIDR */
+	mov	r0, sp
+	and	r0, r0, #7
+	sub	sp, sp, r0
+	push	{r1, r2}
+	mov	r1, r0
+	mrc	p15, 4, r0, c0, c0, 0	/* VPIDR */
+	mrc	p15, 0, r2, c0, c0, 0	/* MIDR  */
+	mcr	p15, 4, r2, c0, c0, 0	/* VPIDR */
+#endif
+
+.macro vect_br val, targ
+ARM(	eor	sp, sp, #\val	)
+ARM(	tst	sp, #7		)
+ARM(	eorne	sp, sp, #\val	)
+
+THUMB(	cmp	r1, #\val	)
+THUMB(	popeq	{r1, r2}	)
+
+	beq	\targ
+.endm
+
+	vect_br	0, hyp_fiq
+	vect_br	1, hyp_irq
+	vect_br	2, hyp_hvc
+	vect_br	3, hyp_dabt
+	vect_br	4, hyp_pabt
+	vect_br	5, hyp_svc
+	vect_br	6, hyp_undef
+	vect_br	7, hyp_reset
+#endif
+
 .macro invalid_vector label, cause
 	.align
 \label:	mov	r0, #\cause
@@ -131,7 +191,14 @@ hyp_hvc:
 	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
 	beq	1f
 
-	push	{lr}
+	/*
+	 * Pushing r2 here is just a way of keeping the stack aligned to
+	 * 8 bytes on any path that can trigger a HYP exception. Here,
+	 * we may well be about to jump into the guest, and the guest
+	 * exit would otherwise be badly decoded by our fancy
+	 * "decode-exception-without-a-branch" code...
+	 */
+	push    {r2, lr}
 
 	mov	lr, r0
 	mov	r0, r1
@@ -141,7 +208,7 @@ hyp_hvc:
 THUMB(	orr	lr, #1)
 	blx	lr			@ Call the HYP function
 
-	pop	{lr}
+	pop	{r2, lr}
 1:	eret
 
 guest_trap:
-- 
2.7.4
