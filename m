Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791A0C10F1B
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 18:01:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B65D64B91F;
	Tue, 13 Dec 2022 13:01:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7OgFD4FUbf+W; Tue, 13 Dec 2022 13:01:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32FBF4B8DD;
	Tue, 13 Dec 2022 13:01:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 017AA4B8CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 13:01:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 80shBZat032u for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2022 13:01:11 -0500 (EST)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7100F4B8B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 13:01:11 -0500 (EST)
Received: by mail-pj1-f47.google.com with SMTP id
 e7-20020a17090a77c700b00216928a3917so4379531pjs.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2022 10:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=My4YjakvUbk1o4WKdOiZPCHxDVw/xJTKMr2LnnQaGN4=;
 b=qZ2TtkvdjSipsoOAy2H8rx1eDLV0IwHZJqgJhy2mQpYEuqdMLebaJVSgIHR/ARSz1k
 LfaFGRrM0ut24/oOPGSvhet5aEwIBrXMJDWG/1qMrXzG/Hnhm0YOBCBlHfHNwFyUM+ON
 a5DoiEzNA9xVWE+azzfd12FxNkqFM9QtuUyqLrqSLSSPmujZzoSkczfNHMIezfoeuaMa
 1FuUa8IHJO9oFkepiksdXdhNYbopyFA8woTs4VC7UFX9GB34ZFf3672qIK0U0aZrN+aV
 1pVCFEPNVwNT6baCr9cu0ykRDIy7BR+w7UqqR9kI4FyMgIV0um1klazVcHbNTu++RJG9
 QrPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=My4YjakvUbk1o4WKdOiZPCHxDVw/xJTKMr2LnnQaGN4=;
 b=AhO3IbYqlW0btEoXaUWIDFSZ6Tuk6lCPETHreKjM0j5Tjrq5wk5Drnwik4XI4iN9W8
 sug0LRIB6xfEyt603tehTZ7XjxKfYffavjDcP6TQfFdy0WHjXlxUwddhscRfASURZ4xB
 su+5+Vo8BPjyOnefdekZM0KSfJVOTwXnHP0CTLh6IATZl4/NksAdxzP0dLE0nSyE+g/O
 QsK7kAbOqjfHN03snfUZMgSeVMPk2vq3J5pvESegVC7HYDQ2uiW7dS/A600Ms+kd7MKL
 QP8oPFCq2ewSKfC+Vw09ZZtnR7FSiWM1oCp2rm8QYa0SZ3OMBS8XBo7Phy++TT2Pzp9s
 Sd7A==
X-Gm-Message-State: ANoB5pmHvpIbnm4lpPWFsg28kpt5x0UzFRINdbtbDCOtuVNgWXEVOicy
 eSvBBKNQ790/nSnt4b0iP5YEPQ==
X-Google-Smtp-Source: AA0mqf4b6XRxUROBc2qMpJNJy/tdk1Pvr20WZBKA5WikwHicXBS9yibYpkN11XonvaaqbdY4TynPWA==
X-Received: by 2002:a05:6a21:2d8f:b0:a7:882e:3a18 with SMTP id
 ty15-20020a056a212d8f00b000a7882e3a18mr120302pzb.1.1670954470167; 
 Tue, 13 Dec 2022 10:01:10 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 h196-20020a6283cd000000b0056d3b8f530csm7941292pfe.34.2022.12.13.10.01.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Dec 2022 10:01:09 -0800 (PST)
Date: Tue, 13 Dec 2022 10:01:06 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5i94ojqRTJMWu8U@google.com>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
 <Y5hxvj6p+mCC2DOs@monolith.localdoman>
 <Y5imhKUIJceHDUMD@google.com>
 <Y5irunF72esHzOWj@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5irunF72esHzOWj@monolith.localdoman>
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

On Tue, Dec 13, 2022 at 04:43:38PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Dec 13, 2022 at 08:21:24AM -0800, Ricardo Koller wrote:
> > On Tue, Dec 13, 2022 at 12:36:14PM +0000, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > Some more comments below.
> > > 
> > > On Fri, Dec 02, 2022 at 04:55:25AM +0000, Ricardo Koller wrote:
> > > > PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> > > > for overflowing at 32 or 64-bits. The consequence is that tests that check
> > > > the counter values after overflowing should not assume that values will be
> > > > wrapped around 32-bits: they overflow into the other half of the 64-bit
> > > > counters on PMUv3p5.
> > > > 
> > > > Fix tests by correctly checking overflowing-counters against the expected
> > > > 64-bit value.
> > > > 
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >  arm/pmu.c | 29 ++++++++++++++++++-----------
> > > >  1 file changed, 18 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > > index cd47b14..eeac984 100644
> > > > --- a/arm/pmu.c
> > > > +++ b/arm/pmu.c
> > > > @@ -54,10 +54,10 @@
> > > >  #define EXT_COMMON_EVENTS_LOW	0x4000
> > > >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> > > >  
> > > > -#define ALL_SET			0xFFFFFFFF
> > > > -#define ALL_CLEAR		0x0
> > > > -#define PRE_OVERFLOW		0xFFFFFFF0
> > > > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > > > +#define ALL_SET			0x00000000FFFFFFFFULL
> > > > +#define ALL_CLEAR		0x0000000000000000ULL
> > > > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > > > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> > > >  
> > > >  #define PMU_PPI			23
> > > >  
> > > > @@ -538,6 +538,7 @@ static void test_mem_access(void)
> > > >  static void test_sw_incr(void)
> > > >  {
> > > >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > > > +	uint64_t cntr0;
> > > >  	int i;
> > > >  
> > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > > > @@ -572,9 +573,9 @@ static void test_sw_incr(void)
> > > >  		write_sysreg(0x3, pmswinc_el0);
> > > >  
> > > >  	isb();
> > > > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > > > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > > > -		"counter #0 after + 100 SW_INCR");
> > > > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > > > +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > > > +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> > > >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> > > >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> > > >  	report(read_sysreg(pmovsclr_el0) == 0x1,
> > > > @@ -584,6 +585,7 @@ static void test_sw_incr(void)
> > > >  static void test_chained_counters(void)
> > > >  {
> > > >  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> > > > +	uint64_t cntr1;
> > > >  
> > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > > >  		return;
> > > > @@ -618,13 +620,16 @@ static void test_chained_counters(void)
> > > >  
> > > >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> > > >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > > > -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > > > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > > > +	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> > > 
> > > It looks to me like the intention of the test was to check that the counter
> > > programmed with the CHAIN event wraps, judging from the report message.
> > > 
> > 
> > Ah, right. Yeah, that message is confusing. It should be the short
> > version of "Inrementing at 32-bits resulted in the right value".
> > 
> > > I think it would be interesting to keep that by programming counter #1 with
> > > ~0ULL when PMUv3p5 (maybe call it ALL_SET64?) and test the counter value
> > > against 0.
> > 
> > The last commit adds tests using ALL_SET64.  Tests can be run in two
> > modes: overflow_at_64bits and not.  However, this test,
> > test_chained_counters(), and all other chained tests only use the
> > !overflow_at_64bits mode (even after the last commit). The reason is
> > that there are no CHAIN events when overflowing at 64-bits (more details
> > in the commit message). But, don't worry, there are lots of tests that
> > check wrapping at 64-bits (overflow_at_64bits=true).
> 
> What I was suggesting is this (change on top of this series, not on top of
> this patch, to get access to ALL_SET_AT):

Ooh, I see, I agree: it would be better to check that the odd counter
increments from ~0ULL to 0 when using 64-bit counters.

> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 3cb563b1abe4..fd7f20fc6c52 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -607,7 +607,6 @@ static void test_sw_incr(bool overflow_at_64bits)
>  static void test_chained_counters(bool overflow_at_64bits)
>  {
>         uint32_t events[] = {CPU_CYCLES, CHAIN};
> -       uint64_t cntr1;
> 
>         if (!satisfy_prerequisites(events, ARRAY_SIZE(events),
>                                    overflow_at_64bits))
> @@ -639,12 +638,11 @@ static void test_chained_counters(bool overflow_at_64bits)
>         report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> 
>         write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> -       write_regn_el0(pmevcntr, 1, ALL_SET);
> +       write_regn_el0(pmevcntr, 1, ALL_SET_AT(overflow_at_64bits));

The only change is that this should be:

	ALL_SET_AT(pmu.version >= ID_DFR0_PMU_V3_8_5)

Because "overflow_at_64bits" implies PMCR_EL0.LP = 1.

> 
>         precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
>         report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> -       cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> -       report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> +       report(read_regn_el0(pmevcntr, 1) == 0, "CHAIN counter #1 wrapped");
> 
>         report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
>  }
> 
> The counters are 64bit, but the CHAIN event should still work because
> PMCR_EL0.LP is 0, according to the event description in the Arm ARM (ARM
> DDI 0487I.a, page D17-6461).
> 
> Thanks,
> Alex
> 
> > 
> > > Alternatively, the report message can be modified, and "wrapped"
> > > replaced with "incremented" (or something like that), to avoid confusion.
> > > 
> > > > +
> > > >  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> > > >  }
> > > >  
> > > >  static void test_chained_sw_incr(void)
> > > >  {
> > > >  	uint32_t events[] = {SW_INCR, CHAIN};
> > > > +	uint64_t cntr0, cntr1;
> > > >  	int i;
> > > >  
> > > >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > > > @@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
> > > >  		write_sysreg(0x1, pmswinc_el0);
> > > >  
> > > >  	isb();
> > > > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > > > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> > > >  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> > > > -		(read_regn_el0(pmevcntr, 1) == 0) &&
> > > > -		(read_regn_el0(pmevcntr, 0) == 84),
> > > > -		"expected overflows and values after 100 SW_INCR/CHAIN");
> > > > +	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
> > > > +	       (read_regn_el0(pmevcntr, 0) == cntr1),
> > > 
> > > This is hard to parse, it would be better if counter 0 is compared against
> > > cntr0 and counter 1 against cntr1.
> > 
> > Ah, yes, code is correct but that's indeed confusing.
> > 
> > > 
> > > Also, same suggestion here, looks like the test wants to check that the
> > > odd-numbered counter wraps around when counting the CHAIN event.
> > 
> > Ack. Will update for v2.
> > 
> > Thanks!
> > Ricardo
> > 
> > > 
> > > Thanks,
> > > Alex
> > > 
> > > > +	       "expected overflows and values after 100 SW_INCR/CHAIN");
> > > >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> > > >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> > > >  }
> > > > -- 
> > > > 2.39.0.rc0.267.gcb52ba06e7-goog
> > > > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
