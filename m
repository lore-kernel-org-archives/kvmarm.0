From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 04/11] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Tue, 19 Sep 2017 10:55:55 +0100
Message-ID: <59C0E9AB.7040703@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com> <20170808164616.25949-5-james.morse@arm.com> <20170917144334.GB99021@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170917144334.GB99021@lvm>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 17/09/17 15:43, Christoffer Dall wrote:
> On Tue, Aug 08, 2017 at 05:46:09PM +0100, James Morse wrote:
>> Now that KVM uses tpidr_el2 in the same way as Linux's cpu_offset in
>> tpidr_el1, merge the two. This saves KVM from save/restoring tpidr_el1
>> on VHE hosts, and allows future code to blindly access per-cpu variables
>> without triggering world-switch.

>> Changes since v1:
>>  * cpu_copy_el2regs()'s 'have I been patched' test now always sets a register,
>>    just in case the compiler puts do_copyregs on the stack.

> I don't understand this?

Looks like this was a note to myself, translation below:


>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 9f9e0064c8c1..1960706d2422 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1295,3 +1296,25 @@ static int __init enable_mrs_emulation(void)
>>  }
>>  
>>  late_initcall(enable_mrs_emulation);
>> +
>> +int cpu_copy_el2regs(void *__unused)
>> +{
>> +	int do_copyregs = 0;
>> +
>> +	/*
>> +	 * Copy register values that aren't redirected by hardware.
>> +	 *
>> +	 * Before code patching, we only set tpidr_el1, all CPUs need to copy
>> +	 * this value to tpidr_el2 before we patch the code. Once we've done
>> +	 * that, freshly-onlined CPUs will set tpidr_el2, so we don't need to
>> +	 * do anything here.
>> +	 */
>> +	asm volatile(ALTERNATIVE("mov %0, #1", "mov %0, #0",
>> +				 ARM64_HAS_VIRT_HOST_EXTN)
>> +		    : "=r" (do_copyregs) : : );
>> +
>> +	if (do_copyregs)
>> +		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
> 
> Could you just use has_vhe() here ?

This is the 'have I been patched' test.
Before patching the my_cpu_offset value will be in tpidr_el1, we copy it to
tpidr_el2.

Once smp_cpus_done() calls apply_alternatives_all(), set_my_cpu_offset() is
patched to write its value into tpidr_el2. CPUs that come online after this
point don't need the value copying, but this cpufeature enable call will still
be called.

The skimmed-over information is that cpufeature's enable methods are called
locally when any core comes online, even after the alternatives have been
applied. (we also modify pstate and set sctlr bits from these).

Would it be clearer if I rewrote the comment as:
> cpufeature's enable methods are called whenever a CPU comes online, but we
> only need to copy tpidr_el1 -> tpidr_el2 on CPUs that were online before the
> alternatives are applied. After that point a VHE system will only use
> tpidr_el2.


The change-since-v1 was paranoia as 'do_copyregs' wasn't always updated: I was
worried about the compiler ditching the '=0' initialisation as its written by
the asm() before being read... but not once we've patched in the alternative.
Having to put 'do_copyregs' on the stack, but then deciding to just allocate it
late was where I thought this might happen. Short-version: I don't trust the
compiler.


>> +
>> +	return 0;
>> +}



> Otherwise:
> 
> Reviewed-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks!

James
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
