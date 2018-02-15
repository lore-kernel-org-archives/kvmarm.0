From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 04/40] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Thu, 15 Feb 2018 22:02:56 +0100
Message-ID: <20180215210332.8648-5-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

VHE actually doesn't rely on clearing the VTTBR when returning to the
host kernel, and that is the current key mechanism of hyp_panic to
figure out how to attempt to return to a state good enough to print a
panic statement.

Therefore, we split the hyp_panic function into two functions, a VHE and
a non-VHE, keeping the non-VHE version intact, but changing the VHE
behavior.

The vttbr_el2 check on VHE doesn't really make that much sense, because
the only situation where we can get here on VHE is when the hypervisor
assembly code actually called into hyp_panic, which only happens when
VBAR_EL2 has been set to the KVM exception vectors.  On VHE, we can
always safely disable the traps and restore the host registers at this
point, so we simply do that unconditionally and call into the panic
function directly.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Fixed typos in the commit message
     - Still use the generic __deactivte_traps() function in the hyp panic
       code until we rework that logic later.

 arch/arm64/kvm/hyp/switch.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d1749fa0bfc3..079bb5243f0c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -437,10 +437,20 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
 
 static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
-					     struct kvm_vcpu *vcpu)
+					     struct kvm_cpu_context *__host_ctxt)
 {
+	struct kvm_vcpu *vcpu;
 	unsigned long str_va;
 
+	vcpu = __host_ctxt->__hyp_running_vcpu;
+
+	if (read_sysreg(vttbr_el2)) {
+		__timer_disable_traps(vcpu);
+		__deactivate_traps(vcpu);
+		__deactivate_vm(vcpu);
+		__sysreg_restore_host_state(__host_ctxt);
+	}
+
 	/*
 	 * Force the panic string to be loaded from the literal pool,
 	 * making sure it is a kernel address and not a PC-relative
@@ -454,37 +464,31 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		       read_sysreg(hpfar_el2), par, vcpu);
 }
 
-static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
-					    struct kvm_vcpu *vcpu)
+static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
+				 struct kvm_cpu_context *host_ctxt)
 {
+	struct kvm_vcpu *vcpu;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+
+	__deactivate_traps(vcpu);
+	__sysreg_restore_host_state(host_ctxt);
+
 	panic(__hyp_panic_string,
 	      spsr,  elr,
 	      read_sysreg_el2(esr),   read_sysreg_el2(far),
 	      read_sysreg(hpfar_el2), par, vcpu);
 }
 
-static hyp_alternate_select(__hyp_call_panic,
-			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 {
-	struct kvm_vcpu *vcpu = NULL;
-
 	u64 spsr = read_sysreg_el2(spsr);
 	u64 elr = read_sysreg_el2(elr);
 	u64 par = read_sysreg(par_el1);
 
-	if (read_sysreg(vttbr_el2)) {
-		vcpu = host_ctxt->__hyp_running_vcpu;
-		__timer_disable_traps(vcpu);
-		__deactivate_traps(vcpu);
-		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state(host_ctxt);
-	}
-
-	/* Call panic for real */
-	__hyp_call_panic()(spsr, elr, par, vcpu);
+	if (!has_vhe())
+		__hyp_call_panic_nvhe(spsr, elr, par, host_ctxt);
+	else
+		__hyp_call_panic_vhe(spsr, elr, par, host_ctxt);
 
 	unreachable();
 }
-- 
2.14.2
