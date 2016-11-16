From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Wed, 16 Nov 2016 17:02:59 -0500
Message-ID: <bb33f1ca-c47c-90b3-668d-e51101c2e642@codeaurora.org>
References: <1479307116-6355-1-git-send-email-drjones@redhat.com>
 <38d079b9-c693-65ea-1e32-4e3c9ea7b91c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <38d079b9-c693-65ea-1e32-4e3c9ea7b91c@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: wei@redhat.com, shannon.zhao@linaro.org, peter.maydell@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 11/16/2016 12:46 PM, Marc Zyngier wrote:
> On 16/11/16 14:38, Andrew Jones wrote:
>> ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
>> function allows unit tests to make the distinction.
> 
> Hi Drew,
> 
> Overall, having to find out about the architecture is a bad idea most of
> the time. We have feature registers for most things, and it definitely
> makes more sense to check for those than trying to cast a wider net.
> 
>>
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>
>> ---
>> I'm actually unsure if there's a feature bit or not that I could
>> probe instead. It'd be nice if somebody can confirm. Thanks, drew

I'd be happy to settle with the hard-coded CPU list.

But if you're curious about alternatives, I've taken a look through some
documentation. ID_ISAR0.coproc describes whether mrrc is available but
I think it is generally available on v7 and above. I think ID_ISAR5 will
be zero on v7 and nonzero on v8-A32. But PMCR.LC seems like the best bit
to check.

>> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
>> index 84d5c7ce752b..b602e1fbbc2d 100644
>> --- a/lib/arm64/asm/processor.h
>> +++ b/lib/arm64/asm/processor.h
>> @@ -81,5 +81,10 @@ DEFINE_GET_SYSREG32(mpidr)
>>  extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
>>  extern bool is_user(void);
>>  
>> +static inline bool is_aarch32(void)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif /* !__ASSEMBLY__ */
>>  #endif /* _ASMARM64_PROCESSOR_H_ */
>>
> 
> So the real question is: what are you trying to check for?

The question is "how many bits wide is pmccntr?" I think we
can test whether writing PMCR.LC = 1 sticks. Based on the
documentation, it seems to me like it wouldn't for v7 and
would for v8-A32.

uint8_t size_pmccntr(void) {
  uint32_t pmcr = get_pmcr();
  if (pmcr & PMU_PMCR_LC_MASK)
    return 64;
  set_pmcr(pmcr | (1 << PMU_PMCR_LC_SHIFT));
  if (get_pmcr() & PMU_PMCR_LC_MASK)
    return 64;
  return 32;
}

Thanks,
Cov

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code
Aurora Forum, a Linux Foundation Collaborative Project.
