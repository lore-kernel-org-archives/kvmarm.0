From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 13/40] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Tue, 27 Feb 2018 12:34:02 +0100
Message-ID: <20180227113429.637-14-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE8049F7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ByfIKY4pQHrV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:28:08 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9F6749E05
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:27:58 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id t3so23399366wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:34:52 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

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
    Changes since v4:
     - Unified has_vhe() conditional calls in kvm_arch_vcpu_ioctl_run
     - Added isb() on exit path of VHE-specific kvm_vcpu_run(), because
       otherwise 32-bit guests can crash the system on reentry to the
       guest, because writes to FPEXC32_EL2 will cause a trap at EL2
       which leads to a hyp panic.  This can be observed on the model
       where writing FPEN to CPACR_EL1 on guest exit doesn't take effect
       prior to entering the guest again.
    
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

 arch/arm/include/asm/kvm_asm.h    |  5 ++-
 arch/arm/kvm/hyp/switch.c         |  2 +-
 arch/arm64/include/asm/kvm_asm.h  |  4 ++-
 arch/arm64/include/asm/kvm_host.h |  7 +++++
 arch/arm64/kvm/hyp/switch.c       | 66 ++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/arm.c                | 12 ++++---
 6 files changed, 87 insertions(+), 9 deletions(-)

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
index 7149f1520382..d53d40704416 100644
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
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c30fc96992df..87abc94fb591 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -428,6 +428,13 @@ static inline void kvm_arm_vhe_guest_enter(void)
 static inline void kvm_arm_vhe_guest_exit(void)
 {
 	local_daif_restore(DAIF_PROCCTX_NOIRQ);
+
+	/*
+	 * When we exit from the guest we change a number of CPU configuration
+	 * parameters, such as traps.  Make sure these changes take effect
+	 * before running the host or additional guests.
+	 */
+	isb();
 }
 
 static inline bool kvm_arm_harden_branch_predictor(void)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b055111df1a1..1b94ac6a85e6 100644
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
index 2062d9357971..09dbee56ed8f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -733,13 +733,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		trace_kvm_entry(*vcpu_pc(vcpu));
 		guest_enter_irqoff();
-		if (has_vhe())
-			kvm_arm_vhe_guest_enter();
-
-		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
 
-		if (has_vhe())
+		if (has_vhe()) {
+			kvm_arm_vhe_guest_enter();
+			ret = kvm_vcpu_run_vhe(vcpu);
 			kvm_arm_vhe_guest_exit();
+		} else {
+			ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
+		}
+
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 		/*
-- 
2.14.2
