From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 26/26] KVM: arm64: Safety check PSTATE when entering guest and
 handle IL
Date: Fri, 19 Oct 2018 13:59:01 +0100
Message-ID: <20181019125901.185478-27-marc.zyngier@arm.com>
References: <20181019125901.185478-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A8584A1D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pZoGgnfziYTu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Oct 2018 09:00:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC93F4A2D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Oct 2018 09:00:34 -0400 (EDT)
In-Reply-To: <20181019125901.185478-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: zhong jiang <zhongjiang@huawei.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

This commit adds a paranoid check when entering the guest to make sure
we don't attempt running guest code in an equally or more privilged mode
than the hypervisor.  We also catch other accidental programming of the
SPSR_EL2 which results in an illegal exception return and report this
safely back to the user.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/include/asm/ptrace.h  |  3 +++
 arch/arm64/kvm/handle_exit.c     |  7 +++++++
 arch/arm64/kvm/hyp/hyp-entry.S   | 16 +++++++++++++++-
 arch/arm64/kvm/hyp/sysreg-sr.c   | 19 ++++++++++++++++++-
 5 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 0b53c72e7591..aea01a09eb94 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -30,6 +30,7 @@
 #define ARM_EXCEPTION_IRQ	  0
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
+#define ARM_EXCEPTION_IL	  3
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 177b851ca6d9..ff35ac1258eb 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -25,6 +25,9 @@
 #define CurrentEL_EL1		(1 << 2)
 #define CurrentEL_EL2		(2 << 2)
 
+/* Additional SPSR bits not exposed in the UABI */
+#define PSR_IL_BIT		(1 << 20)
+
 /* AArch32-specific ptrace requests */
 #define COMPAT_PTRACE_GETREGS		12
 #define COMPAT_PTRACE_SETREGS		13
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e5e741bfffe1..35a81bebd02b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -284,6 +284,13 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 */
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return 0;
+	case ARM_EXCEPTION_IL:
+		/*
+		 * We attempted an illegal exception return.  Guest state must
+		 * have been corrupted somehow.  Give up.
+		 */
+		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		return -EINVAL;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 24b4fbafe3e4..b1f14f736962 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -162,6 +162,20 @@ el1_error:
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
+el2_sync:
+	/* Check for illegal exception return, otherwise panic */
+	mrs	x0, spsr_el2
+
+	/* if this was something else, then panic! */
+	tst	x0, #PSR_IL_BIT
+	b.eq	__hyp_panic
+
+	/* Let's attempt a recovery from the illegal exception return */
+	get_vcpu_ptr	x1, x0
+	mov	x0, #ARM_EXCEPTION_IL
+	b	__guest_exit
+
+
 el2_error:
 	ldp	x0, x1, [sp], #16
 
@@ -240,7 +254,7 @@ ENTRY(__kvm_hyp_vector)
 	invalid_vect	el2t_fiq_invalid	// FIQ EL2t
 	invalid_vect	el2t_error_invalid	// Error EL2t
 
-	invalid_vect	el2h_sync_invalid	// Synchronous EL2h
+	valid_vect	el2_sync		// Synchronous EL2h
 	invalid_vect	el2h_irq_invalid	// IRQ EL2h
 	invalid_vect	el2h_fiq_invalid	// FIQ EL2h
 	valid_vect	el2_error		// Error EL2h
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9ce223944983..8dc285318204 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -152,8 +152,25 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 static void __hyp_text
 __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
 {
+	u64 pstate = ctxt->gp_regs.regs.pstate;
+	u64 mode = pstate & PSR_AA32_MODE_MASK;
+
+	/*
+	 * Safety check to ensure we're setting the CPU up to enter the guest
+	 * in a less privileged mode.
+	 *
+	 * If we are attempting a return to EL2 or higher in AArch64 state,
+	 * program SPSR_EL2 with M=EL2h and the IL bit set which ensures that
+	 * we'll take an illegal exception state exception immediately after
+	 * the ERET to the guest.  Attempts to return to AArch32 Hyp will
+	 * result in an illegal exception return because EL2's execution state
+	 * is determined by SCR_EL3.RW.
+	 */
+	if (!(mode & PSR_MODE32_BIT) && mode >= PSR_MODE_EL2t)
+		pstate = PSR_MODE_EL2h | PSR_IL_BIT;
+
 	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
-	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
+	write_sysreg_el2(pstate,			spsr);
 
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
-- 
2.19.1
