From: Wei Huang <wei@redhat.com>
Subject: Re: [kvm-unit-tests PATCHv2] arm: Add PMU test
Date: Mon, 5 Oct 2015 16:37:41 -0500
Message-ID: <5612EDA5.9010506@redhat.com>
References: <1443728841-10501-1-git-send-email-cov@codeaurora.org>
 <1443800908-12159-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443800908-12159-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>, drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: shannon.zhao@linaro.org, alistair.francis@xilinx.com
List-Id: kvmarm@lists.cs.columbia.edu



On 10/02/2015 10:48 AM, Christopher Covington wrote:
> Add test the ARM Performance Monitors Unit (PMU). The informational
> fields from the control register are printed, but not checked, and
> the number of cycles it takes to run a known-instruction-count loop
> is printed, but not checked. Once QEMU is fixed, we can at least
> begin to check for IPC == 1 when using -icount.

Thanks for submitting it. I think this is a good starting point to add
PMU unit testing support for ARM. Some comments below.

> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/pmu.c               | 89 +++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg       | 11 ++++++
>  config/config-arm64.mak |  4 ++-
>  3 files changed, 103 insertions(+), 1 deletion(-)
>  create mode 100644 arm/pmu.c
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> new file mode 100644
> index 0000000..f724c2c
> --- /dev/null
> +++ b/arm/pmu.c
> @@ -0,0 +1,89 @@
> +/*
> + * Test the ARM Performance Monitors Unit (PMU).
> + *
> + * Copyright 2015 The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Lesser General Public License version 2.1 and
> + * only version 2.1 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
> + * for more details.
> + */
> +#include "libcflat.h"
> +
> +struct pmu_data {
> +	union {
> +		uint32_t pmcr_el0;
> +		struct {
> +			unsigned int enable:1;
> +			unsigned int event_counter_reset:1;
> +			unsigned int cycle_counter_reset:1;
> +			unsigned int cycle_counter_clock_divider:1;
> +			unsigned int event_counter_export:1;
> +			unsigned int cycle_counter_disable_when_prohibited:1;
> +			unsigned int cycle_counter_long:1;
> +			unsigned int zeros:4;
> +			unsigned int num_counters:5;
> +			unsigned int identification_code:8;
> +			unsigned int implementor:8;
                        ^^^^^^^^
Not saying it is a problem because "unsigned int" is 32-bit on 64bit
machine. But to make it consistent with pmcr_el0, I would prefer
"unsigned int" been replaced by "uint32_t".

> +		};
> +	};
> +};
> +
> +/* Execute a known number of guest instructions. Only odd instruction counts
> + * greater than or equal to 3 are supported. The control register (PMCR) is
> + * initialized with the provided value (allowing for example for the cycle
> + * counter or eventer count to be reset if needed). After the known instruction
> + * count loop, zero is written to the PMCR to disable counting, allowing the
> + * cycle counter or event counters to be read as needed at a later time.
> + */
> +static void measure_instrs(int len, struct pmu_data pmcr)
> +{
> +	int i = (len - 1) / 2;
> +
> +	if (len < 3 || ((len - 1) % 2))
> +		abort();
> +
> +	asm volatile(
> +		"msr pmcr_el0, %[pmcr]\n"
> +		"1: subs %[i], %[i], #1\n"
> +		"b.gt 1b\n"
> +		"msr pmcr_el0, xzr"
> +	: [i] "+r" (i) : [pmcr] "r" (pmcr) : "cc");
> +}
> +
> +int main()
> +{
> +	struct pmu_data pmcr;
> +	const int samples = 10;
> +
> +	asm volatile("mrs %0, pmcr_el0" : "=r" (pmcr));
> +
> +	printf("PMU implementor:     %c\n", pmcr.implementor);
> +	printf("Identification code: 0x%x\n", pmcr.identification_code);
> +	printf("Event counters:      %d\n", pmcr.num_counters);
> +
> +	pmcr.cycle_counter_reset = 1;
> +	pmcr.enable = 1;
> +
> +	printf("\ninstructions : cycles0 cycles1 ...\n");
> +
> +	for (int i = 3; i < 300; i += 32) {
> +		int avg, sum = 0;
> +		printf("%d :", i);
> +		for (int j = 0; j < samples; j++) {
> +			int val;
> +			measure_instrs(i, pmcr);
> +			asm volatile("mrs %0, pmccntr_el0" : "=r" (val));
> +			sum += val;
> +			printf(" %d", val);
> +		}
> +		avg = sum / samples;
> +		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n", sum, avg, i / avg, avg / i);
> +	}

I understand that, as stated in commit message, it currently doesn't
check the correctness of PMU counter values. But it would be better if
testing code can be abstracted into an independent function (e.g.
instr_cycle_check) for report("Instruction Cycles",
instr_cycle_check()). You can return TRUE in the checking code for now.


> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index e068a0c..b3b7ff4 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -35,3 +35,14 @@ file = selftest.flat
>  smp = `getconf _NPROCESSORS_CONF`
>  extra_params = -append 'smp'
>  groups = selftest
> +
> +# Test PMU support without -icount
> +[pmu]
> +file = pmu.flat
> +groups = pmu
> +
> +# Test PMU support with -icount
> +[pmu-icount]
> +file = pmu.flat
> +groups = pmu
> +extra_params = -icount 0
> diff --git a/config/config-arm64.mak b/config/config-arm64.mak
> index d61b703..140b611 100644
> --- a/config/config-arm64.mak
> +++ b/config/config-arm64.mak
> @@ -12,9 +12,11 @@ cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
>  
>  # arm64 specific tests
> -tests =
> +tests = $(TEST_DIR)/pmu.flat
>  
>  include config/config-arm-common.mak
>  
>  arch_clean: arm_clean
>  	$(RM) lib/arm64/.*.d
> +
> +$(TEST_DIR)/pmu.elf: $(cstart.o) $(TEST_DIR)/pmu.o
> 
