From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 31/41] KVM: arm64: Defer saving/restoring 32-bit sysregs to
 vcpu load/put
Date: Fri, 12 Jan 2018 13:07:37 +0100
Message-ID: <20180112120747.27999-32-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1F949DF2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IKfZMt6O3XHA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:53 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26FE649DD8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:49 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id v123so2213564wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:39 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
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

When running a 32-bit VM (EL1 in AArch32), the AArch32 system registers
can be deferred to vcpu load/put on VHE systems because neither
the host kernel nor host userspace uses these registers.

Note that we can no longer save/restore DBGVCR32_EL2 conditionally based
on the state of the debug dirty flag on VHE, but since we do the
load/put pretty rarely, this comes out as a win anyway.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c    |  6 ------
 arch/arm64/kvm/hyp/sysreg-sr.c | 12 ++++++++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 2e04d404ac82..05f266b505ce 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -355,11 +355,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__vgic_restore_state(vcpu);
 
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
@@ -371,7 +366,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index eabd35154232..d225f5797651 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -195,7 +195,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
 
@@ -217,7 +217,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
 	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
@@ -242,6 +242,13 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_user_state(host_ctxt);
 
+	/*
+	 * Load guest EL1 and user state
+	 *
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 */
+	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_user_state(guest_ctxt);
 	__sysreg_restore_el1_state(guest_ctxt);
 
@@ -280,6 +287,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
 
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
-- 
2.14.2
