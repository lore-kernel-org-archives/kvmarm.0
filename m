From: Bandan Das <bsd@redhat.com>
Subject: Re: [RFC 10/55] KVM: arm64: Synchronize EL1 system registers on
 virtual EL2 entry and exit
Date: Tue, 06 Jun 2017 16:16:52 -0400
Message-ID: <jpgy3t4dg7f.fsf@linux.bootlegged.copy>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-11-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39AA940C4E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 16:12:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wuqN4KyfJVDa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 16:12:53 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E1A4095A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 16:12:52 -0400 (EDT)
In-Reply-To: <1483943091-1364-11-git-send-email-jintack@cs.columbia.edu>
 (Jintack Lim's message of "Mon, 9 Jan 2017 01:24:06 -0500")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Jintack Lim <jintack@cs.columbia.edu> writes:

> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> When running in virtual EL2 we use the shadow EL1 systerm register array
> for the save/restore process, so that hardware and especially the memory
> subsystem behaves as code written for EL2 expects while really running
> in EL1.
>
> This works great for EL1 system register accesses that we trap, because
> these accesses will be written into the virtual state for the EL1 system
> registers used when eventually switching the VCPU mode to EL1.
>
> However, there was a collection of EL1 system registers which we do not
> trap, and as a consequence all save/restore operations of these
> registers were happening locally in the shadow array, with no benefit to
> software actually running in virtual EL1 at all.
>
> To fix this, simply synchronize the shadow and real EL1 state for these
> registers on entry/exit to/from virtual EL2 state.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/kvm/context.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
> index 2e9e386..0025dd9 100644
> --- a/arch/arm64/kvm/context.c
> +++ b/arch/arm64/kvm/context.c
> @@ -88,6 +88,51 @@ static void create_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
>  	s_sys_regs[CPACR_EL1] = cptr_el2_to_cpacr_el1(el2_regs[CPTR_EL2]);
>  }
>  
> +/*
> + * List of EL1 registers which we allow the virtual EL2 mode to access
> + * directly without trapping and which haven't been paravirtualized.
> + *
> + * Probably CNTKCTL_EL1 should not be copied but be accessed via trap. Because,
> + * the guest hypervisor running in EL1 can be affected by event streams
> + * configured via CNTKCTL_EL1, which it does not expect. We don't have a
> + * mechanism to trap on CNTKCTL_EL1 as of now (v8.3), keep it in here instead.
> + */
> +static const int el1_non_trap_regs[] = {
> +	CNTKCTL_EL1,
> +	CSSELR_EL1,
> +	PAR_EL1,
> +	TPIDR_EL0,
> +	TPIDR_EL1,
> +	TPIDRRO_EL0
> +};
> +

Do we trap on all register accesses in the non-nested case +
all accesses to the memory access registers ? I am trying to
understand how we decide what registers to trap on. For example,
shouldn't accesses to CSSELR_EL1, the cache size selection register
be trapped ?

Bandan


> +/**
> + * sync_shadow_el1_state - Going to/from the virtual EL2 state, sync state
> + * @vcpu:	The VCPU pointer
> + * @setup:	True, if on the way to the guest (called from setup)
> + *		False, if returning form the guet (calld from restore)
> + *
> + * Some EL1 registers are accessed directly by the virtual EL2 mode because
> + * they in no way affect execution state in virtual EL2.   However, we must
> + * still ensure that virtual EL2 observes the same state of the EL1 registers
> + * as the normal VM's EL1 mode, so copy this state as needed on setup/restore.
> + */
> +static void sync_shadow_el1_state(struct kvm_vcpu *vcpu, bool setup)
> +{
> +	u64 *sys_regs = vcpu->arch.ctxt.sys_regs;
> +	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(el1_non_trap_regs); i++) {
> +		const int sr = el1_non_trap_regs[i];
> +
> +		if (setup)
> +			s_sys_regs[sr] = sys_regs[sr];
> +		else
> +			sys_regs[sr] = s_sys_regs[sr];
> +	}
> +}
> +
>  /**
>   * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
>   * @vcpu: The VCPU pointer
> @@ -107,6 +152,7 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
>  		else
>  			ctxt->hw_pstate |= PSR_MODE_EL1t;
>  
> +		sync_shadow_el1_state(vcpu, true);
>  		create_shadow_el1_sysregs(vcpu);
>  		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
>  		ctxt->hw_sp_el1 = ctxt->el2_regs[SP_EL2];
> @@ -125,6 +171,7 @@ void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
>  	if (unlikely(vcpu_mode_el2(vcpu))) {
> +		sync_shadow_el1_state(vcpu, false);
>  		*vcpu_cpsr(vcpu) &= PSR_MODE_MASK;
>  		*vcpu_cpsr(vcpu) |= ctxt->hw_pstate & ~PSR_MODE_MASK;
>  		ctxt->el2_regs[SP_EL2] = ctxt->hw_sp_el1;
