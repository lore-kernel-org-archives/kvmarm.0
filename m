From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] arm64: kvm: Use has_vhe() instead of
 hyp_alternate_select()
Date: Thu, 9 Mar 2017 01:16:47 -0800
Message-ID: <20170309091514.GB114347@lvm>
References: <1488767598-2055-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F38F140B3E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:15:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2hTE573M58s for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 04:15:25 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A609408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 04:15:24 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id n11so50822651wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 01:16:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1488767598-2055-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Sun, Mar 05, 2017 at 08:33:18PM -0600, Shanker Donthineni wrote:
> Now all the cpu_hwcaps features have their own static keys. We don't
> need a separate function hyp_alternate_select() to patch the vhe/nvhe
> code. We can achieve the same functionality by using has_vhe(). It
> improves the code readability, uses the jump label instructions, and
> also compiler generates the better code with a fewer instructions.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>

I have no objections against this patch as such, but I have a number of
more substantial changes which will get rid of most of the
hyp_alternate_select later, and since there's no immediate need to merge
this patch, and there's the risk that it may slow down some things on
certain platforms with older compilers, I'd like to hold off on merging
this patch until the next merge window and revisit this issue at that
point.

Thanks,
-Christoffer

> ---
> v2: removed 'Change-Id: Ia8084189833f2081ff13c392deb5070c46a64038' from commit
> 
>  arch/arm64/kvm/hyp/debug-sr.c  | 12 ++++++----
>  arch/arm64/kvm/hyp/switch.c    | 50 +++++++++++++++++++-----------------------
>  arch/arm64/kvm/hyp/sysreg-sr.c | 23 +++++++++----------
>  3 files changed, 43 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index f5154ed..e5642c2 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -109,9 +109,13 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
>  	dsb(nsh);
>  }
>  
> -static hyp_alternate_select(__debug_save_spe,
> -			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __debug_save_spe(u64 *pmscr_el1)
> +{
> +	if (has_vhe())
> +		__debug_save_spe_vhe(pmscr_el1);
> +	else
> +		__debug_save_spe_nvhe(pmscr_el1);
> +}
>  
>  static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
>  {
> @@ -180,7 +184,7 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
>  
>  	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
>  			   kern_hyp_va(vcpu->arch.host_cpu_context));
> -	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
> +	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
>  }
>  
>  void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index aede165..c5c77b8 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -33,13 +33,9 @@ static bool __hyp_text __fpsimd_enabled_vhe(void)
>  	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
>  }
>  
> -static hyp_alternate_select(__fpsimd_is_enabled,
> -			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> -
>  bool __hyp_text __fpsimd_enabled(void)
>  {
> -	return __fpsimd_is_enabled()();
> +	return has_vhe() ? __fpsimd_enabled_vhe() : __fpsimd_enabled_nvhe();
>  }
>  
>  static void __hyp_text __activate_traps_vhe(void)
> @@ -63,9 +59,10 @@ static void __hyp_text __activate_traps_nvhe(void)
>  	write_sysreg(val, cptr_el2);
>  }
>  
> -static hyp_alternate_select(__activate_traps_arch,
> -			    __activate_traps_nvhe, __activate_traps_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __activate_traps_arch(void)
> +{
> +	has_vhe() ? __activate_traps_vhe() : __activate_traps_nvhe();
> +}
>  
>  static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  {
> @@ -97,7 +94,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>  	write_sysreg(0, pmselr_el0);
>  	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> -	__activate_traps_arch()();
> +	__activate_traps_arch();
>  }
>  
>  static void __hyp_text __deactivate_traps_vhe(void)
> @@ -127,9 +124,10 @@ static void __hyp_text __deactivate_traps_nvhe(void)
>  	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
>  }
>  
> -static hyp_alternate_select(__deactivate_traps_arch,
> -			    __deactivate_traps_nvhe, __deactivate_traps_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __deactivate_traps_arch(void)
> +{
> +	has_vhe() ? __deactivate_traps_vhe() : __deactivate_traps_nvhe();
> +}
>  
>  static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>  {
> @@ -142,7 +140,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.hcr_el2 & HCR_VSE)
>  		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
>  
> -	__deactivate_traps_arch()();
> +	__deactivate_traps_arch();
>  	write_sysreg(0, hstr_el2);
>  	write_sysreg(0, pmuserenr_el0);
>  }
> @@ -183,20 +181,14 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
>  		__vgic_v2_restore_state(vcpu);
>  }
>  
> -static bool __hyp_text __true_value(void)
> +static bool __check_arm_834220(void)
>  {
> -	return true;
> -}
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_834220))
> +		return true;
>  
> -static bool __hyp_text __false_value(void)
> -{
>  	return false;
>  }
>  
> -static hyp_alternate_select(__check_arm_834220,
> -			    __false_value, __true_value,
> -			    ARM64_WORKAROUND_834220);
> -
>  static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  {
>  	u64 par, tmp;
> @@ -251,7 +243,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>  	 * resolve the IPA using the AT instruction.
>  	 */
>  	if (!(esr & ESR_ELx_S1PTW) &&
> -	    (__check_arm_834220()() || (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
> +	    (__check_arm_834220() || (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
>  		if (!__translate_far_to_hpfar(far, &hpfar))
>  			return false;
>  	} else {
> @@ -406,9 +398,13 @@ static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par)
>  	      (void *)read_sysreg(tpidr_el2));
>  }
>  
> -static hyp_alternate_select(__hyp_call_panic,
> -			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __hyp_call_panic(u64 spsr, u64 elr, u64 par)
> +{
> +	if (has_vhe())
> +		__hyp_call_panic_vhe(spsr, elr, par);
> +	else
> +		__hyp_call_panic_nvhe(spsr, elr, par);
> +}
>  
>  void __hyp_text __noreturn __hyp_panic(void)
>  {
> @@ -428,7 +424,7 @@ void __hyp_text __noreturn __hyp_panic(void)
>  	}
>  
>  	/* Call panic for real */
> -	__hyp_call_panic()(spsr, elr, par);
> +	__hyp_call_panic(spsr, elr, par);
>  
>  	unreachable();
>  }
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 9341376..2a6cb27 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -21,9 +21,6 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_hyp.h>
>  
> -/* Yes, this does nothing, on purpose */
> -static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
> -
>  /*
>   * Non-VHE: Both host and guest must save everything.
>   *
> @@ -68,13 +65,15 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
>  	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
>  }
>  
> -static hyp_alternate_select(__sysreg_call_save_host_state,
> -			    __sysreg_save_state, __sysreg_do_nothing,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __sysreg_call_save_host_state(struct kvm_cpu_context *ctxt)
> +{
> +	if (!has_vhe())
> +		__sysreg_save_state(ctxt);
> +}
>  
>  void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
>  {
> -	__sysreg_call_save_host_state()(ctxt);
> +	__sysreg_call_save_host_state(ctxt);
>  	__sysreg_save_common_state(ctxt);
>  }
>  
> @@ -121,13 +120,15 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
>  }
>  
> -static hyp_alternate_select(__sysreg_call_restore_host_state,
> -			    __sysreg_restore_state, __sysreg_do_nothing,
> -			    ARM64_HAS_VIRT_HOST_EXTN);
> +static void __hyp_text __sysreg_call_restore_host_state(struct kvm_cpu_context *ctxt)
> +{
> +	if (!has_vhe())
> +		__sysreg_restore_state(ctxt);
> +}
>  
>  void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
>  {
> -	__sysreg_call_restore_host_state()(ctxt);
> +	__sysreg_call_restore_host_state(ctxt);
>  	__sysreg_restore_common_state(ctxt);
>  }
>  
> -- 
> Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 
