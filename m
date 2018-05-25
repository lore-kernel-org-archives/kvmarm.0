From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 11/15] ARM: KVM: invalidate BTB on guest exit for
 Cortex-A12/A17
Date: Fri, 25 May 2018 15:01:19 +0100
Message-ID: <E1fMDHT-00073l-3b@rmk-PC.armlinux.org.uk>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180525135938.GE17671@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

In order to avoid aliasing attacks against the branch predictor,
let's invalidate the BTB on guest exit. This is made complicated
by the fact that we cannot take a branch before invalidating the
BTB.

We only apply this to A12 and A17, which are the only two ARM
cores on which this useful.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/include/asm/kvm_asm.h |  2 --
 arch/arm/include/asm/kvm_mmu.h | 17 +++++++++-
 arch/arm/kvm/hyp/hyp-entry.S   | 71 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 36dd2962a42d..df24ed48977d 100644
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
index de1b919404e4..d08ce9c41df4 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -297,7 +297,22 @@ static inline unsigned int kvm_get_vmid_bits(void)
 
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
index 95a2faefc070..e789f52a5129 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -71,6 +71,66 @@
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
@@ -149,7 +209,14 @@ ENDPROC(__hyp_do_panic)
 	bx	ip
 
 1:
-	push	{lr}
+	/*
+	 * Pushing r2 here is just a way of keeping the stack aligned to
+	 * 8 bytes on any path that can trigger a HYP exception. Here,
+	 * we may well be about to jump into the guest, and the guest
+	 * exit would otherwise be badly decoded by our fancy
+	 * "decode-exception-without-a-branch" code...
+	 */
+	push	{r2, lr}
 
 	mov	lr, r0
 	mov	r0, r1
@@ -159,7 +226,7 @@ ENDPROC(__hyp_do_panic)
 THUMB(	orr	lr, #1)
 	blx	lr			@ Call the HYP function
 
-	pop	{lr}
+	pop	{r2, lr}
 	eret
 
 guest_trap:
-- 
2.7.4
