From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 28/36] KVM: arm64: Configure FPSIMD traps on vcpu
 load/put for VHE
Date: Mon, 11 Dec 2017 14:18:11 +0000
Message-ID: <28451dbb-1aa8-bdd3-20df-b3ede0c7031d@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-29-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-29-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/17 17:06, Christoffer Dall wrote:
> There is no need to enable/disable traps to FP registers on every switch
> to/from the VM, because the host kernel does not use this resource
> without calling vcpu_put.  We can therefore move things around enough
> that we still always write FPEXC32_EL2 before programming CPTR_EL2 but
> only program these during vcpu load/put.

Same as the 32bit registers. I don't see the point in limiting this to
be VHE only. Or am I missing something?

Thanks,

	M.

> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  3 +++
>  arch/arm64/kvm/hyp/switch.c      | 34 ++++++++++++++++++++++++----------
>  arch/arm64/kvm/hyp/sysreg-sr.c   |  4 ++++
>  3 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 3f54c55f77a1..28d5f3cb4001 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -148,6 +148,9 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>  bool __fpsimd_enabled(void);
>  
> +void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> +void deactivate_traps_vhe_put(void);
> +
>  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>  void __noreturn __hyp_do_panic(unsigned long, ...);
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index c01bcfc3fb52..44aae69a7fec 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -24,22 +24,25 @@
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
>  
> -static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> +static void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  {
>  	/*
> -	 * We are about to set CPTR_EL2.TFP to trap all floating point
> -	 * register accesses to EL2, however, the ARM ARM clearly states that
> -	 * traps are only taken to EL2 if the operation would not otherwise
> -	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
> -	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
> -	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
> -	 * it will cause an exception.
> +	 * We are about to trap all floating point register accesses to EL2,
> +	 * however, traps are only taken to EL2 if the operation would not
> +	 * otherwise trap to EL1.  Therefore, always make sure that for 32-bit
> +	 * guests, we set FPEXC.EN to prevent traps to EL1, when setting the
> +	 * TFP bit.  If FP/ASIMD is not implemented, FPEXC is UNDEFINED and
> +	 * any access to it will cause an exception.
>  	 */
>  	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
>  	    !vcpu->arch.guest_vfp_loaded) {
>  		write_sysreg(1 << 30, fpexc32_el2);
>  		isb();
>  	}
> +}
> +
> +static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> +{
>  	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
>  
>  	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
> @@ -61,10 +64,12 @@ static void __hyp_text __deactivate_traps_common(void)
>  	write_sysreg(0, pmuserenr_el0);
>  }
>  
> -static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> +void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
> +	__activate_traps_fpsimd32(vcpu);
> +
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
>  	val &= ~CPACR_EL1_ZEN;
> @@ -73,7 +78,15 @@ static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
>  	else
>  		val &= ~CPACR_EL1_FPEN;
>  	write_sysreg(val, cpacr_el1);
> +}
>  
> +void deactivate_traps_vhe_put(void)
> +{
> +	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
> +}
> +
> +static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> +{
>  	write_sysreg(__kvm_hyp_vector, vbar_el1);
>  }
>  
> @@ -81,6 +94,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
> +	__activate_traps_fpsimd32(vcpu);
> +
>  	val = CPTR_EL2_DEFAULT;
>  	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
>  	if (vcpu->arch.guest_vfp_loaded)
> @@ -111,7 +126,6 @@ static void __hyp_text __deactivate_traps_vhe(void)
>  
>  	write_sysreg(mdcr_el2, mdcr_el2);
>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> -	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
>  	write_sysreg(vectors, vbar_el1);
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 65abf1aeba59..b647fea93fdc 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -254,6 +254,8 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>  	__sysreg_restore_el1_state(guest_ctxt);
>  
>  	vcpu->arch.sysregs_loaded_on_cpu = true;
> +
> +	activate_traps_vhe_load(vcpu);
>  }
>  
>  /**
> @@ -286,6 +288,8 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>  	if (!has_vhe())
>  		return;
>  
> +	deactivate_traps_vhe_put();
> +
>  	__sysreg_save_el1_state(guest_ctxt);
>  	__sysreg_save_user_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
> 


-- 
Jazz is not dead. It just smells funny...
