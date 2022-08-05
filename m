Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589AFC25B08
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 00:43:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBE554ED30;
	Thu,  4 Aug 2022 20:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zdC2OnSCR0c1; Thu,  4 Aug 2022 20:43:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ADAC4EDF7;
	Thu,  4 Aug 2022 20:43:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3204ED30
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A6O9eWMYBwCS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 20:43:02 -0400 (EDT)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16F864ECF3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:43:01 -0400 (EDT)
Received: by mail-pj1-f46.google.com with SMTP id
 p14-20020a17090a74ce00b001f4d04492faso1336455pjl.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2022 17:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=9mS3Mfp0zzPbmPwS38oCb4X04tayRN9CYkrMdbYGE5E=;
 b=D/FkG3LtGVX1BhSpXaY+N4t4c2oajJR+xg3uzLJo6L5ejr94qD0YJf0weZ3BX2Br34
 X8ng0cxEN92dhDgChFs2idfjW1PM4dZLDcWBqemsadDwQsfbvxrcfeZULYO22uouBolu
 1fxZqJJEKA88NEvl3jk9Yql53B+73MAc1sz1USKkDlopEtyY84gj4flJbvpHPIUhQ9LE
 fUjJsnk6GyK5I06s/MVmBSgjcYKEQtUXRtttMVyLQg/ADVz/QocB3TzGesG2RMolneL/
 mI+OXGTrs0bewC8EMAJvW3QWp8tbUG5778Zow9YxFb6Ly+2GboBE+hXq5ek17q2mpQFp
 y0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=9mS3Mfp0zzPbmPwS38oCb4X04tayRN9CYkrMdbYGE5E=;
 b=Jps4q5Ytc5kDHcxi3NOSqJi4ZTvNV89aDli72KR9+ZYRgoj5ox2n3TbgejOGUNhatO
 Ah/VibTaTwKuP36p7YxnlX1pBw64nVek1JR/liPwkRoA7XtRnlPGDAnOI1qELE7kYd35
 YL8Y+Iwl7Up1Xtc7YP0Vz2X1g15jaTEoZhLI/5KeVMg42VT7YzkQuGFTNZy2sLLTJJ4l
 L3cS45j88xAM31m7jtQZC+5C71zu9qRia9ViEKCraRJjmoqHsj0L2yJPrhq+Ta5XJZkU
 93BgZr14LOpEUKxlf4c2bKCYgTvvSSNK8bknI6FK9ZBPOY5LJPRO5Bb24NC11EY6OOxj
 JbAg==
X-Gm-Message-State: ACgBeo0S68D021KmgKuOuTE4QJO7Jiafze/sUZgx31R9pwS934T/e9LX
 Jt52noYD6PD98y5EfSGw17bt3g==
X-Google-Smtp-Source: AA6agR7crwU6fs5zp1rQ2HaxgIEoz0hMjGBBxbDxp23/BNVlcC056/nC99ZFfbBfvylYxEU0IYcX4A==
X-Received: by 2002:a17:903:40c3:b0:16f:1d75:6f47 with SMTP id
 t3-20020a17090340c300b0016f1d756f47mr4218200pld.159.1659660180827; 
 Thu, 04 Aug 2022 17:43:00 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 4-20020a620504000000b0052d90512a53sm1631171pff.44.2022.08.04.17.42.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Aug 2022 17:43:00 -0700 (PDT)
Date: Thu, 4 Aug 2022 17:42:56 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/3] arm: pmu: Add missing isb()'s
 after sys register writing
Message-ID: <YuxnkI4ADEcVnCPA@google.com>
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-2-ricarkol@google.com>
 <YuuJZf9QPW5p/sbx@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YuuJZf9QPW5p/sbx@monolith.localdoman>
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

On Thu, Aug 04, 2022 at 09:55:01AM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Aug 03, 2022 at 11:23:26AM -0700, Ricardo Koller wrote:
> > There are various pmu tests that require an isb() between enabling
> > counting and the actual counting. This can lead to count registers
> > reporting less events than expected; the actual enabling happens after
> > some events have happened.  For example, some missing isb()'s in the
> > pmu-sw-incr test lead to the following errors on bare-metal:
> > 
> > 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> > 	PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> > 	FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> > 	FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> > 	INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> > 	PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> > 	SUMMARY: 4 tests, 2 unexpected failures
> > 
> > Add the missing isb()'s on all failing tests, plus some others that seem
> > required:
> > - after clearing the overflow signal in the IRQ handler to avoid
> >   spurious interrupts.
> 
> Nitpick, but it doesn't avoid (eliminates) spurious interrupts, it makes
> them less likely.
> 
> > - after direct writes to PMSWINC_EL0 for software to read the correct
> >   value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 15c542a2..76156f78 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > [..]
> > @@ -821,10 +832,13 @@ static void test_overflow_interrupt(void)
> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> >  
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x2, pmswinc_el0);
> >  
> >  	set_pmcr(pmu.pmcr_ro);
> > +	isb();
> 
> A context synchronization event affects system register writes that come
> before the context synchronization event in program order, but if there are
> multiple system register writes, it doesn't perform them in program order
> (if that makes sense).

Good point, didn't think of that case. Added the missing isb() in v3.

Thanks,
Ricardo

> 
> So it might happen that the CPU decides to perform the write to PMCR_EL1
> which disables the PMU *before* the writes to PMSWINC_EL0. Which means that
> even if PMINTENSET_EL1 allows the PMU to assert interrupts when it
> shouldn't (thus causing the test to fail), those interrupt won't be
> asserted by the PMU because the PMU is disabled and the test would pass.
> 
> You need an ISB after the PMSWINC_EL0 writes and before disabling the PMU.
> 
> Thanks,
> Alex
> 
> >  	report(expect_interrupts(0), "no overflow interrupt after counting");
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
