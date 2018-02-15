From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 13/40] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Thu, 15 Feb 2018 22:03:05 +0100
Message-ID: <20180215210332.8648-14-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far this is mostly (see below) a copy of the legacy non-VHE switch
function, but we will start reworking these functions in separate
directions to work on VHE and non-VHE in the most optimal way in later
patches.

The only difference after this patch between the VHE and non-VHE run
functions is that we omit the branch-predictor variant-2 hardening for
QC Falkor CPUs, because this workaround is specific to a series of
non-VHE ARMv8.0 CPUs.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v3:
     - Added BUG() to 32-bit ARM VHE run function
     - Omitted QC Falkor BP Hardening functionality from VHE-specific
       function
    
    Changes since v2:
     - Reworded commit message
    
    Changes since v1:
     - Rename kvm_vcpu_run to kvm_vcpu_run_vhe and rename __kvm_vcpu_run to
       __kvm_vcpu_run_nvhe
     - Removed stray whitespace line

 arch/arm/include/asm/kvm_asm.h   |  5 ++-
 arch/arm/kvm/hyp/switch.c        |  2 +-
 arch/arm64/include/asm/kvm_asm.h |  4 ++-
 arch/arm64/kvm/hyp/switch.c      | 66 +++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/arm.c               |  5 ++-
 5 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 36dd2962a42d..5a953ecb0d78 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -70,7 +70,10 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
-extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+/* no VHE on 32-bit :( */
+static inline int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu) { BUG(); return 0; }
+
+extern int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu);
 
 extern void __init_stage2_translation(void);
 
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index e86679daddff..aac025783ee8 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -154,7 +154,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6b626750b0a1..0be2747a6c5f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -58,7 +58,9 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
-extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+extern int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu);
+
+extern int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
 extern u64 __vgic_v3_read_vmcr(void);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d2c0b1ae3216..b6126af539b6 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -362,7 +362,71 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+/* Switch to the guest for VHE systems running in EL2 */
+int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	bool fp_enabled;
+	u64 exit_code;
+
+	vcpu = kern_hyp_va(vcpu);
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt->__hyp_running_vcpu = vcpu;
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__sysreg_save_host_state(host_ctxt);
+
+	__activate_traps(vcpu);
+	__activate_vm(vcpu);
+
+	__vgic_restore_state(vcpu);
+	__timer_enable_traps(vcpu);
+
+	/*
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_guest_state(guest_ctxt);
+	__debug_switch_to_guest(vcpu);
+
+	do {
+		/* Jump in the fire! */
+		exit_code = __guest_enter(vcpu, host_ctxt);
+
+		/* And we're baaack! */
+	} while (fixup_guest_exit(vcpu, &exit_code));
+
+	fp_enabled = __fpsimd_enabled();
+
+	__sysreg_save_guest_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+	__timer_disable_traps(vcpu);
+	__vgic_save_state(vcpu);
+
+	__deactivate_traps(vcpu);
+	__deactivate_vm(vcpu);
+
+	__sysreg_restore_host_state(host_ctxt);
+
+	if (fp_enabled) {
+		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
+		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+	}
+
+	/*
+	 * This must come after restoring the host sysregs, since a non-VHE
+	 * system may enable SPE here and make use of the TTBRs.
+	 */
+	__debug_switch_to_host(vcpu);
+
+	return exit_code;
+}
+
+/* Switch to the guest for legacy non-VHE systems */
+int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 2062d9357971..5bd879c78951 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -736,7 +736,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (has_vhe())
 			kvm_arm_vhe_guest_enter();
 
-		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
+		if (has_vhe())
+			ret = kvm_vcpu_run_vhe(vcpu);
+		else
+			ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
 
 		if (has_vhe())
 			kvm_arm_vhe_guest_exit();
-- 
2.14.2
