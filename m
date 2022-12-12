Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE13FC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 21:00:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 471254B95F;
	Mon, 12 Dec 2022 16:00:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e9NpZaOQNAVD; Mon, 12 Dec 2022 16:00:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08E444B944;
	Mon, 12 Dec 2022 16:00:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 336A24B84A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:00:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kj5jv2sr3WyK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 16:00:33 -0500 (EST)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7BC04B843
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:00:33 -0500 (EST)
Received: by mail-pl1-f172.google.com with SMTP id m4so13398041pls.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 13:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=q9Cyo+MN6iBVlGOYy9H2mOmmPEe1O5thk2JRcg21fBc=;
 b=KNx9YYvO93M5B4T55A8WKWO154LIH84Vo3+FddYs42VspFrdJyrMt/0QeFruvwvuhD
 D1A1dZFuhoNGfz3iGlwt4AUJeRC//kF1kT1nI+I1CfdI4dftF+t6YjPxYPKlpHdtGcrV
 6h17olcjsZKcD/cbVdH2P7SkU8ST1A24TA6BcaVZKr4/5+u6S3/+rGxEYz9Z7rGiNjCw
 bmneFuy9ChqbLHUay0pRh7IQkvI5wATkD4tBSplwQWXt5i1ZO71cMc1S6cJHjhLy2ZUY
 ktTMJoanlkW9I3IJwh4WQcjNkGFnB5o72Yd3mNZr01qQhrl1KkLb+Tjhi3PGlu/MCwEA
 6eYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=q9Cyo+MN6iBVlGOYy9H2mOmmPEe1O5thk2JRcg21fBc=;
 b=f1Bqmu3l8rbxuq9MXdCNIeKEzFIh7Wy5vXYZcan5jATSD042i2aaMMgghFTE3wPjvA
 FEu3zIniUVwQkMUp0xYt2+dnxYIHVLrDSnOPd6/ZpVR0JywDQRUZrjw9F74rQSlEzu47
 PqMxq/N/sp9QcH7r2UComKedDNY7dvHpMyAFTc3WJZOVhXGM4KK79NSb0JvA3MDPqwfW
 dGx81dzrDv/w6w2p/S3aYwEAgUt1W5Ya6rFpKC8jYIH7GXsdWJ1ZXhf+dwehLVPnDqhB
 ZhgNrRB9hzFLS26BhF510pB8R1rBApscGwCsczY5kIsl9A203A0Xu9bMeSgvZ5YRftiH
 mujQ==
X-Gm-Message-State: ANoB5pkWSWqbuyoKKJZ5wh8OFqoOnP9EnRqyYK55o6pSPwFFpufVYZ1Q
 Td87G/F1AeldWMXujo0uITelHw==
X-Google-Smtp-Source: AA0mqf5tIy71VbMFz6SVtwFMYe0tokUeSCJNdKhzpY/uiVg8ygC0fgJJRcgKfbPfsOuqoXFXn9nuZQ==
X-Received: by 2002:a05:6a20:1d57:b0:a7:891b:3601 with SMTP id
 cs23-20020a056a201d5700b000a7891b3601mr723671pzb.1.1670878832582; 
 Mon, 12 Dec 2022 13:00:32 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 e9-20020a63ae49000000b0046b1dabf9a8sm1128741pgp.70.2022.12.12.13.00.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 13:00:32 -0800 (PST)
Date: Mon, 12 Dec 2022 13:00:28 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for
 PMUv3p5 long counters
Message-ID: <Y5eWbEEDD/eOInYx@google.com>
References: <20221202045527.3646838-1-ricarkol@google.com>
 <20221202045527.3646838-2-ricarkol@google.com>
 <Y5N0os7zL/BaMBa3@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5N0os7zL/BaMBa3@monolith.localdoman>
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

On Fri, Dec 09, 2022 at 05:47:14PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Dec 02, 2022 at 04:55:25AM +0000, Ricardo Koller wrote:
> > PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
> > for overflowing at 32 or 64-bits. The consequence is that tests that check
> > the counter values after overflowing should not assume that values will be
> > wrapped around 32-bits: they overflow into the other half of the 64-bit
> > counters on PMUv3p5.
> > 
> > Fix tests by correctly checking overflowing-counters against the expected
> > 64-bit value.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 29 ++++++++++++++++++-----------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index cd47b14..eeac984 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -54,10 +54,10 @@
> >  #define EXT_COMMON_EVENTS_LOW	0x4000
> >  #define EXT_COMMON_EVENTS_HIGH	0x403F
> >  
> > -#define ALL_SET			0xFFFFFFFF
> > -#define ALL_CLEAR		0x0
> > -#define PRE_OVERFLOW		0xFFFFFFF0
> > -#define PRE_OVERFLOW2		0xFFFFFFDC
> > +#define ALL_SET			0x00000000FFFFFFFFULL
> > +#define ALL_CLEAR		0x0000000000000000ULL
> > +#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
> > +#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
> >  
> >  #define PMU_PPI			23
> >  
> > @@ -538,6 +538,7 @@ static void test_mem_access(void)
> >  static void test_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, SW_INCR};
> > +	uint64_t cntr0;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -572,9 +573,9 @@ static void test_sw_incr(void)
> >  		write_sysreg(0x3, pmswinc_el0);
> >  
> >  	isb();
> > -	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
> > -	report(read_regn_el0(pmevcntr, 1)  == 100,
> > -		"counter #0 after + 100 SW_INCR");
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> 
> Hm... in the Arm ARM it says that counters are 64-bit if PMUv3p5 is
> implemented.  But it doesn't say anywhere that versions newer than p5 are
> required to implement PMUv3p5.
> 
> For example, for PMUv3p7, it says that the feature is mandatory in Arm8.7
> implementations. My interpretation of that is that it is not forbidden for
> an implementer to cherry-pick this version on older versions of the
> architecture where PMUv3p5 is not implemented.
> 
> Maybe the check should be pmu.version == ID_DFR0_PMU_V3_8_5, to match the
> counter definitions in the architecture?
> 
> Also, I found the meaning of those numbers to be quite cryptic. Perhaps
> something like this would be more resilient to changes to the value of
> PRE_OVERFLOW and easier to understand:
> 
> +       cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ?
> +               (uint32_t)PRE_OVERFLOW + 100 :
> +               (uint64_t)PRE_OVERFLOW + 100;
> 
> I haven't tested the code, would that work?

Just checked. That works. It's much cleaner, thank you very much.

Will send a v2 a the end of the week, maybe after some more reviews.

> 
> Thanks,
> Alex
> 
> > +	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
> > +	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
> >  	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  	report(read_sysreg(pmovsclr_el0) == 0x1,
> > @@ -584,6 +585,7 @@ static void test_sw_incr(void)
> >  static void test_chained_counters(void)
> >  {
> >  	uint32_t events[] = {CPU_CYCLES, CHAIN};
> > +	uint64_t cntr1;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> >  		return;
> > @@ -618,13 +620,16 @@ static void test_chained_counters(void)
> >  
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> > -	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > +	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
> > +
> >  	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(void)
> >  {
> >  	uint32_t events[] = {SW_INCR, CHAIN};
> > +	uint64_t cntr0, cntr1;
> >  	int i;
> >  
> >  	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> > @@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > +	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
> > +	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
> >  	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> > -		(read_regn_el0(pmevcntr, 1) == 0) &&
> > -		(read_regn_el0(pmevcntr, 0) == 84),
> > -		"expected overflows and values after 100 SW_INCR/CHAIN");
> > +	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
> > +	       (read_regn_el0(pmevcntr, 0) == cntr1),
> > +	       "expected overflows and values after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  }
> > -- 
> > 2.39.0.rc0.267.gcb52ba06e7-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
