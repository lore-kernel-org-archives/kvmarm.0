From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvm-unit-tests v8 03/10] arm/arm64: add some delay
 routines
Date: Fri, 9 Dec 2016 11:41:06 +0000
Message-ID: <dfb48863-82a7-3bd2-d2dc-498570325970@arm.com>
References: <20161208175030.12269-1-drjones@redhat.com>
 <20161208175030.12269-4-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161208175030.12269-4-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, pbonzini@redhat.com, alex.bennee@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/12/16 17:50, Andrew Jones wrote:
> Allow a thread to wait some specified amount of time. Can
> specify in cycles, usecs, and msecs.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> v8: rewrote basing on new sysreg framework. Also decided delay
>     functions warrant their own files (delay.[ch])
> ---
>  arm/Makefile.common       |  1 +
>  lib/arm/asm/delay.h       | 14 ++++++++++++++
>  lib/arm/asm/processor.h   | 15 +++++++++++++++
>  lib/arm64/asm/delay.h     |  1 +
>  lib/arm64/asm/processor.h | 12 ++++++++++++
>  lib/arm/delay.c           | 29 +++++++++++++++++++++++++++++
>  6 files changed, 72 insertions(+)
>  create mode 100644 lib/arm/asm/delay.h
>  create mode 100644 lib/arm64/asm/delay.h
>  create mode 100644 lib/arm/delay.c
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index b2c0fc8a2fdc..89fe3f69eb44 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -48,6 +48,7 @@ cflatobjs += lib/arm/mmu.o
>  cflatobjs += lib/arm/bitops.o
>  cflatobjs += lib/arm/psci.o
>  cflatobjs += lib/arm/smp.o
> +cflatobjs += lib/arm/delay.o
>  
>  libeabi = lib/arm/libeabi.a
>  eabiobjs = lib/arm/eabi_compat.o
> diff --git a/lib/arm/asm/delay.h b/lib/arm/asm/delay.h
> new file mode 100644
> index 000000000000..2436b28c77ae
> --- /dev/null
> +++ b/lib/arm/asm/delay.h
> @@ -0,0 +1,14 @@
> +#ifndef _ASMARM_DELAY_H_
> +#define _ASMARM_DELAY_H_
> +/*
> + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +
> +extern void delay(u64 cycles);

Nit: Shouldn't this parameter be called "ticks"? Cycles might be a bit
misleading, especially since this prototype is the only documentation on
this. You might just want to fix this when applying the patches.

That notwithstanding:
Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> +extern void udelay(unsigned long usecs);
> +extern void mdelay(unsigned long msecs);
> +
> +#endif /* _ASMARM_DELAY_H_ */
> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> index 6b0d36b87817..857bdd96a3cc 100644
> --- a/lib/arm/asm/processor.h
> +++ b/lib/arm/asm/processor.h
> @@ -7,6 +7,7 @@
>   */
>  #include <asm/ptrace.h>
>  #include <asm/sysreg.h>
> +#include <asm/barrier.h>
>  
>  enum vector {
>  	EXCPTN_RST,
> @@ -51,4 +52,18 @@ extern int mpidr_to_cpu(uint64_t mpidr);
>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>  extern bool is_user(void);
>  
> +#define CNTVCT		__ACCESS_CP15_64(1, c14)
> +#define CNTFRQ		__ACCESS_CP15(c14, 0, c0, 0)
> +
> +static inline u64 get_cntvct(void)
> +{
> +	isb();
> +	return read_sysreg(CNTVCT);
> +}
> +
> +static inline u32 get_cntfrq(void)
> +{
> +	return read_sysreg(CNTFRQ);
> +}
> +
>  #endif /* _ASMARM_PROCESSOR_H_ */
> diff --git a/lib/arm64/asm/delay.h b/lib/arm64/asm/delay.h
> new file mode 100644
> index 000000000000..288e4b3fe610
> --- /dev/null
> +++ b/lib/arm64/asm/delay.h
> @@ -0,0 +1 @@
> +#include "../../arm/asm/delay.h"
> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> index 48abf2c9e358..0898d89f9761 100644
> --- a/lib/arm64/asm/processor.h
> +++ b/lib/arm64/asm/processor.h
> @@ -20,6 +20,7 @@
>  #include <asm/ptrace.h>
>  #include <asm/esr.h>
>  #include <asm/sysreg.h>
> +#include <asm/barrier.h>
>  
>  enum vector {
>  	EL1T_SYNC,
> @@ -83,5 +84,16 @@ extern int mpidr_to_cpu(uint64_t mpidr);
>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>  extern bool is_user(void);
>  
> +static inline u64 get_cntvct(void)
> +{
> +	isb();
> +	return read_sysreg(cntvct_el0);
> +}
> +
> +static inline u32 get_cntfrq(void)
> +{
> +	return read_sysreg(cntfrq_el0);
> +}
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM64_PROCESSOR_H_ */
> diff --git a/lib/arm/delay.c b/lib/arm/delay.c
> new file mode 100644
> index 000000000000..fa65e2dc9e35
> --- /dev/null
> +++ b/lib/arm/delay.c
> @@ -0,0 +1,29 @@
> +/*
> + * Delay loops
> + *
> + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/processor.h>
> +#include <asm/barrier.h>
> +
> +void delay(u64 cycles)
> +{
> +	u64 start = get_cntvct();
> +
> +	while ((get_cntvct() - start) < cycles)
> +		cpu_relax();
> +}
> +
> +void udelay(unsigned long usec)
> +{
> +	delay((u64)usec * get_cntfrq() / 1000000);
> +}
> +
> +void mdelay(unsigned long msecs)
> +{
> +	while (msecs--)
> +		udelay(1000);
> +}
> 
