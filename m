From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/41] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Tue, 13 Feb 2018 09:52:19 +0100
Message-ID: <20180213085219.GC23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-10-christoffer.dall@linaro.org>
 <f29aa630-50af-8686-8274-f099987feba1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f29aa630-50af-8686-8274-f099987feba1@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 03:26:59PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> >Avoid saving the guest VFP registers and restoring the host VFP
> >registers on every exit from the VM.  Only when we're about to run
> >userspace or other threads in the kernel do we really have to switch the
> 
> s/do// ?
> 
> >state back to the host state.
> >
> >We still initially configure the VFP registers to trap when entering the
> >VM, but the difference is that we now leave the guest state in the
> >hardware registers as long as we're running this VCPU, even if we
> >occasionally trap to the host, and we only restore the host state when
> >we return to user space or when scheduling another thread.
> >
> >Reviewed-by: Andrew Jones <drjones@redhat.com>
> >Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kernel/asm-offsets.c   |  1 +
> >  arch/arm64/kvm/hyp/entry.S        |  3 +++
> >  arch/arm64/kvm/hyp/switch.c       | 48 ++++++++++++---------------------------
> >  arch/arm64/kvm/hyp/sysreg-sr.c    | 21 ++++++++++++++---
> >  5 files changed, 40 insertions(+), 36 deletions(-)
> >
> >diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> >index 0e9e7291a7e6..9e23bc968668 100644
> >--- a/arch/arm64/include/asm/kvm_host.h
> >+++ b/arch/arm64/include/asm/kvm_host.h
> >@@ -213,6 +213,9 @@ struct kvm_vcpu_arch {
> >  	/* Guest debug state */
> >  	u64 debug_flags;
> >+	/* 1 if the guest VFP state is loaded into the hardware */
> >+	u8 guest_vfp_loaded;
> >+
> >  	/*
> >  	 * We maintain more than a single set of debug registers to support
> >  	 * debugging the guest from the host and to maintain separate host and
> >diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> >index 612021dce84f..99467327c043 100644
> >--- a/arch/arm64/kernel/asm-offsets.c
> >+++ b/arch/arm64/kernel/asm-offsets.c
> >@@ -133,6 +133,7 @@ int main(void)
> >    DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
> >    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
> >    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
> >+  DEFINE(VCPU_GUEST_VFP_LOADED,	offsetof(struct kvm_vcpu, arch.guest_vfp_loaded));
> >    DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
> >    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> >    DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
> >diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> >index a360ac6e89e9..53652287a236 100644
> >--- a/arch/arm64/kvm/hyp/entry.S
> >+++ b/arch/arm64/kvm/hyp/entry.S
> >@@ -184,6 +184,9 @@ alternative_endif
> >  	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> >  	bl	__fpsimd_restore_state
> >+	mov	x0, #1
> >+	strb	w0, [x3, #VCPU_GUEST_VFP_LOADED]
> >+
> >  	// Skip restoring fpexc32 for AArch64 guests
> >  	mrs	x1, hcr_el2
> >  	tbnz	x1, #HCR_RW_SHIFT, 1f
> >diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >index 12dc647a6e5f..29e44a20f5e3 100644
> >--- a/arch/arm64/kvm/hyp/switch.c
> >+++ b/arch/arm64/kvm/hyp/switch.c
> >@@ -24,43 +24,32 @@
> >  #include <asm/fpsimd.h>
> >  #include <asm/debug-monitors.h>
> >-static bool __hyp_text __fpsimd_enabled_nvhe(void)
> >-{
> >-	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
> >-}
> >-
> >-static bool __hyp_text __fpsimd_enabled_vhe(void)
> >-{
> >-	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
> >-}
> >-
> >-static hyp_alternate_select(__fpsimd_is_enabled,
> >-			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
> >-			    ARM64_HAS_VIRT_HOST_EXTN);
> >-
> >-bool __hyp_text __fpsimd_enabled(void)
> 
> Now that __fpsimd_enabled is removed, I think you need to remove the
> prototype in arch/arm64/include/kvm_hyp.h too.
> 
Will do.

Thanks,
-Christoffer
