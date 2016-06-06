From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 02/10] arm64: fix get_"sysreg32" and make MPIDR 64bit
Date: Mon, 06 Jun 2016 13:47:50 +0100
Message-ID: <87bn3eiivd.fsf@linaro.org>
References: <1465064165-14885-3-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1465064165-14885-3-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> mrs is always 64bit, so we should always use a 64bit register.
> Sometimes we'll only want to return the lower 32, but not for
> MPIDR, as that does define fields in the upper 32.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm64/asm/processor.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 84d5c7ce752b0..9a208ff729b7e 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -66,14 +66,17 @@ static inline unsigned long current_level(void)
>  	return el & 0xc;
>  }
>
> -#define DEFINE_GET_SYSREG32(reg)				\
> -static inline unsigned int get_##reg(void)			\
> +#define DEFINE_GET_SYSREG(reg, type)				\
> +static inline type get_##reg(void)				\
>  {								\
> -	unsigned int reg;					\
> -	asm volatile("mrs %0, " #reg "_el1" : "=3Dr" (reg));	\
> -	return reg;						\
> +	unsigned long r;					\
> +	asm volatile("mrs %0, " #reg "_el1" : "=3Dr" (r));	\
> +	return (type)r;						\
>  }
> -DEFINE_GET_SYSREG32(mpidr)
> +#define DEFINE_GET_SYSREG32(reg) DEFINE_GET_SYSREG(reg, unsigned int=
)
> +#define DEFINE_GET_SYSREG64(reg) DEFINE_GET_SYSREG(reg, unsigned lon=
g)

I guess this is a hang-over the kernel style to use int/long over
u32/u64?

Otherwise:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

> +
> +DEFINE_GET_SYSREG64(mpidr)
>
>  /* Only support Aff0 for now, gicv2 only */
>  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))


--
Alex Benn=C3=A9e
