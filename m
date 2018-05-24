From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 12/14] arm64: KVM: Add ARCH_WORKAROUND_2 support for
 guests
Date: Thu, 24 May 2018 13:15:07 +0100
Message-ID: <20180524121507.kocupewjagu7c4lw@lakrids.cambridge.arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522150648.28297-13-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 04:06:46PM +0100, Marc Zyngier wrote:
> In order to offer ARCH_WORKAROUND_2 support to guests, we need
> a bit of infrastructure.
> 
> Let's add a flag indicating whether or not the guest uses
> SSBD mitigation. Depending on the state of this flag, allow
> KVM to disable ARCH_WORKAROUND_2 before entering the guest,
> and enable it when exiting it.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm/include/asm/kvm_mmu.h    |  5 +++++
>  arch/arm64/include/asm/kvm_asm.h  |  3 +++
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/include/asm/kvm_mmu.h  | 24 ++++++++++++++++++++++
>  arch/arm64/kvm/hyp/switch.c       | 42 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/arm.c                |  4 ++++
>  6 files changed, 81 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index 707a1f06dc5d..b0c17d88ed40 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -319,6 +319,11 @@ static inline int kvm_map_vectors(void)
>  	return 0;
>  }
>  
> +static inline int hyp_map_aux_data(void)
> +{
> +	return 0;
> +}
> +
>  #define kvm_phys_to_vttbr(addr)		(addr)
>  
>  #endif	/* !__ASSEMBLY__ */
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index fefd8cf42c35..d4fbb1356c4c 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -33,6 +33,9 @@
>  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
>  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
>  
> +#define	VCPU_WORKAROUND_2_FLAG_SHIFT	0
> +#define	VCPU_WORKAROUND_2_FLAG		(_AC(1, UL) << VCPU_WORKAROUND_2_FLAG_SHIFT)
> +
>  /* Translate a kernel address of @sym into its equivalent linear mapping */
>  #define kvm_ksym_ref(sym)						\
>  	({								\
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 469de8acd06f..9bef3f69bdcd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -216,6 +216,9 @@ struct kvm_vcpu_arch {
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  
> +	/* State of various workarounds, see kvm_asm.h for bit assignment */
> +	u64 workaround_flags;
> +
>  	/* Guest debug state */
>  	u64 debug_flags;
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 082110993647..eb7a5c2a2bfb 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -457,6 +457,30 @@ static inline int kvm_map_vectors(void)
>  }
>  #endif
>  
> +#ifdef CONFIG_ARM64_SSBD
> +DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
> +
> +static inline int hyp_map_aux_data(void)
> +{
> +	int cpu, err;
> +
> +	for_each_possible_cpu(cpu) {
> +		u64 *ptr;
> +
> +		ptr = per_cpu_ptr(&arm64_ssbd_callback_required, cpu);
> +		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
> +		if (err)
> +			return err;
> +	}
> +	return 0;
> +}
> +#else
> +static inline int hyp_map_aux_data(void)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d9645236e474..c50cedc447f1 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -15,6 +15,7 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> +#include <linux/arm-smccc.h>
>  #include <linux/types.h>
>  #include <linux/jump_label.h>
>  #include <uapi/linux/psci.h>
> @@ -389,6 +390,39 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> +static inline bool __hyp_text __needs_ssbd_off(struct kvm_vcpu *vcpu)
> +{
> +	if (!cpus_have_const_cap(ARM64_SSBD))
> +		return false;
> +
> +	return !(vcpu->arch.workaround_flags & VCPU_WORKAROUND_2_FLAG);
> +}
> +
> +static void __hyp_text __set_guest_arch_workaround_state(struct kvm_vcpu *vcpu)
> +{
> +#ifdef CONFIG_ARM64_SSBD
> +	/*
> +	 * The host runs with the workaround always present. If the
> +	 * guest wants it disabled, so be it...
> +	 */
> +	if (__needs_ssbd_off(vcpu) &&
> +	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
> +		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, 0, NULL);
> +#endif
> +}
> +
> +static void __hyp_text __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
> +{
> +#ifdef CONFIG_ARM64_SSBD
> +	/*
> +	 * If the guest has disabled the workaround, bring it back on.
> +	 */
> +	if (__needs_ssbd_off(vcpu) &&
> +	    __hyp_this_cpu_read(arm64_ssbd_callback_required))
> +		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, 1, NULL);
> +#endif
> +}
> +
>  /* Switch to the guest for VHE systems running in EL2 */
>  int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  {
> @@ -409,6 +443,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> +	__set_guest_arch_workaround_state(vcpu);
> +
>  	do {
>  		/* Jump in the fire! */
>  		exit_code = __guest_enter(vcpu, host_ctxt);
> @@ -416,6 +452,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  		/* And we're baaack! */
>  	} while (fixup_guest_exit(vcpu, &exit_code));
>  
> +	__set_host_arch_workaround_state(vcpu);
> +
>  	fp_enabled = fpsimd_enabled_vhe();
>  
>  	sysreg_save_guest_state_vhe(guest_ctxt);
> @@ -465,6 +503,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  	__sysreg_restore_state_nvhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> +	__set_guest_arch_workaround_state(vcpu);
> +
>  	do {
>  		/* Jump in the fire! */
>  		exit_code = __guest_enter(vcpu, host_ctxt);
> @@ -472,6 +512,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  		/* And we're baaack! */
>  	} while (fixup_guest_exit(vcpu, &exit_code));
>  
> +	__set_host_arch_workaround_state(vcpu);
> +
>  	fp_enabled = __fpsimd_enabled_nvhe();
>  
>  	__sysreg_save_state_nvhe(guest_ctxt);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a4c1b76240df..2d9b4795edb2 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1490,6 +1490,10 @@ static int init_hyp_mode(void)
>  		}
>  	}
>  
> +	err = hyp_map_aux_data();
> +	if (err)
> +		kvm_err("Cannot map host auxilary data: %d\n", err);
> +
>  	return 0;
>  
>  out_err:
> -- 
> 2.14.2
> 
