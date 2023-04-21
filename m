Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF6928E2
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 11:13:33 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA3C51480;
	Fri, 21 Apr 2023 04:14:16 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 682263F587;
	Fri, 21 Apr 2023 04:13:31 -0700 (PDT)
Date: Fri, 21 Apr 2023 12:13:28 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	andrew.jones@linux.dev, maz@kernel.org, will@kernel.org,
	oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH 5/6] arm: pmu: Add
 pmu-memaccess-reliability test
Message-ID: <ZEJv2EINBwNRjBa6@monolith.localdoman>
References: <20230315110725.1215523-1-eric.auger@redhat.com>
 <20230315110725.1215523-6-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110725.1215523-6-eric.auger@redhat.com>

Hi,

On Wed, Mar 15, 2023 at 12:07:24PM +0100, Eric Auger wrote:
> Add a new basic test that runs MEM_ACCESS loop over
> 100 iterations and make sure the number of measured
> MEM_ACCESS never overflows the margin. Some other
> pmu tests rely on this pattern and if the MEM_ACCESS
> measurement is not reliable, it is better to report
> it beforehand and not confuse the user any further.
> 
> Without the subsequent patch, this typically fails on
> ThunderXv2 with the following logs:
> 
> INFO: pmu: pmu-memaccess-reliability: 32-bit overflows:
> overflow=1 min=21 max=41 COUNT=20 MARGIN=15
> FAIL: pmu: pmu-memaccess-reliability: 32-bit overflows:
> memaccess is reliable
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c         | 52 +++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |  6 ++++++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index af679667..c3d2a428 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -56,6 +56,7 @@
>  #define EXT_COMMON_EVENTS_HIGH	0x403F
>  
>  #define ALL_SET_32		0x00000000FFFFFFFFULL
> +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
>  #define ALL_CLEAR		0x0000000000000000ULL
>  #define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
>  #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> @@ -67,6 +68,10 @@
>   * for some observed variability we take into account a given @MARGIN
>   */
>  #define PRE_OVERFLOW2_32		(ALL_SET_32 - COUNT - MARGIN)
> +#define PRE_OVERFLOW2_64		(ALL_SET_64 - COUNT - MARGIN)
> +
> +#define PRE_OVERFLOW2(__overflow_at_64bits)				\
> +	(__overflow_at_64bits ? PRE_OVERFLOW2_64 : PRE_OVERFLOW2_32)
>  
>  #define PRE_OVERFLOW(__overflow_at_64bits)				\
>  	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> @@ -746,6 +751,50 @@ static void disable_chain_counter(int even)
>  	isb();
>  }
>  
> +static void test_memaccess_reliability(bool overflow_at_64bits)
> +{
> +	uint32_t events[] = {MEM_ACCESS};
> +	void *addr = malloc(PAGE_SIZE);
> +	uint64_t count, max = 0, min = pmevcntr_mask();
> +	uint64_t pre_overflow2 = PRE_OVERFLOW2(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> +	bool overflow = false;
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> +	    !check_overflow_prerequisites(overflow_at_64bits))
> +		return;
> +
> +	pmu_reset();
> +	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> +	for (int i = 0; i < 100; i++) {
> +		pmu_reset();
> +		write_regn_el0(pmevcntr, 0, pre_overflow2);
> +		write_sysreg_s(0x1, PMCNTENSET_EL0);
> +		isb();
> +		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +		count = read_regn_el0(pmevcntr, 0);
> +		if (count < pre_overflow2) {
> +			count += COUNT + MARGIN;
> +			if (count > max)
> +				max = count;
> +			if (count < min)
> +				min = count;
> +			overflow = true;
> +			report_info("iter=%d count=%ld min=%ld max=%ld overflow!!!",
> +				    i, count, min, max);
> +			continue;
> +		}
> +		count -= pre_overflow2;
> +		if (count > max)
> +			max = count;
> +		if (count < min)
> +			min = count;

I'm having difficulties following the above maze of conditions. That's not going
to be easy to maintain.

If I understand the commit message correctly, the point of this test is to check
that PRE_OVERFLOW2 + COUNT doesn't overflow, but PRE_OVERFLOW2 + 2 * COUNT does.
How about this simpler approach instead:

	for (int i = 0; i < 100; i++) {
		pmu_reset();
		write_regn_el0(pmevcntr, 0, pre_overflow2);
		write_sysreg_s(0x1, PMCNTENSET_EL0);
		isb();

		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
		count = read_regn_el0(pmevcntr, 0);
		/* Counter overflowed when it shouldn't. */
		if (count < pre_overflow2) {
			report_fail("reliable memaccess loop");
			return;
		}

		mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
		count = read_regn_el0(pmevcntr, 0);
		/* Counter didn't overflow when it should. */
		if (count >= pre_overflow2) {
			report_fail("reliable memaccess loop");
			return;
		}
	}

	report_success("reliable memaccess loop");

Thanks,
Alex

>  static void test_chain_promotion(bool unused)
>  {
>  	uint32_t events[] = {MEM_ACCESS, CHAIN};
> @@ -1203,6 +1252,9 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>  		run_event_test(argv[1], test_basic_event_count, false);
>  		run_event_test(argv[1], test_basic_event_count, true);
> +	} else if (strcmp(argv[1], "pmu-memaccess-reliability") == 0) {
> +		run_event_test(argv[1], test_memaccess_reliability, false);
> +		run_event_test(argv[1], test_memaccess_reliability, true);
>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>  		run_event_test(argv[1], test_mem_access, false);
>  		run_event_test(argv[1], test_mem_access, true);
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 5e67b558..301261aa 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -90,6 +90,12 @@ groups = pmu
>  arch = arm64
>  extra_params = -append 'pmu-mem-access'
>  
> +[pmu-memaccess-reliability]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'pmu-memaccess-reliability'
> +
>  [pmu-sw-incr]
>  file = pmu.flat
>  groups = pmu
> -- 
> 2.38.1
> 
