Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9534DC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 16:20:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3C096112E
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 16:20:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3C096112E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74ACC4B20E;
	Tue,  7 Sep 2021 12:20:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PWFF5Kt126Pe; Tue,  7 Sep 2021 12:20:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22EC44B202;
	Tue,  7 Sep 2021 12:20:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D5A4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 12:20:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rqz-fvdYht8G for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 12:20:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C1104B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 12:20:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631031621;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=s5kpwoL6JLP9VWq157hj4yt5pn95OzlSkFYcjxu+uM8=;
 b=A//GbMzVInx3sIjulM8vMA2hwvrRkGYJHTASDkQ2/e56WCkn6o1BuF9szfdJ2r4jigSVSc
 wBA48ke7CgXgXcBx6OKsrk26TkUfeb/89wag7B6Ls9sgoBhrSOM0noizfDUHs3UItTJwVd
 4EBtaP5KQ7o9ZSGfdDuYN5UsED45+QM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-xY9KjWShMSmYgYBaSWCHCQ-1; Tue, 07 Sep 2021 12:20:20 -0400
X-MC-Unique: xY9KjWShMSmYgYBaSWCHCQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 h4-20020aa7c604000000b003c423efb7efso5579835edq.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 09:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=s5kpwoL6JLP9VWq157hj4yt5pn95OzlSkFYcjxu+uM8=;
 b=ohqQhWN0bobQsFCCrLJh7EK2ymQF6AFJCDMuuteVL6UATQ7rDXQdjW+UJZjHTcoslD
 xRlyzvqQAwlvDVPySvITuU33lMpQT5XYV5U48x58TJuu7lqjLE1TsrzCkccFmxPzsx+6
 7i+9njlAsEiyU79zKAQmLi//Q0Pfl90+fV7vmdmMd/ACNwv0is6ab6h1FspRJe+25PfR
 iR3vfgnC6ZSIyVdGW78LzUeJTeP1b9sFquNbtBDE+cJOy7bIFBCs9+miHwAJkZ+3PX2T
 gPRZ35wZjI3he0LsLqzNmoCOhg9vqQwEoiZlt/NgLQ6QrWQ/a3/LiafeIrrvOgLNIpbF
 Fq9g==
X-Gm-Message-State: AOAM530Y2siqIEP94KON6p9RDV3AfaZ9V4dmEZoAeShSSP1C9Y0aJ1B8
 SZNIylYHtPf0czFQOUshzq7klUnh0KNzgCKpq6s8TSAvc+hfNZ5AMKsQVyUeNWVVf8Z2gsmhsQJ
 pVLcG046UkLHtb5hh+3//7SSF
X-Received: by 2002:aa7:d351:: with SMTP id m17mr307628edr.72.1631031618939;
 Tue, 07 Sep 2021 09:20:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlG1x6vmubv9Q2F6F+Q/kXpwV0kbe4co0LWgBBS7NPE4nU1F3mfGZ5885MxN5txLMEejY+/w==
X-Received: by 2002:aa7:d351:: with SMTP id m17mr307607edr.72.1631031618753;
 Tue, 07 Sep 2021 09:20:18 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id a24sm6571101edu.49.2021.09.07.09.20.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Sep 2021 09:20:18 -0700 (PDT)
Date: Tue, 7 Sep 2021 18:20:16 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
Message-ID: <20210907162016.2axil4gjjvkafnkx@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
 <20210903110514.22x3txynin5hg46z@gator.home>
 <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
 <20210906063900.t6rbykpwyau5u32s@gator.home>
 <CAJHc60xEj3Xw9wcSbxCUXg0GE5+NTadQeO17f6hpa9VqQ1o5tg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60xEj3Xw9wcSbxCUXg0GE5+NTadQeO17f6hpa9VqQ1o5tg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Tue, Sep 07, 2021 at 09:14:54AM -0700, Raghavendra Rao Ananta wrote:
> On Sun, Sep 5, 2021 at 11:39 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Sep 03, 2021 at 01:53:27PM -0700, Raghavendra Rao Ananta wrote:
> > > On Fri, Sep 3, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> > > >
> > > > On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> > > > > Since the timer stack (hardware and KVM) is per-CPU, there
> > > > > are potential chances for races to occur when the scheduler
> > > > > decides to migrate a vCPU thread to a different physical CPU.
> > > > > Hence, include an option to stress-test this part as well by
> > > > > forcing the vCPUs to migrate across physical CPUs in the
> > > > > system at a particular rate.
> > > > >
> > > > > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > > > > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > > > > was discovered using arch_timer test with vCPU migrations and
> > > > > can be easily reproduced.
> > > > >
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > > ---
> > > > >  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
> > > > >  1 file changed, 107 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > > index 1383f33850e9..de246c7afab2 100644
> > > > > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > > @@ -14,6 +14,8 @@
> > > > >   *
> > > > >   * The test provides command-line options to configure the timer's
> > > > >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > > > > + * To stress-test the timer stack even more, an option to migrate the
> > > > > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> > > > >   *
> > > > >   * Copyright (c) 2021, Google LLC.
> > > > >   */
> > > > > @@ -24,6 +26,8 @@
> > > > >  #include <pthread.h>
> > > > >  #include <linux/kvm.h>
> > > > >  #include <linux/sizes.h>
> > > > > +#include <linux/bitmap.h>
> > > > > +#include <sys/sysinfo.h>
> > > > >
> > > > >  #include "kvm_util.h"
> > > > >  #include "processor.h"
> > > > > @@ -41,12 +45,14 @@ struct test_args {
> > > > >       int nr_vcpus;
> > > > >       int nr_iter;
> > > > >       int timer_period_ms;
> > > > > +     int migration_freq_ms;
> > > > >  };
> > > > >
> > > > >  static struct test_args test_args = {
> > > > >       .nr_vcpus = NR_VCPUS_DEF,
> > > > >       .nr_iter = NR_TEST_ITERS_DEF,
> > > > >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > > > > +     .migration_freq_ms = 0,         /* Turn off migrations by default */
> > > >
> > > > I'd rather we enable good tests like these by default.
> > > >
> > > Well, that was my original idea, but I was concerned about the ease
> > > for diagnosing
> > > things since it'll become too noisy. And so I let it as a personal
> > > preference. But I can
> > > include it back and see how it goes.
> >
> > Break the tests into two? One run without migration and one with. If
> > neither work, then we can diagnose the one without first, possibly
> > avoiding the need to diagnose the one with.
> >
> Right. I guess that's where the test's migration switch can come in handy.
> Let's turn migration ON by default. If we see a failure, we can turn
> OFF migration
> and run the tests. I'll try to include some verbose printing for diagnosability.
>

Sounds good. You can also consider using pr_debug if you feel the need to
balance verbosity with diagnostics.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
