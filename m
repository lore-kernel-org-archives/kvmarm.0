From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 01/15] KVM: arm: plug guest debug exploit
Date: Wed, 2 Sep 2015 13:38:04 +0200
Message-ID: <20150902113804.GJ10991@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-2-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439213167-8988-2-git-send-email-zhichao.huang@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 09:25:53PM +0800, Zhichao Huang wrote:
> Hardware debugging in guests is not intercepted currently, it means
> that a malicious guest can bring down the entire machine by writing
> to the debug registers.
> 
> This patch enable trapping of all debug registers, preventing the guests
> to access the debug registers.
> 
> This patch also disable the debug mode(DBGDSCR) in the guest world all
> the time, preventing the guests to mess with the host state.

Remind me how this works:  How does disabling debug mode prevent the
guest from messing with the host state?  I would think that disabling
debug mode makes sure that exceptions from breakpoints or watchpoints
programmed by the host are ignored?

> 
> However, it is a precursor for later patches which will need to do
> more to world switch debug states while necessary.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/include/asm/kvm_coproc.h |  3 +-
>  arch/arm/kvm/coproc.c             | 82 +++++++++++++++++++++++++++++----------
>  arch/arm/kvm/handle_exit.c        |  4 +-
>  arch/arm/kvm/interrupts.S         | 12 +++---
>  arch/arm/kvm/interrupts_head.S    | 21 ++++++++--
>  5 files changed, 89 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_coproc.h b/arch/arm/include/asm/kvm_coproc.h
> index 4917c2f..e74ab0f 100644
> --- a/arch/arm/include/asm/kvm_coproc.h
> +++ b/arch/arm/include/asm/kvm_coproc.h
> @@ -31,7 +31,8 @@ void kvm_register_target_coproc_table(struct kvm_coproc_target_table *table);
>  int kvm_handle_cp10_id(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp_0_13_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
> -int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index f3d88dc..a885cfe 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -91,12 +91,6 @@ int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 1;
>  }
>  
> -int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
> -{
> -	kvm_inject_undefined(vcpu);
> -	return 1;
> -}
> -
>  static void reset_mpidr(struct kvm_vcpu *vcpu, const struct coproc_reg *r)
>  {
>  	/*
> @@ -465,12 +459,8 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
>  	return 1;
>  }
>  
> -/**
> - * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
> - * @vcpu: The VCPU pointer
> - * @run:  The kvm_run struct
> - */
> -int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +static int kvm_handle_cp_64(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			    bool cp15)

perhaps have cp as an int argument instead and do a switch below?

>  {
>  	struct coproc_params params;
>  
> @@ -484,7 +474,35 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.Rt2 = (kvm_vcpu_get_hsr(vcpu) >> 10) & 0xf;
>  	params.CRm = 0;
>  
> -	return emulate_cp15(vcpu, &params);
> +	if (cp15)
> +		return emulate_cp15(vcpu, &params);
> +
> +	/* raz_wi cp14 */
> +	(void)pm_fake(vcpu, &params, NULL);

I don't think you need the (void) ?

> +
> +	/* handled */
> +	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +	return 1;

perhaps this would be easier to read by adding an emulate_cp14 function
which basically looks like this:

static int emulate_cp14(struct kvm_vcpu *vcpu,
			const struct coproc_params *params)
{
	pm_fake(vcpu, &params, NULL);

	/* handled */
	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
	return 1;
}
	

> +}
> +
> +/**
> + * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
> + * @vcpu: The VCPU pointer
> + * @run:  The kvm_run struct
> + */
> +int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	return kvm_handle_cp_64(vcpu, run, 1);
> +}
> +
> +/**
> + * kvm_handle_cp14_64 -- handles a mrrc/mcrr trap on a guest CP14 access
> + * @vcpu: The VCPU pointer
> + * @run:  The kvm_run struct
> + */
> +int kvm_handle_cp14_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	return kvm_handle_cp_64(vcpu, run, 0);
>  }
>  
>  static void reset_coproc_regs(struct kvm_vcpu *vcpu,
> @@ -497,12 +515,8 @@ static void reset_coproc_regs(struct kvm_vcpu *vcpu,
>  			table[i].reset(vcpu, &table[i]);
>  }
>  
> -/**
> - * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
> - * @vcpu: The VCPU pointer
> - * @run:  The kvm_run struct
> - */
> -int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +static int kvm_handle_cp_32(struct kvm_vcpu *vcpu, struct kvm_run *run,
> +			      bool cp15)
>  {
>  	struct coproc_params params;
>  
> @@ -516,7 +530,35 @@ int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.Op2 = (kvm_vcpu_get_hsr(vcpu) >> 17) & 0x7;
>  	params.Rt2 = 0;
>  
> -	return emulate_cp15(vcpu, &params);
> +	if (cp15)
> +		return emulate_cp15(vcpu, &params);
> +
> +	/* raz_wi cp14 */
> +	(void)pm_fake(vcpu, &params, NULL);
> +
> +	/* handled */
> +	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +	return 1;

same comment as above

> +}
> +
> +/**
> + * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
> + * @vcpu: The VCPU pointer
> + * @run:  The kvm_run struct
> + */
> +int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	return kvm_handle_cp_32(vcpu, run, 1);
> +}
> +
> +/**
> + * kvm_handle_cp14_32 -- handles a mrc/mcr trap on a guest CP14 access
> + * @vcpu: The VCPU pointer
> + * @run:  The kvm_run struct
> + */
> +int kvm_handle_cp14_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	return kvm_handle_cp_32(vcpu, run, 0);
>  }
>  
>  /******************************************************************************
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 95f12b2..357ad1b 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -104,9 +104,9 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[HSR_EC_WFI]		= kvm_handle_wfx,
>  	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
>  	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
> -	[HSR_EC_CP14_MR]	= kvm_handle_cp14_access,
> +	[HSR_EC_CP14_MR]	= kvm_handle_cp14_32,
>  	[HSR_EC_CP14_LS]	= kvm_handle_cp14_load_store,
> -	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
> +	[HSR_EC_CP14_64]	= kvm_handle_cp14_64,
>  	[HSR_EC_CP_0_13]	= kvm_handle_cp_0_13_access,
>  	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
>  	[HSR_EC_SVC_HYP]	= handle_svc_hyp,
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 568494d..48333ff 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -112,9 +112,9 @@ ENTRY(__kvm_vcpu_run)
>  	restore_vgic_state
>  	restore_timer_state
>  
> -	@ Store hardware CP15 state and load guest state
> -	read_cp15_state store_to_vcpu = 0
> -	write_cp15_state read_from_vcpu = 1
> +	@ Store hardware CP14/CP15 state and load guest state
> +	read_coproc_state store_to_vcpu = 0
> +	write_coproc_state read_from_vcpu = 1
>  
>  	@ If the host kernel has not been configured with VFPv3 support,
>  	@ then it is safer if we deny guests from using it as well.
> @@ -199,9 +199,9 @@ after_vfp_restore:
>  	mrc	p15, 0, r2, c0, c0, 5
>  	mcr	p15, 4, r2, c0, c0, 5
>  
> -	@ Store guest CP15 state and restore host state
> -	read_cp15_state store_to_vcpu = 1
> -	write_cp15_state read_from_vcpu = 0
> +	@ Store guest CP14/CP15 state and restore host state
> +	read_coproc_state store_to_vcpu = 1
> +	write_coproc_state read_from_vcpu = 0
>  
>  	save_timer_state
>  	save_vgic_state
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index 702740d..7c4075c 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -239,7 +239,7 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>  	save_guest_regs_mode irq, #VCPU_IRQ_REGS
>  .endm
>  
> -/* Reads cp15 registers from hardware and stores them in memory
> +/* Reads cp14/cp15 registers from hardware and stores them in memory
>   * @store_to_vcpu: If 0, registers are written in-order to the stack,
>   * 		   otherwise to the VCPU struct pointed to by vcpup
>   *
> @@ -247,7 +247,12 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>   *
>   * Clobbers r2 - r12
>   */
> -.macro read_cp15_state store_to_vcpu
> +.macro read_coproc_state store_to_vcpu
> +	.if \store_to_vcpu == 0
> +	mrc	p14, 0, r2, c0, c1, 0	@ DBGDSCR
> +	push	{r2}
> +	.endif
> +
>  	mrc	p15, 0, r2, c1, c0, 0	@ SCTLR
>  	mrc	p15, 0, r3, c1, c0, 2	@ CPACR
>  	mrc	p15, 0, r4, c2, c0, 2	@ TTBCR
> @@ -325,7 +330,7 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>   *
>   * Assumes vcpu pointer in vcpu reg
>   */
> -.macro write_cp15_state read_from_vcpu
> +.macro write_coproc_state read_from_vcpu
>  	.if \read_from_vcpu == 0
>  	pop	{r2,r4-r7}
>  	.else
> @@ -394,6 +399,14 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>  	mcr	p15, 0, r10, c10, c2, 0	@ PRRR
>  	mcr	p15, 0, r11, c10, c2, 1	@ NMRR
>  	mcr	p15, 2, r12, c0, c0, 0	@ CSSELR
> +
> +	.if \read_from_vcpu == 0
> +	pop	{r2}
> +	.else
> +	mov	r2, #0

I really think that we should read the register, clear the bits you care
about (MDBGen and HDBGen) and then write back the register.

So, if I recall correctly, this is to avoid having to set HDCR_TDE
below?

Given Will's concerns about touching this register, I'm thinking if we
shouldn't start with the HDCR_TDE enabled (and a handler in KVM) and
then see if we want to add this optimization later?

At the very least, you should do as Will pointed out and predicate
writes to this register based on whether the reset code in
hw_breakpoint.c successfully reset the debug regs.  I think checking the
debug_err_mask variable from the C code and pass this on to the Hyp code
would be the right way to go.

But as I said, I think we should just trap debug exceptions to begin
with (to plug the hole) and then add the more intelligent stuff later.

> +	.endif
> +
> +	mcr	p14, 0, r2, c0, c2, 2	@ DBGDSCR
>  .endm
>  
>  /*
> @@ -620,7 +633,7 @@ ARM_BE8(rev	r6, r6  )
>   * (hardware reset value is 0) */
>  .macro set_hdcr operation
>  	mrc	p15, 4, r2, c1, c1, 1
> -	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
> +	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA|HDCR_TDA)



>  	.if \operation == vmentry
>  	orr	r2, r2, r3		@ Trap some perfmon accesses
>  	.else
> -- 
> 1.7.12.4
> 

Thanks,
-Christoffer
