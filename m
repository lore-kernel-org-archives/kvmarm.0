From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v2 05/10] arm/arm64: irq
 enable/disable
Date: Tue, 07 Jun 2016 17:22:20 +0100
Message-ID: <87portge9v.fsf@linaro.org>
References: <1465064165-14885-6-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-reply-to: <1465064165-14885-6-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: Andrew Jones <drjones@redhat.com>
Cc: peter.maydell@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, andre.przywara@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Andrew Jones <drjones@redhat.com> writes:

> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

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


--
Alex Bennée
