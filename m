From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 15/15] KVM: arm: enable trapping of all debug registers
Date: Wed, 2 Sep 2015 18:08:14 +0200
Message-ID: <20150902160814.GS10991@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-16-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439213167-8988-16-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 09:26:07PM +0800, Zhichao Huang wrote:
> Enable trapping of the debug registers unconditionally, allowing guests to
> use the debug infrastructure.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/kvm/interrupts_head.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index 7ad0adf..494991d 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -792,7 +792,7 @@ ARM_BE8(rev	r6, r6  )
>   * (hardware reset value is 0) */
>  .macro set_hdcr operation
>  	mrc	p15, 4, r2, c1, c1, 1
> -	ldr	r3, =(HDCR_TPM|HDCR_TPMCR)
> +	ldr	r3, =(HDCR_TPM|HDCR_TPMCR|HDCR_TDRA|HDCR_TDOSA|HDCR_TDA)

eh, but I thought we didn't have to trap accesses to the debug registers
if we switch them, because the guest is likely to be using them?

Maybe I am getting confused, can you repeat for me exactly when we
context-switch the registers and when we trap accesses to them?

Thanks,
-Christoffer

>  	.if \operation == vmentry
>  	orr	r2, r2, r3		@ Trap some perfmon accesses
>  	.else
> -- 
> 1.7.12.4
> 
