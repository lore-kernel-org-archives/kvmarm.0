From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 11/11] KVM: arm: enable trapping of all debug registers
Date: Tue, 30 Jun 2015 15:19:55 +0200
Message-ID: <20150630131955.GR11332@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-12-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434969694-7432-12-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 06:41:34PM +0800, Zhichao Huang wrote:
> Enable trapping of the debug registers, allowing guests to use
> the debug infrastructure.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/kvm/interrupts_head.S | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index ed406be..107bda4 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -886,10 +886,21 @@ ARM_BE8(rev	r6, r6  )
>  .endm
>  
>  /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
> - * (hardware reset value is 0) */
> + * (hardware reset value is 0)
> + *
> + * Clobbers r2-r4
> + */
>  .macro set_hdcr operation
>  	mrc	p15, 4, r2, c1, c1, 1
> -	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
> +	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA)
> +
> +	// Check for KVM_ARM_DEBUG_DIRTY, and set debug to trap
> +	// if not dirty.
> +	ldr	r4, [vcpu, #VCPU_DEBUG_FLAGS]
> +	cmp	r4, #KVM_ARM_DEBUG_DIRTY
> +	beq	1f
> +	orr	r3, r3,  #HDCR_TDA
> +1:

It may make me slightly more calm if you always unconditionally clear
HDCR_TDA on vmexit, but ok.

>  	.if \operation == vmentry
>  	orr	r2, r2, r3		@ Trap some perfmon accesses
>  	.else
> -- 
> 1.7.12.4
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
