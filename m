From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 16/16] KVM: arm64: Handle deferred SErrors consumed on
 guest exit
Date: Fri, 28 Jul 2017 15:10:19 +0100
Message-ID: <20170728141019.9084-17-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A04A949C2D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G96NjzmwFcOF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:11:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AB6649C3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:10 -0400 (EDT)
In-Reply-To: <20170728141019.9084-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On systems with VHE, the RAS extensions and IESB support, KVM gets an
implicit ESB whenever it enters/exits a guest, because the host sets
SCTLR_EL1.IESB.

To prevent errors being lost, add code to __guest_exit() to read DISR_EL1,
and save it in the kvm_vcpu_fault_info. Add code to handle_exit() to
process this deferred SError. This data is in addition to the reason the
guest exitted.

Future patches may add a firmware-first callout from
kvm_handle_deferred_serror() to decode CPER records populated by firmware,
or call some arm64 arch code to process the RAS 'ERR' registers for
kernel-first handling. Without either of these, we just make a judgement
on the severity: corrected and restartable errors are ignored, all others
result it an SError being given to the guest.

On systems with EL2 but where VHE has been disabled in the build config,
add an explicit ESB in the __guest_exit() path. This lets us skip the
SError VAXorcism on all systems with the RAS extensions.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/kernel/asm-offsets.c      |  1 +
 arch/arm64/kvm/handle_exit.c         | 84 +++++++++++++++++++++++++++++-------
 arch/arm64/kvm/hyp/entry.S           |  9 ++++
 5 files changed, 85 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fe39e6841326..9bec1e572bee 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -168,6 +168,11 @@ static inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_MASK) << 8;
 }
 
+static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.fault.disr_el1;
+}
+
 static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_hsr(vcpu) & ESR_ELx_xVC_IMM_MASK;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d68630007b14..f65cc6d497e6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -88,6 +88,7 @@ struct kvm_vcpu_fault_info {
 	u32 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
 	u64 hpfar_el2;		/* Hyp IPA Fault Address Register */
+	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
 /*
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b3bb7ef97bc8..331cccbd38cf 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -129,6 +129,7 @@ int main(void)
   BLANK();
 #ifdef CONFIG_KVM_ARM_HOST
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
+  DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
   DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 17d8a1677a0b..b8e2477853eb 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -23,6 +23,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/esr.h>
+#include <asm/exception.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
@@ -67,6 +68,67 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
+static void kvm_inject_serror(struct kvm_vcpu *vcpu)
+{
+	u8 hsr_ec = ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
+
+	/*
+	 * HVC/SMC already have an adjusted PC, which we need
+	 * to correct in order to return to after having
+	 * injected the SError.
+	 */
+	if (hsr_ec == ESR_ELx_EC_HVC32 || hsr_ec == ESR_ELx_EC_HVC64 ||
+	    hsr_ec == ESR_ELx_EC_SMC32 || hsr_ec == ESR_ELx_EC_SMC64) {
+		u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
+		*vcpu_pc(vcpu) -= adj;
+	}
+
+	kvm_inject_vabt(vcpu);
+}
+
+/**
+ * kvm_handle_guest_serror
+ *
+ * @vcpu:	the vcpu pointer
+ * @esr:	the esr_el2 value read at guest exit for an SError, or
+ * 		disr_el1 for a deferred SError.
+ *
+ * Either the guest took an SError, or we found one pending while handling
+ * __guest_exit() at EL2. With the v8.2 RAS extensions SErrors are either
+ * 'impementation defined' or categorised as a RAS exception.
+ * Without any further information we ignore SErrors categorised as
+ * 'corrected' or 'restartable' by RAS, and hand the guest an SError in
+ * all other cases.
+ */
+static int kvm_handle_guest_serror(struct kvm_vcpu *vcpu, u32 esr)
+{
+	bool impdef_syndrome = esr & ESR_ELx_ISV;	/* aka IDS */
+	unsigned int aet = esr & ESR_ELx_AET;
+
+	if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN) || impdef_syndrome) {
+		kvm_inject_serror(vcpu);
+		return 1;
+	}
+
+	/*
+	 * AET is RES0 if 'the value returned in the DFSC field is not
+	 * [ESR_ELx_FSC_SERROR]'
+	 */
+	if ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR) {
+		kvm_inject_serror(vcpu);
+		return 1;
+	}
+
+	switch (aet) {
+	case ESR_ELx_AET_CE:	/* corrected error */
+	case ESR_ELx_AET_UEO:	/* restartable error, not yet consumed */
+		return 0;	/* continue processing the guest exit */
+	default:
+		kvm_inject_serror(vcpu);
+		return 1;
+	}
+}
+
 /**
  * kvm_handle_wfx - handle a wait-for-interrupts or wait-for-event
  *		    instruction executed by a guest
@@ -187,21 +249,13 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	exit_handle_fn exit_handler;
 
-	if (ARM_SERROR_PENDING(exception_index)) {
-		u8 hsr_ec = ESR_ELx_EC(kvm_vcpu_get_hsr(vcpu));
-
-		/*
-		 * HVC/SMC already have an adjusted PC, which we need
-		 * to correct in order to return to after having
-		 * injected the SError.
-		 */
-		if (hsr_ec == ESR_ELx_EC_HVC32 || hsr_ec == ESR_ELx_EC_HVC64 ||
-		    hsr_ec == ESR_ELx_EC_SMC32 || hsr_ec == ESR_ELx_EC_SMC64) {
-			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
-			*vcpu_pc(vcpu) -= adj;
-		}
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
+		u64 disr = kvm_vcpu_get_disr(vcpu);
 
-		kvm_inject_vabt(vcpu);
+		if (disr)
+			kvm_handle_guest_serror(vcpu, disr_to_esr(disr));
+	} else if (ARM_SERROR_PENDING(exception_index)) {
+		kvm_inject_serror(vcpu);
 		return 1;
 	}
 
@@ -211,7 +265,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case ARM_EXCEPTION_IRQ:
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
-		kvm_inject_vabt(vcpu);
+		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_hsr(vcpu));
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		/*
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index cec18df5a324..f1baaffa6922 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -142,6 +142,15 @@ ENTRY(__guest_exit)
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
+	kvm_explicit_esb
+	disr_read	reg=x2
+alternative_if ARM64_HAS_RAS_EXTN
+	str	x2, [x1, #(VCPU_FAULT_DISR - VCPU_CONTEXT)]
+	cbz	x2, 1f
+	orr	x0, x0, #(1<<ARM_EXIT_WITH_SERROR_BIT)
+1:	ret
+alternative_else_nop_endif
+
 	// If we have a pending asynchronous abort, now is the
 	// time to find out. From your VAXorcist book, page 666:
 	// "Threaten me not, oh Evil one!  For I speak with
-- 
2.13.2
