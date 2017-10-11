From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v3 01/20] arm64: explicitly mask all exceptions
Date: Wed, 11 Oct 2017 17:30:08 +0100
Message-ID: <25eb4c59-a09e-5b0a-66fb-6c650ab8e057@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
 <20171005191812.5678-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 195EA49D3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 12:29:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EcRyK9jcF0rO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 12:29:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BF8240638
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 12:29:30 -0400 (EDT)
In-Reply-To: <20171005191812.5678-2-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 05/10/17 20:17, James Morse wrote:
> There are a few places where we want to mask all exceptions. Today we
> do this in a piecemeal fashion, typically we expect the caller to
> have masked irqs and the arch code masks debug exceptions, ignoring
> SError which is probably masked.
> 
> Make it clear that 'mask all exceptions' is the intention by adding
> helpers to do exactly that.
> 
> This will let us unmask SError without having to add 'oh and SError'
> to these paths.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> Remove the disable IRQs comment above cpu_die(): we return from idle via
> cpu_resume. This comment is confusing once the local_irq_disable() call
> is changed.
> 
>   arch/arm64/include/asm/assembler.h | 17 +++++++++++
>   arch/arm64/include/asm/daifflags.h | 59 ++++++++++++++++++++++++++++++++++++++
>   arch/arm64/kernel/hibernate.c      |  5 ++--
>   arch/arm64/kernel/machine_kexec.c  |  4 +--
>   arch/arm64/kernel/smp.c            |  9 ++----
>   arch/arm64/kernel/suspend.c        |  7 +++--
>   arch/arm64/kernel/traps.c          |  3 +-
>   arch/arm64/mm/proc.S               |  9 +++---
>   8 files changed, 94 insertions(+), 19 deletions(-)
>   create mode 100644 arch/arm64/include/asm/daifflags.h

[...]

> diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
> new file mode 100644
> index 000000000000..fb40da8e1457
> --- /dev/null
> +++ b/arch/arm64/include/asm/daifflags.h
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright (C) 2017 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_DAIFFLAGS_H
> +#define __ASM_DAIFFLAGS_H
> +
> +#include <asm/irqflags.h>
> +#include <linux/irqflags.h>
> +
> +/* Mask/unmask/restore all exceptions, including interrupts. */
> +static inline unsigned long local_mask_daif(void)
> +{
> +	unsigned long flags;
> +	asm volatile(
> +		"mrs	%0, daif		// local_mask_daif\n"
> +		"msr	daifset, #0xf"
> +		: "=r" (flags)
> +		:
> +		: "memory");
> +	trace_hardirqs_off();
> +	return flags;
> +}
> +
nit:
Can we call this local_daif_save? (and maybe a version that only 
disables without saving?)

Also, I was wondering why use 'local' as prefix? Is there gonna be a 
similar set of function for arm that could be called by common code? 
(e.g. drivers?)

Otherwise:
Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

-- 
Julien Thierry
