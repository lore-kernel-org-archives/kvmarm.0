From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 05/15] ARM: head: use PC-relative insn sequence for
 __smp_alt
Date: Fri, 11 Aug 2017 08:13:46 -0700
Message-ID: <20170811151346.GR8569@atomide.com>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
 <20170805205222.19868-6-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170805205222.19868-6-ard.biesheuvel@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, linux@armlinux.org.uk, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, nico@linaro.org, dave.martin@arm.com, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170805 13:54]:
> Replace the open coded PC relative offset calculations with a pair
> of adr_l invocations.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/kernel/head.S | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 6e9df3663a57..aed341e0f530 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -523,19 +523,11 @@ ARM_BE8(rev	r0, r0)			@ byteswap if big endian
>  	retne	lr
>  
>  __fixup_smp_on_up:
> -	adr	r0, 1f
> -	ldmia	r0, {r3 - r5}
> -	sub	r3, r0, r3
> -	add	r4, r4, r3
> -	add	r5, r5, r3
> +	adr_l	r4, __smpalt_begin
> +	adr_l	r5, __smpalt_end
>  	b	__do_fixup_smp_on_up
>  ENDPROC(__fixup_smp)
>  
> -	.align
> -1:	.word	.
> -	.word	__smpalt_begin
> -	.word	__smpalt_end
> -
>  	.pushsection .data
>  	.globl	smp_on_up
>  smp_on_up:

Ard, it's this one that cause boot to fail on omap3.
The rest of your set works for me with just this one
left out.

Regards,

Tony
