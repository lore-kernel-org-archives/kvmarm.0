Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9DCC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 14 Dec 2022 18:31:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E05954B972;
	Wed, 14 Dec 2022 13:31:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id moW6RAYqYjJM; Wed, 14 Dec 2022 13:31:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 355F54B979;
	Wed, 14 Dec 2022 13:31:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 450BE4B975
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 13:31:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DeHENtMx+RAj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2022 13:31:08 -0500 (EST)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C1134B944
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 13:31:08 -0500 (EST)
Received: by mail-pl1-f176.google.com with SMTP id g10so4210706plo.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2022 10:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=ef/KS+dDcI13fmIvD4UBbVCW4p2FNzehlTRgxqeAbB0=;
 b=pRV02hP3M+yJA2WHAGDkOa8IHMNmJTvfAj1MXEYW+D3dKrbCddh8FKLJXvZPFSC8C1
 xfK9xlnUy2K8yHeTSBEWyi6JqPhc4HnY5UjBz96YTrsmbnWN9yFD+knpUsBQlTaxphjq
 tJGDzJAoqrYg3Bp3N9XSEb6z+ZkK0FquzyohLw+mHap6AePeHlkU1tP5+kwUR41ukaaa
 pFZLJjR6C7HVHJh1LccgCI1P2xxNj0sydPzr7CJXs+9WzLPjTfn+9582jatLooLt35Tq
 9NeNyjbh5Xa6rTNeUcxzsuOB1lCImK8DUVNImWOuTh22fRwzo/y3hzn93WFZExwZ1VGr
 1JQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ef/KS+dDcI13fmIvD4UBbVCW4p2FNzehlTRgxqeAbB0=;
 b=uO/gYk0uxelqpqd6PkKLdxbZx3Xblz7Xlud1baaq54HPi6aZxAkXJ5xjAEAKrnJ3Ct
 rapllxC7wSCa5E2vmJhuS6P3imJTXo0kK2+Eue8PprOgcFht6WyuAO9QHvBcKfsaIjUr
 TAwWMC/RV20/6SfbaWHhJaMr1gKqBelKm/T/THMizkLAWbGM15kg4qjPtmncBJderhqu
 gjR9kkk4gp1sQbDaohdbN5FbYCRRC7YV3btcHs9CiNo0Pou2JfglrQNl3O4j3gZ9rinR
 QEdFznxF5YsC+DJu9drW4ujzPn1loZyub2AKNlbv8+TwK/3iO6H/AXs+MsPHILkAs3+l
 zcDw==
X-Gm-Message-State: ANoB5plvFUrOR+uOlASBR515YPJ/phXAkQcRYrqKzk6sDj4wM80U9BoK
 aIodtvOt//XptA1vWXQn9ddzMg==
X-Google-Smtp-Source: AA0mqf4rea3Df0TYacDCbrsx4dT3fzI/Ja0fotoDiRiLtV8KN5TsRrUiwq8gxKiHVYkymjNE/V7Qow==
X-Received: by 2002:a05:6a20:3b09:b0:a4:efde:2ed8 with SMTP id
 c9-20020a056a203b0900b000a4efde2ed8mr813131pzh.0.1671042667293; 
 Wed, 14 Dec 2022 10:31:07 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 q8-20020a170902a3c800b00174c1855cd9sm2169811plb.267.2022.12.14.10.31.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 14 Dec 2022 10:31:06 -0800 (PST)
Date: Wed, 14 Dec 2022 10:31:03 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y5oWZ7q9PkAc84cM@google.com>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-4-ricarkol@google.com>
 <Y5iwbJykRKFQumKi@monolith.localdoman>
 <Y5i+lMQ6/2hWGM47@google.com>
 <Y5mpM4uQiM+scQ5l@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5mpM4uQiM+scQ5l@monolith.localdoman>
Cc: kvm@vger.kernel.org, maz@kernel.org, andrew.jones@linux.dev,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Dec 14, 2022 at 10:45:07AM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Dec 13, 2022 at 10:04:04AM -0800, Ricardo Koller wrote:
> > On Tue, Dec 13, 2022 at 05:03:40PM +0000, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > Checked that all places where ALL_SET/PRE_OVERFLOW were used are now taking
> > > into account the fact that counters are programmed to be 64bit.
> > > 
> > > In the case of 64bit counters, the printf format specifier is %ld, which
> > > means that ALL_SET_64 and PRE_OVERFLOW_64 are now displayed as negative
> > > numbers. For example:
> > > 
> > > INFO: pmu: pmu-sw-incr: 32-bit: SW_INCR counter #0 has value 4294967280
> > > PASS: pmu: pmu-sw-incr: 32-bit: PWSYNC does not increment if PMCR.E is unset
> > > [..]
> > > INFO: pmu: pmu-sw-incr: 64-bit: SW_INCR counter #0 has value -16
> > > PASS: pmu: pmu-sw-incr: 64-bit: PWSYNC does not increment if PMCR.E is unset
> > > 
> > 
> > Argh, I didn't notice this. I think this would be more useful if it
> > printed %llx in all cases.
> 
> Indeed, printing the hex value will make it easier to match it against the
> defines.
> 
> One more comment below.
> 
> > 
> > > I was thinking that the format specifiers could be changed to unsigned
> > > long.  The counters only increment, they don't decrement, and I can't think
> > > how printing them as signed could be useful.
> > > 
> > > One more comment below.
> > > 
> > > On Fri, Dec 02, 2022 at 04:55:27AM +0000, Ricardo Koller wrote:
> > > > Modify all tests checking overflows to support both 32 (PMCR_EL0.LP == 0)
> > > > and 64-bit overflows (PMCR_EL0.LP == 1). 64-bit overflows are only
> > > > supported on PMUv3p5.
> > > > 
> > > > Note that chained tests do not implement "overflow_at_64bits == true".
> > > > That's because there are no CHAIN events when "PMCR_EL0.LP == 1" (for more
> > > > details see AArch64.IncrementEventCounter() pseudocode in the ARM ARM DDI
> > > > 0487H.a, J1.1.1 "aarch64/debug").
> > > > 
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >  arm/pmu.c | 91 ++++++++++++++++++++++++++++++++++++-------------------
> > > >  1 file changed, 60 insertions(+), 31 deletions(-)
> > > > 
> > > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > > index 59e5bfe..3cb563b 100644
> > > > --- a/arm/pmu.c
> > > > +++ b/arm/pmu.c
> > > > @@ -28,6 +28,7 @@
> > > >  #define PMU_PMCR_X         (1 << 4)
> > > >  #define PMU_PMCR_DP        (1 << 5)
> > > >  #define PMU_PMCR_LC        (1 << 6)
> > > > +#define PMU_PMCR_LP        (1 << 7)
> > > >  #define PMU_PMCR_N_SHIFT   11
> > > >  #define PMU_PMCR_N_MASK    0x1f
> > > >  #define PMU_PMCR_ID_SHIFT  16
> > > > @@ -55,10 +56,15 @@
> > > >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> > > >  
> > > >  #define ALL_SET			0x00000000FFFFFFFFULL
> > > > +#define ALL_SET_64		0xFFFFFFFFFFFFFFFFULL
> > > >  #define ALL_CLEAR		0x0000000000000000ULL
> > > >  #define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > > > +#define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
> > > >  #define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> > > >  
> > > > +#define PRE_OVERFLOW_AT(_64b)	(_64b ? PRE_OVERFLOW_64 : PRE_OVERFLOW)
> > > > +#define ALL_SET_AT(_64b)	(_64b ? ALL_SET_64 : ALL_SET)
> > > > +
> > > >  #define PMU_PPI			23
> > > >  
> > > >  struct pmu {
> > > > @@ -429,8 +435,10 @@ static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events,
> > > >  static void test_basic_event_count(bool overflow_at_64bits)
> > > >  {
> > > >  	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> > > > -	uint32_t counter_mask;
> > > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > > >  	uint32_t events[] = {CPU_CYCLES, INST_RETIRED};
> > > > +	uint32_t counter_mask;
> > > >  
> > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
> > > >  				   overflow_at_64bits))
> > > > @@ -452,13 +460,13 @@ static void test_basic_event_count(bool overflow_at_64bits)
> > > >  	 * clear cycle and all event counters and allow counter enablement
> > > >  	 * through PMCNTENSET. LC is RES1.
> > > >  	 */
> > > > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> > > > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P | pmcr_lp);
> > > >  	isb();
> > > > -	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> > > > +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC | pmcr_lp), "pmcr: reset counters");
> > > >  
> > > >  	/* Preset counter #0 to pre overflow value to trigger an overflow */
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > > +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
> > > >  		"counter #0 preset to pre-overflow value");
> > > >  	report(!read_regn_el0(pmevcntr, 1), "counter #1 is 0");
> > > >  
> > > > @@ -511,6 +519,8 @@ static void test_mem_access(bool overflow_at_64bits)
> > > >  {
> > > >  	void *addr = malloc(PAGE_SIZE);
> > > >  	uint32_t events[] = {MEM_ACCESS, MEM_ACCESS};
> > > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > > >  
> > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
> > > >  				   overflow_at_64bits))
> > > > @@ -522,7 +532,7 @@ static void test_mem_access(bool overflow_at_64bits)
> > > >  	write_regn_el0(pmevtyper, 1, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> > > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > >  	isb();
> > > > -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > > > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > >  	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
> > > >  	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
> > > >  	/* We may measure more than 20 mem access depending on the core */
> > > > @@ -532,11 +542,11 @@ static void test_mem_access(bool overflow_at_64bits)
> > > >  
> > > >  	pmu_reset();
> > > >  
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> > > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > >  	isb();
> > > > -	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> > > > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > >  	report(read_sysreg(pmovsclr_el0) == 0x3,
> > > >  	       "Ran 20 mem accesses with expected overflows on both counters");
> > > >  	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> > > > @@ -546,6 +556,8 @@ static void test_mem_access(bool overflow_at_64bits)
> > > >  
> > > >  static void test_sw_incr(bool overflow_at_64bits)
> > > >  {
> > > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > > >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > > >  	uint64_t cntr0;
> > > >  	int i;
> > > > @@ -561,7 +573,7 @@ static void test_sw_incr(bool overflow_at_64bits)
> > > >  	/* enable counters #0 and #1 */
> > > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > >  
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > >  	isb();
> > > >  
> > > >  	for (i = 0; i < 100; i++)
> > > > @@ -569,21 +581,21 @@ static void test_sw_incr(bool overflow_at_64bits)
> > > >  
> > > >  	isb();
> > > >  	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
> > > > -	report(read_regn_el0(pmevcntr, 0) == PRE_OVERFLOW,
> > > > +	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
> > > >  		"PWSYNC does not increment if PMCR.E is unset");
> > > >  
> > > >  	pmu_reset();
> > > >  
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > > > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > >  	isb();
> > > >  
> > > >  	for (i = 0; i < 100; i++)
> > > >  		write_sysreg(0x3, pmswinc_el0);
> > > >  
> > > >  	isb();
> > > > -	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > > > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : pre_overflow + 100;
> > > >  	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > > >  	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> > > >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> > > > @@ -844,6 +856,9 @@ static bool expect_interrupts(uint32_t bitmap)
> > > >  
> > > >  static void test_overflow_interrupt(bool overflow_at_64bits)
> > > >  {
> > > > +	uint64_t pre_overflow = PRE_OVERFLOW_AT(overflow_at_64bits);
> > > > +	uint64_t all_set = ALL_SET_AT(overflow_at_64bits);
> > > > +	uint64_t pmcr_lp = overflow_at_64bits ? PMU_PMCR_LP : 0;
> > > >  	uint32_t events[] = {MEM_ACCESS, SW_INCR};
> > > >  	void *addr = malloc(PAGE_SIZE);
> > > >  	int i;
> > > > @@ -862,16 +877,16 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > > >  	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
> > > >  	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
> > > >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> > > >  	isb();
> > > >  
> > > >  	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> > > >  
> > > > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > > +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> > > >  
> > > > -	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > > > +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > >  	isb();
> > > >  
> > > >  	for (i = 0; i < 100; i++)
> > > > @@ -886,12 +901,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > > >  
> > > >  	pmu_reset_stats();
> > > >  
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > -	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > > +	write_regn_el0(pmevcntr, 1, pre_overflow);
> > > >  	write_sysreg(ALL_SET, pmintenset_el1);
> > > >  	isb();
> > > >  
> > > > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > > +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > >  	for (i = 0; i < 100; i++)
> > > >  		write_sysreg(0x3, pmswinc_el0);
> > > >  
> > > > @@ -900,25 +915,35 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > > >  	report(expect_interrupts(0x3),
> > > >  		"overflow interrupts expected on #0 and #1");
> > > >  
> > > > -	/* promote to 64-b */
> > > > +	/*
> > > > +	 * promote to 64-b:
> > > > +	 *
> > > > +	 * This only applies to the !overflow_at_64bits case, as
> > > > +	 * overflow_at_64bits doesn't implement CHAIN events. The
> > > > +	 * overflow_at_64bits case just checks that chained counters are
> > > > +	 * not incremented when PMCR.LP == 1.
> > > > +	 */
> > > 
> > > If this doesn't do anything for when overflow_at_64bits, and since the
> > > interrupt is already tested before this part, why not exit early?
> > > 
> > > Or the test could check that the CHAIN event indeed does not increment when
> > > LP=1 at the end of this function.
> > 
> > That's precisely what it's doing.
> 
> Where? Are you referring to this part?
> 
> 	if (overflow_at_64bits)
> 		report(expect_interrupts(0x1),
> 		       "expect overflow interrupt on even counter");
> 
> My suggestion was to check that the counter that counts the CHAIN event
> didn't increment (PMEVCNTR1_EL0 == all_set).

Ah, I see. Yes, this could check that there are no interrupts and that
the even counter doesn't increment.

> I was thinking that since KVM
> emulates the CHAIN event in software, it might be useful to check that the
> final state of all registers is consistent. I'll leave it up to you to
> decide if you want to add this extra check.

Will add it if no other test is checking that, which I think is the
case.

Thanks!
Ricardo

> 
> Thanks,
> Alex
> 
> > 
> > Thanks!
> > Ricardo
> > 
> > > 
> > > Thanks,
> > > Alex
> > > 
> > > >  
> > > >  	pmu_reset_stats();
> > > >  
> > > >  	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > >  	isb();
> > > > -	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> > > > -	report(expect_interrupts(0x1),
> > > > -		"expect overflow interrupt on 32b boundary");
> > > > +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > > +	report(expect_interrupts(0x1), "expect overflow interrupt");
> > > >  
> > > >  	/* overflow on odd counter */
> > > >  	pmu_reset_stats();
> > > > -	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > > -	write_regn_el0(pmevcntr, 1, ALL_SET);
> > > > +	write_regn_el0(pmevcntr, 0, pre_overflow);
> > > > +	write_regn_el0(pmevcntr, 1, all_set);
> > > >  	isb();
> > > > -	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> > > > -	report(expect_interrupts(0x3),
> > > > -		"expect overflow interrupt on even and odd counter");
> > > > +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
> > > > +	if (overflow_at_64bits)
> > > > +		report(expect_interrupts(0x1),
> > > > +		       "expect overflow interrupt on even counter");
> > > > +	else
> > > > +		report(expect_interrupts(0x3),
> > > > +		       "expect overflow interrupt on even and odd counter");
> > > >  }
> > > >  #endif
> > > >  
> > > > @@ -1119,10 +1144,13 @@ int main(int argc, char *argv[])
> > > >  		report_prefix_pop();
> > > >  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
> > > >  		run_test(argv[1], test_basic_event_count, false);
> > > > +		run_test(argv[1], test_basic_event_count, true);
> > > >  	} else if (strcmp(argv[1], "pmu-mem-access") == 0) {
> > > >  		run_test(argv[1], test_mem_access, false);
> > > > +		run_test(argv[1], test_mem_access, true);
> > > >  	} else if (strcmp(argv[1], "pmu-sw-incr") == 0) {
> > > >  		run_test(argv[1], test_sw_incr, false);
> > > > +		run_test(argv[1], test_sw_incr, true);
> > > >  	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
> > > >  		run_test(argv[1], test_chained_counters, false);
> > > >  	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
> > > > @@ -1131,6 +1159,7 @@ int main(int argc, char *argv[])
> > > >  		run_test(argv[1], test_chain_promotion, false);
> > > >  	} else if (strcmp(argv[1], "pmu-overflow-interrupt") == 0) {
> > > >  		run_test(argv[1], test_overflow_interrupt, false);
> > > > +		run_test(argv[1], test_overflow_interrupt, true);
> > > >  	} else {
> > > >  		report_abort("Unknown sub-test '%s'", argv[1]);
> > > >  	}
> > > > -- 
> > > > 2.39.0.rc0.267.gcb52ba06e7-goog
> > > > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
