From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 02/10] arm64: fix
 get_"sysreg32" and make MPIDR 64bit
Date: Tue, 30 Aug 2016 16:28:18 +0200
Message-ID: <d3c66b41-bf8a-cb9c-b5ae-87298e8a0835@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-3-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468587641-7300-3-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com, wei@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 15/07/2016 15:00, Andrew Jones wrote:
> mrs is always 64bit, so we should always use a 64bit register.
> Sometimes we'll only want to return the lower 32, but not for
> MPIDR, as that does define fields in the upper 32.
> 
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
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
> -	asm volatile("mrs %0, " #reg "_el1" : "=r" (reg));	\
> -	return reg;						\
> +	unsigned long r;					\
> +	asm volatile("mrs %0, " #reg "_el1" : "=r" (r));	\
> +	return (type)r;						\
>  }
> -DEFINE_GET_SYSREG32(mpidr)
> +#define DEFINE_GET_SYSREG32(reg) DEFINE_GET_SYSREG(reg, unsigned int)
> +#define DEFINE_GET_SYSREG64(reg) DEFINE_GET_SYSREG(reg, unsigned long)
> +
> +DEFINE_GET_SYSREG64(mpidr)
>  
>  /* Only support Aff0 for now, gicv2 only */
>  #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
