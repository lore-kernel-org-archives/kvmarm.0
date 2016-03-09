From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 20/95] ARM: KVM: Add panic handling code
Date: Wed,  9 Mar 2016 07:30:14 +0000
Message-ID: <1457508689-19672-21-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E50C44113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JKgH6pVquKp2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B196F49B30
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:41 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Instead of spinning forever, let's "properly" handle any unexpected
exception ("properly" meaning "print a spat on the console and die").

This has proved useful quite a few times...

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp-entry.S | 28 +++++++++++++++++++++-------
 arch/arm/kvm/hyp/switch.c    | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 1b4aa02..54a8d67 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -75,15 +75,29 @@ __kvm_hyp_vector:
 
 .macro invalid_vector label, cause
 	.align
-\label:	b	.
+\label:	mov	r0, #\cause
+	b	__hyp_panic
 .endm
 
-	invalid_vector	hyp_reset
-	invalid_vector	hyp_undef
-	invalid_vector	hyp_svc
-	invalid_vector	hyp_pabt
-	invalid_vector	hyp_dabt
-	invalid_vector	hyp_fiq
+	invalid_vector	hyp_reset	ARM_EXCEPTION_RESET
+	invalid_vector	hyp_undef	ARM_EXCEPTION_UNDEFINED
+	invalid_vector	hyp_svc		ARM_EXCEPTION_SOFTWARE
+	invalid_vector	hyp_pabt	ARM_EXCEPTION_PREF_ABORT
+	invalid_vector	hyp_dabt	ARM_EXCEPTION_DATA_ABORT
+	invalid_vector	hyp_fiq		ARM_EXCEPTION_FIQ
+
+ENTRY(__hyp_do_panic)
+	mrs	lr, cpsr
+	bic	lr, lr, #MODE_MASK
+	orr	lr, lr, #SVC_MODE
+THUMB(	orr	lr, lr, #PSR_T_BIT	)
+	msr	spsr_cxsf, lr
+	ldr	lr, =panic
+	msr	ELR_hyp, lr
+	ldr	lr, =kvm_call_hyp
+	clrex
+	eret
+ENDPROC(__hyp_do_panic)
 
 hyp_hvc:
 	/*
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 0dd0ba3..abbe90b 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -192,3 +192,41 @@ again:
 }
 
 __alias(__guest_run) int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+
+static const char * const __hyp_panic_string[] = {
+	[ARM_EXCEPTION_RESET]      = "\nHYP panic: RST   PC:%08x CPSR:%08x",
+	[ARM_EXCEPTION_UNDEFINED]  = "\nHYP panic: UNDEF PC:%08x CPSR:%08x",
+	[ARM_EXCEPTION_SOFTWARE]   = "\nHYP panic: SVC   PC:%08x CPSR:%08x",
+	[ARM_EXCEPTION_PREF_ABORT] = "\nHYP panic: PABRT PC:%08x CPSR:%08x",
+	[ARM_EXCEPTION_DATA_ABORT] = "\nHYP panic: DABRT PC:%08x ADDR:%08x",
+	[ARM_EXCEPTION_IRQ]        = "\nHYP panic: IRQ   PC:%08x CPSR:%08x",
+	[ARM_EXCEPTION_FIQ]        = "\nHYP panic: FIQ   PC:%08x CPSR:%08x",
+	[ARM_EXCEPTION_HVC]        = "\nHYP panic: HVC   PC:%08x CPSR:%08x",
+};
+
+void __hyp_text __noreturn __hyp_panic(int cause)
+{
+	u32 elr = read_special(ELR_hyp);
+	u32 val;
+
+	if (cause == ARM_EXCEPTION_DATA_ABORT)
+		val = read_sysreg(HDFAR);
+	else
+		val = read_special(SPSR);
+
+	if (read_sysreg(VTTBR)) {
+		struct kvm_vcpu *vcpu;
+		struct kvm_cpu_context *host_ctxt;
+
+		vcpu = (struct kvm_vcpu *)read_sysreg(HTPIDR);
+		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+		__deactivate_traps(vcpu);
+		__deactivate_vm(vcpu);
+		__sysreg_restore_state(host_ctxt);
+	}
+
+	/* Call panic for real */
+	__hyp_do_panic(__hyp_panic_string[cause], elr, val);
+
+	unreachable();
+}
-- 
2.1.4
