From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 43/85] KVM: arm64: Defer saving/restoring 32-bit sysregs to
 vcpu load/put
Date: Wed, 28 Mar 2018 13:52:12 +0100
Message-ID: <20180328125254.31380-44-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 735784A089
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:51:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y9F0dMl8t92W for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:51:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 637EE4A08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:47:54 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When running a 32-bit VM (EL1 in AArch32), the AArch32 system registers
can be deferred to vcpu load/put on VHE systems because neither
the host kernel nor host userspace uses these registers.

Note that we can't save DBGVCR32_EL2 conditionally based on the state of
the debug dirty flag on VHE after this change, because during
vcpu_load() we haven't calculated a valid debug flag yet, and when we've
restored the register during vcpu_load() we also have to save it during
vcpu_put().  This means that we'll always restore/save the register for
VHE on load/put, but luckily vcpu load/put are called rarely, so saving
an extra register unconditionally shouldn't significantly hurt
performance.

We can also not defer saving FPEXC32_32 because this register only holds
a guest-valid value for 32-bit guests during the exit path when the
guest has used FPSIMD registers and restored the register in the early
assembly handler from taking the EL2 fault, and therefore we have to
check if fpsimd is enabled for the guest in the exit path and save the
register then, for both VHE and non-VHE guests.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c    | 17 +++++++++++------
 arch/arm64/kvm/hyp/sysreg-sr.c | 15 ++++++++++-----
 arch/arm64/kvm/sys_regs.c      |  6 ++++++
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ec31e447dd7f..9b0380d3c9c3 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -47,6 +47,15 @@ bool __hyp_text __fpsimd_enabled(void)
 	return __fpsimd_is_enabled()();
 }
 
+/* Save the 32-bit only FPSIMD system register state */
+static void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_el1_is_32bit(vcpu))
+		return;
+
+	vcpu->arch.ctxt.sys_regs[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
+}
+
 static void __hyp_text __activate_traps_vhe(void)
 {
 	u64 val;
@@ -380,11 +389,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__vgic_restore_state(vcpu);
 
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
@@ -398,7 +402,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	fp_enabled = __fpsimd_enabled();
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
@@ -408,6 +411,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+		__fpsimd_save_fpexc32(vcpu);
 	}
 
 	__debug_switch_to_host(vcpu);
@@ -477,6 +481,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
+		__fpsimd_save_fpexc32(vcpu);
 	}
 
 	/*
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9c60b8062724..aacba4636871 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -196,10 +196,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
 
-	if (__fpsimd_enabled())
-		sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
-
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
 
@@ -221,7 +218,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
 	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
@@ -246,6 +243,13 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 
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
 
@@ -273,6 +277,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
 
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 17eb7772e059..806b0b126a64 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -112,6 +112,9 @@ u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
 	case AMAIR_EL1:		return read_sysreg_s(amair_EL12);
 	case CNTKCTL_EL1:	return read_sysreg_s(cntkctl_EL12);
 	case PAR_EL1:		return read_sysreg_s(SYS_PAR_EL1);
+	case DACR32_EL2:	return read_sysreg_s(SYS_DACR32_EL2);
+	case IFSR32_EL2:	return read_sysreg_s(SYS_IFSR32_EL2);
+	case DBGVCR32_EL2:	return read_sysreg_s(SYS_DBGVCR32_EL2);
 	}
 
 immediate_read:
@@ -152,6 +155,9 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	case AMAIR_EL1:		write_sysreg_s(val, amair_EL12);	return;
 	case CNTKCTL_EL1:	write_sysreg_s(val, cntkctl_EL12);	return;
 	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	return;
+	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	return;
+	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	return;
+	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	return;
 	}
 
 immediate_write:
-- 
2.14.2
