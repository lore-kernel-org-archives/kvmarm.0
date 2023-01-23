Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525657E2
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 20:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674506039;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3yiJ0LLxvtbFO2iTfAP2iJAfDFf5lSlEOvDDJWpwwc=;
	b=dLP7FBEL2bG9Ee3Ezq7xottKb9LESlMmV9Er3cbuEua/s5anQkmE5zM3sRrUutWT81rLhY
	JMyeOHd0DGxbU4cuit4sckdSx+qW+DFoAIxHGWR+INzJ0/R46Dh7s8oWoWuakjvd15Xy3d
	IsMIJjlhi6xRdmSGgf0iByAcVd03qrw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-kq1UrFTYMMOnwvIRhTWFUQ-1; Mon, 23 Jan 2023 15:33:56 -0500
X-MC-Unique: kq1UrFTYMMOnwvIRhTWFUQ-1
Received: by mail-qk1-f199.google.com with SMTP id u10-20020a05620a0c4a00b00705e77d6207so9508817qki.5
        for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 12:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j3yiJ0LLxvtbFO2iTfAP2iJAfDFf5lSlEOvDDJWpwwc=;
        b=7SfkGsKzNR5a13EWaK40R6m/0t640DTpAjQRT8JlMS005txNPteb21mRpN0EslTsdn
         nrLAlAln0EaxzfKoRaM4tM8G0zDx+ryFuRI4KcGA6CzIYd+nYGtIe8mwGWWGlY2tiM/r
         j52XPUbBfkMlMC0RQUnzlvbUyX3xQlMxpR0PrONWlHcRr+xK4kF86luUvvhazvunj2sk
         F4jzdLI+z6YmQTi+G8nI32kTZejbjv2OJiBGKoex/5XZUHJkpaRkYXNcNuv38xAFO1cO
         uZCm5BGOchqqF7aR8GLAWjhEjz3YnYsQKWZfPKJpaVuxn+XxPBP+ytTHgGLF9r5BylDn
         uuxw==
X-Gm-Message-State: AFqh2kpmw134nTI4OuhHb9C79Su6QvkdCtVvsUAqKATUjFBlBM97/kqe
	rtfGjFblAikK4j/UnU69R4WAJJoahRmMF53mOs2Nje7eVI+c/ypOAF816M5bHyJZcuot4BeCdwf
	Dxf6hQpiJHSFa4Qbr
X-Received: by 2002:ac8:6f09:0:b0:3b6:2d34:45ef with SMTP id bs9-20020ac86f09000000b003b62d3445efmr42971910qtb.7.1674506035427;
        Mon, 23 Jan 2023 12:33:55 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt6rL//i20o2XoUY8MWX5LeRcBD4/aFtgQ1XCySuYGQ7H9PJZ0eqJpvPbO2AdAFSm8GRcZJ7w==
X-Received: by 2002:ac8:6f09:0:b0:3b6:2d34:45ef with SMTP id bs9-20020ac86f09000000b003b62d3445efmr42971880qtb.7.1674506035090;
        Mon, 23 Jan 2023 12:33:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a19-20020ac84353000000b003a7e38055c9sm278671qtn.63.2023.01.23.12.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:33:54 -0800 (PST)
Message-ID: <8bfc9b2b-0bad-a6dc-3c23-f67ad3d56741@redhat.com>
Date: Mon, 23 Jan 2023 21:33:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230109211754.67144-4-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 1/9/23 22:17, Ricardo Koller wrote:
> Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
> and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
> supported on PMUv3p5.
>
> Note that chained tests do not implement "overflow_at_64bits == true".
> That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
> details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
> 0487H.a, J1.1.1 "aarch64/debug").
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/pmu.c | 116 +++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 75 insertions(+), 41 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 0d06b59..72d0f50 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -28,6 +28,7 @@
>  #define PMU_PMCR_X         (1 << 4)
>  #define PMU_PMCR_DP        (1 << 5)
>  #define PMU_PMCR_LC        (1 << 6)
> +#define PMU_PMCR_LP        (1 << 7)
>  #define PMU_PMCR_N_SHIFT   11
>  #define PMU_PMCR_N_MASK    0x1f
>  #define PMU_PMCR_ID_SHIFT  16
> @@ -56,9 +57,13 @@
>  
>  #define ALL_SET			0x00000000FFFFFFFFULL
>  #define ALL_CLEAR		0x0000000000000000ULL
> -#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW_32		0x00000000FFFFFFF0ULL
> +#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
>  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
>  
> +#define PRE_OVERFLOW(__overflow_at_64bits)				\
> +	(__overflow_at_64bits ? PRE_OVERFLOW_64 : PRE_OVERFLOW_32)
> +
>  #define PMU_PPI			23
>  
>  struct pmu {
> @@ -449,8 +454,10 @@ static bool check_overflow_prerequisites(bool overflow_at_64bits)
>  static void test_basic_event_count(bool overflow_at_64bits)
>  {
>  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> -	uint32_t counter_mask;
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> +	uint32_t counter_mask;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>  	    !check_overflow_prerequisites(overflow_at_64bits))
> @@ -472,13 +479,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
>  	 * clear cycle and all event counters and allow counter enablement
>  	 * through PMCNTENSET. LC is RES1.
>  	 */
> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
>  	isb();
> -	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
>  
>  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>  		"counter #0 preset to pre-overflow value");
>  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
>  
> @@ -531,6 +538,8 @@ static void test_mem_access(bool overflow_at_64bits)
>  {
>  	void *addr = malloc(PAGE_SIZE);
>  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
>  	    !check_overflow_prerequisites(overflow_at_64bits))
> @@ -542,7 +551,7 @@ static void test_mem_access(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
>  	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
>  	/* We may measure more than 20 mem access depending on the core */
> @@ -552,11 +561,11 @@ static void test_mem_access(bool overflow_at_64bits)
>  
>  	pmu_reset();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	isb();
> -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	report(read_sysreg(pmovsclr_el0) == 0x3,
>  	       "Ran 20 mem accesses with expected overflows on both counters");
>  	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> @@ -566,8 +575,10 @@ static void test_mem_access(bool overflow_at_64bits)
>  
>  static void test_sw_incr(bool overflow_at_64bits)
>  {
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  	uint32_t events[] = {SW_INCR, SW_INCR};
> -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +	uint64_t cntr0 = (pre_overflow + 100) & pmevcntr_mask();
>  	int i;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)) ||
> @@ -581,7 +592,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -589,14 +600,14 @@ static void test_sw_incr(bool overflow_at_64bits)
>  
>  	isb();
>  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
>  		"PWSYNC does not increment if PMCR.E is unset");
>  
>  	pmu_reset();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -614,6 +625,7 @@ static void test_sw_incr(bool overflow_at_64bits)
>  static void test_chained_counters(bool unused)
>  {
>  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> +	uint64_t all_set = pmevcntr_mask();
ALL_SET_32 may be enough, as suggested by Reiji;
>  
>  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
>  		return;
> @@ -624,7 +636,7 @@ static void test_chained_counters(bool unused)
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  
> @@ -636,26 +648,26 @@ static void test_chained_counters(bool unused)
>  	pmu_reset();
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_regn_el0(pmevcntr, 1, 0x1);
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
>  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
>  	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, ALL_SET);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
> +	write_regn_el0(pmevcntr, 1, all_set);
and here
>  
>  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> +	report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
>  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
>  
>  static void test_chained_sw_incr(bool unused)
>  {
>  	uint32_t events[] = {SW_INCR, CHAIN};
> -	uint64_t cntr0 = (PRE_OVERFLOW + 100) & pmevcntr_mask();
> +	uint64_t cntr0 = (PRE_OVERFLOW_32 + 100) & pmevcntr_mask();
>  	uint64_t cntr1 = (ALL_SET + 1) & pmevcntr_mask();
>  	int i;
the chained counter changes may be put in a separate patch to help the
reviewer focus on the new 64b overflow tests.
>  
> @@ -669,7 +681,7 @@ static void test_chained_sw_incr(bool unused)
>  	/* enable counters #0 and #1 */
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>  	isb();
>  
> @@ -687,7 +699,7 @@ static void test_chained_sw_incr(bool unused)
>  	pmu_reset();
>  
>  	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_regn_el0(pmevcntr, 1, ALL_SET);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
>  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> @@ -726,7 +738,7 @@ static void test_chain_promotion(bool unused)
>  
>  	/* Only enable even counter */
>  	pmu_reset();
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW_32);
>  	write_sysreg_s(0x1, PMCNTENSET_EL0);
>  	isb();
>  
> @@ -856,6 +868,9 @@ static bool expect_interrupts(uint32_t bitmap)
>  
>  static void test_overflow_interrupt(bool overflow_at_64bits)
>  {
> +	uint64_t pre_overflow = PRE_OVERFLOW(overflow_at_64bits);
> +	uint64_t all_set = pmevcntr_mask();
> +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
>  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
>  	void *addr = malloc(PAGE_SIZE);
>  	int i;
> @@ -874,16 +889,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
>  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
>  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>  	isb();
>  
>  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
I noticed that undocumented change. Is it done on purpose?
>  	report(expect_interrupts(0), "no overflow interrupt after preset");
>  
> -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	isb();
>  
>  	for (i = 0; i < 100; i++)
> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  
>  	pmu_reset_stats();
>  
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, pre_overflow);
>  	write_sysreg(ALL_SET, pmintenset_el1);
>  	isb();
>  
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
>  	for (i = 0; i < 100; i++)
>  		write_sysreg(0x3, pmswinc_el0);
>  
> @@ -912,25 +927,40 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>  	report(expect_interrupts(0x3),
>  		"overflow interrupts expected on #0 and #1");
>  
> -	/* promote to 64-b */
> +	/*
> +	 * promote to 64-b:
> +	 *
> +	 * This only applies to the !overflow_at_64bits case, as
> +	 * overflow_at_64bits doesn't implement CHAIN events. The
> +	 * overflow_at_64bits case just checks that chained counters are
> +	 * not incremented when PMCR.LP == 1.
> +	 */
>  
>  	pmu_reset_stats();
>  
>  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
>  	isb();
> -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> -	report(expect_interrupts(0x1),
> -		"expect overflow interrupt on 32b boundary");
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	report(expect_interrupts(0x1), "expect overflow interrupt");
>  
>  	/* overflow on odd counter */
>  	pmu_reset_stats();
> -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -	write_regn_el0(pmevcntr, 1, ALL_SET);
> +	write_regn_el0(pmevcntr, 0, pre_overflow);
> +	write_regn_el0(pmevcntr, 1, all_set);
>  	isb();
> -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> -	report(expect_interrupts(0x3),
> -		"expect overflow interrupt on even and odd counter");
> +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> +	if (overflow_at_64bits) {
> +		report(expect_interrupts(0x1),
> +		       "expect overflow interrupt on even counter");
> +		report(read_regn_el0(pmevcntr, 1) == all_set,
> +		       "Odd counter did not change");
> +	} else {
> +		report(expect_interrupts(0x3),
> +		       "expect overflow interrupt on even and odd counter");
> +		report(read_regn_el0(pmevcntr, 1) != all_set,
> +		       "Odd counter wrapped");
> +	}
>  }
>  #endif
>  
> @@ -1131,10 +1161,13 @@ int main(int argc, char *argv[])
>  		report_prefix_pop();
>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>  		run_test(argv[1], test_basic_event_count, false);
> +		run_test(argv[1], test_basic_event_count, true);
>  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
>  		run_test(argv[1], test_mem_access, false);
> +		run_test(argv[1], test_mem_access, true);
>  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
>  		run_test(argv[1], test_sw_incr, false);
> +		run_test(argv[1], test_sw_incr, true);
>  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
>  		run_test(argv[1], test_chained_counters, false);
>  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> @@ -1143,6 +1176,7 @@ int main(int argc, char *argv[])
>  		run_test(argv[1], test_chain_promotion, false);
>  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
>  		run_test(argv[1], test_overflow_interrupt, false);
> +		run_test(argv[1], test_overflow_interrupt, true);
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}
Thanks

Eric

