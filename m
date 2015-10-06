From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCHv3 1/3] arm: Add PMU test
Date: Tue, 6 Oct 2015 21:38:27 +0200
Message-ID: <20151006193827.GF9323@hawk.localdomain>
References: <5612EDA5.9010506@redhat.com>
 <1444153766-12532-1-git-send-email-cov@codeaurora.org>
 <1444153766-12532-2-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444153766-12532-2-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, wei@redhat.com, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 06, 2015 at 01:49:24PM -0400, Christopher Covington wrote:
> Beginning with a simple sanity check of the control register, add
> a unit test for the ARM Performance Monitors Unit (PMU).
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arm/pmu.c               | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg       |  5 ++++
>  config/config-arm64.mak |  4 ++-
>  3 files changed, 74 insertions(+), 1 deletion(-)
>  create mode 100644 arm/pmu.c
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> new file mode 100644
> index 0000000..91a3688
> --- /dev/null
> +++ b/arm/pmu.c
> @@ -0,0 +1,66 @@
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
> +			uint32_t enable:1;
> +			uint32_t event_counter_reset:1;
> +			uint32_t cycle_counter_reset:1;
> +			uint32_t cycle_counter_clock_divider:1;
> +			uint32_t event_counter_export:1;
> +			uint32_t cycle_counter_disable_when_prohibited:1;
> +			uint32_t cycle_counter_long:1;
> +			uint32_t zeros:4;

resv might be a better name than zeros. Actually, does the spec even
state these bits will always be read as zeros?

> +			uint32_t num_counters:5;
> +			uint32_t identification_code:8;
> +			uint32_t implementer:8;
> +		};
> +	};
> +};
> +
> +/* As a simple sanity check on the PMCR_EL0, ensure the implementer field isn't
> + * null. Also print out a couple other interesting fields for diagnostic
> + * purposes. For example, as of fall 2015, QEMU TCG mode doesn't implement
> + * event counters and therefore reports zero of them, but hopefully support for
                                                ^for
> + * at least the instructions event will be added in the future and the reported
> + * number of event counters will become nonzero.
> + */
> +static bool check_pmcr(void)
> +{
> +	struct pmu_data pmcr;

Thanks for making the union and bitfield anonymous. I suggested
naming the struct pmu_data because I'm expecting more stuff to
eventually get shoved in there. If not, then maybe it needs to
be renamed something more pmcr-ish. Or, if it might expand its
purpose as I expect, then this variable should be renamed, i.e.

  struct pmu_data pmu;

> +
> +	asm volatile("mrs %0, pmcr_el0" : "=r" (pmcr));

And this should be

  asm volatile("mrs %0, pmcr_el0" : "=r" (pmu.pmcr_el0));

> +
> +	printf("PMU implementer:     %c\n", pmcr.implementer);
> +	printf("Identification code: 0x%x\n", pmcr.identification_code);
> +	printf("Event counters:      %d\n", pmcr.num_counters);
> +
> +	if (pmcr.implementer)
> +		return true;
> +
> +	return false;

How about

  return pmcr.implementer != 0;

> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("pmu");
> +
> +	report("Control register", check_pmcr());
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index e068a0c..fd94adb 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -35,3 +35,8 @@ file = selftest.flat
>  smp = `getconf _NPROCESSORS_CONF`
>  extra_params = -append 'smp'
>  groups = selftest
> +
> +# Test PMU support without -icount
> +[pmu]
> +file = pmu.flat
> +groups = pmu
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

We can have a PMU on 32-bit ARM processors too. If this test file
needs to be specific to 64-bit, then we should probably name it
less generically, like pmu64?

Thanks,
drew
