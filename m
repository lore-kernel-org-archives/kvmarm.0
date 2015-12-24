From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 18/31] arm64: KVM: Add panic handling
Date: Thu, 24 Dec 2015 11:12:26 +0000
Message-ID: <1450955559-15639-19-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Amit Singh Tomar <amittomer25@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Jisheng Zhang <jszhang@marvell.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the panic handler, together with the small bits of assembly
code to call the kernel's panic implementation.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/hyp-entry.S | 11 ++++++++++-
 arch/arm64/kvm/hyp/hyp.h       |  1 +
 arch/arm64/kvm/hyp/switch.c    | 30 ++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 818731a..8e58a3b 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -155,7 +155,16 @@ el1_irq:
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
index 70d4f69..fb27517 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -84,6 +84,7 @@ static inline bool __fpsimd_enabled(void)
 }
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
+void __noreturn __hyp_do_panic(unsigned long, ...);
 
 #endif /* __ARM64_KVM_HYP_H__ */
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 608155f..b012870 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -141,3 +141,33 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 
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
+	__hyp_do_panic(hyp_kern_va(str_va),
+		       spsr,  elr,
+		       read_sysreg(esr_el2),   read_sysreg(far_el2),
+		       read_sysreg(hpfar_el2), par,
+		       (void *)read_sysreg(tpidr_el2));
+
+	unreachable();
+}
-- 
2.1.4

