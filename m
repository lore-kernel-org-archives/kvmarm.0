From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 4/4] arm64/sve: KVM: Basic SVE support
Date: Fri, 17 Nov 2017 16:38:55 +0000
Message-ID: <1510936735-6762-5-git-send-email-Dave.Martin@arm.com>
References: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB5440651
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Nov 2017 11:36:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aPBuiO6EG60P for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Nov 2017 11:36:45 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8375E49D5F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Nov 2017 11:36:45 -0500 (EST)
In-Reply-To: <1510936735-6762-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch is a flattened bunch of hacks for adding SVE support to
KVM.  It's intended as a starting point for comments: it is not
intended to be complete or final!

** This patch has suspected bugs and has undergone minimal testing: do
not merge **

Notes:

struct kvm_vpcu_arch does not currently include space for a guest's
SVE state, so supporting SVE in guests requires some additional
space to be allocated.  Statically allocating space per-vcpu is
wasteful, especially if this allocation is based on the theoretical
future arch maximum vector length SVE_VL_MAX.

A pointer to dynamically allocated memory would require that memory
to be mapped into hyp.  Hyp mappings cannot currently be torn down
dynamically, so this would result in a mess of kernel heap memory
getting mapped into hyp over time.

This patch adopts a compromise: enough space is allocated at the
end of each kvm_vcpu to store the SVE state, sized according to the
maximum vector length supported by the hardware.  Naturally, if the
hardware does not support SVE, no extra space is allocated at all.

Context switching implemented by adding alternative SVE code at
each site where FPSIMD context is handled.  SVE is unconditionally
provided to the guest is the host supports it.  This is a bit
crude, but good enough for a proof-of-concept implementation.

ZCR_EL1 and ZCR_EL2 are added to the sys_regs list unconditionally,
which will break userspace snapshot/restore compatibility.
Possibly a more flexible approach is needed.  The inclusion of
ZCR_EL2 here is a bit odd too: this is a feature configuration
control rather than a guest register -- it is used to clamp the
maximum vector length available to the guest.  Currently it is just
set by default to correspond to the host's maximum.

Questions
---------

 * Should userspace be able to control the maximum SVE vector
   length available to the guest, and what's the most natural way
   to do it?

   For example, it would be necessary to limit the vector length to
   the lowest common denominator in order to support migration
   across a cluster where the maximum hardware vector length
   differs between nodes.

 * Combined alternatives are really awkward.  Is there any way to
   use the standard static key based features tests in hyp?

TODO
----

 * Allow userspace feature control, to choose whether to expose SVE
   to a guest.

 * Attempt to port some of the KVM entry code to C, at least for the
   __fpsimd_guest_restore stuff.  The extra complexity with SVE looks
   unsustainable.

 * Figure out ABI for exposing SVE regs via the ioctl interface.

*Bugs*
------

Currently there is nothing stopping KVM userspace from
changing the guest's ZCR_EL2 after boot via the ioctl interface:
this breaks architectural assumptions in the guest, and should
really be forbidden.  Also, this is a latent trigger for
buffer overruns, if creation of guests with limited VL is
someday permitted.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimdmacros.h |  8 +++++
 arch/arm64/include/asm/kvm_host.h     | 30 ++++++++++++++++++
 arch/arm64/include/asm/kvm_hyp.h      |  4 +++
 arch/arm64/include/asm/sysreg.h       |  1 +
 arch/arm64/kernel/asm-offsets.c       |  8 +++++
 arch/arm64/kernel/entry-fpsimd.S      |  1 -
 arch/arm64/kvm/handle_exit.c          |  2 +-
 arch/arm64/kvm/hyp/entry.S            | 60 ++++++++++++++++++++++++++++-------
 arch/arm64/kvm/hyp/fpsimd.S           | 12 +++++++
 arch/arm64/kvm/hyp/hyp-entry.S        |  7 ++++
 arch/arm64/kvm/hyp/switch.c           | 46 ++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c                | 18 +++++++++++
 arch/arm64/kvm/sys_regs.c             | 39 ++++++++++++++++-------
 virt/kvm/arm/arm.c                    | 12 +++++--
 14 files changed, 221 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index e050d76..e2124c8 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -17,6 +17,12 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#ifndef __ARM64_FPSIMDMACROS_H
+#define __ARM64_FPSIMDMACROS_H
+
+#include <asm/assembler.h>
+#include <asm/sysreg.h>
+
 .macro fpsimd_save state, tmpnr
 	stp	q0, q1, [\state, #16 * 0]
 	stp	q2, q3, [\state, #16 * 2]
@@ -223,3 +229,5 @@
 		ldr		w\nxtmp, [\xpfpsr, #4]
 		msr		fpcr, x\nxtmp
 .endm
+
+#endif /* ! __ARM64_FPSIMDMACROS_H */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 674912d..7045682 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -22,6 +22,7 @@
 #ifndef __ARM64_KVM_HOST_H__
 #define __ARM64_KVM_HOST_H__
 
+#include <linux/stddef.h>
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <asm/cpufeature.h>
@@ -29,6 +30,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmio.h>
+#include <asm/sigcontext.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -102,6 +104,8 @@ enum vcpu_sysreg {
 	SCTLR_EL1,	/* System Control Register */
 	ACTLR_EL1,	/* Auxiliary Control Register */
 	CPACR_EL1,	/* Coprocessor Access Control */
+	ZCR_EL1,	/* SVE Control */
+	ZCR_EL2,	/* SVE Control (enforced by host) */
 	TTBR0_EL1,	/* Translation Table Base Register 0 */
 	TTBR1_EL1,	/* Translation Table Base Register 1 */
 	TCR_EL1,	/* Translation Control Register */
@@ -202,6 +206,7 @@ struct kvm_vcpu_arch {
 	/* HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
+	u32 sve_ffr_offset;	/* offset of stored SVE FFR from ctxt base */
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
@@ -279,6 +284,31 @@ struct kvm_vcpu_arch {
 	bool has_run_once;
 };
 
+/*
+ * The size of SVE state is not known at compile time, so these helper
+ * macros are used to address state appended to the end of struct
+ * kvm_vcpu.
+ *
+ * There is currently no host SVE state, since a vcpu must run inside
+ * syscall context, and any cached SVE state of a second thread is
+ * explicitly flushed before vcpu entry.
+ *
+ * Similarly to the host thread_struct, the FFR image is used as an
+ * addressing origin for save restore, and FPSR and FPCR are stored in
+ * vcpu->arch.ctxt.gp_regs.fp_regs.
+ */
+#define vcpu_guest_sve_state(v)					\
+	((char *)(v) + ALIGN(sizeof(*(v)), SVE_VQ_BYTES))
+
+#define vcpu_guest_sve_size(vq)	ALIGN(SVE_SIG_REGS_SIZE(vq), SVE_VQ_BYTES)
+
+#define vcpu_guest_sve_pffr(v,vq)				\
+	(vcpu_guest_sve_state(v) +				\
+		(SVE_SIG_FFR_OFFSET(vq) - SVE_SIG_REGS_OFFSET))
+
+/* Used by arm_init() to determine the size of each vcpu, including SVE */
+size_t arch_kvm_vcpu_size(void);
+
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 #define vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
 /*
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 08d3bb6..0d666f6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -152,6 +152,10 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
+void __sve_save_state(void *state, u32 *pfpsr);
+void __sve_load_state(void const *state, u32 const *pfpsr,
+		      unsigned long vq_minus_1);
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 08cc885..710207c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -165,6 +165,7 @@
 #define SYS_CPACR_EL1			sys_reg(3, 0, 1, 0, 2)
 
 #define SYS_ZCR_EL1			sys_reg(3, 0, 1, 2, 0)
+#define SYS_ZCR_EL12			sys_reg(3, 5, 1, 2, 0)
 
 #define SYS_TTBR0_EL1			sys_reg(3, 0, 2, 0, 0)
 #define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 71bf088..554d567 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -34,6 +34,8 @@
 
 int main(void)
 {
+  struct kvm_vcpu vcpu;
+
   DEFINE(TSK_ACTIVE_MM,		offsetof(struct task_struct, active_mm));
   BLANK();
   DEFINE(TSK_TI_FLAGS,		offsetof(struct task_struct, thread_info.flags));
@@ -133,8 +135,14 @@ int main(void)
   DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
   DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
+  DEFINE(VCPU_FPSR,		offsetof(struct kvm_vcpu, arch.ctxt.gp_regs.fp_regs.fpsr));
   DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
+
+  DEFINE(VCPU_SVE_FFR_OFFSET,	offsetof(struct kvm_vcpu, arch.sve_ffr_offset));
+  DEFINE(VCPU_ZCR_EL1,		offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[ZCR_EL1]));
+  DEFINE(VCPU_ZCR_EL2,		offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[ZCR_EL2]));
+  DEFINE(VCPU_GUEST_SVE,	vcpu_guest_sve_state(&vcpu) - (char *)&vcpu);
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
diff --git a/arch/arm64/kernel/entry-fpsimd.S b/arch/arm64/kernel/entry-fpsimd.S
index 73f17bf..9e5aae0 100644
--- a/arch/arm64/kernel/entry-fpsimd.S
+++ b/arch/arm64/kernel/entry-fpsimd.S
@@ -19,7 +19,6 @@
 
 #include <linux/linkage.h>
 
-#include <asm/assembler.h>
 #include <asm/fpsimdmacros.h>
 
 /*
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b712479..39cf981 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -147,9 +147,9 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+/* Illegitimate SVE use, unhandled by the hyp entry code */
 static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	/* Until SVE is supported for guests: */
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 12ee62d..d8e8d22 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -162,37 +162,75 @@ ENTRY(__fpsimd_guest_restore)
 	stp	x2, x3, [sp, #-16]!
 	stp	x4, lr, [sp, #-16]!
 
+	mrs	x0, cptr_el2
+
+alternative_if_not ARM64_SVE
+	mov	x1, #CPTR_EL2_TFP
+	mov	x2, #CPACR_EL1_FPEN
+alternative_else
+	mov	x1, #CPTR_EL2_TFP | CPTR_EL2_TZ
+	mov	x2, #CPACR_EL1_FPEN | CPACR_EL1_ZEN
+alternative_endif
+
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	mrs	x2, cptr_el2
-	bic	x2, x2, #CPTR_EL2_TFP
-	msr	cptr_el2, x2
+	bic	x0, x0, x1
 alternative_else
-	mrs	x2, cpacr_el1
-	orr	x2, x2, #CPACR_EL1_FPEN
-	msr	cpacr_el1, x2
+	orr	x0, x0, x2
 alternative_endif
+
+	msr	cptr_el2, x0
 	isb
 
-	mrs	x3, tpidr_el2
+	mrs	x4, tpidr_el2
 
-	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
+	ldr	x0, [x4, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x0
 	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
 	bl	__fpsimd_save_state
 
-	add	x2, x3, #VCPU_CONTEXT
+	add	x2, x4, #VCPU_CONTEXT
+
+#ifdef CONFIG_ARM64_SVE
+alternative_if ARM64_SVE
+	b	2f
+alternative_else_nop_endif
+#endif
+
 	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
 	bl	__fpsimd_restore_state
 
+0:
 	// Skip restoring fpexc32 for AArch64 guests
 	mrs	x1, hcr_el2
 	tbnz	x1, #HCR_RW_SHIFT, 1f
-	ldr	x4, [x3, #VCPU_FPEXC32_EL2]
-	msr	fpexc32_el2, x4
+	ldr	x3, [x4, #VCPU_FPEXC32_EL2]
+	msr	fpexc32_el2, x3
 1:
 	ldp	x4, lr, [sp], #16
 	ldp	x2, x3, [sp], #16
 	ldp	x0, x1, [sp], #16
 
 	eret
+
+#ifdef CONFIG_ARM64_SVE
+2:
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	ldr	x0, [x4, #VCPU_ZCR_EL2]
+	ldr	x3, [x4, #VCPU_ZCR_EL1]
+	msr_s	SYS_ZCR_EL2, x0
+alternative_else
+	ldr	x0, [x4, #VCPU_ZCR_EL1]
+	ldr	x3, [x4, #VCPU_ZCR_EL2]
+	msr_s	SYS_ZCR_EL12, x0
+alternative_endif
+
+	ldr	w0, [x4, #VCPU_SVE_FFR_OFFSET]
+	add	x0, x4, x0
+	add	x1, x2, #VCPU_FPSR - VCPU_CONTEXT
+	mov	x2, x3
+	bl	__sve_load_state
+
+	b	0b
+#endif /* CONFIG_ARM64_SVE */
+
 ENDPROC(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index da3f22c..91ae93d 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -31,3 +31,15 @@ ENTRY(__fpsimd_restore_state)
 	fpsimd_restore	x0, 1
 	ret
 ENDPROC(__fpsimd_restore_state)
+
+#ifdef CONFIG_ARM64_SVE
+ENTRY(__sve_save_state)
+	sve_save	0, x1, 2
+	ret
+ENDPROC(__sve_save_state)
+
+ENTRY(__sve_load_state)
+	sve_load	0, x1, x2, 3
+	ret
+ENDPROC(__sve_load_state)
+#endif /* CONFIG_ARM64_SVE */
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5170ce1..58e7dcd 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -116,6 +116,13 @@ alternative_if_not ARM64_HAS_NO_FPSIMD
 	b.eq	__fpsimd_guest_restore
 alternative_else_nop_endif
 
+alternative_if ARM64_SVE	/* architecturally requires FPSIMD */
+	cmp	x0, #ESR_ELx_EC_SVE
+	b.ne	1f
+	b	__fpsimd_guest_restore	/* trampoline for more branch range */
+1:
+alternative_else_nop_endif
+
 	mrs	x1, tpidr_el2
 	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 525c01f..42c421d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -42,6 +42,50 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
+static void __hyp_text __sve_guest_save_regs(struct kvm_vcpu *vcpu,
+					     struct kvm_cpu_context *ctxt)
+{
+	unsigned int vq =
+		(ctxt->sys_regs[ZCR_EL2] & ZCR_ELx_LEN_MASK) + 1;
+
+	__sve_save_state(vcpu_guest_sve_pffr(vcpu, vq),
+			 &ctxt->gp_regs.fp_regs.fpsr);
+}
+
+static void __hyp_text __sve_guest_save_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+	ctxt->sys_regs[ZCR_EL1] = read_sysreg_s(SYS_ZCR_EL1);
+	__sve_guest_save_regs(vcpu, ctxt);
+}
+
+static void __hyp_text __sve_guest_save_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+	ctxt->sys_regs[ZCR_EL1] = read_sysreg_s(SYS_ZCR_EL12);
+	__sve_guest_save_regs(vcpu, ctxt);
+}
+
+static hyp_alternate_select(__sve_guest_save,
+			    __sve_guest_save_nvhe, __sve_guest_save_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+static void __hyp_text __fpsimd_guest_save_nsve(struct kvm_vcpu *vcpu)
+{
+	__fpsimd_save_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
+}
+
+static void __hyp_text __fpsimd_guest_save_sve(struct kvm_vcpu *vcpu)
+{
+	__sve_guest_save()(vcpu);
+}
+
+static hyp_alternate_select(__fpsimd_guest_save,
+			    __fpsimd_guest_save_nsve, __fpsimd_guest_save_sve,
+			    ARM64_SVE);
+
 static void __hyp_text __activate_traps_vhe(void)
 {
 	u64 val;
@@ -383,7 +427,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg_restore_host_state(host_ctxt);
 
 	if (fp_enabled) {
-		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
+		__fpsimd_guest_save()(vcpu);
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 	}
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3256b92..b105e54 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -26,7 +26,9 @@
 
 #include <kvm/arm_arch_timer.h>
 
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
+#include <asm/fpsimd.h>
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
@@ -88,6 +90,22 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+size_t arch_kvm_vcpu_size(void)
+{
+	unsigned int vq;
+	struct kvm_vcpu vcpu;	/* dummy struct used for size calculation */
+	char *p;
+
+	if (!system_supports_sve())
+		return sizeof(struct kvm_vcpu);
+
+	BUG_ON(!sve_vl_valid(sve_max_vl));
+	vq = sve_vq_from_vl(sve_max_vl);
+
+	p = vcpu_guest_sve_state(&vcpu) + vcpu_guest_sve_size(vq);
+	return p - (char *)&vcpu;
+}
+
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1830ebc..fb86907 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -481,6 +481,29 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 }
 
+static void reset_zcr_el2(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 val = 0;
+	unsigned int vq;
+	char *p;
+
+	if (system_supports_sve()) {
+		BUG_ON(!sve_vl_valid(sve_max_vl));
+		vq = sve_vq_from_vl(sve_max_vl);
+		val = vq - 1;
+
+		/*
+		 * It's a bit gross to do this here.  But sve_ffr_offset is
+		 * essentially a cached form of ZCR_EL2 for use by the hyp asm
+		 * code, and I don't want to split the logic:
+		 */
+		p = vcpu_guest_sve_pffr(vcpu, vq);
+		vcpu->arch.sve_ffr_offset = p - (char *)vcpu;
+	}
+
+	vcpu_sys_reg(vcpu, ZCR_EL2) = val;
+}
+
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
 	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
@@ -885,17 +908,7 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 {
 	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
 			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
-	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
-
-	if (id == SYS_ID_AA64PFR0_EL1) {
-		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
-			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
-				    task_pid_nr(current));
-
-		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
-	}
-
-	return val;
+	return raz ? 0 : read_sanitised_ftr_reg(id);
 }
 
 /* cpufeature ID register access trap handlers */
@@ -1152,6 +1165,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
 	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
+	/* ZCR_EL1: make RES0 bits 0, and minimise the vector length */
+	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0 },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
@@ -1283,6 +1298,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 */
 	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
 
+	{ SYS_DESC(SYS_ZCR_EL2), NULL, reset_zcr_el2, ZCR_EL2 },
+
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
 	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 554b157..d2d16f1 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
+#include <linux/stddef.h>
 #include <linux/kvm.h>
 #include <trace/events/kvm.h>
 #include <kvm/arm_pmu.h>
@@ -44,6 +45,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
+#include <asm/kvm_host.h>
 #include <asm/kvm_psci.h>
 #include <asm/sections.h>
 
@@ -272,7 +274,8 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 	if (err)
 		goto free_vcpu;
 
-	err = create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
+	err = create_hyp_mappings(vcpu, (char *)vcpu + arch_kvm_vcpu_size(),
+				  PAGE_HYP);
 	if (err)
 		goto vcpu_uninit;
 
@@ -1509,9 +1512,14 @@ void kvm_arch_exit(void)
 	kvm_perf_teardown();
 }
 
+size_t __weak arch_kvm_vcpu_size(void)
+{
+	return sizeof(struct kvm_vcpu);
+}
+
 static int arm_init(void)
 {
-	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	int rc = kvm_init(NULL, arch_kvm_vcpu_size(), 0, THIS_MODULE);
 	return rc;
 }
 
-- 
2.1.4
