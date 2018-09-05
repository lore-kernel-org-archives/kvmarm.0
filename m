From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: Treat FPEXC32_EL2 as a regular guest
 system register
Date: Wed, 5 Sep 2018 17:08:38 +0200
Message-ID: <20180905150838.GU4029@e113682-lin.lund.arm.com>
References: <1536153553-28767-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB49B4A1D8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Sep 2018 11:08:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V-Yt5S9y+OYx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Sep 2018 11:08:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 232BF4A1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Sep 2018 11:08:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1536153553-28767-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 05, 2018 at 02:19:13PM +0100, Dave Martin wrote:
> Currently FPEXC32_EL2 is handled specially when context-switching.
> This made sense for arm, where FPEXC affects host execution
> (including VFP/SIMD register save/restore at Hyp).
> 
> However, FPEXC has no architectural effect when running in AArch64.
> The only case where an arm64 host may execute in AArch32 is when
> running compat user code at EL0: the architecture explicitly
> documents FPEXC as having no effect in this case either when the
> kernel (EL2 in the VHE case; otherwise EL1) is AArch64.
> 
> So, we can just handle FPEXC32_EL2 (which is the AArch64 alias for
> this register) as a regular AArch32-only system register and switch
> it without any special handling or synchronisation.
> 
> This allows some gnarly special-case code to be eliminated from
> hyp.  The extra isb() in __activate_traps_fpsimd32() is dropped
> too: for the reasons explained above arm64 never required this
> anyway.

This looks like a reasonable cleanup, but I don't understand how this
works.  The reason we had the special casing of FPXEC_EL2 was to ensure
that we trap to EL2 when VFP should be trapped for a 32-bit guest
instead of going to EL1.  How does that work with this patch if we set
CPTR_EL2.TFP and the guest has set FPXEX32_EL2.EN ?

Thanks,

    Christoffer

> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Alexander Graf <agraf@suse.de>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
> 
> I could do with some confirmation from someone that my interpretation of
> the architecture is in fact correct here.  The CheckFPAdvSIMDEnabled64()
> and CheckAdvSIMDEnabled() pseudocode functions may be a reasonable
> starting point (this was my reference where the wordy text is unclear).
> 
> If Alexander could try this out, that would be good.
> 
> This cleanup applies on top of the following previously pubished fix:
> [PULL 2/4] arm64: KVM: Only force FPEXC32_EL2.EN if trapping FPSIMD
> http://lists.infradead.org/pipermail/linux-arm-kernel/2018-September/599537.html
> 
> 
>  arch/arm64/kvm/hyp/switch.c    | 45 ++----------------------------------------
>  arch/arm64/kvm/hyp/sysreg-sr.c |  2 ++
>  2 files changed, 4 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index ca46153..0450b85 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -43,32 +43,6 @@ static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
>  	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
>  }
>  
> -/* Save the 32-bit only FPSIMD system register state */
> -static void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
> -{
> -	if (!vcpu_el1_is_32bit(vcpu))
> -		return;
> -
> -	vcpu->arch.ctxt.sys_regs[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
> -}
> -
> -static void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * We are about to set CPTR_EL2.TFP to trap all floating point
> -	 * register accesses to EL2, however, the ARM ARM clearly states that
> -	 * traps are only taken to EL2 if the operation would not otherwise
> -	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> -	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> -	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
> -	 * it will cause an exception.
> -	 */
> -	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
> -		write_sysreg(1 << 30, fpexc32_el2);
> -		isb();
> -	}
> -}
> -
>  static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
>  {
>  	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
> @@ -98,10 +72,8 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
>  	val &= ~CPACR_EL1_ZEN;
> -	if (!update_fp_enabled(vcpu)) {
> +	if (!update_fp_enabled(vcpu))
>  		val &= ~CPACR_EL1_FPEN;
> -		__activate_traps_fpsimd32(vcpu);
> -	}
>  
>  	write_sysreg(val, cpacr_el1);
>  
> @@ -116,10 +88,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> -	if (!update_fp_enabled(vcpu)) {
> +	if (!update_fp_enabled(vcpu))
>  		val |= CPTR_EL2_TFP;
> -		__activate_traps_fpsimd32(vcpu);
> -	}
>  
>  	write_sysreg(val, cptr_el2);
>  }
> @@ -366,11 +336,6 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>  
>  	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
>  
> -	/* Skip restoring fpexc32 for AArch64 guests */
> -	if (!(read_sysreg(hcr_el2) & HCR_RW))
> -		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
> -			     fpexc32_el2);
> -
>  	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
>  
>  	return true;
> @@ -522,9 +487,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	sysreg_restore_host_state_vhe(host_ctxt);
>  
> -	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
> -		__fpsimd_save_fpexc32(vcpu);
> -
>  	__debug_switch_to_host(vcpu);
>  
>  	return exit_code;
> @@ -580,9 +542,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_restore_state_nvhe(host_ctxt);
>  
> -	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
> -		__fpsimd_save_fpexc32(vcpu);
> -
>  	/*
>  	 * This must come after restoring the host sysregs, since a non-VHE
>  	 * system may enable SPE here and make use of the TTBRs.
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 9ce2239..12994a9 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -195,6 +195,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
>  
>  	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
>  	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
> +	sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
>  
>  	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
>  		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
> @@ -217,6 +218,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
>  
>  	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
>  	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
> +	write_sysreg(sysreg[FPEXC32_EL2], fpexc32_el2);
>  
>  	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
>  		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
> -- 
> 2.1.4
> 
