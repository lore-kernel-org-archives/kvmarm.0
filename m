From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 26/36] KVM: arm64: Defer saving/restoring system
 registers to vcpu load/put on VHE
Date: Fri, 15 Dec 2017 17:29:29 +0100
Message-ID: <20171215162929.GC910@cbox>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-27-christoffer.dall@linaro.org>
 <c45eaebe-57a1-7737-c515-111d497dd06e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c45eaebe-57a1-7737-c515-111d497dd06e@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 11, 2017 at 01:20:03PM +0000, Marc Zyngier wrote:
> On 07/12/17 17:06, Christoffer Dall wrote:
> > Some system registers do not affect the host kernel's execution and can
> > therefore be loaded when we are about to run a VCPU and we don't have to
> > restore the host state to the hardware before the time when we are
> > actually about to return to userspace or schedule out the VCPU thread.
> > 
> > The EL1 system registers and the userspace state registers, which only
> > affect EL0 execution, do not affect the host kernel's execution.
> > 
> > The 32-bit system registers are not used by a VHE host kernel and
> > therefore don't need to be saved/restored on every entry/exit to/from
> > the guest, but can be deferred to vcpu_load and vcpu_put, respectively.
> 
> Note that they are not used by the !VHE host kernel either, and I
> believe they could be deferred too, although that would imply a round
> trip to HYP to save/restore them. We already have such a hook there when
> configuring ICH_VMCR_EL2, so we may not need much of a new infrastructure.
> 

This turned out to be a bit trickier than I initial thought, and I think
it also revealed a bug around running 32-bit guests on VHE systems,
related to how DBGVCR32_EL2 is currently handled.

The result will look something like this (depending a bit on the rework
for the system register accesses discussed in the earlier patch):

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 0488841c6341..de98b99b1eec 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -92,13 +92,18 @@ static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 static inline void vcpu_set_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
-		if (vcpu->arch.sysregs_loaded_on_cpu)
-			__sysreg32_save_state(vcpu);
+		bool loaded;
+
+		preempt_disable();
+		loaded = vcpu->arch.sysregs32_loaded_on_cpu;
+		if (loaded)
+			kvm_call_hyp(__sysreg32_save_state, vcpu);
 
 		*vcpu_spsr32(vcpu) = val;
 
-		if (vcpu->arch.sysregs_loaded_on_cpu)
-			__sysreg32_restore_state(vcpu);
+		if (loaded)
+			kvm_call_hyp(__sysreg32_restore_state, vcpu);
+		preempt_enable();
 	}
 
 	if (vcpu->arch.sysregs_loaded_on_cpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 992c19816893..bc116d6c8756 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -283,6 +283,7 @@ struct kvm_vcpu_arch {
 	/* True when deferrable sysregs are loaded on the physical CPU,
 	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
 	bool sysregs_loaded_on_cpu;
+	bool sysregs32_loaded_on_cpu;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index ee87115eb12f..d80037b655b4 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -20,6 +20,7 @@
 
 #include <asm/debug-monitors.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 #define read_debug(r,n)		read_sysreg(r##n##_el1)
@@ -169,6 +170,9 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 
 	__debug_save_state(vcpu, host_dbg, host_ctxt);
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
+
+	if (vcpu_el1_is_32bit(vcpu))
+		write_sysreg(vcpu->arch.ctxt.sys_regs[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
 void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
@@ -192,6 +196,9 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
 	__debug_restore_state(vcpu, host_dbg, host_ctxt);
 
+	if (vcpu_el1_is_32bit(vcpu))
+		vcpu->arch.ctxt.sys_regs[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
+
 	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 05f266b505ce..48dc2c0b10d0 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -402,7 +402,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * We must restore the 32-bit state before the sysregs, thanks
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
-	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
@@ -414,7 +413,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 3c62c1c14b22..42eb0cc68079 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -181,7 +181,9 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
-	if (!vcpu_el1_is_32bit(vcpu))
+	vcpu = kern_hyp_va(vcpu);
+
+	if (!vcpu_el1_is_32bit(vcpu) || !vcpu->arch.sysregs32_loaded_on_cpu)
 		return;
 
 	spsr = vcpu->arch.ctxt.gp_regs.spsr;
@@ -195,15 +197,18 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
-		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
+	sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
+
+	vcpu->arch.sysregs32_loaded_on_cpu = false;
 }
 
 void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
 
-	if (!vcpu_el1_is_32bit(vcpu))
+	vcpu = kern_hyp_va(vcpu);
+
+	if (!vcpu_el1_is_32bit(vcpu) || vcpu->arch.sysregs32_loaded_on_cpu)
 		return;
 
 	spsr = vcpu->arch.ctxt.gp_regs.spsr;
@@ -217,8 +222,9 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
 	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
 
-	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
-		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
+	write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
+
+	vcpu->arch.sysregs32_loaded_on_cpu = true;
 }
 
 /**
@@ -237,19 +243,19 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 
+	/*
+	 * Erratum #852523 (Cortex-A57) or #853709 (Cortex-A72) requires us to
+	 * restore the 32-bit state before the sysregs, which will happen on
+	 * both VHE (below) and on non-VHE in the world-switch path.
+	 */
+	kvm_call_hyp(__sysreg32_restore_state, vcpu);
+
 	if (!has_vhe())
 		return;
 
 	__sysreg_save_user_state(host_ctxt);
 
-
-	/*
-	 * Load guest EL1 and user state
-	 *
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
+	/* Load guest EL1 and user state */
 	__sysreg_restore_user_state(guest_ctxt);
 	__sysreg_restore_el1_state(guest_ctxt);
 
@@ -283,12 +289,13 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_vfp_loaded = 0;
 	}
 
+	kvm_call_hyp(__sysreg32_save_state, vcpu);
+
 	if (!has_vhe())
 		return;
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);


For now, I'll stash this as a separate patch as it will improve
readability and make it easier to bisect things.

Thanks,
-Christoffer
