From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH v3 33/41] KVM: arm64: Configure FPSIMD traps on vcpu
 load/put
Date: Wed, 31 Jan 2018 13:17:36 +0100
Message-ID: <a182d82e-73e0-8bfa-1d10-166b73ac1fdf@semihalf.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-34-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-34-christoffer.dall@linaro.org>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 12.01.2018 13:07, Christoffer Dall wrote:
> There is no need to enable/disable traps to FP registers on every switch
> to/from the VM, because the host kernel does not use this resource
> without calling vcpu_put.  We can therefore move things around enough
> that we still always write FPEXC32_EL2 before programming CPTR_EL2 but
> only program these during vcpu load/put.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>   arch/arm64/include/asm/kvm_hyp.h |  6 +++++
>   arch/arm64/kvm/hyp/switch.c      | 51 +++++++++++++++++++++++++++++-----------
>   arch/arm64/kvm/hyp/sysreg-sr.c   | 12 ++++++++--
>   3 files changed, 53 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 3f54c55f77a1..ffd62e31f134 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -148,6 +148,12 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
>   void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>   bool __fpsimd_enabled(void);
>   
> +void __activate_traps_nvhe_load(struct kvm_vcpu *vcpu);
> +void __deactivate_traps_nvhe_put(void);
> +
> +void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> +void deactivate_traps_vhe_put(void);
> +
>   u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>   void __noreturn __hyp_do_panic(unsigned long, ...);
>   
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index c01bcfc3fb52..d14ab9650f81 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -24,22 +24,25 @@
>   #include <asm/fpsimd.h>
>   #include <asm/debug-monitors.h>
>   
> -static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> +static void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>   {
>   	/*
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
>   	 */
>   	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
>   	    !vcpu->arch.guest_vfp_loaded) {
>   		write_sysreg(1 << 30, fpexc32_el2);
>   		isb();
>   	}
> +}
> +
> +static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
> +{
>   	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
>   
>   	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
> @@ -61,10 +64,12 @@ static void __hyp_text __deactivate_traps_common(void)
>   	write_sysreg(0, pmuserenr_el0);
>   }
>   
> -static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> +void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
>   {
>   	u64 val;
>   
> +	__activate_traps_fpsimd32(vcpu);
> +
>   	val = read_sysreg(cpacr_el1);
>   	val |= CPACR_EL1_TTA;
>   	val &= ~CPACR_EL1_ZEN;
> @@ -73,14 +78,26 @@ static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
>   	else
>   		val &= ~CPACR_EL1_FPEN;
>   	write_sysreg(val, cpacr_el1);

Giving that you move this code to kvm_vcpu_load_sysregs() I am wondering 
if we have to deactivate FPEN trap here. IIUC, we call 
kvm_vcpu_load_sysregs()->activate_traps_vhe_load() and then 
kvm_vcpu_put_sysregs() by design. So vcpu->arch.guest_vfp_loaded should 
be always 0 here since it is zeroed in kvm_vcpu_put_sysregs(). The same 
for nvhe case below.

I might miss some scenario or future changes you are planning to do. Let 
me know your thoughts.

Thanks,
Tomasz

> +}
>   
> +void deactivate_traps_vhe_put(void)
> +{
> +	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
> +}
> +
> +static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
> +{
>   	write_sysreg(__kvm_hyp_vector, vbar_el1);
>   }
>   
> -static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> +void __hyp_text __activate_traps_nvhe_load(struct kvm_vcpu *vcpu)
>   {
>   	u64 val;
>   
> +	vcpu = kern_hyp_va(vcpu);
> +
> +	__activate_traps_fpsimd32(vcpu);
> +
>   	val = CPTR_EL2_DEFAULT;
>   	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
>   	if (vcpu->arch.guest_vfp_loaded)
> @@ -90,6 +107,15 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>   	write_sysreg(val, cptr_el2);
>   }
>   
> +void __hyp_text __deactivate_traps_nvhe_put(void)
> +{
> +	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
> +}
> +
> +static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
> +{
> +}
> +
>   static hyp_alternate_select(__activate_traps_arch,
>   			    __activate_traps_nvhe, __activate_traps_vhe,
>   			    ARM64_HAS_VIRT_HOST_EXTN);
> @@ -111,12 +137,10 @@ static void __hyp_text __deactivate_traps_vhe(void)
>   
>   	write_sysreg(mdcr_el2, mdcr_el2);
>   	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
> -	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
>   	write_sysreg(vectors, vbar_el1);
>   }
>   
> -static void __hyp_text __deactivate_traps_nvhe(void)
> -{
> +static void __hyp_text __deactivate_traps_nvhe(void) {
>   	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>   
>   	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
> @@ -124,7 +148,6 @@ static void __hyp_text __deactivate_traps_nvhe(void)
>   
>   	write_sysreg(mdcr_el2, mdcr_el2);
>   	write_sysreg(HCR_RW, hcr_el2);
> -	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
>   }
>   
>   static hyp_alternate_select(__deactivate_traps_arch,
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index d225f5797651..7943d5b4dbcb 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -237,8 +237,10 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>   	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
>   	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
>   
> -	if (!has_vhe())
> +	if (!has_vhe()) {
> +		kvm_call_hyp(__activate_traps_nvhe_load, vcpu);
>   		return;
> +	}
>   
>   	__sysreg_save_user_state(host_ctxt);
>   
> @@ -253,6 +255,8 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
>   	__sysreg_restore_el1_state(guest_ctxt);
>   
>   	vcpu->arch.sysregs_loaded_on_cpu = true;
> +
> +	activate_traps_vhe_load(vcpu);
>   }
>   
>   /**
> @@ -282,8 +286,12 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>   		vcpu->arch.guest_vfp_loaded = 0;
>   	}
>   
> -	if (!has_vhe())
> +	if (!has_vhe()) {
> +		kvm_call_hyp(__deactivate_traps_nvhe_put);
>   		return;
> +	}
> +
> +	deactivate_traps_vhe_put();
>   
>   	__sysreg_save_el1_state(guest_ctxt);
>   	__sysreg_save_user_state(guest_ctxt);
> 
