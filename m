Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEBAC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 16:15:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1EE3D6112F
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 16:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1EE3D6112F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 984854B214;
	Tue,  7 Sep 2021 12:15:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LWFRjNPU5Aad; Tue,  7 Sep 2021 12:15:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F184B202;
	Tue,  7 Sep 2021 12:15:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF16B4B186
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 12:15:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EVBKJTKpX3Tf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 12:15:06 -0400 (EDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com
 [209.85.217.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D248B4B153
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 12:15:06 -0400 (EDT)
Received: by mail-vs1-f49.google.com with SMTP id a21so8768566vsp.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 09:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=53NoctMz48+CeLqiVC5I0V3NFwxWAgsbbnTUAzbd+hE=;
 b=YNYxpL3byJi9/i1wxvusekdfG85rJg2iAXadc+WxFxywy4oWvjMI3uXNcyWOlxxMrS
 EdpAOUgFjqpDIS/wwwtVDTmghSnl3ODhrbnz6soZ60h+yizjbAXAkJSf1grM7Teo2r0C
 vhpt1WVvz11f4Tc2cRbTDwOhKqZuJEOwhTWYAF1wvFhhF0XXyndZ4w25FOcpk2hHjbB5
 N01VZ0RdH41I+q8ndIQdwd1WcNIxYSM/6oqxKhJIjLE4udbySizWK7QbUakq4v5VKJIG
 OjyJBm5Vl29e29rFpxmIU8FKwDKc2afSbUPg+H8twGg1Pum+7VMJAOfkHMyxuVefxNlN
 fl0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=53NoctMz48+CeLqiVC5I0V3NFwxWAgsbbnTUAzbd+hE=;
 b=VXBzv/0CWMYjdtb06VVSf6ZiO6njwqFfrQSS2DKKRaTEzZbXY1RNuDwyGaEqTpfkUM
 sHSO5VHlit6mBsqSBB6Tv0ArREvY8mlPZemY04mFkK+ZA2L6dlOrFFTTFnjEjzfq/Ob7
 sVD9nAV/o/BQ0ILA8O8fjnaHDlaUWSJn+g+8tLcGZg+FFdi+LQ9WT3OYPJIU3CLD+ROg
 jxZgssQT3Simmpi6Riv64z5RsAuWPIG/YRWxt5XszMPTER6u6A+vA+SM2lMJawxD1a62
 lQkQ2j3HAA3Krk5EEtUkeOdZ1Fuq31/KS/Yz5qjDyLxM0DjiPDI36PKmbJzC5yx4na2a
 CE/Q==
X-Gm-Message-State: AOAM530Bn0Xs+R4U96o7rMrxpnhcWI7S7FTcRaRrQFJY1wHUjw1QTGS4
 vhjVn+VwJjsvOyOLfh0m+sCfjAr+uG30WWX4toTwdw==
X-Google-Smtp-Source: ABdhPJyPH1MEpxcXQlJbdJBRBkP9ThCEHiUxWntffEiOQeHb6NiMZUvRWykC9miCsBLizeK2Q+vVmPB6HEfXvgs4zYY=
X-Received: by 2002:a67:f74a:: with SMTP id w10mr9939395vso.13.1631031306233; 
 Tue, 07 Sep 2021 09:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
 <20210903110514.22x3txynin5hg46z@gator.home>
 <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
 <20210906063900.t6rbykpwyau5u32s@gator.home>
In-Reply-To: <20210906063900.t6rbykpwyau5u32s@gator.home>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 7 Sep 2021 09:14:54 -0700
Message-ID: <CAJHc60xEj3Xw9wcSbxCUXg0GE5+NTadQeO17f6hpa9VqQ1o5tg@mail.gmail.com>
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Sun, Sep 5, 2021 at 11:39 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Sep 03, 2021 at 01:53:27PM -0700, Raghavendra Rao Ananta wrote:
> > On Fri, Sep 3, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> > > > Since the timer stack (hardware and KVM) is per-CPU, there
> > > > are potential chances for races to occur when the scheduler
> > > > decides to migrate a vCPU thread to a different physical CPU.
> > > > Hence, include an option to stress-test this part as well by
> > > > forcing the vCPUs to migrate across physical CPUs in the
> > > > system at a particular rate.
> > > >
> > > > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > > > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > > > was discovered using arch_timer test with vCPU migrations and
> > > > can be easily reproduced.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
> > > >  1 file changed, 107 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > index 1383f33850e9..de246c7afab2 100644
> > > > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > @@ -14,6 +14,8 @@
> > > >   *
> > > >   * The test provides command-line options to configure the timer's
> > > >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > > > + * To stress-test the timer stack even more, an option to migrate the
> > > > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> > > >   *
> > > >   * Copyright (c) 2021, Google LLC.
> > > >   */
> > > > @@ -24,6 +26,8 @@
> > > >  #include <pthread.h>
> > > >  #include <linux/kvm.h>
> > > >  #include <linux/sizes.h>
> > > > +#include <linux/bitmap.h>
> > > > +#include <sys/sysinfo.h>
> > > >
> > > >  #include "kvm_util.h"
> > > >  #include "processor.h"
> > > > @@ -41,12 +45,14 @@ struct test_args {
> > > >       int nr_vcpus;
> > > >       int nr_iter;
> > > >       int timer_period_ms;
> > > > +     int migration_freq_ms;
> > > >  };
> > > >
> > > >  static struct test_args test_args = {
> > > >       .nr_vcpus = NR_VCPUS_DEF,
> > > >       .nr_iter = NR_TEST_ITERS_DEF,
> > > >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > > > +     .migration_freq_ms = 0,         /* Turn off migrations by default */
> > >
> > > I'd rather we enable good tests like these by default.
> > >
> > Well, that was my original idea, but I was concerned about the ease
> > for diagnosing
> > things since it'll become too noisy. And so I let it as a personal
> > preference. But I can
> > include it back and see how it goes.
>
> Break the tests into two? One run without migration and one with. If
> neither work, then we can diagnose the one without first, possibly
> avoiding the need to diagnose the one with.
>
Right. I guess that's where the test's migration switch can come in handy.
Let's turn migration ON by default. If we see a failure, we can turn
OFF migration
and run the tests. I'll try to include some verbose printing for diagnosability.

Regards,
Raghavendra
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
