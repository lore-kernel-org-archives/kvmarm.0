From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] arm: Add PMU test
Date: Fri, 2 Oct 2015 11:58:32 +0200
Message-ID: <20151002095832.GC3719@hawk.localdomain>
References: <1443728841-10501-1-git-send-email-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443728841-10501-1-git-send-email-cov@codeaurora.org>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 01, 2015 at 03:47:21PM -0400, Christopher Covington wrote:
> Beginning with just a read of the control register, add plumbing
> for testing the ARM Performance Monitors Unit (PMU).
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>

Hi Christopher,

PMU tests are a great idea. I think Wei Huang has started working
on them too. I've CC'ed him so you two can work out how to proceed
without duplication of effort.

For kvm-unit-tests patches please make sure the kvm-unit-tests flag
is in the PATCH tag. You may want to run

  git config format.subjectprefix "kvm-unit-tests PATCH"

in your git repo.


> ---
>  arm/pmu.c                    | 31 +++++++++++++++++++++++++++++++
>  arm/unittests.cfg            |  5 +++++
>  config/config-arm-common.mak |  4 +++-
>  3 files changed, 39 insertions(+), 1 deletion(-)
>  create mode 100644 arm/pmu.c
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> new file mode 100644
> index 0000000..b1e3c7a
> --- /dev/null
> +++ b/arm/pmu.c
> @@ -0,0 +1,31 @@
> +#include "libcflat.h"
> +
> +union pmcr_el0 {
> +	struct {
> +		unsigned int implementor:8;
> +		unsigned int identification_code:8;
> +		unsigned int num_counters:5;
> +		unsigned int zeros:4;
> +		unsigned int cycle_counter_long:1;
> +		unsigned int cycle_counter_disable_when_prohibited:1;
> +		unsigned int event_counter_export:1;
> +		unsigned int cycle_counter_clock_divider:1;
> +		unsigned int cycle_counter_reset:1;
> +		unsigned int event_counter_reset:1;
> +		unsigned int enable:1;
> +	} split;

I'd use an anonymous struct here. And, since I prefer to avoid needing
to remember a data structure is a union, I'd also make the union anonymous
and wrap it inside a struct, i.e.

struct pmu_data {
        union {
                uint32_t pmcr_el0;
                struct {
			...
		};
	};
};

> +	uint32_t full;
> +};
> +
> +int main()
> +{
> +	union pmcr_el0 pmcr;
> +
> +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
> +
> +	printf("PMU implementor:     0x%x\n", pmcr.split.implementor);
> +	printf("Identification code: 0x%x\n", pmcr.split.identification_code);
> +	printf("Event counters:      %d\n", pmcr.split.num_counters);
> +
> +	return report_summary();
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index e068a0c..d3deb6a 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -35,3 +35,8 @@ file = selftest.flat
>  smp = `getconf _NPROCESSORS_CONF`
>  extra_params = -append 'smp'
>  groups = selftest
> +
> +# Test PMU support
> +[pmu]
> +file = pmu.flat
> +groups = pmu
> diff --git a/config/config-arm-common.mak b/config/config-arm-common.mak
> index 698555d..b34d04c 100644
> --- a/config/config-arm-common.mak
> +++ b/config/config-arm-common.mak
> @@ -11,7 +11,8 @@ endif
>  
>  tests-common = \
>  	$(TEST_DIR)/selftest.flat \
> -	$(TEST_DIR)/spinlock-test.flat
> +	$(TEST_DIR)/spinlock-test.flat \
> +	$(TEST_DIR)/pmu.flat
>  
>  all: test_cases
>  
> @@ -70,3 +71,4 @@ test_cases: $(generated_files) $(tests-common) $(tests)
>  
>  $(TEST_DIR)/selftest.elf: $(cstart.o) $(TEST_DIR)/selftest.o
>  $(TEST_DIR)/spinlock-test.elf: $(cstart.o) $(TEST_DIR)/spinlock-test.o
> +$(TEST_DIR)/pmu.elf: $(cstart.o) $(TEST_DIR)/pmu.o
> -- 
> Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
>

Thanks,
drew 
