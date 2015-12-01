From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 10/21] arm64: KVM: Add patchable function selector
Date: Tue, 1 Dec 2015 16:39:00 +0100
Message-ID: <20151201153900.GT11704@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-11-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448650215-15218-11-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 27, 2015 at 06:50:04PM +0000, Marc Zyngier wrote:
> KVM so far relies on code patching, and is likely to use it more
> in the future. The main issue is that our alternative system works
> at the instruction level, while we'd like to have alternatives at
> the function level.
> 
> In order to cope with this, add the "hyp_alternate_select" macro that
> outputs a brief sequence of code that in turn can be patched, allowing
> al alternative function to be selected.

s/al/an/ ?

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/hyp.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index 7ac8e11..f0427ee 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -27,6 +27,22 @@
>  
>  #define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
>  
> +/*
> + * Generates patchable code sequences that are used to switch between
> + * two implementations of a function, depending on the availability of
> + * a feature.
> + */

This looks right to me, but I'm a bit unclear what the types of this is
and how to use it.

Are orig and alt function pointers and cond is a CONFIG_FOO ?  fname is
a symbol, which is defined as a prototype somewhere and then implemented
here, or?

Perhaps a Usage: part of the docs would be helpful.


> +#define hyp_alternate_select(fname, orig, alt, cond)			\
> +typeof(orig) * __hyp_text fname(void)					\
> +{									\
> +	typeof(alt) *val = orig;					\
> +	asm volatile(ALTERNATIVE("nop		\n",			\
> +				 "mov	%0, %1	\n",			\
> +				 cond)					\
> +		     : "+r" (val) : "r" (alt));				\
> +	return val;							\
> +}
> +
>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>  
> -- 
> 2.1.4
> 

I haven't thought much about how all of this is implemented, but from my
point of views the ideal situation would be something like:

void foo(int a, int b)
{
	ALTERNATIVE_IF_NOT CONFIG_BAR
	foo_legacy(a, b);
	ALTERNATIVE_ELSE
	foo_new(a, b);
	ALTERNATIVE_END
}

I realize this may be impossible because the C code could implement all
sort of fun stuff around the actual function calls, but would there be
some way to annotate the functions and find the actual branch statement
and change the target?

Apologies if this question is just outright ridiculous.

-Christoffer
