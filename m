From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 14/15] KVM: arm: implement lazy world switch for debug
 registers
Date: Wed, 2 Sep 2015 18:06:20 +0200
Message-ID: <20150902160620.GR10991@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-15-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439213167-8988-15-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 09:26:06PM +0800, Zhichao Huang wrote:
> Avoid world-switching all the debug registers when neither the host
> nor the guest has configured any [WB]points.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/kvm/interrupts_head.S | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index b9e7410..7ad0adf 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -332,6 +332,21 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>  	sub	r12, r2, r12		@ How many WPs to skip
>  .endm
>  

> +/* If VCPU_DEBUG_FLAGS is not set, it means that neither the host

For multi-line comments, can you please have the opening '/*' on a
separate line in keeping with the rest of these files?  Please change
this throughout the patch series (I think I've asked this before).

> + * nor the guest has configured any [WB]points.
> + *
> + * We avoid world-switching all the debug registers in that case.
> + *
> + * Assume vcpu pointer in vcpu reg
> + *
> + * clobbers r2
> + */
> +.macro skip_debug_state target
> +	ldr	r2, [vcpu, #VCPU_DEBUG_FLAGS]
> +	cmp	r2, #0
> +	beq	\target
> +.endm

But if the guest started using the registers and we're not trapping
accesses, then surely you need to store the values of the registers when
you come back from the guest, right?

Something about this feels weird.

> +
>  /* Reads cp14 registers from hardware.
>   * Writes cp14 registers in-order to the CP14 struct pointed to by r10
>   *
> @@ -340,12 +355,14 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>   * Clobbers r2-r12
>   */
>  .macro save_debug_state
> +	skip_debug_state 9999f
> +
>  	read_hw_dbg_num
>  	cp14_read_and_str r10, 4, cp14_DBGBVR0, r11
>  	cp14_read_and_str r10, 5, cp14_DBGBCR0, r11
>  	cp14_read_and_str r10, 6, cp14_DBGWVR0, r12
>  	cp14_read_and_str r10, 7, cp14_DBGWCR0, r12
> -
> +9999:
>  	/* DBGDSCR reg */
>  	mrc	p14, 0, r2, c0, c1, 0
>  	str	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
> @@ -359,12 +376,14 @@ vcpu	.req	r0		@ vcpu pointer always in r0
>   * Clobbers r2-r12
>   */
>  .macro restore_debug_state
> +	skip_debug_state 9999f
> +
>  	read_hw_dbg_num
>  	cp14_ldr_and_write r10, 4, cp14_DBGBVR0, r11
>  	cp14_ldr_and_write r10, 5, cp14_DBGBCR0, r11
>  	cp14_ldr_and_write r10, 6, cp14_DBGWVR0, r12
>  	cp14_ldr_and_write r10, 7, cp14_DBGWCR0, r12
> -
> +9999:
>  	/* DBGDSCR reg */
>  	ldr	r2, [r10, #CP14_OFFSET(cp14_DBGDSCRext)]
>  	mcr	p14, 0, r2, c0, c2, 2
> -- 
> 1.7.12.4
> 
