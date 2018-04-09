From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [RFC PATCH v3 4/4] KVM: arm64: Optimise FPSIMD handling to
 reduce guest/host thrashing
Date: Mon, 9 Apr 2018 23:22:43 +0200
Message-ID: <20180409212243.GI10904@cbox>
References: <1523271182-22130-1-git-send-email-Dave.Martin@arm.com>
 <1523271182-22130-5-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1523271182-22130-5-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On Mon, Apr 09, 2018 at 11:53:02AM +0100, Dave Martin wrote:
> This patch refactors KVM to align the host and guest FPSIMD
> save/restore logic with each other for arm64.  This reduces the
> number of redundant save/restore operations that must occur, and
> reduces the common-case IRQ blackout time during guest exit storms
> by saving the host state lazily and optimising away the need to
> restore the host state before returning to the run loop.
> 

[...]

> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index db08a54..74c5a46 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c

[...]

> @@ -1054,15 +1066,20 @@ void fpsimd_update_current_state(struct user_fpsimd_state const *state)
>  	local_bh_enable();
>  }
>  
> +void fpsimd_flush_state(unsigned int *cpu)

This API looks strange to me, and doesn't seem to be called from
elsewhere.  Wouldn't it be more clear if it took a struct thread_struct
pointer instead, or if the logic remained embedded in
fpsimd_flush_task_state ?

> +{
> +	*cpu = NR_CPUS;
> +}
> +
>  /*
>   * Invalidate live CPU copies of task t's FPSIMD state
>   */
>  void fpsimd_flush_task_state(struct task_struct *t)
>  {
> -	t->thread.fpsimd_cpu = NR_CPUS;
> +	fpsimd_flush_state(&t->thread.fpsimd_cpu);
>  }
>  
> -static inline void fpsimd_flush_cpu_state(void)
> +void fpsimd_flush_cpu_state(void)
>  {
>  	__this_cpu_write(fpsimd_last_state.st, NULL);
>  }

[...]

> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 8605e04..797b259 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -27,6 +27,7 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
> +#include <asm/thread_info.h>
>  
>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
>  {
> @@ -47,24 +48,40 @@ bool __hyp_text __fpsimd_enabled(void)
>  	return __fpsimd_is_enabled()();
>  }
>  
> -static void __hyp_text __activate_traps_vhe(void)
> +static bool update_fp_enabled(struct kvm_vcpu *vcpu)

I think this needs a __hyp_text in the unlikely case that this function
is not inlined in the _nvhe caller by the compiler.

> +{
> +	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE) {
> +		vcpu->arch.host_fpsimd_state = NULL;
> +		vcpu->arch.fp_enabled = false;
> +	}

I'm not clear why the above logic can't go into kvm_arch_vcpu_load_fp
and why we can't simply check TIF_FOREIGN_FPSTATE in __hyp_switch_fpsimd
instead?

> +
> +	return vcpu->arch.fp_enabled;
> +}
> +
> +static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
>  	val = read_sysreg(cpacr_el1);
>  	val |= CPACR_EL1_TTA;
> -	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
> +	val &= ~CPACR_EL1_ZEN;
> +	if (!update_fp_enabled(vcpu))
> +		val &= ~CPACR_EL1_FPEN;
> +
>  	write_sysreg(val, cpacr_el1);
>  
>  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
>  }
>  
> -static void __hyp_text __activate_traps_nvhe(void)
> +static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	u64 val;
>  
>  	val = CPTR_EL2_DEFAULT;
> -	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
> +	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
> +	if (!update_fp_enabled(vcpu))
> +		val |= CPTR_EL2_TFP;
> +
>  	write_sysreg(val, cptr_el2);
>  }
>  

[...]

Otherwise this approach looks quite good to me overall.  Are you
planning to add SVE support before removing the RFC from this series?

Thanks,
-Christoffer
