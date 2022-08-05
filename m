Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A964CC25B08
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 00:43:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 481534EF18;
	Thu,  4 Aug 2022 20:43:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cxwRy5XvOrlY; Thu,  4 Aug 2022 20:43:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E99644E36E;
	Thu,  4 Aug 2022 20:43:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 727B14E312
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:43:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PBZCDGh5eLsa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 20:43:47 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 287724E0E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:43:47 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id b4so1286506pji.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2022 17:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=kQ7XLNd19T2F/0Kyxgg6JcVUt8GKc+lVKttADwvo10Q=;
 b=o0Hz+1us5VA/Xhi2yrNBqIcOm+c2QYyK5BWs6G7ju17Z1xRI2ewGwz2Q9XJtRUF1zI
 Tzj/J2JNyfa2khkGo5FfEUEAsA8I0Z2HQJuAKT9xkogEOxLB29p+ZSy9p8yf46n56PIt
 7UocWMSPRjNZ8qxr2eY+J5og7iYRzL1PMU9BXE4K6/2EC2TQ9PdexzJCiMDM0mK2GW1E
 Q/xZL/iJTN4y4BxeNKN5S3PnV7PTBqpdJSYqJvzEMg453k4owZx+PUTbYpVadsQGo53/
 9Z5U1BolH3ioIGPN2GX97vUuCHkFoh2LLp5V9WbilWzFNXpn9ij9QC9tlGZ/oPIoGBXH
 Driw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=kQ7XLNd19T2F/0Kyxgg6JcVUt8GKc+lVKttADwvo10Q=;
 b=djhi+KIjdzku5vsa1zlMPI4Nnc5UfHE34EYZdgadxpbyid8o8N90CmcOMMyc1K5vW3
 Tep12PbD3QFxh1j+ZVVoJeLzTnzqymiGAnPrN7ZIDHBZh4Te5Bb1ZI2rxF3z0aZ74vjp
 wcnm6R3TlBouT86DLrLD/Gz4UtOnKZw3XVDcAB0sYSRYFU1+YDVuu/DLt3YMWnZWSTOv
 nv6f7WXiwSixf+guRAYXgBbPSXcTaspjPy/8sOhduDxj/cGTd2dH3qJLDEhqM9SG7Lry
 7sTDWG+StX3HAZC2rjF7+jl85U8W4tYxvsjYn5p45zDxfePOu0JY6fjDK/DmKgt5Ykz8
 7Yiw==
X-Gm-Message-State: ACgBeo2SWh41HnCeGzKzF4SbYgDfwE3+55vHGdbcMdBMChf6hrF7lzQK
 7e8mCzLEZBGQFv7VSj4Rob9OUw==
X-Google-Smtp-Source: AA6agR5vOF22By5G4B3O1K1orZI72z0z2GBJLPw9nu+X+0JSKcaaDQwhjARKOHGymwsC0NrtMgfaDw==
X-Received: by 2002:a17:90a:4291:b0:1f2:2a19:fc95 with SMTP id
 p17-20020a17090a429100b001f22a19fc95mr13151051pjg.29.1659660226053; 
 Thu, 04 Aug 2022 17:43:46 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 ij29-20020a170902ab5d00b0016dc6243bb2sm1557217plb.143.2022.08.04.17.43.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Aug 2022 17:43:45 -0700 (PDT)
Date: Thu, 4 Aug 2022 17:43:41 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] arm: pmu: Check for overflow in
 the low counter in chained counters tests
Message-ID: <YuxnvTT9EATgTY22@google.com>
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-4-ricarkol@google.com>
 <20220804081832.3pyn7nospfdekbz3@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220804081832.3pyn7nospfdekbz3@kamzik>
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

On Thu, Aug 04, 2022 at 10:18:32AM +0200, Andrew Jones wrote:
> On Wed, Aug 03, 2022 at 11:23:28AM -0700, Ricardo Koller wrote:
> > A chained event overflowing on the low counter can set the overflow flag
> > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > overflow.
> > 
> > The pmu chain tests fail on bare metal when checking the overflow flag
> > of the low counter _not_ being set on overflow.  Fix by checking for
> > overflow. Note that this test fails in KVM without the respective fix.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 33 ++++++++++++++++++---------------
> >  1 file changed, 18 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 7c5bc259..258780f4 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -583,7 +583,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  
> >  	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
> > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
> > +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
> >  
> >  	/* test 64b overflow */
> >  
> > @@ -595,7 +595,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
> > +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> > @@ -603,7 +603,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > -	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
> > +	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(void)
> > @@ -629,8 +629,9 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > -	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
> > -		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> > +	report((read_sysreg(pmovsclr_el0) == 0x1) &&
> > +		(read_regn_el0(pmevcntr, 1) == 1),
> > +		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  
> > @@ -648,10 +649,10 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > -	report((read_sysreg(pmovsclr_el0) == 0x2) &&
> > +	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> >  		(read_regn_el0(pmevcntr, 1) == 0) &&
> >  		(read_regn_el0(pmevcntr, 0) == 84),
> > -		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
> > +		"overflow on even and odd counters,  and expected values after 100 SW_INCR/CHAIN");
> 
> Besides the extra space, this doesn't read well (to me).

Replaced the sentence with something simpler and hopefully nicer (in v3).

Thanks,
Ricardo

> 
> Thanks,
> drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
