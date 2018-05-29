From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH] KVM: arm64: VHE: Migrate _elx sysreg accessors to msr_s/mrs_s
Date: Tue, 29 May 2018 15:20:47 +0100
Message-ID: <1527603647-24787-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently, the {read,write}_sysreg_el*() accessors for accessing
particular ELs' sysregs in the presence of VHE rely on some local
hacks and define their system register encodings in a way that is
inconsistent with the core definitions in <asm/sysreg.h>.

As a result, it is necessary to add duplicate definitions for any
system register that already needs a definition in sysreg.h for
other reasons.

This is a bit of a maintenance headache, and the reasons for the
_el*() accessors working the way they do is a bit historical.

This patch gets rid of the shadow sysreg definitions in
<asm/kvm_hyp.h>, converts the _el*() accessors to use the core
msr_s/mrs_s interface, and converts all call sites to use the
standard sysreg #define names (i.e., upper case, with SYS_ prefix).

This patch will conflict heavily anyway, so the opportunity taken
to clean up some bad whitespace in the context of the changes is
taken.

The change exposes a few system registers that have no sysreg.h
definition, due to msr_s/mrs_s being used in place of msr/mrs:
additions are made in order to fill in the gaps.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>

---

Build-tested only, for now, and diffed the disassembly of vmlinux build
with defconfig.  Not proposed for v4.18.

I can keep this in my branch for now, but if someone is interested in
picking it up, let me know.  Due to the potential for conflicts, it may
be useful to get it into next sooner rather than later, though it may
be a bit premature just now.

Reviewers may want to look closely at the new additions to sysreg.h
which is the one significant part of this patch that is not
straightforwardly automatable.

The motivation for this is adding SVE support to KVM, where I would
have to add shadow ZCR_ELx definitions in kvm_hyp.h, which seems a bit
gross.

Otherwise, most of the changes were done with something like the
following elisp:

(let (case-fold-search case-replace)
 (goto-char (point-min))
 (while (re-search-forward (concat
    "\\(read_sysreg_[a-z0-9]*[[:blank:]]*(\\|"
     "write_sysreg_[a-z0-9]*[[:blank:]]*([^\n,]*,[[:blank:]]*\\)"
    "\\([a-z][^\n)]*\\)" )
   nil t )
  (upcase-region (match-beginning 2) (match-end 2))
  (save-excursion (goto-char (match-beginning 2)) (insert "SYS_")) ) )
---
 arch/arm64/include/asm/kvm_emulate.h     |  8 ++--
 arch/arm64/include/asm/kvm_hyp.h         | 36 +++-----------
 arch/arm64/include/asm/sysreg.h          | 39 ++++++++++++++-
 arch/arm64/kvm/hyp/switch.c              | 24 +++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c           | 78 +++++++++++++++---------------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 arch/arm64/kvm/regmap.c                  |  4 +-
 arch/arm64/kvm/sys_regs.c                | 82 ++++++++++++++------------------
 virt/kvm/arm/arch_timer.c                | 12 ++---
 9 files changed, 143 insertions(+), 142 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1dab3a9..1fedfef 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -99,7 +99,7 @@ static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
 static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.sysregs_loaded_on_cpu)
-		return read_sysreg_el1(elr);
+		return read_sysreg_el1(SYS_ELR);
 	else
 		return *__vcpu_elr_el1(vcpu);
 }
@@ -107,7 +107,7 @@ static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
 static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long v)
 {
 	if (vcpu->arch.sysregs_loaded_on_cpu)
-		write_sysreg_el1(v, elr);
+		write_sysreg_el1(v, SYS_ELR);
 	else
 		*__vcpu_elr_el1(vcpu) = v;
 }
@@ -167,7 +167,7 @@ static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 		return vcpu_read_spsr32(vcpu);
 
 	if (vcpu->arch.sysregs_loaded_on_cpu)
-		return read_sysreg_el1(spsr);
+		return read_sysreg_el1(SYS_SPSR);
 	else
 		return vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1];
 }
@@ -180,7 +180,7 @@ static inline void vcpu_write_spsr(struct kvm_vcpu *vcpu, unsigned long v)
 	}
 
 	if (vcpu->arch.sysregs_loaded_on_cpu)
-		write_sysreg_el1(v, spsr);
+		write_sysreg_el1(v, SYS_SPSR);
 	else
 		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
 }
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 384c343..ac54dbe 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -27,7 +27,7 @@
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
-		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##nvh),\
+		asm volatile(ALTERNATIVE("mrs_s %0, " __stringify(r##nvh),\
 					 "mrs_s %0, " __stringify(r##vh),\
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 			     : "=r" (reg));				\
@@ -37,7 +37,7 @@
 #define write_sysreg_elx(v,r,nvh,vh)					\
 	do {								\
 		u64 __val = (u64)(v);					\
-		asm volatile(ALTERNATIVE("msr " __stringify(r##nvh) ", %x0",\
+		asm volatile(ALTERNATIVE("msr_s " __stringify(r##nvh) ", %x0",\
 					 "msr_s " __stringify(r##vh) ", %x0",\
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 					 : : "rZ" (__val));		\
@@ -51,8 +51,8 @@
 #define read_sysreg_el2(r)						\
 	({								\
 		u64 reg;						\
-		asm volatile(ALTERNATIVE("mrs %0, " __stringify(r##_EL2),\
-					 "mrs %0, " __stringify(r##_EL1),\
+		asm volatile(ALTERNATIVE("mrs_s %0, " __stringify(r##_EL2),\
+					 "mrs_s %0, " __stringify(r##_EL1),\
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 			     : "=r" (reg));				\
 		reg;							\
@@ -61,8 +61,8 @@
 #define write_sysreg_el2(v,r)						\
 	do {								\
 		u64 __val = (u64)(v);					\
-		asm volatile(ALTERNATIVE("msr " __stringify(r##_EL2) ", %x0",\
-					 "msr " __stringify(r##_EL1) ", %x0",\
+		asm volatile(ALTERNATIVE("msr_s " __stringify(r##_EL2) ", %x0",\
+					 "msr_s " __stringify(r##_EL1) ", %x0",\
 					 ARM64_HAS_VIRT_HOST_EXTN)	\
 					 : : "rZ" (__val));		\
 	} while (0)
@@ -72,30 +72,6 @@
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
 #define write_sysreg_el1(v,r)	write_sysreg_elx(v, r, _EL1, _EL12)
 
-/* The VHE specific system registers and their encoding */
-#define sctlr_EL12              sys_reg(3, 5, 1, 0, 0)
-#define cpacr_EL12              sys_reg(3, 5, 1, 0, 2)
-#define ttbr0_EL12              sys_reg(3, 5, 2, 0, 0)
-#define ttbr1_EL12              sys_reg(3, 5, 2, 0, 1)
-#define tcr_EL12                sys_reg(3, 5, 2, 0, 2)
-#define afsr0_EL12              sys_reg(3, 5, 5, 1, 0)
-#define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
-#define esr_EL12                sys_reg(3, 5, 5, 2, 0)
-#define far_EL12                sys_reg(3, 5, 6, 0, 0)
-#define mair_EL12               sys_reg(3, 5, 10, 2, 0)
-#define amair_EL12              sys_reg(3, 5, 10, 3, 0)
-#define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
-#define contextidr_EL12         sys_reg(3, 5, 13, 0, 1)
-#define cntkctl_EL12            sys_reg(3, 5, 14, 1, 0)
-#define cntp_tval_EL02          sys_reg(3, 5, 14, 2, 0)
-#define cntp_ctl_EL02           sys_reg(3, 5, 14, 2, 1)
-#define cntp_cval_EL02          sys_reg(3, 5, 14, 2, 2)
-#define cntv_tval_EL02          sys_reg(3, 5, 14, 3, 0)
-#define cntv_ctl_EL02           sys_reg(3, 5, 14, 3, 1)
-#define cntv_cval_EL02          sys_reg(3, 5, 14, 3, 2)
-#define spsr_EL12               sys_reg(3, 5, 4, 0, 0)
-#define elr_EL12                sys_reg(3, 5, 4, 0, 1)
-
 /**
  * hyp_alternate_select - Generates patchable code sequences that are
  * used to switch between two implementations of a function, depending
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6171178..74fc3ca 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -171,6 +171,9 @@
 #define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
 #define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
 
+#define SYS_SPSR_EL1			sys_reg(3, 0, 4, 0, 0)
+#define SYS_ELR_EL1			sys_reg(3, 0, 4, 0, 1)
+
 #define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 
 #define SYS_AFSR0_EL1			sys_reg(3, 0, 5, 1, 0)
@@ -359,22 +362,30 @@
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
 #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
 
+#define SYS_CNTV_CTL_EL0		sys_reg(3, 3, 14, 3, 1)
+#define SYS_CNTV_CVAL_EL0		sys_reg(3, 3, 14, 3, 2)
+
 #define __PMEV_op2(n)			((n) & 0x7)
 #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
 #define SYS_PMEVCNTRn_EL0(n)		sys_reg(3, 3, 14, __CNTR_CRm(n), __PMEV_op2(n))
 #define __TYPER_CRm(n)			(0xc | (((n) >> 3) & 0x3))
 #define SYS_PMEVTYPERn_EL0(n)		sys_reg(3, 3, 14, __TYPER_CRm(n), __PMEV_op2(n))
 
-#define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
+#define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
 
 #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
 
+#define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
+#define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
+
 #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
 #define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_ESR_EL2			sys_reg(3, 4, 5, 2, 0)
 #define SYS_VSESR_EL2			sys_reg(3, 4, 5, 2, 3)
 #define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
+#define SYS_FAR_EL2			sys_reg(3, 4, 6, 0, 0)
 
-#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1,  1)
+#define SYS_VDISR_EL2			sys_reg(3, 4, 12, 1, 1)
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
 #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
@@ -416,6 +427,30 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+/* VHE encodings for architectural EL0/1 system registers */
+#define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
+#define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
+#define SYS_TTBR0_EL12			sys_reg(3, 5, 2, 0, 0)
+#define SYS_TTBR1_EL12			sys_reg(3, 5, 2, 0, 1)
+#define SYS_TCR_EL12			sys_reg(3, 5, 2, 0, 2)
+#define SYS_AFSR0_EL12			sys_reg(3, 5, 5, 1, 0)
+#define SYS_AFSR1_EL12			sys_reg(3, 5, 5, 1, 1)
+#define SYS_ESR_EL12			sys_reg(3, 5, 5, 2, 0)
+#define SYS_FAR_EL12			sys_reg(3, 5, 6, 0, 0)
+#define SYS_MAIR_EL12			sys_reg(3, 5, 10, 2, 0)
+#define SYS_AMAIR_EL12			sys_reg(3, 5, 10, 3, 0)
+#define SYS_VBAR_EL12			sys_reg(3, 5, 12, 0, 0)
+#define SYS_CONTEXTIDR_EL12		sys_reg(3, 5, 13, 0, 1)
+#define SYS_CNTKCTL_EL12		sys_reg(3, 5, 14, 1, 0)
+#define SYS_CNTP_TVAL_EL02		sys_reg(3, 5, 14, 2, 0)
+#define SYS_CNTP_CTL_EL02		sys_reg(3, 5, 14, 2, 1)
+#define SYS_CNTP_CVAL_EL02		sys_reg(3, 5, 14, 2, 2)
+#define SYS_CNTV_TVAL_EL02		sys_reg(3, 5, 14, 3, 0)
+#define SYS_CNTV_CTL_EL02		sys_reg(3, 5, 14, 3, 1)
+#define SYS_CNTV_CVAL_EL02		sys_reg(3, 5, 14, 3, 2)
+#define SYS_SPSR_EL12			sys_reg(3, 5, 4, 0, 0)
+#define SYS_ELR_EL12			sys_reg(3, 5, 4, 0, 1)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_IESB	(1 << 21)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 2d45bd7..143a008 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -275,7 +275,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
 		return true;
 
-	far = read_sysreg_el2(far);
+	far = read_sysreg_el2(SYS_FAR);
 
 	/*
 	 * The HPFAR can be invalid if the stage 2 fault did not
@@ -307,17 +307,17 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
  */
 static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
 {
-	*vcpu_pc(vcpu) = read_sysreg_el2(elr);
+	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 
 	if (vcpu_mode_is_32bit(vcpu)) {
-		vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(spsr);
+		vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(SYS_SPSR);
 		kvm_skip_instr32(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-		write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, spsr);
+		write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, SYS_SPSR);
 	} else {
 		*vcpu_pc(vcpu) += 4;
 	}
 
-	write_sysreg_el2(*vcpu_pc(vcpu), elr);
+	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		vcpu->arch.fault.esr_el2 =
@@ -380,7 +380,7 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
-		vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
+		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
 	/*
 	 * We're using the raw exception code in order to only process
@@ -572,8 +572,8 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
 
 	__hyp_do_panic(str_va,
-		       spsr,  elr,
-		       read_sysreg(esr_el2),   read_sysreg_el2(far),
+		       spsr, elr,
+		       read_sysreg(esr_el2), read_sysreg_el2(SYS_FAR),
 		       read_sysreg(hpfar_el2), par, vcpu);
 }
 
@@ -587,15 +587,15 @@ static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
 	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic(__hyp_panic_string,
-	      spsr,  elr,
-	      read_sysreg_el2(esr),   read_sysreg_el2(far),
+	      spsr, elr,
+	      read_sysreg_el2(SYS_ESR), read_sysreg_el2(SYS_FAR),
 	      read_sysreg(hpfar_el2), par, vcpu);
 }
 
 void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 {
-	u64 spsr = read_sysreg_el2(spsr);
-	u64 elr = read_sysreg_el2(elr);
+	u64 spsr = read_sysreg_el2(SYS_SPSR);
+	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
 
 	if (!has_vhe())
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 35bc168..08e34a1 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -54,33 +54,33 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
-	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
+	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
 	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
-	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
-	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
-	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
-	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(tcr);
-	ctxt->sys_regs[ESR_EL1]		= read_sysreg_el1(esr);
-	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg_el1(afsr0);
-	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg_el1(afsr1);
-	ctxt->sys_regs[FAR_EL1]		= read_sysreg_el1(far);
-	ctxt->sys_regs[MAIR_EL1]	= read_sysreg_el1(mair);
-	ctxt->sys_regs[VBAR_EL1]	= read_sysreg_el1(vbar);
-	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(contextidr);
-	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
-	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
+	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
+	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
+	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
+	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(SYS_TCR);
+	ctxt->sys_regs[ESR_EL1]		= read_sysreg_el1(SYS_ESR);
+	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg_el1(SYS_AFSR0);
+	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg_el1(SYS_AFSR1);
+	ctxt->sys_regs[FAR_EL1]		= read_sysreg_el1(SYS_FAR);
+	ctxt->sys_regs[MAIR_EL1]	= read_sysreg_el1(SYS_MAIR);
+	ctxt->sys_regs[VBAR_EL1]	= read_sysreg_el1(SYS_VBAR);
+	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(SYS_CONTEXTIDR);
+	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(SYS_AMAIR);
+	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(SYS_CNTKCTL);
 	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
 	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
 
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
-	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
-	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
+	ctxt->gp_regs.elr_el1		= read_sysreg_el1(SYS_ELR);
+	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(SYS_SPSR);
 }
 
 static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
-	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
+	ctxt->gp_regs.regs.pc		= read_sysreg_el2(SYS_ELR);
+	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(SYS_SPSR);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
@@ -118,42 +118,42 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 
 static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  	tpidr_el0);
-	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], 	tpidrro_el0);
+	write_sysreg(ctxt->sys_regs[TPIDR_EL0],		tpidr_el0);
+	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0],	tpidrro_el0);
 }
 
 static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
-	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
-	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	ttbr0);
-	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	ttbr1);
-	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	tcr);
-	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	esr);
-	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	afsr0);
-	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	afsr1);
-	write_sysreg_el1(ctxt->sys_regs[FAR_EL1],	far);
-	write_sysreg_el1(ctxt->sys_regs[MAIR_EL1],	mair);
-	write_sysreg_el1(ctxt->sys_regs[VBAR_EL1],	vbar);
-	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL1],contextidr);
-	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
-	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
+	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
+	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
+	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
+	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
+	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	SYS_ESR);
+	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	SYS_AFSR0);
+	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	SYS_AFSR1);
+	write_sysreg_el1(ctxt->sys_regs[FAR_EL1],	SYS_FAR);
+	write_sysreg_el1(ctxt->sys_regs[MAIR_EL1],	SYS_MAIR);
+	write_sysreg_el1(ctxt->sys_regs[VBAR_EL1],	SYS_VBAR);
+	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL1],SYS_CONTEXTIDR);
+	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	SYS_AMAIR);
+	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1],	SYS_CNTKCTL);
 	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
 	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
 
 	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
-	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
-	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
+	write_sysreg_el1(ctxt->gp_regs.elr_el1,		SYS_ELR);
+	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
 }
 
 static void __hyp_text
 __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
-	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
+	write_sysreg_el2(ctxt->gp_regs.regs.pc,		SYS_ELR);
+	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	SYS_SPSR);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 39be799..55f3724 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -27,7 +27,7 @@
 static bool __hyp_text __is_be(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu))
-		return !!(read_sysreg_el2(spsr) & COMPAT_PSR_E_BIT);
+		return !!(read_sysreg_el2(SYS_SPSR) & COMPAT_PSR_E_BIT);
 
 	return !!(read_sysreg(SCTLR_EL1) & SCTLR_ELx_EE);
 }
diff --git a/arch/arm64/kvm/regmap.c b/arch/arm64/kvm/regmap.c
index eefe403..6a295eb 100644
--- a/arch/arm64/kvm/regmap.c
+++ b/arch/arm64/kvm/regmap.c
@@ -163,7 +163,7 @@ unsigned long vcpu_read_spsr32(const struct kvm_vcpu *vcpu)
 
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
-		return read_sysreg_el1(spsr);
+		return read_sysreg_el1(SYS_SPSR);
 	case KVM_SPSR_ABT:
 		return read_sysreg(spsr_abt);
 	case KVM_SPSR_UND:
@@ -188,7 +188,7 @@ void vcpu_write_spsr32(struct kvm_vcpu *vcpu, unsigned long v)
 
 	switch (spsr_idx) {
 	case KVM_SPSR_SVC:
-		write_sysreg_el1(v, spsr);
+		write_sysreg_el1(v, SYS_SPSR);
 	case KVM_SPSR_ABT:
 		write_sysreg(v, spsr_abt);
 	case KVM_SPSR_UND:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a436373..2a16999 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -76,6 +76,31 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+#define DO_SYSREGS(macro)			\
+	macro(CSSELR,	1,	1)		\
+	macro(SCTLR,	1,	12)		\
+	macro(ACTLR,	1,	1)		\
+	macro(CPACR,	1,	12)		\
+	macro(TTBR0,	1,	12)		\
+	macro(TTBR1,	1,	12)		\
+	macro(TCR,	1,	12)		\
+	macro(ESR,	1,	12)		\
+	macro(AFSR0,	1,	12)		\
+	macro(AFSR1,	1,	12)		\
+	macro(FAR,	1,	12)		\
+	macro(MAIR,	1,	12)		\
+	macro(VBAR,	1,	12)		\
+	macro(CONTEXTIDR, 1,	12)		\
+	macro(TPIDR,	0,	0)		\
+	macro(TPIDRRO,	0,	0)		\
+	macro(TPIDR,	1,	1)		\
+	macro(AMAIR,	1,	12)		\
+	macro(CNTKCTL,	1,	12)		\
+	macro(PAR,	1,	1)		\
+	macro(DACR32,	2,	2)		\
+	macro(IFSR32,	2,	2)		\
+	macro(DBGVCR32,	2,	2)
+
 u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
 {
 	if (!vcpu->arch.sysregs_loaded_on_cpu)
@@ -90,30 +115,12 @@ u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
 	 * own MPIDR_EL1 and MPIDR_EL1 is accessed for VCPU A from VCPU B's
 	 * thread when emulating cross-VCPU communication.
 	 */
+#define READ_SYSREG(reg, guest_el, hyp_el)			\
+	case reg##_EL##guest_el:				\
+		return read_sysreg_s(SYS_##reg##_EL##hyp_el);
+
 	switch (reg) {
-	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
-	case SCTLR_EL1:		return read_sysreg_s(sctlr_EL12);
-	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
-	case CPACR_EL1:		return read_sysreg_s(cpacr_EL12);
-	case TTBR0_EL1:		return read_sysreg_s(ttbr0_EL12);
-	case TTBR1_EL1:		return read_sysreg_s(ttbr1_EL12);
-	case TCR_EL1:		return read_sysreg_s(tcr_EL12);
-	case ESR_EL1:		return read_sysreg_s(esr_EL12);
-	case AFSR0_EL1:		return read_sysreg_s(afsr0_EL12);
-	case AFSR1_EL1:		return read_sysreg_s(afsr1_EL12);
-	case FAR_EL1:		return read_sysreg_s(far_EL12);
-	case MAIR_EL1:		return read_sysreg_s(mair_EL12);
-	case VBAR_EL1:		return read_sysreg_s(vbar_EL12);
-	case CONTEXTIDR_EL1:	return read_sysreg_s(contextidr_EL12);
-	case TPIDR_EL0:		return read_sysreg_s(SYS_TPIDR_EL0);
-	case TPIDRRO_EL0:	return read_sysreg_s(SYS_TPIDRRO_EL0);
-	case TPIDR_EL1:		return read_sysreg_s(SYS_TPIDR_EL1);
-	case AMAIR_EL1:		return read_sysreg_s(amair_EL12);
-	case CNTKCTL_EL1:	return read_sysreg_s(cntkctl_EL12);
-	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
-	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2);
-	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2);
-	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2);
+	DO_SYSREGS(READ_SYSREG)
 	}
 
 immediate_read:
@@ -133,30 +140,13 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	 * should never be listed below, because the the MPIDR should only be
 	 * set once, before running the VCPU, and never changed later.
 	 */
+#define WRITE_SYSREG(reg, guest_el, hyp_el)			\
+	case reg##_EL##guest_el:				\
+		write_sysreg_s(val, SYS_##reg##_EL##hyp_el);	\
+		return;
+
 	switch (reg) {
-	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
-	case SCTLR_EL1:		write_sysreg_s(val, sctlr_EL12);	return;
-	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
-	case CPACR_EL1:		write_sysreg_s(val, cpacr_EL12);	return;
-	case TTBR0_EL1:		write_sysreg_s(val, ttbr0_EL12);	return;
-	case TTBR1_EL1:		write_sysreg_s(val, ttbr1_EL12);	return;
-	case TCR_EL1:		write_sysreg_s(val, tcr_EL12);		return;
-	case ESR_EL1:		write_sysreg_s(val, esr_EL12);		return;
-	case AFSR0_EL1:		write_sysreg_s(val, afsr0_EL12);	return;
-	case AFSR1_EL1:		write_sysreg_s(val, afsr1_EL12);	return;
-	case FAR_EL1:		write_sysreg_s(val, far_EL12);		return;
-	case MAIR_EL1:		write_sysreg_s(val, mair_EL12);		return;
-	case VBAR_EL1:		write_sysreg_s(val, vbar_EL12);		return;
-	case CONTEXTIDR_EL1:	write_sysreg_s(val, contextidr_EL12);	return;
-	case TPIDR_EL0:		write_sysreg_s(val, SYS_TPIDR_EL0);	return;
-	case TPIDRRO_EL0:	write_sysreg_s(val, SYS_TPIDRRO_EL0);	return;
-	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	return;
-	case AMAIR_EL1:		write_sysreg_s(val, amair_EL12);	return;
-	case CNTKCTL_EL1:	write_sysreg_s(val, cntkctl_EL12);	return;
-	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
-	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	return;
-	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	return;
-	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	return;
+	DO_SYSREGS(WRITE_SYSREG)
 	}
 
 immediate_write:
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index bd3d57f..ce5e90e 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -226,7 +226,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 		u32 cnt_ctl;
 
 		/* Only the virtual timer can be loaded so far */
-		cnt_ctl = read_sysreg_el0(cntv_ctl);
+		cnt_ctl = read_sysreg_el0(SYS_CNTV_CTL);
 		return  (cnt_ctl & ARCH_TIMER_CTRL_ENABLE) &&
 		        (cnt_ctl & ARCH_TIMER_CTRL_IT_STAT) &&
 		       !(cnt_ctl & ARCH_TIMER_CTRL_IT_MASK);
@@ -350,12 +350,12 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 		goto out;
 
 	if (timer->enabled) {
-		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
+		vtimer->cnt_ctl = read_sysreg_el0(SYS_CNTV_CTL);
+		vtimer->cnt_cval = read_sysreg_el0(SYS_CNTV_CVAL);
 	}
 
 	/* Disable the virtual timer */
-	write_sysreg_el0(0, cntv_ctl);
+	write_sysreg_el0(0, SYS_CNTV_CTL);
 	isb();
 
 	vtimer->loaded = false;
@@ -410,9 +410,9 @@ static void vtimer_restore_state(struct kvm_vcpu *vcpu)
 		goto out;
 
 	if (timer->enabled) {
-		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
+		write_sysreg_el0(vtimer->cnt_cval, SYS_CNTV_CVAL);
 		isb();
-		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
+		write_sysreg_el0(vtimer->cnt_ctl, SYS_CNTV_CTL);
 	}
 
 	vtimer->loaded = true;
-- 
2.1.4
