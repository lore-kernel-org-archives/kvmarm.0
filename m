From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Wed, 16 Nov 2016 17:42:08 +0000
Message-ID: <dd65516e-4f61-969f-ee58-9e1357f530f0@arm.com>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 770CB40223
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 12:41:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vdu4b0CzbLAd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2016 12:40:59 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23244401BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 12:40:58 -0500 (EST)
In-Reply-To: <1479307116-6355-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 16/11/16 14:38, Andrew Jones wrote:
> ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
> function allows unit tests to make the distinction.

So the big question here is why you would like to know this?
If it is for a certain feature, you should check for that instead.

> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> I'm actually unsure if there's a feature bit or not that I could
> probe instead. It'd be nice if somebody can confirm. Thanks, drew

Probing for a Cortex-A15 is definitely not the right thing. I think
under KVM you'd see Cortex-A7 and Cortex-A12/A17 if you run on one of those.

So there does not seem to be a dedicated feature bit, however you could
look for some ISA features that ARMv8 AA32 gained over ARMv7.
So one thing you could check for is ID_ISAR5[3:0] (SEVL).
The ARMv7 ARM says that this whole register is "Reserved, UNK", which
technically doesn't give you a lot to check for. But I guess it just
reads as zero on ARMv7 ;-)
The ARMv8 ARM on the other hands puts ARMv8 features in there, among the
new crypto instructions (which are optional), there is the SEVL
instruction, which the architecture mandates:
"In ARMv8-A the only permitted value is 0001."

So I guess the closest you could come to is to check for the lowest 4
bits of ID_ISAR5 to read as '0001'.

HTH,
Andre.

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
