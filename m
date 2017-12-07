From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 11/36] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Thu,  7 Dec 2017 18:06:05 +0100
Message-ID: <20171207170630.592-12-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72DA049DC0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6wrUUBufgHT1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:03:44 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A83A49DC2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:43 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id f206so14073276wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:06:59 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

So far this is just a copy of the legacy non-VHE switch function, where
we only change the existing calls to has_vhe() in both the original and
new functions.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Rename kvm_vcpu_run to kvm_vcpu_run_vhe and rename __kvm_vcpu_run to
       __kvm_vcpu_run_nvhe
     - Removed stray whitespace line

 arch/arm/include/asm/kvm_asm.h   |  5 +++-
 arch/arm/kvm/hyp/switch.c        |  2 +-
 arch/arm64/include/asm/kvm_asm.h |  4 ++-
 arch/arm64/kvm/hyp/switch.c      | 58 +++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/arm.c               |  5 +++-
 5 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 36dd2962a42d..4ac717276543 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -70,7 +70,10 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
 extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
 
-extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
+/* no VHE on 32-bit :( */
+static inline int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu) { return 0; }
+
+extern int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu);
 
 extern void __init_stage2_translation(void);
 
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index c3b9799e2e13..7b2bd25e3b10 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -153,7 +153,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 33e0edc6f8be..adaf1db12271 100644
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
index 845e3bece399..8f32f8dcab65 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -342,7 +342,63 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+/* Switch to the guest for VHE systems running in EL2 */
+int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
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
index 3e10343374a1..104ee524c75a 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -712,7 +712,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_entry(*vcpu_pc(vcpu));
 		guest_enter_irqoff();
 
-		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
+		if (has_vhe())
+			ret = kvm_vcpu_run_vhe(vcpu);
+		else
+			ret = kvm_call_hyp(__kvm_vcpu_run_nvhe, vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
-- 
2.14.2
