From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v4 10/11] arm/arm64: gicv3: add an IPI test
Date: Wed, 9 Nov 2016 09:33:49 +0100
Message-ID: <20161109083349.fhomosnrnj7wkmm7@kamzik.brq.redhat.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
 <1478636499-14339-11-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478636499-14339-11-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: pbonzini@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Argh. I forgot to compile/test arm32/gicv3... Just did now and found
a copy+paste error.

On Tue, Nov 08, 2016 at 09:21:38PM +0100, Andrew Jones wrote:
[...]
> diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
> index 81a1e5f6c29c..cbcec024a2a6 100644
> --- a/lib/arm/asm/arch_gicv3.h
> +++ b/lib/arm/asm/arch_gicv3.h
> @@ -16,10 +16,28 @@
>  #define __stringify xstr
>  
>  #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
> +#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
>  
> +#define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
> +#define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
> +#define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
>  #define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
>  #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
>  
> +static inline void gicv3_write_eoir(u32 irq)
> +{
> +	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (val));
                                              should be irq ^^
> +	isb();
> +}
> +
[...]

I've pushed an arm/gic-v5 branch[*] to github, and removed the broken
arm/gic-v4 branch.

[*] https://github.com/rhdrjones/kvm-unit-tests/commits/arm/gic-v5

drew
