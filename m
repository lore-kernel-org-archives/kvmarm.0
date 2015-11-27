From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 15/21] arm64: KVM: Add panic handling
Date: Fri, 27 Nov 2015 18:50:09 +0000
Message-ID: <1448650215-15218-16-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDA0448531
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BGd6hNx3n3gh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1240F4968B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:48 -0500 (EST)
In-Reply-To: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the panic handler, together with the small bits of assembly
code to call the kernel's panic implementation.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 11 ++++++++++-
 arch/arm64/kvm/hyp/hyp.h       |  1 +
 arch/arm64/kvm/hyp/switch.c    | 30 ++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 8334407..39d6935 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -150,7 +150,16 @@ el1_irq:
 	mov	x1, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
-.macro invalid_vector	label, target = __kvm_hyp_panic
+ENTRY(__hyp_do_panic)
+	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
+		      PSR_MODE_EL1h)
+	msr	spsr_el2, lr
+	ldr	lr, =panic
+	msr	elr_el2, lr
+	eret
+ENDPROC(__hyp_do_panic)
+
+.macro invalid_vector	label, target = __hyp_panic
 	.align	2
 \label:
 	b \target
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 18365dd..87f16fa 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -74,6 +74,7 @@ static inline bool __fpsimd_enabled(void)
 }
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+void __noreturn __hyp_do_panic(unsigned long, ...);
 
 #endif /* __ARM64_KVM_HYP_H__ */
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8affc19..7b81089 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -140,3 +140,33 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 
 	return exit_code;
 }
+
+static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
+
+void __hyp_text __noreturn __hyp_panic(void)
+{
+	unsigned long str_va = (unsigned long)__hyp_panic_string;
+	u64 spsr = read_sysreg(spsr_el2);
+	u64 elr = read_sysreg(elr_el2);
+	u64 par = read_sysreg(par_el1);
+
+	if (read_sysreg(vttbr_el2)) {
+		struct kvm_vcpu *vcpu;
+		struct kvm_cpu_context *host_ctxt;
+
+		vcpu = (struct kvm_vcpu *)read_sysreg(tpidr_el2);
+		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+		__deactivate_traps(vcpu);
+		__deactivate_vm(vcpu);
+		__sysreg_restore_state(host_ctxt);
+	}
+
+	/* Call panic for real */
+	__hyp_do_panic(str_va - HYP_PAGE_OFFSET + PAGE_OFFSET,
+		       spsr,  elr,
+		       read_sysreg(esr_el2),   read_sysreg(far_el2),
+		       read_sysreg(hpfar_el2), par,
+		       (void *)read_sysreg(tpidr_el2));
+
+	unreachable();
+}
-- 
2.1.4
