From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 11/20] KVM: arm/arm64: Move timer save/restore out of
 the hyp code
Date: Mon, 9 Oct 2017 18:47:42 +0100
Message-ID: <3aebbbaa-bad2-32ed-822d-2db23a759f78@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-12-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B47749D0F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 13:47:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8ntJmIHOPmzC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Oct 2017 13:47:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C541649D0A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 13:47:09 -0400 (EDT)
In-Reply-To: <20170923004207.22356-12-cdall@linaro.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 23/09/17 01:41, Christoffer Dall wrote:
> As we are about to be lazy with saving and restoring the timer
> registers, we prepare by moving all possible timer configuration logic
> out of the hyp code.  All virtual timer registers can be programmed from
> EL1 and since the arch timer is always a level triggered interrupt we
> can safely do this with interrupts disabled in the host kernel on the
> way to the guest without taking vtimer interrupts in the host kernel
> (yet).
> 
> The downside is that the cntvoff register can only be programmed from
> hyp mode, so we jump into hyp mode and back to program it.  This is also
> safe, because the host kernel doesn't use the virtual timer in the KVM
> code.  It may add a little performance performance penalty, but only
> until following commits where we move this operation to vcpu load/put.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_asm.h   |  2 ++
>  arch/arm/include/asm/kvm_hyp.h   |  4 +--
>  arch/arm/kvm/hyp/switch.c        |  7 ++--
>  arch/arm64/include/asm/kvm_asm.h |  2 ++
>  arch/arm64/include/asm/kvm_hyp.h |  4 +--
>  arch/arm64/kvm/hyp/switch.c      |  6 ++--
>  virt/kvm/arm/arch_timer.c        | 40 ++++++++++++++++++++++
>  virt/kvm/arm/hyp/timer-sr.c      | 74 +++++++++++++++++-----------------------
>  8 files changed, 87 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index 14d68a4..36dd296 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -68,6 +68,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
>  extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>  
> +extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
> +
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
>  extern void __init_stage2_translation(void);
> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
> index 14b5903..ab20ffa 100644
> --- a/arch/arm/include/asm/kvm_hyp.h
> +++ b/arch/arm/include/asm/kvm_hyp.h
> @@ -98,8 +98,8 @@
>  #define cntvoff_el2			CNTVOFF
>  #define cnthctl_el2			CNTHCTL
>  
> -void __timer_save_state(struct kvm_vcpu *vcpu);
> -void __timer_restore_state(struct kvm_vcpu *vcpu);
> +void __timer_enable_traps(struct kvm_vcpu *vcpu);
> +void __timer_disable_traps(struct kvm_vcpu *vcpu);
>  
>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
> index ebd2dd4..330c9ce 100644
> --- a/arch/arm/kvm/hyp/switch.c
> +++ b/arch/arm/kvm/hyp/switch.c
> @@ -174,7 +174,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	__activate_vm(vcpu);
>  
>  	__vgic_restore_state(vcpu);
> -	__timer_restore_state(vcpu);
> +	__timer_enable_traps(vcpu);
>  
>  	__sysreg_restore_state(guest_ctxt);
>  	__banked_restore_state(guest_ctxt);
> @@ -191,7 +191,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	__banked_save_state(guest_ctxt);
>  	__sysreg_save_state(guest_ctxt);
> -	__timer_save_state(vcpu);
> +	__timer_disable_traps(vcpu);
> +
>  	__vgic_save_state(vcpu);
>  
>  	__deactivate_traps(vcpu);
> @@ -237,7 +238,7 @@ void __hyp_text __noreturn __hyp_panic(int cause)
>  
>  		vcpu = (struct kvm_vcpu *)read_sysreg(HTPIDR);
>  		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -		__timer_save_state(vcpu);
> +		__timer_disable_traps(vcpu);
>  		__deactivate_traps(vcpu);
>  		__deactivate_vm(vcpu);
>  		__banked_restore_state(host_ctxt);
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 26a64d0..ab4d0a9 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -55,6 +55,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
>  extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>  
> +extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
> +
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
>  extern u64 __vgic_v3_get_ich_vtr_el2(void);
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 4572a9b..08d3bb6 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -129,8 +129,8 @@ void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>  int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
>  
> -void __timer_save_state(struct kvm_vcpu *vcpu);
> -void __timer_restore_state(struct kvm_vcpu *vcpu);
> +void __timer_enable_traps(struct kvm_vcpu *vcpu);
> +void __timer_disable_traps(struct kvm_vcpu *vcpu);
>  
>  void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
>  void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 945e79c..4994f4b 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -298,7 +298,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	__activate_vm(vcpu);
>  
>  	__vgic_restore_state(vcpu);
> -	__timer_restore_state(vcpu);
> +	__timer_enable_traps(vcpu);
>  
>  	/*
>  	 * We must restore the 32-bit state before the sysregs, thanks
> @@ -368,7 +368,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	__sysreg_save_guest_state(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
> -	__timer_save_state(vcpu);
> +	__timer_disable_traps(vcpu);
>  	__vgic_save_state(vcpu);
>  
>  	__deactivate_traps(vcpu);
> @@ -436,7 +436,7 @@ void __hyp_text __noreturn __hyp_panic(void)
>  
>  		vcpu = (struct kvm_vcpu *)read_sysreg(tpidr_el2);
>  		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> -		__timer_save_state(vcpu);
> +		__timer_disable_traps(vcpu);
>  		__deactivate_traps(vcpu);
>  		__deactivate_vm(vcpu);
>  		__sysreg_restore_host_state(host_ctxt);
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 7f87099..4254f88 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -276,6 +276,20 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu,
>  	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
>  }
>  
> +static void timer_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +
> +	if (timer->enabled) {
> +		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> +		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
> +	}
> +
> +	/* Disable the virtual timer */
> +	write_sysreg_el0(0, cntv_ctl);
> +}
> +
>  /*
>   * Schedule the background timer before calling kvm_vcpu_block, so that this
>   * thread is removed from its waitqueue and made runnable when there's a timer
> @@ -312,6 +326,18 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	soft_timer_start(&timer->bg_timer, kvm_timer_earliest_exp(vcpu));
>  }
>  
> +static void timer_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +
> +	if (timer->enabled) {
> +		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
> +		isb();
> +		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
> +	}
> +}
> +
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> @@ -320,6 +346,13 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>  	timer->armed = false;
>  }
>  
> +static void set_cntvoff(u64 cntvoff)
> +{
> +	u32 low = cntvoff & GENMASK(31, 0);
> +	u32 high = (cntvoff >> 32) & GENMASK(31, 0);

upper_32_bits/lower_32_bits?

> +	kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);

Maybe a comment as to why we need to split the 64bit value in two 32bit
words (32bit ARM PCS is getting in the way).

> +}
> +
>  static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> @@ -423,6 +456,7 @@ static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
>  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
>  	if (unlikely(!timer->enabled))
>  		return;
> @@ -436,6 +470,9 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  		kvm_timer_flush_hwstate_user(vcpu);
>  	else
>  		kvm_timer_flush_hwstate_vgic(vcpu);
> +
> +	set_cntvoff(vtimer->cntvoff);
> +	timer_restore_state(vcpu);
>  }
>  
>  /**
> @@ -455,6 +492,9 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  	 */
>  	soft_timer_cancel(&timer->phys_timer, NULL);
>  
> +	timer_save_state(vcpu);
> +	set_cntvoff(0);
> +
>  	/*
>  	 * The guest could have modified the timer registers or the timer
>  	 * could have expired, update the timer state.
> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> index 4734915..a6c3b10 100644
> --- a/virt/kvm/arm/hyp/timer-sr.c
> +++ b/virt/kvm/arm/hyp/timer-sr.c
> @@ -21,58 +21,48 @@
>  
>  #include <asm/kvm_hyp.h>
>  
> -/* vcpu is already in the HYP VA space */
> -void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
> +void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
> +{
> +	u64 cntvoff = (u64)cntvoff_high << 32 | cntvoff_low;
> +	write_sysreg(cntvoff, cntvoff_el2);
> +}
> +
> +void __hyp_text enable_phys_timer(void)
>  {
> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	u64 val;
>  
> -	if (timer->enabled) {
> -		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> -		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
> -	}
> +	/* Allow physical timer/counter access for the host */
> +	val = read_sysreg(cnthctl_el2);
> +	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> +	write_sysreg(val, cnthctl_el2);
> +}
>  
> -	/* Disable the virtual timer */
> -	write_sysreg_el0(0, cntv_ctl);
> +void __hyp_text disable_phys_timer(void)
> +{
> +	u64 val;
>  
>  	/*
> +	 * Disallow physical timer access for the guest
> +	 * Physical counter access is allowed
> +	 */
> +	val = read_sysreg(cnthctl_el2);
> +	val &= ~CNTHCTL_EL1PCEN;
> +	val |= CNTHCTL_EL1PCTEN;
> +	write_sysreg(val, cnthctl_el2);
> +}
> +
> +void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
> +{
> +	/*
>  	 * We don't need to do this for VHE since the host kernel runs in EL2
>  	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
>  	 */
> -	if (!has_vhe()) {
> -		/* Allow physical timer/counter access for the host */
> -		val = read_sysreg(cnthctl_el2);
> -		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> -		write_sysreg(val, cnthctl_el2);
> -	}
> -
> -	/* Clear cntvoff for the host */
> -	write_sysreg(0, cntvoff_el2);
> +	if (!has_vhe())
> +		enable_phys_timer();
>  }
>  
> -void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
> +void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
> -	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -	u64 val;
> -
> -	/* Those bits are already configured at boot on VHE-system */
> -	if (!has_vhe()) {
> -		/*
> -		 * Disallow physical timer access for the guest
> -		 * Physical counter access is allowed
> -		 */
> -		val = read_sysreg(cnthctl_el2);
> -		val &= ~CNTHCTL_EL1PCEN;
> -		val |= CNTHCTL_EL1PCTEN;
> -		write_sysreg(val, cnthctl_el2);
> -	}
> -
> -	if (timer->enabled) {
> -		write_sysreg(vtimer->cntvoff, cntvoff_el2);
> -		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
> -		isb();
> -		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
> -	}
> +	if (!has_vhe())
> +		disable_phys_timer();
>  }
> 

Otherwise:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
