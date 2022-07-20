Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE24C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 21:21:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA1C4D8FD;
	Wed, 20 Jul 2022 17:21:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nB6WhDBwipkq; Wed, 20 Jul 2022 17:21:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED7B4D914;
	Wed, 20 Jul 2022 17:21:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 210FD4D8FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:21:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uH1IQ6PV42j8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 17:21:04 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 473E34D911
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:21:04 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id e16so17559511pfm.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=nETyZes6r+WdTkVJmCqdkDrl1X+qF+WpOLPfuydDKY8=;
 b=Qw9fnyif/telTEQCY2VpLgCg9Q7ckWB0iPYTwQogaBB300de+or1r+oCWaZsNTtlmM
 96fWLzLb8pz5+fV5ZPj8qZw5GwOJBRce9RdjVU5P5/xDV5pJ9vTT1TJsvH6DU/Sk4RWI
 CVA/GYc7BbZsffDmACXZ91Awy3NiL/t7oPfgmaYGOdf+BBHFPlll1qcn3j23U1qi5QLV
 F9KwBUuFzSxQ7CJe1J6eHI8jfx53e9zgqXdPl1vS2owxJcW18TgDly9Ox6R1rdQlp2fc
 Cj2EXCcbLdGffMVRikafFTelWUX79IBOlMv9CMe+3PgNh5C/RU0FcfAcGLG+B1pyXjTX
 IB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=nETyZes6r+WdTkVJmCqdkDrl1X+qF+WpOLPfuydDKY8=;
 b=eu3BpmsYiTxCmwy8SZDC5aVjy0MZXJE8pt3ZFbj7pN0QVa1hFZWfK2EYZAdjISCUh8
 Gc+ECx5yLBFNbO1Z15Xfm8yLd1EDAB5pghkVo9foLnrFLkKMAAAGzw2JvAPaiQ6enhfy
 30eySX/ktK16gwmB8OxU3mY3k90ej1q8ngOQXwWvSK7JLmqDSv4BixUct4858y5QNpu4
 81A6VaIbuOLJ3lfGx1yQhctBWHBEZwmx3MRCrM0AAHMLY47wLDT6PgWTMINUHAK3zwRv
 qVTHLNqzCbcOT1XGtzi8oQBe4RHnA7Al4dUVJqFgBquByvE6zfuoca4dw1HSVS/yx/DL
 kTfA==
X-Gm-Message-State: AJIora/1UqDwMFqxcaoFD7QJx3qQZfNKqVrS1T/jf7RNFGRZUeOcl3ob
 7iKpi/OY0PvrZbyiVw6Zs6Q5tg==
X-Google-Smtp-Source: AGRyM1vu3nT98pOKmBmQ0Vagol839niHDAst1eMkt1TOrXj71moRImGgoRNuZw3N1jS75gy9Pt6TWQ==
X-Received: by 2002:a63:4604:0:b0:40d:a0ec:5dc4 with SMTP id
 t4-20020a634604000000b0040da0ec5dc4mr35503558pga.510.1658352063143; 
 Wed, 20 Jul 2022 14:21:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 12-20020a630c4c000000b0040dd052ab11sm12094688pgm.58.2022.07.20.14.21.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Jul 2022 14:21:02 -0700 (PDT)
Date: Wed, 20 Jul 2022 14:20:58 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after
 sys register writing
Message-ID: <YthxunT37Sxt/Nei@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-2-ricarkol@google.com>
 <YtaSDhj2SXEzh8QI@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtaSDhj2SXEzh8QI@monolith.localdoman>
Cc: drjones@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu
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

On Tue, Jul 19, 2022 at 12:14:37PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> Since you're touching the PMU tests, I took the liberty to suggest changes
> somewhat related to this patch. If you don't want to implement them, let me
> know and I'll try to make a patch/series out of them.
> 
> On Mon, Jul 18, 2022 at 08:49:08AM -0700, Ricardo Koller wrote:
> > There are various pmu tests that require an isb() between enabling
> > counting and the actual counting. This can lead to count registers
> > reporting less events than expected; the actual enabling happens after
> > some events have happened.  For example, some missing isb()'s in the
> > pmu-sw-incr test lead to the following errors on bare-metal:
> > 
> > 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> >         PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> >         FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> >         FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> >         INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> >         PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> >         SUMMARY: 4 tests, 2 unexpected failures
> > 
> > Add the missing isb()'s on all failing tests, plus some others that are
> > not currently required but might in the future (like an isb() after
> > clearing the overflow signal in the IRQ handler).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 15c542a2..fd838392 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -307,6 +307,7 @@ static void irq_handler(struct pt_regs *regs)
> >  			}
> >  		}
> >  		write_sysreg(ALL_SET, pmovsclr_el0);
> > +		isb();
> >  	} else {
> >  		pmu_stats.unexpected = true;
> >  	}
> > @@ -534,6 +535,7 @@ static void test_sw_incr(void)
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > +	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x1, pmswinc_el0);
> > @@ -547,6 +549,7 @@ static void test_sw_incr(void)
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x3, pmswinc_el0);
> > @@ -618,6 +621,8 @@ static void test_chained_sw_incr(void)
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> > @@ -634,6 +639,8 @@ static void test_chained_sw_incr(void)
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> > @@ -821,6 +828,8 @@ static void test_overflow_interrupt(void)
> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> >  
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x2, pmswinc_el0);
> 
> You missed the set_pmcr(pmu.pmcr_ro) call on the next line.

Will add this in V2.

> 
> Also the comment "enable interrupts" below:
> 
> [..]
>         report(expect_interrupts(0), "no overflow interrupt after preset");
> 
>         set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
>         for (i = 0; i < 100; i++)
>                 write_sysreg(0x2, pmswinc_el0);
> 
>         set_pmcr(pmu.pmcr_ro);
>         report(expect_interrupts(0), "no overflow interrupt after counting");
> 
>         /* enable interrupts */
> 
>         pmu_reset_stats();
> [..]
> 
> is misleading, because pmu_reset_stats() doesn't enable the PMU. Unless the
> intention was to call pmu_reset(), in which case the comment is correct and
> the code is wrong. My guess is that the comment is incorrect, the test
> seems to be working fine when the PMU is enabled in the mem_access_loop()
> call.

Yes, it seems that the comment is incorrect. Will fix this in V2.

> 
> >  
> > @@ -879,6 +888,7 @@ static bool check_cycles_increase(void)
> >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> >  
> >  	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
> > +	isb();
> >  
> >  	for (int i = 0; i < NR_SAMPLES; i++) {
> >  		uint64_t a, b;
> > @@ -894,6 +904,7 @@ static bool check_cycles_increase(void)
> >  	}
> >  
> >  	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
> > +	isb();
> 
> Those look good to me.
> 
> Thanks,
> Alex

Thanks for the reviews,
Ricardo

> 
> >  
> >  	return success;
> >  }
> > -- 
> > 2.37.0.170.g444d1eabd0-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
