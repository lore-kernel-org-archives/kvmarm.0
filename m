From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm64: KVM: Disable virtual timer even if the guest
 is not using it
Date: Thu, 17 Sep 2015 13:17:35 +0200
Message-ID: <20150917111735.GA19365@cbox>
References: <1442419087-24648-1-git-send-email-marc.zyngier@arm.com>
 <1442419087-24648-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442419087-24648-3-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Pavel Fedin <p.fedin@samsung.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 16, 2015 at 04:58:06PM +0100, Marc Zyngier wrote:
> When running a guest with the architected timer disabled (with QEMU and
> the kernel_irqchip=off option, for example), it is important to make
> sure the timer gets turned off. Otherwise, the guest may try to
> enable it anyway, leading to a screaming HW interrupt.
> 
> The fix is to unconditionally turn off the virtual timer on guest
> exit.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 6addf97..38f5434 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -570,8 +570,6 @@ alternative_endif

The context confuses me; did you happen to base this on your VHE
patches?

>  	mrs	x3, cntv_ctl_el0
>  	and	x3, x3, #3
>  	str	w3, [x0, #VCPU_TIMER_CNTV_CTL]
> -	bic	x3, x3, #1		// Clear Enable
> -	msr	cntv_ctl_el0, x3
>  
>  	isb
>  
> @@ -579,6 +577,8 @@ alternative_endif
>  	str	x3, [x0, #VCPU_TIMER_CNTV_CVAL]
>  
>  1:
> +	msr	cntv_ctl_el0, xzr
> +

We could have a comment here, but ok.

>  	// Allow physical timer/counter access for the host
>  	mrs	x2, cnthctl_el2
>  	orr	x2, x2, #3
> -- 
> 2.1.4
> 

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
