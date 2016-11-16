From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Wed, 16 Nov 2016 17:46:08 +0000
Message-ID: <38d079b9-c693-65ea-1e32-4e3c9ea7b91c@arm.com>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1479307116-6355-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.maydell@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 16/11/16 14:38, Andrew Jones wrote:
> ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> function allows unit tests to make the distinction.

Hi Drew,

Overall, having to find out about the architecture is a bad idea most of
the time. We have feature registers for most things, and it definitely
makes more sense to check for those than trying to cast a wider net.

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> I'm actually unsure if there's a feature bit or not that I could
> probe instead. It'd be nice if somebody can confirm. Thanks, drew
> 
>  lib/arm/asm/processor.h   | 20 ++++++++++++++++++++
>  lib/arm64/asm/processor.h |  5 +++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index f25e7eee3666..223e54beb72a 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -5,6 +5,7 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <bitops.h>
>  #include <asm/ptrace.h>
>  
>  enum vector {
> @@ -46,4 +47,23 @@ static inline unsigned int get_mpidr(void)
>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>  extern bool is_user(void);
>  
> +/*
> + * ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> + * function allows unit tests to make the distinction.
> + */
> +static inline bool is_aarch32(void)

I'm really worried that you're not considering v7-A as AArch32.

> +{
> +	/*
> +	 * XXX: Unfortunately there's no feature bit we can probe for
> +	 * this, so we do a hacky check for the processor type not being
> +	 * a Cortex-A15, which is the only v7 type we currently use.
> +	 */
> +	unsigned long midr;
> +
> +	asm volatile("MRC p15, 0, %0, c0, c0, 0" : "=r" (midr));
> +	midr &= GENMASK(31, 24) | GENMASK(15, 4);
> +
> +	return midr != ((0x41 << 24) | (0xc0f << 4));

And what about A7, A12, A17? They all are v7's.

> +}
> +
>  #endif /* _ASMARM_PROCESSOR_H_ */
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 84d5c7ce752b..b602e1fbbc2d 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -81,5 +81,10 @@ DEFINE_GET_SYSREG32(mpidr)
>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>  extern bool is_user(void);
>  
> +static inline bool is_aarch32(void)
> +{
> +	return false;
> +}
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM64_PROCESSOR_H_ */
> 

So the real question is: what are you trying to check for?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
