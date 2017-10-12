From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 01/37] KVM: arm64: Avoid storing the vcpu pointer on the stack
Date: Thu, 12 Oct 2017 12:41:05 +0200
Message-ID: <20171012104141.26902-2-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We already have the percpu area for the host cpu state, which points to
the VCPU, so there's no need to store the VCPU pointer on the stack on
every context switch.  We can be a little more clever and just use
tpidr_el2 for the percpu offset and load the VCPU pointer from the host
context.

This requires us to have a scratch register though, so we take the
chance to rearrange some of the el1_sync code to only look at the
vttbr_el2 to determine if this is a trap from the guest or an HVC from
the host.  We do add an extra check to call the panic code if the kernel
is configured with debugging enabled and we saw a trap from the host
which wasn't an HVC, indicating that we left some EL2 trap configured by
mistake.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h | 20 ++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c  |  1 +
 arch/arm64/kvm/hyp/entry.S       |  5 +----
 arch/arm64/kvm/hyp/hyp-entry.S   | 39 ++++++++++++++++++---------------------
 arch/arm64/kvm/hyp/switch.c      |  2 +-
 5 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ab4d0a9..7e48a39 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,4 +70,24 @@ extern u32 __init_stage2_translation(void);
 
 #endif
 
+#ifdef __ASSEMBLY__
+.macro get_host_ctxt reg, tmp
+	/*
+	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
+	 * not be accessible by this address from EL2, hyp_panic() converts
+	 * it with kern_hyp_va() before use.
+	 */
+	ldr	\reg, =kvm_host_cpu_state
+	mrs	\tmp, tpidr_el2
+	add	\reg, \reg, \tmp
+	kern_hyp_va \reg
+.endm
+
+.macro get_vcpu vcpu, ctxt
+	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	kern_hyp_va	\vcpu
+.endm
+
+#endif
+
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 71bf088..612021d 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -135,6 +135,7 @@ int main(void)
   DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
   DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
+  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 9a8ab5d..76cd48f 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -62,9 +62,6 @@ ENTRY(__guest_enter)
 	// Store the host regs
 	save_callee_saved_regs x1
 
-	// Store host_ctxt and vcpu for use at exit time
-	stp	x1, x0, [sp, #-16]!
-
 	add	x18, x0, #VCPU_CONTEXT
 
 	// Restore guest regs x0-x17
@@ -119,7 +116,7 @@ ENTRY(__guest_exit)
 	save_callee_saved_regs x1
 
 	// Restore the host_ctxt from the stack
-	ldr	x2, [sp], #16
+	get_host_ctxt	x2, x3
 
 	// Now restore the host regs
 	restore_callee_saved_regs x2
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index e4f37b9..2950f26 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -56,19 +56,16 @@ ENDPROC(__vhe_hyp_call)
 el1_sync:				// Guest trapped into EL2
 	stp	x0, x1, [sp, #-16]!
 
-alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	mrs	x1, esr_el2
-alternative_else
-	mrs	x1, esr_el1
-alternative_endif
-	lsr	x0, x1, #ESR_ELx_EC_SHIFT
-
-	cmp	x0, #ESR_ELx_EC_HVC64
-	b.ne	el1_trap
-
 	mrs	x1, vttbr_el2		// If vttbr is valid, the 64bit guest
 	cbnz	x1, el1_trap		// called HVC
 
+#ifdef CONFIG_DEBUG
+	mrs	x0, esr_el2
+	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	cmp     x0, #ESR_ELx_EC_HVC64
+	b.ne    __hyp_panic
+#endif
+
 	/* Here, we're pretty sure the host called HVC. */
 	ldp	x0, x1, [sp], #16
 
@@ -101,10 +98,15 @@ alternative_endif
 	eret
 
 el1_trap:
+	get_host_ctxt	x0, x1
+	get_vcpu	x1, x0
+
+	mrs		x0, esr_el2
+	lsr		x0, x0, #ESR_ELx_EC_SHIFT
 	/*
 	 * x0: ESR_EC
+	 * x1: vcpu pointer
 	 */
-	ldr	x1, [sp, #16 + 8]	// vcpu stored by __guest_enter
 
 	/*
 	 * We trap the first access to the FP/SIMD to save the host context
@@ -122,13 +124,15 @@ alternative_else_nop_endif
 
 el1_irq:
 	stp     x0, x1, [sp, #-16]!
-	ldr	x1, [sp, #16 + 8]
+	get_host_ctxt	x0, x1
+	get_vcpu	x1, x0
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
 	stp     x0, x1, [sp, #-16]!
-	ldr	x1, [sp, #16 + 8]
+	get_host_ctxt	x0, x1
+	get_vcpu	x1, x0
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
@@ -164,14 +168,7 @@ ENTRY(__hyp_do_panic)
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-	/*
-	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
-	 * not be accessible by this address from EL2, hyp_panic() converts
-	 * it with kern_hyp_va() before use.
-	 */
-	ldr	x0, =kvm_host_cpu_state
-	mrs	x1, tpidr_el2
-	add	x0, x0, x1
+	get_host_ctxt x0, x1
 	b	hyp_panic
 ENDPROC(__hyp_panic)
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 69ef24a..a0123ad 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -435,7 +435,7 @@ void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt)
 	if (read_sysreg(vttbr_el2)) {
 		struct kvm_cpu_context *host_ctxt;
 
-		host_ctxt = kern_hyp_va(__host_ctxt);
+		host_ctxt = __host_ctxt;
 		vcpu = host_ctxt->__hyp_running_vcpu;
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
-- 
2.9.0
