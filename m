From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv4 3/3] arm: pmu: Add
 CPI checking
Date: Mon, 19 Oct 2015 11:44:30 -0400
Message-ID: <56250FDE.8000008@codeaurora.org>
References: <5612EDA5.9010506@redhat.com> <1444662470-13045-1-git-send-email-cov@codeaurora.org> <1444662470-13045-4-git-send-email-cov@codeaurora.org> <20151018182821.GC12158@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151018182821.GC12158@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com, alindsay@codeaurora.org, croberts@codeaurora.org, shannon.zhao@linaro.org, alistair.francis@xilinx.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

I appreciate your feedback on these patches.

On 10/18/2015 02:28 PM, Andrew Jones wrote:

>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -37,6 +37,18 @@ static inline unsigned long get_pmccntr(void)
>>  	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
>>  	return cycles;
>>  }
>> +
>> +static inline void loop(int i, uint32_t pmcr)
>> +{
>> +	uint32_t z = 0;
>> +
>> +	asm volatile(
>> +		"	mcr p15, 0, %[pmcr], c9, c12, 0\n"
>> +		"	1: subs %[i], %[i], #1\n"
>> +		"	bgt 1b\n"
>> +		"	mcr p15, 0, %[z], c9, c12, 0\n"
>> +	: [i] "+r" (i) : [pmcr] "r" (pmcr), [z] "r" (z) : "cc");
> 
> Assembly is always ugly, but we can do a bit better formatting with tabs
> 
> 	asm volatile(
> 	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> 	"1:	subs	%[i], %[i], #1\n"
> 	"	bgt	1b\n"
> 	"	mcr	p15, 0, %[z], c9, c12, 0\n"
> 	: [i] "+r" (i)
> 	: [pmcr] "r" (pmcr), [z] "r" (z)
> 	: "cc");
> 
> Actually it can be even cleaner because you already created set_pmcr()
> 
> 	set_pmcr(pmcr);
> 
> 	asm volatile(
> 	"1:	subs	%0, %0, #1\n"
> 	"	bgt     1b\n"
> 	: "+r" (i) : : "cc");
> 
> 	set_pmcr(0);

Is there any way to ensure that the compiler won't for example put a `mov rd,
#0` between the `bgt 1b` and the `mcr <pmcr>, rn`?

>> @@ -125,12 +147,79 @@ static bool check_cycles_increase(void)
>>  	return true;
>>  }
>>  
>> -int main(void)
>> +/*
>> + * Execute a known number of guest instructions. Only odd instruction counts
>> + * greater than or equal to 3 are supported by the in-line assembly code. The
> 
> Not all odd counts, right? But rather all multiples of 3? IIUC this is because
> the loop is two instructions (sub + branch), and then the clearing of the pmcr
> register counts as the 3rd?

Clearing the PMCR doesn't happen as part of the loop, but as part of the loop
exit or epilogue.

total_instrs = iteration_count * loop_instrs + eipilogue_instrs
total_instrs = iteration_count * 2 + 1

Thanks,
Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
