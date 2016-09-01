From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v3 05/10] arm/arm64: irq
 enable/disable
Date: Thu, 1 Sep 2016 12:19:29 +0200
Message-ID: <c4a8a1c7-4636-de98-2c1f-c45cc4b37501@redhat.com>
References: <1468587641-7300-1-git-send-email-drjones@redhat.com>
 <1468587641-7300-6-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1468587641-7300-6-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com, wei@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 15/07/2016 15:00, Andrew Jones wrote:
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  lib/arm/asm/processor.h   | 10 ++++++++++
>  lib/arm64/asm/processor.h | 10 ++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index afc903ca7d4ab..75a8d08b89330 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -35,6 +35,16 @@ static inline unsigned long current_cpsr(void)
>  
>  #define current_mode() (current_cpsr() & MODE_MASK)
>  
> +static inline void local_irq_enable(void)
> +{
> +	asm volatile("cpsie i" : : : "memory", "cc");
> +}
> +
> +static inline void local_irq_disable(void)
> +{
> +	asm volatile("cpsid i" : : : "memory", "cc");
> +}
> +
>  static inline unsigned int get_mpidr(void)
>  {
>  	unsigned int mpidr;
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 94f7ce35b65c1..d54a4ed1c1876 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -68,6 +68,16 @@ static inline unsigned long current_level(void)
>  	return el & 0xc;
>  }
>  
> +static inline void local_irq_enable(void)
> +{
> +	asm volatile("msr daifclr, #2" : : : "memory");
> +}
> +
> +static inline void local_irq_disable(void)
> +{
> +	asm volatile("msr daifset, #2" : : : "memory");
> +}
> +
>  #define DEFINE_GET_SYSREG(reg, type)				\
>  static inline type get_##reg(void)				\
>  {								\
> 
Besides the non existing commit msg - looks like the kvm-unit-tests
practices are different from kernel ones ;-)-,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
