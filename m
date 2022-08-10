Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E19C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 23:33:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1944DDC4;
	Wed, 10 Aug 2022 19:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CT4h5ozUXnnL; Wed, 10 Aug 2022 19:33:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 528A44DDBA;
	Wed, 10 Aug 2022 19:33:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B3C4DDB8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 19:33:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fo2f9tFtqzrA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 19:33:32 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B72B4DDB7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 19:33:32 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id r22so13285982pgm.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 16:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=KboTvwgUFUJZZgdLSyM30lTXnrslAqe3eOSw/sVDlUY=;
 b=jM6njugBVrh9WNTJQOr6gE5k45aeD/aB+ULFzWYMorDQhSH8zrpJNCjyFiWB34SbY7
 WrnyyGxzRlMhfroh8aQ737/XyEaYQpiBOOqoRSZnWPMuBT+nx1NiNcTIQyf8DFkWD1zf
 9wLEzWuB9v3Xgg9qJW1ptkKyd1BRRs47MabRONrogQjvNn0ZozusgLcRGTWRpYlHNk39
 WpwUFsKxAnqsrgMT5premRn33serrhdKBLJRhP+dYdoskAzny7eySKhtcc/C0yi+HpoH
 elCYpIACP4H2F6AmMaaul8Yx5pQdJj5SejLLeyrx2olqFCjH5qaM+167ZXvZ5LAicER8
 IfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=KboTvwgUFUJZZgdLSyM30lTXnrslAqe3eOSw/sVDlUY=;
 b=RVBr+wXkD63ni3lWHmr73V2IEp7jc6yAelVFAbCmVLiCjeo9LFS+yQy2mT4bf4S6cm
 7PPbUXDA2uZcVtbdFuGDqs/SsCR+6T35Na6+/ow1tK3sERKajptmAzyki3gTA67qZxQO
 65q1Sg478Upoi8LbLRuH6Rnu/6B9Bk8GeWZH7EQk5jkX3KMahxZRhjsf2rhdAlK6jG45
 D709eJkKkyrYetdDWC3u2c/Arh4zHlEwLvA7WUXJajug2lvdn5QKjBErIRWNydJh20Xw
 X1iEvipx9iEM4GeAkaYDY14M7D3habR7cxLYAlzL/0Yr+K0X8fFk/FtYJsUVKL1c7/PB
 vJrg==
X-Gm-Message-State: ACgBeo0J1V5l1UFVscFB0j43rIOHUI16761ZPspnspzYxkugbKHrfD+s
 pJ33FKgmmBJqAh/l4R+8p2nB5Q==
X-Google-Smtp-Source: AA6agR7L/RXaWNWjaSPyN9BUFzkksyrI4OgzKqR2iz1PyEsp2uz10foTn2uB8rPwHVCSuh3R9Obibw==
X-Received: by 2002:a05:6a00:1821:b0:52e:3c7c:9297 with SMTP id
 y33-20020a056a00182100b0052e3c7c9297mr29474982pfa.54.1660174410908; 
 Wed, 10 Aug 2022 16:33:30 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 i126-20020a628784000000b0052d33bf14d6sm2603501pfe.63.2022.08.10.16.33.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 10 Aug 2022 16:33:30 -0700 (PDT)
Date: Wed, 10 Aug 2022 16:33:26 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 2/3] arm: pmu: Reset the pmu registers
 before starting some tests
Message-ID: <YvRARgEDkSI1ken5@google.com>
References: <20220805004139.990531-1-ricarkol@google.com>
 <20220805004139.990531-3-ricarkol@google.com>
 <20220810190216.hqt3wyzufyvhhpkf@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220810190216.hqt3wyzufyvhhpkf@kamzik>
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 10, 2022 at 09:02:16PM +0200, Andrew Jones wrote:
> On Thu, Aug 04, 2022 at 05:41:38PM -0700, Ricardo Koller wrote:
> > Some registers like the PMOVS reset to an architecturally UNKNOWN value.
> > Most tests expect them to be reset (mostly zeroed) using pmu_reset().
> > Add a pmu_reset() on all the tests that need one.
> > 
> > As a bonus, fix a couple of comments related to the register state
> > before a sub-test.
> > 
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 4c601b05..12e7d84e 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
> >  	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> >  	isb();
> >  
> > -	/* interrupts are disabled */
> > +	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
> >  
> >  	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> > @@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
> >  	isb();
> >  	report(expect_interrupts(0), "no overflow interrupt after counting");
> >  
> > -	/* enable interrupts */
> > +	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
> >  
> >  	pmu_reset_stats();
> >  
> > @@ -890,6 +890,7 @@ static bool check_cycles_increase(void)
> >  	bool success = true;
> >  
> >  	/* init before event access, this test only cares about cycle count */
> > +	pmu_reset();
> 
> This and the other pmu_reset() call below break compilation on 32-bit arm,
> because there's no pmu_reset() defined for it.
I completely missed the 32-bit arm case. Thanks!

> It'd probably be best if
> we actually implemented some sort of reset for arm, considering it's being
> called in common tests.

Mind if I start by creating a pmu_reset() for 32-bit arm, which can
later be used by a general arm_reset()?

> 
> Thanks,
> drew
> 
> >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> >  
> > @@ -944,6 +945,7 @@ static bool check_cpi(int cpi)
> >  	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
> >  
> >  	/* init before event access, this test only cares about cycle count */
> > +	pmu_reset();
> >  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> >  	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> >  
> > -- 
> > 2.37.1.559.g78731f0fdb-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
