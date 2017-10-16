From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 09/13] arm64: kernel: Add arch-specific SDEI entry
 code and CPU masking
Date: Mon, 16 Oct 2017 14:41:39 +0100
Message-ID: <20171016134139.sqe6xabdson2d5rd@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-10-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5BFB40D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 09:40:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 58DuvVAKG0EZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 09:40:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3B29406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 09:40:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170922182614.27885-10-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 22, 2017 at 07:26:10PM +0100, James Morse wrote:
> diff --git a/arch/arm64/include/asm/sdei.h b/arch/arm64/include/asm/sdei.h
> new file mode 100644
> index 000000000000..ed329e01a301
> --- /dev/null
> +++ b/arch/arm64/include/asm/sdei.h
> @@ -0,0 +1,63 @@
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
> +#ifndef __ASM_SDEI_H
> +#define __ASM_SDEI_H
> +
> +/* Values for sdei_exit_mode */
> +#define SDEI_EXIT_HVC  0
> +#define SDEI_EXIT_SMC  1
> +
> +#define SDEI_STACK_SIZE		IRQ_STACK_SIZE
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/linkage.h>
> +#include <linux/types.h>
> +
> +#include <asm/virt.h>
> +
> +extern unsigned long sdei_exit_mode;
> +
> +/* Software Delegated Exception entry point from firmware*/
> +asmlinkage void __sdei_asm_handler(unsigned long event_num, unsigned long arg,
> +				   unsigned long pc, unsigned long pstate);
> +
> +/*
> + * The above entry point does the minimum to call C code. This function does
> + * anything else, before calling the driver.
> + */
> +struct sdei_registered_event;
> +asmlinkage unsigned long __sdei_handler(struct pt_regs *regs,
> +					struct sdei_registered_event *arg);
> +
> +extern unsigned long sdei_arch_get_entry_point(int conduit);

Nitpick: drop the "extern" here.

> diff --git a/arch/arm64/kernel/sdei-entry.S b/arch/arm64/kernel/sdei-entry.S
> new file mode 100644
> index 000000000000..cf12f8da0789
> --- /dev/null
> +++ b/arch/arm64/kernel/sdei-entry.S
> @@ -0,0 +1,122 @@
> +/*
> + * Software Delegated Exception entry point from firmware to the kernel.
> + *
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
> +
> +#include <linux/linkage.h>
> +
> +#include <asm/alternative.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/assembler.h>
> +#include <asm/memory.h>
> +#include <asm/ptrace.h>
> +#include <asm/sdei.h>
> +#include <uapi/linux/sdei.h>
> +
> +/*
> + * Software Delegated Exception entry point.
> + *
> + * x0: Event number

Currently the only event number is 0. Shall we plan for having other
events in the future or we just ignore this argument?

> + * x1: struct sdei_registered_event argument from registration time.
> + * x2: interrupted PC
> + * x3: interrupted PSTATE
[...]
> +/*
> + * __sdei_handler() returns one of:
> + *  SDEI_EV_HANDLED -  success, return to the interrupted context.
> + *  SDEI_EV_FAILED  -  failure, return this error code to firmare.
> + *  virtual-address -  success, return to this address.
> + */
> +static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
> +					     struct sdei_registered_event *arg)
> +{
> +	u32 mode;
> +	int i, err = 0;
> +	int clobbered_registers = 4;

Maybe const int here if you want to avoid magic numbers in the 'for'
loop below. Otherwise it looks like some variable you intend to modify
in this function.

> +	u64 elr = read_sysreg(elr_el1);
> +	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
> +	unsigned long vbar = read_sysreg(vbar_el1);
> +
> +	/* Retrieve the missing registers values */
> +	for (i = 0; i < clobbered_registers; i++) {
> +		/* from within the handler, this call always succeeds */
> +		sdei_api_event_context(i, &regs->regs[i]);
> +	}
> +
> +	/*
> +	 * We didn't take an exception to get here, set PAN. UAO will be cleared
> +	 * by sdei_event_handler()s set_fs(USER_DS) call.
> +	 */
> +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
> +			CONFIG_ARM64_PAN));

Can you use uaccess_disable() directly?

> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index d8a9859f6102..1f6633b337aa 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -50,6 +50,7 @@ config ARM_SCPI_POWER_DOMAIN
>  
>  config ARM_SDE_INTERFACE
>  	bool "ARM Software Delegated Exception Interface (SDEI)"
> +	depends on ARM64
>  	help
>  	  The Software Delegated Exception Interface (SDEI) is an ARM
>  	  standard for registering callbacks from the platform firmware
> diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
> index 4b3c7fd99c34..3ea6a19ae439 100644
> --- a/drivers/firmware/arm_sdei.c
> +++ b/drivers/firmware/arm_sdei.c
> @@ -154,6 +154,7 @@ int sdei_api_event_context(u32 query, u64 *result)
>  	return invoke_sdei_fn(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, query, 0, 0, 0, 0,
>  			      result);
>  }
> +NOKPROBE_SYMBOL(sdei_api_event_context);

Should this be part of the patch introducing arm_sdei.c?

>  
>  static int sdei_api_event_get_info(u32 event, u32 info, u64 *result)
>  {
> diff --git a/include/linux/sdei.h b/include/linux/sdei.h
> index bb3dd000771e..df3fe6373e32 100644
> --- a/include/linux/sdei.h
> +++ b/include/linux/sdei.h
> @@ -32,6 +32,8 @@ enum sdei_conduit_types {
>  	CONDUIT_HVC,
>  };
>  
> +#include <asm/sdei.h>
> +
>  /* Arch code should override this to set the entry point from firmware... */
>  #ifndef sdei_arch_get_entry_point
>  #define sdei_arch_get_entry_point(conduit)	(0)

Same here. This should not be built before the Kconfig change anyway.

-- 
Catalin
