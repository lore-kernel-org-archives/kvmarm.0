From: cov@codeaurora.org
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv7 2/3] arm: pmu: Check cycle
 count increases
Date: Thu, 03 Nov 2016 08:25:05 -0600
Message-ID: <17b56cf125cf91f0effe8aacbc8df4d1@codeaurora.org>
References: <1478125337-11770-1-git-send-email-wei@redhat.com>
 <1478125337-11770-3-git-send-email-wei@redhat.com>
 <20161103103507.qg65rruprmm6drzk@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161103103507.qg65rruprmm6drzk@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Wei Huang <wei@redhat.com>, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-11-03 04:35, Andrew Jones wrote:

>> +/*
>> + * Ensure that the cycle counter progresses between back-to-back 
>> reads.
>> + */
>> +static bool check_cycles_increase(void)
>> +{
>> +	struct pmu_data pmu = {{0}};
>> +
>> +	enable_counter(ARMV8_PMU_CYCLE_IDX);
>> +	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
>> +
>> +	pmu.enable = 1;
>> +	set_pmcr(pmu.pmcr_el0);
>> +
>> +	for (int i = 0; i < NR_SAMPLES; i++) {
>> +		unsigned long a, b;
>> +
>> +		a = get_pmccntr();
>> +		b = get_pmccntr();
>> +
>> +		if (a >= b) {
>> +			printf("Read %ld then %ld.\n", a, b);
>> +			return false;
>> +		}
>> +	}
>> +
>> +	pmu.enable = 0;
>> +	set_pmcr(pmu.pmcr_el0);
>> +
>> +	return true;
>> +}
>> +
>>  int main(void)
>>  {
>>  	report_prefix_push("pmu");
>> 
>>  	report("Control register", check_pmcr());
>> +	report("Monotonically increasing cycle count", 
>> check_cycles_increase());
>> 
>>  	return report_summary();
>>  }
> 
> What happens with this test running on tcg? Do we just fail? Does it
> explode? Is there a register we can probe and when it indicates things
> won't work we can invoke a report_skip?

A monotonically increasing value (but not any attempt at approximating 
actual cycle
values) in cycle counter is pretty much the only piece of the PMU it's 
had implemented
for the past while. We'll have to check whether TCG can handle the 
filter and enable set
registers, but if it doesn't yet, that's something we can improve :).

Thanks,
Cov
