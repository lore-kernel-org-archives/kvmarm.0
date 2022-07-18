Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37343C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 17:48:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7A604CC4D;
	Mon, 18 Jul 2022 13:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pcuRCOClOhzK; Mon, 18 Jul 2022 13:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 666CA4CCA1;
	Mon, 18 Jul 2022 13:48:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5DA14C6D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:48:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cGHDgARRGfa4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 13:48:35 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51AE04C6D4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 13:48:35 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id q16so8143595pgq.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=oOsKh/rIhzMX0TySwIVedxK3T/oFogHZu9Zo5Njg4nY=;
 b=iI/EuXMT3hnfS/KXhKpU2+UUram/irufsKD+JzL1ddlwduIbJlgnERbf5Xmd+GEVF+
 /XMBIqp7S2IUzYRjV+EIR5WtKp71bM7REnjxbD83DTV6sPd7ebKra89kCQGMamb12MAC
 yG9rpxXHw0kt68OtiRCJ6RbRjxzNpaiG5sBk1CfpW8w8Lw/efEzfpV/FdwwK3CTDrSH0
 2yOpdUOAVWWnTsIykRfbCFdZoM7Qw8VLy5PCzDPOixx+l75AI/lxvDdPrdfx2nAyRHd7
 ddXbM90BnyACrzrWKQDNRhvehCl+u5B1cqlWPEorVoV4lo+d/KroQBG2UKRLcY00ZCTm
 w2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oOsKh/rIhzMX0TySwIVedxK3T/oFogHZu9Zo5Njg4nY=;
 b=IXjhW6qN0r0a505OOgFyG8mc42ZH3YZARV038wuIUi8O4Nqerb7ZnoAszGnyTh1Ly0
 DRx6MR9nmCnF6M3GYCoyGLCtuhy75+wHd2stu45RtATTsOWvZdpsCftxahIq28jkhE2o
 lTlWI8nXGHYqe/JXT56Dsu2wmU/TE+6Vrp0BFcCjV3hjPw+2Ac7JOUD3gC5fLKbH5fef
 L02MBoZ9E+1cwyUGSL5vwcWiB6GGABErXIWwH3bJ9qAtfNG/m/nIzaONfQEi4bsSneAt
 yj60vYNQLsNhJVY6Q2Tb8+on/OGaRrurMTTwldPaYgrjRHeMEkRxlQw81fcDujrl5cqX
 s62g==
X-Gm-Message-State: AJIora/0vwm/8087eue6Kb0k9YyPpc+f3k2sazFqD7U7Hl2N9n2SqWU0
 UJz1baOLs5M6HidLriK1hQkxrw==
X-Google-Smtp-Source: AGRyM1sM+5CRpTbQiBX5p0a/c1Za6phiAHgbGxxqgGPFpFpn0lDH9mHEuzIfTx6X7ASHTSkNMpj0Sg==
X-Received: by 2002:a05:6a00:2481:b0:52a:d50e:e75e with SMTP id
 c1-20020a056a00248100b0052ad50ee75emr29606011pfv.43.1658166514122; 
 Mon, 18 Jul 2022 10:48:34 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 q11-20020a170902dacb00b001640aad2f71sm9844100plx.180.2022.07.18.10.48.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jul 2022 10:48:33 -0700 (PDT)
Date: Mon, 18 Jul 2022 10:48:29 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after
 sys register writing
Message-ID: <YtWc7YbR2d9uEZmX@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-2-ricarkol@google.com>
 <YtWMXYyrEvZDFrAb@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtWMXYyrEvZDFrAb@monolith.localdoman>
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

On Mon, Jul 18, 2022 at 05:38:23PM +0100, Alexandru Elisei wrote:
> Hi,
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
> 
> That's rather cryptic. What might require those hypothetical ISBs and why? Why
> should a test add code for some hypothetical requirement that might, or might
> not, be implemented?

Good point, this wasn't very clear. Will add something more specific.

> 
> This is pure speculation on my part, were you seeing spurious interrupts that
> went away after adding the ISB in irq_handler()?

I didn't see any. But I think it could happen: multiple spurious
interrupts until the line finally gets cleared.

> 
> A couple of comments below.
> 
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
> 
> Since your patch adds needed synchronization, from ARM DDI 0487H.a, page
> D13-5237:
> 
> "Where a direct write to one register causes a bit or field in a different
> register [..] to be updated as a side-effect of that direct write [..], the
> change to the different register [..] is defined to be an indirect write. In
> this case, the indirect write is only guaranteed to be visible to subsequent
> direct or indirect reads or writes if synchronization is performed after the
> direct write and before the subsequent direct or indirect reads or writes."
> 
> I think that says that you need an ISB after the direct writes to PMSWINC_EL0
> for software to read the correct value for PMEVNCTR0_EL0.
> 
> > @@ -547,6 +549,7 @@ static void test_sw_incr(void)
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	write_sysreg_s(0x3, PMCNTENSET_EL0);
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> >  
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x3, pmswinc_el0);
> 
> Same as above, might be worth checking in other places.
> 
> Will come back with more review comments.
> 
> Thanks,
> Alex
> 
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
> >  
> >  	return success;
> >  }
> > -- 
> > 2.37.0.170.g444d1eabd0-goog
> > 

Thanks!
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
