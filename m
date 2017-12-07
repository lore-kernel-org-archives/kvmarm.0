From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 30/36] KVM: arm64: Separate activate_traps and deactive_traps for VHE and non-VHE
Date: Thu,  7 Dec 2017 18:06:24 +0100
Message-ID: <20171207170630.592-31-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

To make the code more readable and to avoid the overhead of a function
call, let's get rid of a pair of the alternative function selectors and
explicitly call the VHE and non-VHE functions instead, telling the
compiler to try to inline the static function if it can.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 78 +++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f039aad86c27..f9f104bfc27b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -103,9 +103,27 @@ void deactivate_traps_vhe_put(void)
 	write_sysreg(mdcr_el2, mdcr_el2);
 }
 
-static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
+static inline void activate_traps_vhe(struct kvm_vcpu *vcpu)
 {
-	write_sysreg(__kvm_hyp_vector, vbar_el1);
+	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
+	write_sysreg_el2(__kvm_hyp_vector, vbar);
+}
+
+static inline void deactivate_traps_vhe(struct kvm_vcpu *vcpu)
+{
+	extern char vectors[];	/* kernel exception vectors */
+
+	/*
+	 * If we pended a virtual abort, preserve it until it gets
+	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
+	 * the crucial bit is "On taking a vSError interrupt,
+	 * HCR_EL2.VSE is cleared to 0."
+	 */
+	if (vcpu->arch.hcr_el2 & HCR_VSE)
+		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
+
+	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	write_sysreg(vectors, vbar_el1);
 }
 
 static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
@@ -126,44 +144,15 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 	else
 		val |= CPTR_EL2_TFP;
 	write_sysreg(val, cptr_el2);
-}
 
-static hyp_alternate_select(__activate_traps_arch,
-			    __activate_traps_nvhe, __activate_traps_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
-static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
-{
-	__activate_traps_arch()(vcpu);
+	/* Configure all other hypervisor traps and features */
 	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
 }
 
-static void __hyp_text __deactivate_traps_vhe(void)
-{
-	extern char vectors[];	/* kernel exception vectors */
-
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
-	write_sysreg(vectors, vbar_el1);
-}
-
-static void __hyp_text __deactivate_traps_nvhe(void)
+static void __hyp_text __deactivate_traps_nvhe(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
-	write_sysreg(HCR_RW, hcr_el2);
-	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
-}
-
-static hyp_alternate_select(__deactivate_traps_arch,
-			    __deactivate_traps_nvhe, __deactivate_traps_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
+	u64 mdcr_el2;
 
-static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
-{
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
 	 * cleared. See D1.14.3 (Virtual Interrupts) for details, but
@@ -174,7 +163,14 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
 
 	__deactivate_traps_common();
-	__deactivate_traps_arch()();
+
+	mdcr_el2 = read_sysreg(mdcr_el2);
+	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
+	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
+
+	write_sysreg(mdcr_el2, mdcr_el2);
+	write_sysreg(HCR_RW, hcr_el2);
+	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
 static void __hyp_text __activate_vm(struct kvm *kvm)
@@ -391,7 +387,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_save_host_state_vhe(host_ctxt);
 
-	__activate_traps(vcpu);
+	activate_traps_vhe(vcpu);
 	__activate_vm(vcpu->kvm);
 
 	__vgic_restore_state(vcpu);
@@ -409,7 +405,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_save_guest_state_vhe(guest_ctxt);
 	__vgic_save_state(vcpu);
 
-	__deactivate_traps(vcpu);
+	deactivate_traps_vhe(vcpu);
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
@@ -433,7 +429,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(host_ctxt);
 
-	__activate_traps(vcpu);
+	__activate_traps_nvhe(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
 
 	__vgic_restore_state(vcpu);
@@ -459,7 +455,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
 
-	__deactivate_traps(vcpu);
+	__deactivate_traps_nvhe(vcpu);
 	__deactivate_vm(vcpu);
 
 	__sysreg_restore_state_nvhe(host_ctxt);
@@ -485,7 +481,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 
 	if (read_sysreg(vttbr_el2)) {
 		__timer_disable_traps(vcpu);
-		__deactivate_traps(vcpu);
+		__deactivate_traps_nvhe(vcpu);
 		__deactivate_vm(vcpu);
 		__sysreg_restore_state_nvhe(__host_ctxt);
 	}
@@ -509,7 +505,7 @@ static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
 	struct kvm_vcpu *vcpu;
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
-	__deactivate_traps(vcpu);
+	deactivate_traps_vhe(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic(__hyp_panic_string,
-- 
2.14.2
