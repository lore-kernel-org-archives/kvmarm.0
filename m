From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 09/13] arm64: kernel: Add arch-specific SDEI entry
 code and CPU masking
Date: Tue, 17 Oct 2017 17:34:13 +0100
Message-ID: <59E63105.9080804@arm.com>
References: <20170922182614.27885-1-james.morse@arm.com> <20170922182614.27885-10-james.morse@arm.com> <20171016134139.sqe6xabdson2d5rd@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016134139.sqe6xabdson2d5rd-+1aNUgJU5qkijLcmloz0ER/iLCjYCKR+VpNB7YpNyf8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Catalin,

On 16/10/17 14:41, Catalin Marinas wrote:
> On Fri, Sep 22, 2017 at 07:26:10PM +0100, James Morse wrote:
>> diff --git a/arch/arm64/kernel/sdei-entry.S b/arch/arm64/kernel/sdei-entry.S
>> new file mode 100644
>> index 000000000000..cf12f8da0789
>> --- /dev/null
>> +++ b/arch/arm64/kernel/sdei-entry.S
>> @@ -0,0 +1,122 @@
>> +/*
>> + * Software Delegated Exception entry point from firmware to the kernel.
>> + *
>> + * Copyright (C) 2017 ARM Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/linkage.h>
>> +
>> +#include <asm/alternative.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/assembler.h>
>> +#include <asm/memory.h>
>> +#include <asm/ptrace.h>
>> +#include <asm/sdei.h>
>> +#include <uapi/linux/sdei.h>
>> +
>> +/*
>> + * Software Delegated Exception entry point.
>> + *
>> + * x0: Event number
> 
> Currently the only event number is 0. Shall we plan for having other
> events in the future or we just ignore this argument?

'0' is the only event number specified by the SDEI specification. For use with
RAS the event number is read from the HEST. (and there may me more than one of
them).



>> + * x1: struct sdei_registered_event argument from registration time.
>> + * x2: interrupted PC
>> + * x3: interrupted PSTATE
> [...]
>> +/*
>> + * __sdei_handler() returns one of:
>> + *  SDEI_EV_HANDLED -  success, return to the interrupted context.
>> + *  SDEI_EV_FAILED  -  failure, return this error code to firmare.
>> + *  virtual-address -  success, return to this address.
>> + */
>> +static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
>> +					     struct sdei_registered_event *arg)
>> +{
>> +	u32 mode;
>> +	int i, err = 0;
>> +	int clobbered_registers = 4;

> Maybe const int here if you want to avoid magic numbers in the 'for'
> loop below. Otherwise it looks like some variable you intend to modify
> in this function.

Sure.

(this was modified in my various attempts to get this working on non-vhe systems
with KVM).


>> +	u64 elr = read_sysreg(elr_el1);
>> +	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
>> +	unsigned long vbar = read_sysreg(vbar_el1);
>> +
>> +	/* Retrieve the missing registers values */
>> +	for (i = 0; i < clobbered_registers; i++) {
>> +		/* from within the handler, this call always succeeds */
>> +		sdei_api_event_context(i, &regs->regs[i]);
>> +	}
>> +
>> +	/*
>> +	 * We didn't take an exception to get here, set PAN. UAO will be cleared
>> +	 * by sdei_event_handler()s set_fs(USER_DS) call.
>> +	 */
>> +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
>> +			CONFIG_ARM64_PAN));

> Can you use uaccess_disable() directly?

Wouldn't this invoke sw-pan's __uaccess_ttbr0_disable():
> write_sysreg(ttbr, ttbr0_el1);

Probing depends on VHE if booted at EL2, can we guarantee to have PAN (and
therefore not-SW-PAN) too?

(otherwise I can add 'depends on !ARM64_SW_TTBR0_PAN' to the Kconfig)


>> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>> index d8a9859f6102..1f6633b337aa 100644
>> --- a/drivers/firmware/Kconfig
>> +++ b/drivers/firmware/Kconfig
>> @@ -50,6 +50,7 @@ config ARM_SCPI_POWER_DOMAIN
>>  
>>  config ARM_SDE_INTERFACE
>>  	bool "ARM Software Delegated Exception Interface (SDEI)"
>> +	depends on ARM64
>>  	help
>>  	  The Software Delegated Exception Interface (SDEI) is an ARM
>>  	  standard for registering callbacks from the platform firmware
>> diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
>> index 4b3c7fd99c34..3ea6a19ae439 100644
>> --- a/drivers/firmware/arm_sdei.c
>> +++ b/drivers/firmware/arm_sdei.c
>> @@ -154,6 +154,7 @@ int sdei_api_event_context(u32 query, u64 *result)
>>  	return invoke_sdei_fn(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, query, 0, 0, 0, 0,
>>  			      result);
>>  }
>> +NOKPROBE_SYMBOL(sdei_api_event_context);

> Should this be part of the patch introducing arm_sdei.c?

Yes.


>>  static int sdei_api_event_get_info(u32 event, u32 info, u64 *result)
>>  {
>> diff --git a/include/linux/sdei.h b/include/linux/sdei.h
>> index bb3dd000771e..df3fe6373e32 100644
>> --- a/include/linux/sdei.h
>> +++ b/include/linux/sdei.h
>> @@ -32,6 +32,8 @@ enum sdei_conduit_types {
>>  	CONDUIT_HVC,
>>  };
>>  
>> +#include <asm/sdei.h>
>> +
>>  /* Arch code should override this to set the entry point from firmware... */
>>  #ifndef sdei_arch_get_entry_point
>>  #define sdei_arch_get_entry_point(conduit)	(0)
> 
> Same here. This should not be built before the Kconfig change anyway.

(I've been building this on x86 to check I'd not done anything arm64 specific
outside the arch code...)

Sure, I'll move this hunk and the Kconfig create a place holder asm/sdei.h in
the earlier patch.


Thanks,

James

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
