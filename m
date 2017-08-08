From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 07/11] firmware: arm_sdei: Add driver for Software Delegated
 Exceptions
Date: Tue, 08 Aug 2017 17:48:01 +0100
Message-ID: <5989EB41.10909@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com> <20170515174400.29735-8-james.morse@arm.com> <20170719135213.GA1538@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170719135213.GA1538-M5GwZQ6tE7x5pKCnmE3YQBJ8xKzm50AiAL8bYrjMMd8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 19/07/17 14:52, Dave Martin wrote:
> On Mon, May 15, 2017 at 06:43:55PM +0100, James Morse wrote:
>> The Software Delegated Exception Interface (SDEI) is an ARM standard
>> for registering callbacks from the platform firmware into the OS.
>> This is typically used to implement RAS notifications.
>>
>> Add the code for detecting the SDEI version and the framework for
>> registering and unregistering events. Subsequent patches will add the
>> arch-specific backend code and the necessary power management hooks.
>>
>> Currently only shared events are supported.

>> diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
>> new file mode 100644
>> index 000000000000..d22dda5e0fed
>> --- /dev/null
>> +++ b/drivers/firmware/arm_sdei.c
>> +int sdei_mask_local_cpu(unsigned int cpu)
>> +{
>> +	int err;
>> +	struct arm_smccc_res res;
>> +
>> +	WARN_ON(preemptible());
>> +	err = invoke_sdei_fn(&res, SDEI_1_0_FN_SDEI_PE_MASK, 0, 0, 0, 0, 0);

> It seems awkward to have to declare res repeatedly when it's basically
> unused.  Several callsites seem to do this.  Out of context, this looks
> bug-like (though it's not a bug).

After a quick trawl, only the 'qcom' and 'optee' callers use regs other than x0.


> Could we make it explicit that the results other than x0 are unwanted by
> passing NULL instead?

Looks straightforward, the quirk buffer has the same behaviour. I will put
something together.


> invoke_sdei_fn (or some downstream function) could declare its own res
> for this case, but at least we'd only have to do that in one place.
> arm_smccc_smc() and friends (at least the C interface in the headers)
> could do something similar.

Yes, for SDEI I can reduce this weirdness by moving smccc_res up a level.


Thanks,

James
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
