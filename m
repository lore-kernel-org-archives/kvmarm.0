From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/11] KVM: arm: implement lazy world switch for debug
 registers
Date: Fri, 3 Jul 2015 23:05:53 +0200
Message-ID: <20150703210553.GB10878@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-10-git-send-email-zhichao.huang@linaro.org>
 <20150630131522.GQ11332@cbox>
 <B5E26578-9F34-4D53-8F4E-3CC147382D79@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2957657A14
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 16:54:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4W+mwIgNhNT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 16:54:36 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F94857627
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 16:54:36 -0400 (EDT)
Received: by lagx9 with SMTP id x9so96578479lag.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Jul 2015 14:05:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <B5E26578-9F34-4D53-8F4E-3CC147382D79@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, huangzhichao@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 03, 2015 at 06:06:48PM +0800, Zhichao Huang wrote:
> 
> 
> On June 30, 2015 9:15:22 PM GMT+08:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> >On Mon, Jun 22, 2015 at 06:41:32PM +0800, Zhichao Huang wrote:
> >> Implement switching of the debug registers. While the number
> >> of registers is massive, CPUs usually don't implement them all
> >> (A15 has 6 breakpoints and 4 watchpoints, which gives us a total
> >> of 22 registers "only").
> >> 
> >> Notice that, for ARMv7, if the CONFIG_HAVE_HW_BREAKPOINT is set in
> >> the guest, debug is always actively in use (ARM_DSCR_MDBGEN set).
> >> 
> >> We have to do the save/restore dance in this case, because the host
> >> and the guest might use their respective debug registers at any moment.
> >
> >this sounds expensive, and I suggested an alternative approach in the
> >previsou patch.  In any case, measuring the impact on this on hardware
> >would be a great idea...
> >
> >> 
> >> If the CONFIG_HAVE_HW_BREAKPOINT is not set, and if no one flagged
> >> the debug registers as dirty, we only save/resotre DBGDSCR.
> >
> >restore
> >
> >> 
> >> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> >> ---
> >>  arch/arm/kvm/interrupts.S      |  16 +++
> >>  arch/arm/kvm/interrupts_head.S | 249 ++++++++++++++++++++++++++++++++++++++++-
> >>  2 files changed, 263 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> >> index 79caf79..d626275 100644
> >> --- a/arch/arm/kvm/interrupts.S
> >> +++ b/arch/arm/kvm/interrupts.S
> >> @@ -116,6 +116,12 @@ ENTRY(__kvm_vcpu_run)
> >>  	read_cp15_state store_to_vcpu = 0
> >>  	write_cp15_state read_from_vcpu = 1
> >>  
> >> +	@ Store hardware CP14 state and load guest state
> >> +	compute_debug_state 1f
> >> +	bl __save_host_debug_regs
> >> +	bl __restore_guest_debug_regs
> >> +
> >> +1:
> >>  	@ If the host kernel has not been configured with VFPv3 support,
> >>  	@ then it is safer if we deny guests from using it as well.
> >>  #ifdef CONFIG_VFPv3
> >> @@ -201,6 +207,16 @@ after_vfp_restore:
> >>  	mrc	p15, 0, r2, c0, c0, 5
> >>  	mcr	p15, 4, r2, c0, c0, 5
> >>  
> >> +	@ Store guest CP14 state and restore host state
> >> +	skip_debug_state 1f
> >> +	bl __save_guest_debug_regs
> >> +	bl __restore_host_debug_regs
> >> +	/* Clear the dirty flag for the next run, as all the state has
> >> +	 * already been saved. Note that we nuke the whole 32bit word.
> >> +	 * If we ever add more flags, we'll have to be more careful...
> >> +	 */
> >> +	clear_debug_dirty_bit
> >> +1:
> >>  	@ Store guest CP15 state and restore host state
> >>  	read_cp15_state store_to_vcpu = 1
> >>  	write_cp15_state read_from_vcpu = 0
> >> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> >> index 5662c39..ed406be 100644
> >> --- a/arch/arm/kvm/interrupts_head.S
> >> +++ b/arch/arm/kvm/interrupts_head.S
> >> @@ -7,6 +7,7 @@
> >>  #define VCPU_USR_SP		(VCPU_USR_REG(13))
> >>  #define VCPU_USR_LR		(VCPU_USR_REG(14))
> >>  #define CP15_OFFSET(_cp15_reg_idx) (VCPU_CP15 + (_cp15_reg_idx * 4))
> >> +#define CP14_OFFSET(_cp14_reg_idx) (VCPU_CP14 + ((_cp14_reg_idx) *
> >4))
> >>  
> >>  /*
> >>   * Many of these macros need to access the VCPU structure, which is
> >always
> >> @@ -168,8 +169,7 @@ vcpu	.req	r0		@ vcpu pointer always in r0
> >>   * Clobbers *all* registers.
> >>   */
> >>  .macro restore_guest_regs
> >> -	/* reset DBGDSCR to disable debug mode */
> >> -	mov	r2, #0
> >> +	ldr	r2, [vcpu, #CP14_OFFSET(cp14_DBGDSCRext)]
> >>  	mcr	p14, 0, r2, c0, c2, 2
> >>  
> >>  	restore_guest_regs_mode svc, #VCPU_SVC_REGS
> >> @@ -250,6 +250,10 @@ vcpu	.req	r0		@ vcpu pointer always in r0
> >>  	save_guest_regs_mode abt, #VCPU_ABT_REGS
> >>  	save_guest_regs_mode und, #VCPU_UND_REGS
> >>  	save_guest_regs_mode irq, #VCPU_IRQ_REGS
> >> +
> >> +	/* DBGDSCR reg */
> >> +	mrc	p14, 0, r2, c0, c1, 0
> >> +	str	r2, [vcpu, #CP14_OFFSET(cp14_DBGDSCRext)]
> >>  .endm
> >>  
> >>  /* Reads cp15 registers from hardware and stores them in memory
> >> @@ -449,6 +453,231 @@ vcpu	.req	r0		@ vcpu pointer always in r0
> >>  	str	r5, [vcpu, #VCPU_DEBUG_FLAGS]
> >>  .endm
> >>  
> >> +/* Assume r11/r12 in used, clobbers r2-r10 */
> >> +.macro cp14_read_and_push Op2 skip_num
> >> +	cmp	\skip_num, #8
> >> +	// if (skip_num >= 8) then skip c8-c15 directly
> >> +	bge	1f
> >> +	adr	r2, 9998f
> >> +	add	r2, r2, \skip_num, lsl #2
> >> +	bx	r2
> >> +1:
> >> +	adr	r2, 9999f
> >> +	sub	r3, \skip_num, #8
> >> +	add	r2, r2, r3, lsl #2
> >> +	bx	r2
> >> +9998:
> >> +	mrc	p14, 0, r10, c0, c15, \Op2
> >> +	mrc	p14, 0, r9, c0, c14, \Op2
> >> +	mrc	p14, 0, r8, c0, c13, \Op2
> >> +	mrc	p14, 0, r7, c0, c12, \Op2
> >> +	mrc	p14, 0, r6, c0, c11, \Op2
> >> +	mrc	p14, 0, r5, c0, c10, \Op2
> >> +	mrc	p14, 0, r4, c0, c9, \Op2
> >> +	mrc	p14, 0, r3, c0, c8, \Op2
> >> +	push	{r3-r10}
> >
> >you probably don't want to do more stores to memory than required
> 
> Yeah, there is no need to push some registers, but I can't find a better 
> way to optimize it, is there any precedents that I can refer to?

Can you not simply do what you do below where you read the coproc
register and then do the store of that and so on?

If you unify the two approaches you should be in the clear on this one
anyway...

> 
> Imaging that there are only 2 hwbrpts available, BCR0/BCR1, and we
> can code like this:
> 
> Save:
> 		 jump to 1
>     save BCR2 to r5
> 1:
>     save BCR1 to r4
>     save BCR0 to r3
>     push {r3-r5}
> 
> Restore:
>     pop {r3-r5}
>     jump to 1
>     restore r5 to BCR2
> 1:
>     restore r4 to BCR1
>     restore r3 to BCR0
> 
> Buf if we want to only push the registers we acutally need, we have to
> code like this:
> 
> Save:
>     jump to 1
>     save BCR2 to r5
>     push r5
> 1:
>     save BCR1 to r4
>     push r4
>     save BCR0 to r3
>     push r3
> 
> Resotre:
>     jump to 1
>     pop r5
>     restore r5 to BCR2
> 1:
>     pop r4
>     restore r4 to BCR1
>     pop r3
>     restore r3 to BCR0
> 
> Then we might entercounter a mistake on restoring, as we want to pop
> r4, but actually we pop r3.
> 
> >
> >> +9999:
> >> +	mrc	p14, 0, r10, c0, c7, \Op2
> >> +	mrc	p14, 0, r9, c0, c6, \Op2
> >> +	mrc	p14, 0, r8, c0, c5, \Op2
> >> +	mrc	p14, 0, r7, c0, c4, \Op2
> >> +	mrc	p14, 0, r6, c0, c3, \Op2
> >> +	mrc	p14, 0, r5, c0, c2, \Op2
> >> +	mrc	p14, 0, r4, c0, c1, \Op2
> >> +	mrc	p14, 0, r3, c0, c0, \Op2
> >> +	push	{r3-r10}
> >
> >same
> >
> >> +.endm
> >> +
> >> +/* Assume r11/r12 in used, clobbers r2-r10 */
> >> +.macro cp14_pop_and_write Op2 skip_num
> >> +	cmp	\skip_num, #8
> >> +	// if (skip_num >= 8) then skip c8-c15 directly
> >> +	bge	1f
> >> +	adr	r2, 9998f
> >> +	add	r2, r2, \skip_num, lsl #2
> >> +	pop	{r3-r10}
> >
> >you probably don't want to do more loads from memory than required
> >
> >> +	bx	r2
> >> +1:
> >> +	adr	r2, 9999f
> >> +	sub	r3, \skip_num, #8
> >> +	add	r2, r2, r3, lsl #2
> >> +	pop	{r3-r10}
> >
> >same
> >
> >> +	bx	r2
> >> +
> >> +9998:
> >> +	mcr	p14, 0, r10, c0, c15, \Op2
> >> +	mcr	p14, 0, r9, c0, c14, \Op2
> >> +	mcr	p14, 0, r8, c0, c13, \Op2
> >> +	mcr	p14, 0, r7, c0, c12, \Op2
> >> +	mcr	p14, 0, r6, c0, c11, \Op2
> >> +	mcr	p14, 0, r5, c0, c10, \Op2
> >> +	mcr	p14, 0, r4, c0, c9, \Op2
> >> +	mcr	p14, 0, r3, c0, c8, \Op2
> >> +
> >> +	pop	{r3-r10}
> >> +9999:
> >> +	mcr	p14, 0, r10, c0, c7, \Op2
> >> +	mcr	p14, 0, r9, c0, c6, \Op2
> >> +	mcr	p14, 0, r8, c0, c5, \Op2
> >> +	mcr	p14, 0, r7, c0, c4, \Op2
> >> +	mcr	p14, 0, r6, c0, c3, \Op2
> >> +	mcr	p14, 0, r5, c0, c2, \Op2
> >> +	mcr	p14, 0, r4, c0, c1, \Op2
> >> +	mcr	p14, 0, r3, c0, c0, \Op2
> >> +.endm
> >> +
> >> +/* Assume r11/r12 in used, clobbers r2-r3 */
> >> +.macro cp14_read_and_str Op2 cp14_reg0 skip_num
> >> +	adr	r3, 1f
> >> +	add	r3, r3, \skip_num, lsl #3
> >> +	bx	r3
> >> +1:
> >> +	mrc	p14, 0, r2, c0, c15, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+15)]
> >> +	mrc	p14, 0, r2, c0, c14, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+14)]
> >> +	mrc	p14, 0, r2, c0, c13, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+13)]
> >> +	mrc	p14, 0, r2, c0, c12, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+12)]
> >> +	mrc	p14, 0, r2, c0, c11, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+11)]
> >> +	mrc	p14, 0, r2, c0, c10, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+10)]
> >> +	mrc	p14, 0, r2, c0, c9, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+9)]
> >> +	mrc	p14, 0, r2, c0, c8, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+8)]
> >> +	mrc	p14, 0, r2, c0, c7, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+7)]
> >> +	mrc	p14, 0, r2, c0, c6, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+6)]
> >> +	mrc	p14, 0, r2, c0, c5, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+5)]
> >> +	mrc	p14, 0, r2, c0, c4, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+4)]
> >> +	mrc	p14, 0, r2, c0, c3, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+3)]
> >> +	mrc	p14, 0, r2, c0, c2, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+2)]
> >> +	mrc	p14, 0, r2, c0, c1, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+1)]
> >> +	mrc	p14, 0, r2, c0, c0, \Op2
> >> +	str     r2, [vcpu, #CP14_OFFSET(\cp14_reg0)]
> >> +.endm
> >> +
> >> +/* Assume r11/r12 in used, clobbers r2-r3 */
> >> +.macro cp14_ldr_and_write Op2 cp14_reg0 skip_num
> >> +	adr	r3, 1f
> >> +	add	r3, r3, \skip_num, lsl #3
> >> +	bx	r3
> >> +1:
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+15)]
> >> +	mcr	p14, 0, r2, c0, c15, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+14)]
> >> +	mcr	p14, 0, r2, c0, c14, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+13)]
> >> +	mcr	p14, 0, r2, c0, c13, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+12)]
> >> +	mcr	p14, 0, r2, c0, c12, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+11)]
> >> +	mcr	p14, 0, r2, c0, c11, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+10)]
> >> +	mcr	p14, 0, r2, c0, c10, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+9)]
> >> +	mcr	p14, 0, r2, c0, c9, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+8)]
> >> +	mcr	p14, 0, r2, c0, c8, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+7)]
> >> +	mcr	p14, 0, r2, c0, c7, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+6)]
> >> +	mcr	p14, 0, r2, c0, c6, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+5)]
> >> +	mcr	p14, 0, r2, c0, c5, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+4)]
> >> +	mcr	p14, 0, r2, c0, c4, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+3)]
> >> +	mcr	p14, 0, r2, c0, c3, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+2)]
> >> +	mcr	p14, 0, r2, c0, c2, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0+1)]
> >> +	mcr	p14, 0, r2, c0, c1, \Op2
> >> +	ldr     r2, [vcpu, #CP14_OFFSET(\cp14_reg0)]
> >> +	mcr	p14, 0, r2, c0, c0, \Op2
> >> +.endm
> >
> >can you not find some way of unifying cp14_pop_and_write with
> >cp14_ldr_and_write and cp14_read_and_push with cp14_read_and_str ?
> >
> >Probably having two separate structs for the VFP state on the vcpu
> >struct
> >for both the guest and the host state is one possible way of doing so.
> >
> 
> OK, I will do it.
> Would you like me to rename the struct vfp_hard_struct, and add 
> host_cp14_state in there, or add a new struct host_cp14_state in the
> kvm_vcpu_arch?
> 

Not sure I understand the question exactly.  I would probably define
kvm_cpu_context_t as a new struct that includes the VFP state instead of
it being a typedef, but I haven't looked at it too carefully.


> >> +
> >> +/* Get extract number of BRPs and WRPs. Saved in r11/r12 */
> >> +.macro read_hw_dbg_num
> >> +	mrc	p14, 0, r2, c0, c0, 0
> >> +	ubfx	r11, r2, #24, #4
> >> +	add	r11, r11, #1		// Extract BRPs
> >> +	ubfx	r12, r2, #28, #4
> >> +	add	r12, r12, #1		// Extract WRPs
> >> +	mov	r2, #16
> >> +	sub	r11, r2, r11		// How many BPs to skip
> >> +	sub	r12, r2, r12		// How many WPs to skip
> >> +.endm
> >> +
> >> +/* Reads cp14 registers from hardware.
> >
> >You have a lot of multi-line comments in these patches which don't
> >start
> >with a separate '/*' line, as dictated by the Linux kernel coding
> >style.
> >So far, I've ignored this, but please fix all these throughout the
> >series when you respin.
> >
> >> + * Writes cp14 registers in-order to the stack.
> >> + *
> >> + * Assumes vcpu pointer in vcpu reg
> >> + *
> >> + * Clobbers r2-r12
> >> + */
> >> +.macro save_host_debug_regs
> >> +	read_hw_dbg_num
> >> +	cp14_read_and_push #4, r11	@ DBGBVR
> >> +	cp14_read_and_push #5, r11	@ DBGBCR
> >> +	cp14_read_and_push #6, r12	@ DBGWVR
> >> +	cp14_read_and_push #7, r12	@ DBGWCR
> >> +.endm
> >> +
> >> +/* Reads cp14 registers from hardware.
> >> + * Writes cp14 registers in-order to the VCPU struct pointed to by
> >vcpup.
> >> + *
> >> + * Assumes vcpu pointer in vcpu reg
> >> + *
> >> + * Clobbers r2-r12
> >> + */
> >> +.macro save_guest_debug_regs
> >> +	read_hw_dbg_num
> >> +	cp14_read_and_str #4, cp14_DBGBVR0, r11
> >
> >why do you need the has before the op2 field?
> 
> Sorry, I can't quite understand.
> 

heh, I meant hash, why is is '#4' instead of '4' ?

Thanks,
-Christoffer
