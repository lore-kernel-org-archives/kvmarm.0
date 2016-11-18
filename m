From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Fri, 18 Nov 2016 10:06:34 -0500
Message-ID: <588b642c-2594-3a68-6de5-6962173656a6@codeaurora.org>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
 <38d079b9-c693-65ea-1e32-4e3c9ea7b91c@arm.com>
 <bb33f1ca-c47c-90b3-668d-e51101c2e642@codeaurora.org>
 <20161117165948.lajsuwyrkgrtpvbd@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B03D3401A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2016 10:06:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sgBlH6SSBkQe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2016 10:06:06 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BAC6400E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2016 10:06:06 -0500 (EST)
In-Reply-To: <20161117165948.lajsuwyrkgrtpvbd@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, shannon.zhao@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 11/17/2016 11:59 AM, Andrew Jones wrote:
> On Wed, Nov 16, 2016 at 05:02:59PM -0500, Christopher Covington wrote:
>> On 11/16/2016 12:46 PM, Marc Zyngier wrote:
>>> On 16/11/16 14:38, Andrew Jones wrote:
>>>> ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
>>>> function allows unit tests to make the distinction.
>>>
>>> Hi Drew,
>>>
>>> Overall, having to find out about the architecture is a bad idea most of
>>> the time. We have feature registers for most things, and it definitely
>>> makes more sense to check for those than trying to cast a wider net.
>>>
>>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>>>
>>>> ---
>>>> I'm actually unsure if there's a feature bit or not that I could
>>>> probe instead. It'd be nice if somebody can confirm. Thanks, drew
>>
>> I'd be happy to settle with the hard-coded CPU list.
>>
>> But if you're curious about alternatives, I've taken a look through some
>> documentation. ID_ISAR0.coproc describes whether mrrc is available but
>> I think it is generally available on v7 and above. I think ID_ISAR5 will
>> be zero on v7 and nonzero on v8-A32. But PMCR.LC seems like the best bit
>> to check.
>>
>>>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>>>> index 84d5c7ce752b..b602e1fbbc2d 100644
>>>> --- a/lib/arm64/asm/processor.h
>>>> +++ b/lib/arm64/asm/processor.h
>>>> @@ -81,5 +81,10 @@ DEFINE_GET_SYSREG32(mpidr)
>>>>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>>>>  extern bool is_user(void);
>>>>  
>>>> +static inline bool is_aarch32(void)
>>>> +{
>>>> +	return false;
>>>> +}
>>>> +
>>>>  #endif /* !__ASSEMBLY__ */
>>>>  #endif /* _ASMARM64_PROCESSOR_H_ */
>>>>
>>>
>>> So the real question is: what are you trying to check for?
>>
>> The question is "how many bits wide is pmccntr?" I think we
>> can test whether writing PMCR.LC = 1 sticks. Based on the
>> documentation, it seems to me like it wouldn't for v7 and
>> would for v8-A32.
>>
>> uint8_t size_pmccntr(void) {
>>   uint32_t pmcr = get_pmcr();
>>   if (pmcr & PMU_PMCR_LC_MASK)
>>     return 64;
>>   set_pmcr(pmcr | (1 << PMU_PMCR_LC_SHIFT));
>>   if (get_pmcr() & PMU_PMCR_LC_MASK)
>>     return 64;
>>   return 32;
>> }
> 
> Thanks for this Cov. I mostly agree with the proposal, except for two
> reasons; the spec says the bit is UNK/SBZP for v7, which doesn't give
> me 100% confidence that we can rely on it behaving a certain way. And,

The v7 definition of UNK/SBZP (page Glossary-2736 of ARM DDI 0406C.c):

Hardware must ... Read-As-Zero, and must ignore writes

> I'd rather not rely on the emulation we're testing to work well enough
> that we can probe it.

I agree that it'd really be best to test that QEMU is behaving correctly
rather than assume it does. Real production hardware has passed the ARM
Architecture Validation Suite, but QEMU hasn't.

> For our PMU testing purposes there is a somewhat ugly, but foolproof
> way to manage it; we could just add a command line input that says
> we're aarch32 (-cpu host,aarch64=off -append aarch32)

I would group ARMv7 versus ARMv8-A32 as an "implementation defined"
choice. There are hundreds of these in the architecture, and many of
them require tests to behave differently. For example AES support:

if (DEVICE_SUPPORTS(AES)) {
  assert(ID_ISAR5.AES == 0001 || ID_ISAR5.AES == 0010);
  /* use some AES instructions and check the results */
} else {
  assrt(ID_ISAR5.AES == 0);
  /* maybe check that AES instructions throw undefined
     instruction exceptions */
}

I'm starting to most prefer the original suggestion, which I'll
reframe as built-in tables of implementation defined options, using
the MIDR (and auxiliary ID registers if necessary) to select which
table to use. That way the tests only have to rely on MIDR being
properly emulated, and can check all the other behavior step by step.

Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
