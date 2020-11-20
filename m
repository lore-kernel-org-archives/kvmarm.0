Return-Path: <SRS0=rD/S=E2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991B8C5519F
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 10:52:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D65FC22226
	for <kvmarm@archiver.kernel.org>; Fri, 20 Nov 2020 10:52:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D65FC22226
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D11C4B5FA;
	Fri, 20 Nov 2020 05:52:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CVCJZdyWmagw; Fri, 20 Nov 2020 05:52:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9C344B5A8;
	Fri, 20 Nov 2020 05:52:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 400BD4B59B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 05:52:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rEgMxf-KSzoq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2020 05:52:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5988E4B598
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2020 05:52:36 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B33C211D4;
 Fri, 20 Nov 2020 02:52:35 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCF763F718;
 Fri, 20 Nov 2020 02:52:33 -0800 (PST)
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Subject: Re: [PATCH v3 4/5] arm64: Add support for SMCCC TRNG entropy source
To: Ard Biesheuvel <ardb@kernel.org>
References: <20201113182435.64015-1-andre.przywara@arm.com>
 <20201113182435.64015-5-andre.przywara@arm.com>
 <CAMj1kXFMzSKO7yMRSz55Au_kRr=zLT_2tZA_+JNDfJ+osfjkKg@mail.gmail.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <ecff0731-b007-9e7c-3d1d-ae9bc7b1c92e@arm.com>
Date: Fri, 20 Nov 2020 10:52:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXFMzSKO7yMRSz55Au_kRr=zLT_2tZA_+JNDfJ+osfjkKg@mail.gmail.com>
Content-Language: en-GB
Cc: Marc Zyngier <maz@kernel.org>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Theodore Ts'o <tytso@mit.edu>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, Russell King <linux@armlinux.org.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Mark Brown <broonie@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 19/11/2020 13:41, Ard Biesheuvel wrote:

Hi,

> On Fri, 13 Nov 2020 at 19:24, Andre Przywara <andre.przywara@arm.com> wrote:
>>
>> The ARM architected TRNG firmware interface, described in ARM spec
>> DEN0098, defines an ARM SMCCC based interface to a true random number
>> generator, provided by firmware.
>> This can be discovered via the SMCCC >=v1.1 interface, and provides
>> up to 192 bits of entropy per call.
>>
>> Hook this SMC call into arm64's arch_get_random_*() implementation,
>> coming to the rescue when the CPU does not implement the ARM v8.5 RNG
>> system registers.
>>
>> For the detection, we piggy back on the PSCI/SMCCC discovery (which gives
>> us the conduit to use (hvc/smc)), then try to call the
>> ARM_SMCCC_TRNG_VERSION function, which returns -1 if this interface is
>> not implemented.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arch/arm64/include/asm/archrandom.h | 69 ++++++++++++++++++++++++-----
>>  1 file changed, 58 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
>> index abe07c21da8e..fe34bfd30caa 100644
>> --- a/arch/arm64/include/asm/archrandom.h
>> +++ b/arch/arm64/include/asm/archrandom.h
>> @@ -4,13 +4,24 @@
>>
>>  #ifdef CONFIG_ARCH_RANDOM
>>
>> +#include <linux/arm-smccc.h>
>>  #include <linux/bug.h>
>>  #include <linux/kernel.h>
>>  #include <asm/cpufeature.h>
>>
>> +#define ARM_SMCCC_TRNG_MIN_VERSION     0x10000UL
>> +
>> +extern bool smccc_trng_available;
>> +
>>  static inline bool __init smccc_probe_trng(void)
>>  {
>> -       return false;
>> +       struct arm_smccc_res res;
>> +
>> +       arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_VERSION, &res);
>> +       if ((s32)res.a0 < 0)
>> +               return false;
>> +
>> +       return res.a0 >= ARM_SMCCC_TRNG_MIN_VERSION;
>>  }
>>
>>  static inline bool __arm64_rndr(unsigned long *v)
>> @@ -43,26 +54,52 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
>>
>>  static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
>>  {
>> +       struct arm_smccc_res res;
>> +
>>         /*
>>          * Only support the generic interface after we have detected
>>          * the system wide capability, avoiding complexity with the
>>          * cpufeature code and with potential scheduling between CPUs
>>          * with and without the feature.
>>          */
>> -       if (!cpus_have_const_cap(ARM64_HAS_RNG))
>> -               return false;
>> +       if (cpus_have_const_cap(ARM64_HAS_RNG))
>> +               return __arm64_rndr(v);
>>
>> -       return __arm64_rndr(v);
>> -}
>> +       if (smccc_trng_available) {
>> +               arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 64, &res);
>> +               if ((int)res.a0 < 0)
>> +                       return false;
>>
>> +               *v = res.a3;
>> +               return true;
>> +       }
>> +
>> +       return false;
>> +}
>>
> 
> I think we should be more rigorous here in how we map the concepts of
> random seeds and random numbers onto the various sources.
> 
> First of all, assuming my patch dropping the call to
> arch_get_random_seed_long() from add_interrupt_randomness() gets
> accepted, we should switch to RNDRRS here, and implement the non-seed
> variants using RNDR.

I agree (and have a patch ready), but that seems independent from this
series.

> However, this is still semantically inaccurate: RNDRRS does not return
> a random *seed*, it returns a number drawn from a freshly seeded
> pseudo-random sequence. This means that the TRNG interface, if
> implemented, is a better choice, and so we should try it first. Note
> that on platforms that don't implement both, only one of these will be
> available in the first place. But on platforms that *do* implement
> both, the firmware interface may actually be less wasteful in terms of
> resources: the TRNG interface returns every bit drawn from the
> underlying entropy source, whereas RNDRRS uses ~500 bits of entropy to
> reseed a DRBG that gets used only once to draw a single 64-bit number.

I am not sure I share your enthusiasm about the quality of the actual
TRNG firmware implementations, but we can go with this for now.
Maybe if we see bad implementations in the future, we can revisit this,
and have some tuneables? Or a command line option to ignore the SMCCC
interface? Or use the UUID mechanism for that?

> And the cost of the SMCCC call in terms of CPU time is charged to the
> caller, which is appropriate here.

This still leaves the problem that the core might be stuck in EL3 for an
unknown period of time, impeding our realtime efforts.
Do we have some ball park number of a number of cycles spent in EL3
still being acceptable? That could serve as a guideline for firmware
implementations?

> Then, I don't think we should ever return false without even trying if
> RNDRRS is available if the SMCCC invocation fails.

That's a good point.

> Something like this perhaps?
> 
> if (smccc_trng_available) {
>   arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 64, &res);
>   if ((int)res.a0 >= 0) {
>     *v = res.a3;
>     return true;
>   }
> }

yeah, the fall-through here is a good idea.

> 
> if (cpus_have_const_cap(ARM64_HAS_RNG))
>    return __arm64_rndrrs(v);
> 
> return false;

So I wonder if we have a trade-off here between the performance of the
RNDRRS entropy source and the latency of the firmware implementation.
If the RNDR entropy source delivers Mbits/s (the Juno h/w definitely
does), we might just not care about throwing away some (or even the
majority) of it.

On the other hand the Juno TRNG hardware for instance spends already
hundreds of cycles on a single 32-bit MMIO read alone, just to transfer
the bits into the CPU. Having a rather large pool could avoid paying
this price on every SMC call, but I don't see a nice way of allowing
TF-A to fill this pool, when Linux thinks it can spare the time.

So I am a bit uneasy about unconditionally preferring the SMCCC
implementation over the RNDRRS instruction.

Cheers,
Andre

> (and something similar 2x below)
> 
> 
>>  static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
>>  {
>> +       struct arm_smccc_res res;
>>         unsigned long val;
>> -       bool ok = arch_get_random_seed_long(&val);
>>
>> -       *v = val;
>> -       return ok;
>> +       if (cpus_have_const_cap(ARM64_HAS_RNG)) {
>> +               if (arch_get_random_seed_long(&val)) {
>> +                       *v = val;
>> +                       return true;
>> +               }
>> +               return false;
>> +       }
>> +
>> +       if (smccc_trng_available) {
>> +               arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 32, &res);
>> +               if ((int)res.a0 < 0)
>> +                       return false;
>> +
>> +               *v = res.a3 & GENMASK(31, 0);
>> +               return true;
>> +       }
>> +
>> +       return false;
>>  }
>>
>>  static inline bool __init __early_cpu_has_rndr(void)
>> @@ -77,10 +114,20 @@ arch_get_random_seed_long_early(unsigned long *v)
>>  {
>>         WARN_ON(system_state != SYSTEM_BOOTING);
>>
>> -       if (!__early_cpu_has_rndr())
>> -               return false;
>> +       if (__early_cpu_has_rndr())
>> +               return __arm64_rndr(v);
>> +
>> +       if (smccc_trng_available) {
>> +               struct arm_smccc_res res;
>>
>> -       return __arm64_rndr(v);
>> +               arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 64, &res);
>> +               if ((int)res.a0 >= 0) {
>> +                       *v = res.a3;
>> +                       return true;
>> +               }
>> +       }
>> +
>> +       return false;
>>  }
>>  #define arch_get_random_seed_long_early arch_get_random_seed_long_early
>>
>> --
>> 2.17.1
>>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
