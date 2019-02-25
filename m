From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 1/6] arm64/kvm: preserve host HCR_EL2 value
Date: Mon, 25 Feb 2019 17:39:58 +0000
Message-ID: <ba023672-92f5-41dd-1194-4ab4f647b204@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-2-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-2-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/02/2019 09:24, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
> is a constant value. This works today, as the host HCR_EL2 value is
> always the same, but this will get in the way of supporting extensions
> that require HCR_EL2 bits to be set conditionally for the host.
> 
> To allow such features to work without KVM having to explicitly handle
> every possible host feature combination, this patch has KVM save/restore
> for the host HCR when switching to/from a guest HCR. The saving of the
> register is done once during cpu hypervisor initialization state and is
> just restored after switch from guest.
> 
> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
> kvm_call_hyp and is helpful in NHVE case.
> 
> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
> to toggle the TGE bit with a RMW sequence, as we already do in
> __tlb_switch_to_guest_vhe().
> 
> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
> and guest can now use this field in a common way.


> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index ca56537..05706b4 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -273,6 +273,8 @@ static inline void __cpu_init_stage2(void)
>  	kvm_call_hyp(__init_stage2_translation);
>  }
>  
> +static inline void __cpu_copy_hyp_conf(void) {}
> +

I agree Mark's suggestion of adding 'host_ctxt' in here makes it clearer what it is.


> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 506386a..0dbe795 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h

Hmmm, there is still a fair amount of churn due to moving the struct definition, but its
easy enough to ignore as its mechanical. A preparatory patch that switched as may as
possible to '*vcpu_hcr() = ' would cut the churn down some more, but I don't think its
worth the extra effort.


> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index a80a7ef..6e65cad 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -151,7 +151,7 @@ void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>  bool __fpsimd_enabled(void);
>  
>  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> -void deactivate_traps_vhe_put(void);
> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);

I've forgotten why this is needed. You don't add a user of vcpu to
deactivate_traps_vhe_put() in this patch.


> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index b0b1478..006bd33 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -191,7 +194,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)

> -void deactivate_traps_vhe_put(void)
> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
>  {
>  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>  

Why does deactivate_traps_vhe_put() need the vcpu?


> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7732d0b..1b2e05b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -458,6 +459,16 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>
>  static inline void __cpu_init_stage2(void) {}
>
> +/**
> + * __cpu_copy_hyp_conf - copy the boot hyp configuration registers
> + *
> + * It is called once per-cpu during CPU hyp initialisation.
> + */

Is it just the boot cpu?


> +static inline void __cpu_copy_hyp_conf(void)
> +{
> +	kvm_call_hyp(__kvm_populate_host_regs);
> +}
> +


> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index 68d6f7c..68ddc0f 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -21,6 +21,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>

... what's kvm_mmu.h needed for?
The __hyp_this_cpu_ptr() you add comes from kvm_asm.h.

/me tries it.

Heh, hyp_symbol_addr(). kvm_asm.h should include this, but can't because the
kvm_ksym_ref() dependency is the other-way round. This is just going to bite us somewhere
else later!
If we want to fix it now, moving hyp_symbol_addr() to kvm_asm.h would fix it. It's
generating adrp/add so the 'asm' label is fair, and it really should live with its EL1
counterpart kvm_ksym_ref().


> @@ -294,7 +295,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>  	if (!has_vhe())
>  		return;
>  
> -	deactivate_traps_vhe_put();
> +	deactivate_traps_vhe_put(vcpu);
>  
>  	__sysreg_save_el1_state(guest_ctxt);
>  	__sysreg_save_user_state(guest_ctxt);
> @@ -316,3 +317,21 @@ void __hyp_text __kvm_enable_ssbs(void)
>  	"msr	sctlr_el2, %0"
>  	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
>  }
> +
> +/**
> + * __kvm_populate_host_regs - Stores host register values
> + *
> + * This function acts as a function handler parameter for kvm_call_hyp and
> + * may be called from EL1 exception level to fetch the register value.
> + */
> +void __hyp_text __kvm_populate_host_regs(void)
> +{
> +	struct kvm_cpu_context *host_ctxt;


> +	if (has_vhe())
> +		host_ctxt = this_cpu_ptr(&kvm_host_cpu_state);
> +	else
> +		host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);

You can use __hyp_this_cpu_ptr() here, even on VHE.

For VHE the guts are the same and its simpler to use the same version in both cases.


__hyp_this_cpu_ptr(sym) == hyp_symbol_addr(sym) + tpidr_el2;

hyp_symbol_addr() here is just to guarantee the address is generated based on where we're
executing from, not loaded from a literal pool which would give us the link-time address.
(or whenever kaslr applied the relocations). This matters for non-VHE because the compiler
can't know the code has an EL2 address as well as its link-time address.

This doesn't matter for VHE, as there is no additional different address.

(the other trickery is on non-VHE the tpidr_el2 value isn't actually the same as the
hosts.. but on VHE it is)


> +	host_ctxt->hcr_el2 = read_sysreg(hcr_el2);
> +}


> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 9e350fd3..8e18f7f 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1328,6 +1328,7 @@ static void cpu_hyp_reinit(void)
>  		cpu_init_hyp_mode(NULL);
>  
>  	kvm_arm_init_debug();
> +	__cpu_copy_hyp_conf();

Your commit message says:
| The saving of the register is done once during cpu hypervisor initialization state

But cpu_hyp_reinit() is called each time secondary CPUs come online. Its also called as
part of the cpu-idle mechanism via hyp_init_cpu_pm_notifier(). cpu-idle can ask the
firmware to power-off the CPU until an interrupt becomes pending for it. KVM's EL2 state
disappears when this happens, these calls take care of setting it back up again. On Juno,
this can happen tens of times a second, and this adds an extra call to EL2.

init_subsystems() would be the alternative place for this, but it wouldn't catch CPUs that
came online after booting. I think you need something in cpu_hyp_reinit() or
__cpu_copy_hyp_conf() to ensure it only happens once per CPU.

I think you can test whether the HCR_EL2 value is zero, assuming zero means uninitialised.
A VHE system would always set E2H, and a non-VHE system has to set RW.


>  	if (vgic_present)
>  		kvm_vgic_init_cpu_hardware();
> 


Thanks,

James
