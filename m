From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Prevent VGIC_ADDR_TO_INTID from
 emiting divisions
Date: Tue, 1 Nov 2016 16:28:49 +0100
Message-ID: <20161101152849.GC13677@cbox>
References: <20161029111901.16668-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E30C34025C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 11:28:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id noQF6G8dYzIO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2016 11:28:45 -0400 (EDT)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4440F4022C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 11:28:44 -0400 (EDT)
Received: by mail-lf0-f47.google.com with SMTP id b81so128656594lfe.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2016 08:28:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20161029111901.16668-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 29, 2016 at 12:19:01PM +0100, Marc Zyngier wrote:
> Using non-constant number of bits for VGIC_ADDR_TO_INTID() leads
> to gcc 6.1 emiting calls to __aeabi_uldivmod, which the kernel
> does not implement.
> 
> As we really don't want to implement complex division in the kernel,
> the only other option is to prove to the compiler that there is only
> a few values that are possible for the number of bits per IRQ, and
> that they are all power of 2.
> 
> We turn the VGIC_ADDR_TO_INTID macro into a switch that looks for
> the supported set of values (1, 2, 8, 64), and perform the computation
> accordingly. When "bits" is a constant, the compiler optimizes
> away the other cases. If not, we end-up with a small number of cases
> that GCC optimises reasonably well. Out of range values are detected
> both at build time (constants) and at run time (variables).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> This should be applied *before* Andre's patch fixing out of bound SPIs.
> 
>  virt/kvm/arm/vgic/vgic-mmio.h | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
> index 4c34d39..a457282 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.h
> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
> @@ -57,10 +57,41 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
>   * multiplication with the inverted fraction, and scale up both the
>   * numerator and denominator with 8 to support at most 64 bits per IRQ:
>   */
> -#define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
> +#define __VGIC_ADDR_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
>  					64 / (bits) / 8)
>  
>  /*
> + * Perform the same computation, but also handle non-constant number
> + * of bits. We only care about the few cases that are required by
> + * GICv2/v3.
> + */
> +#define VGIC_ADDR_TO_INTID(addr, bits)				\
> +	({							\
> +		u32 __v;					\
> +		switch((bits)) {				\
> +		case 1:						\
> +			__v = __VGIC_ADDR_INTID((addr), 1);	\
> +			break;					\
> +		case 2:						\
> +			__v = __VGIC_ADDR_INTID((addr), 2);	\
> +			break;					\
> +		case 8:						\
> +			__v = __VGIC_ADDR_INTID((addr), 8);	\
> +			break;					\
> +		case 64:					\
> +			__v = __VGIC_ADDR_INTID((addr), 64);	\
> +			break;					\
> +		default:					\
> +			if (__builtin_constant_p((bits)))	\
> +				BUILD_BUG();			\
> +			else					\
> +				BUG();				\
> +		}						\
> +								\
> +		__v;						\
> +	})
> +
> +/*
>   * Some VGIC registers store per-IRQ information, with a different number
>   * of bits per IRQ. For those registers this macro is used.
>   * The _WITH_LENGTH version instantiates registers with a fixed length
> -- 
> 2.9.3
> 

Looks functionally correct, just wondering if it's cleaner to turn the
whole thing into a static inline, or if it can be rewritten to use
shifts with any benefit.

In any case, if you like this version:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
