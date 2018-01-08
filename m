From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v6 03/16] KVM: arm64: Change hyp_panic()s dependency on tpidr_el2
Date: Mon,  8 Jan 2018 15:38:05 +0000
Message-ID: <20180108153818.22743-4-james.morse@arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108153818.22743-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Make tpidr_el2 a cpu-offset for per-cpu variables in the same way the
host uses tpidr_el1. This lets tpidr_el{1,2} have the same value, and
on VHE they can be the same register.

KVM calls hyp_panic() when anything unexpected happens. This may occur
while a guest owns the EL1 registers. KVM stashes the vcpu pointer in
tpidr_el2, which it uses to find the host context in order to restore
the host EL1 registers before parachuting into the host's panic().

The host context is a struct kvm_cpu_context allocated in the per-cpu
area, and mapped to hyp. Given the per-cpu offset for this CPU, this is
easy to find. Change hyp_panic() to take a pointer to the
struct kvm_cpu_context. Wrap these calls with an asm function that
retrieves the struct kvm_cpu_context from the host's per-cpu area.

Copy the per-cpu offset from the hosts tpidr_el1 into tpidr_el2 during
kvm init. (Later patches will make this unnecessary for VHE hosts)

We print out the vcpu pointer as part of the panic message. Add a back
reference to the 'running vcpu' in the host cpu context to preserve this.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Reviewed-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
Changes since v1:
 * Added a comment explaining how =kvm_host_cpu_state gets from a host-va
   to a hyp va.
 * Added the first paragraph to the commit message.

 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/hyp/hyp-entry.S    | 12 ++++++++++++
 arch/arm64/kvm/hyp/s2-setup.c     |  3 +++
 arch/arm64/kvm/hyp/switch.c       | 25 +++++++++++++------------
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ea6cb5b24258..7ee72b402907 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -192,6 +192,8 @@ struct kvm_cpu_context {
 		u64 sys_regs[NR_SYS_REGS];
 		u32 copro[NR_COPRO_REGS];
 	};
+
+	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
 typedef struct kvm_cpu_context kvm_cpu_context_t;
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index fce7cc507e0a..e4f37b9dd47c 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -163,6 +163,18 @@ ENTRY(__hyp_do_panic)
 	eret
 ENDPROC(__hyp_do_panic)
 
+ENTRY(__hyp_panic)
+	/*
+	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
+	 * not be accessible by this address from EL2, hyp_panic() converts
+	 * it with kern_hyp_va() before use.
+	 */
+	ldr	x0, =kvm_host_cpu_state
+	mrs	x1, tpidr_el2
+	add	x0, x0, x1
+	b	hyp_panic
+ENDPROC(__hyp_panic)
+
 .macro invalid_vector	label, target = __hyp_panic
 	.align	2
 \label:
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index a81f5e10fc8c..7fb88274eba1 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -84,5 +84,8 @@ u32 __hyp_text __init_stage2_translation(void)
 
 	write_sysreg(val, vtcr_el2);
 
+	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
+	write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
+
 	return parange;
 }
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 4d273f6d0e69..4d83c69bafba 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -306,9 +306,9 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	u64 exit_code;
 
 	vcpu = kern_hyp_va(vcpu);
-	write_sysreg(vcpu, tpidr_el2);
 
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	__sysreg_save_host_state(host_ctxt);
@@ -435,7 +435,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
-static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
+static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
+					     struct kvm_vcpu *vcpu)
 {
 	unsigned long str_va;
 
@@ -449,35 +450,35 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
 	__hyp_do_panic(str_va,
 		       spsr,  elr,
 		       read_sysreg(esr_el2),   read_sysreg_el2(far),
-		       read_sysreg(hpfar_el2), par,
-		       (void *)read_sysreg(tpidr_el2));
+		       read_sysreg(hpfar_el2), par, vcpu);
 }
 
-static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par)
+static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
+					    struct kvm_vcpu *vcpu)
 {
 	panic(__hyp_panic_string,
 	      spsr,  elr,
 	      read_sysreg_el2(esr),   read_sysreg_el2(far),
-	      read_sysreg(hpfar_el2), par,
-	      (void *)read_sysreg(tpidr_el2));
+	      read_sysreg(hpfar_el2), par, vcpu);
 }
 
 static hyp_alternate_select(__hyp_call_panic,
 			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
-void __hyp_text __noreturn __hyp_panic(void)
+void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt)
 {
+	struct kvm_vcpu *vcpu = NULL;
+
 	u64 spsr = read_sysreg_el2(spsr);
 	u64 elr = read_sysreg_el2(elr);
 	u64 par = read_sysreg(par_el1);
 
 	if (read_sysreg(vttbr_el2)) {
-		struct kvm_vcpu *vcpu;
 		struct kvm_cpu_context *host_ctxt;
 
-		vcpu = (struct kvm_vcpu *)read_sysreg(tpidr_el2);
-		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+		host_ctxt = kern_hyp_va(__host_ctxt);
+		vcpu = host_ctxt->__hyp_running_vcpu;
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
@@ -485,7 +486,7 @@ void __hyp_text __noreturn __hyp_panic(void)
 	}
 
 	/* Call panic for real */
-	__hyp_call_panic()(spsr, elr, par);
+	__hyp_call_panic()(spsr, elr, par, vcpu);
 
 	unreachable();
 }
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
