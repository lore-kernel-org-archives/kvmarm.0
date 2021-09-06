Return-Path: <SRS0=b97j=N4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E018CC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 06:39:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57E5461029
	for <kvmarm@archiver.kernel.org>; Mon,  6 Sep 2021 06:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 57E5461029
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD3934B26D;
	Mon,  6 Sep 2021 02:39:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yQ-9o3AHTsME; Mon,  6 Sep 2021 02:39:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DB24B264;
	Mon,  6 Sep 2021 02:39:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0138E4B25C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 02:39:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0XdNEZY9q092 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Sep 2021 02:39:06 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A35A4B25A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Sep 2021 02:39:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1630910345;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=pFZpAGoXWqtD1eNY9zjgxvjbpkWIm9fS1Q1YaYaJFgM=;
 b=OBZ1bQilztxl4te6PG57UvNVqo6kIW1jESOeTAr3soI9DA5bjMl7K54uPJ1ANHaF0Q4AN2
 ePo8CZvny2AhHhlB5I0t/BS4GGYx9xlFU43dzJrVWEdaUAr7fD3eTC2QBciMkNrK3yl4yP
 vXPrkFT1VrEzLq3qSsJ2el/OrVm4xyk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-F8qaapy5MSW30xU3OEcMuA-1; Mon, 06 Sep 2021 02:39:03 -0400
X-MC-Unique: F8qaapy5MSW30xU3OEcMuA-1
Received: by mail-ej1-f72.google.com with SMTP id
 q15-20020a17090622cf00b005c42d287e6aso1840623eja.18
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Sep 2021 23:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pFZpAGoXWqtD1eNY9zjgxvjbpkWIm9fS1Q1YaYaJFgM=;
 b=buFSx5NbFx8eHcBmy5M7Z+lSnsrR2AZSCSVeStAKvT1gS5qcu1ufpl74lb4C2TIWxu
 WcieU5Z5VNRhPLWQJHcEPD0/8B0iYxw6Q9TBBTuIy0h4iV9yCbq0i3zU6+RYc8418ozD
 wcPRgGBmgt7a49JoOB7LKPz8AwOuirq0IjUku9OiqinX8bPkPkMDhxPSjRHGUtDnnrFu
 /wdVA8KiSpYZGGBc/yqyBNCPEGluBv+WGJgB4mnr/D3ag553tXaGxfXar7i22f+RKZD9
 N0gcGeA+NYqJ23Ry6uCdTeEQ+qkw7bm6aOq8TeYVqCjbMJ7UteMo3cpEpDmBo2vabcIN
 h1oA==
X-Gm-Message-State: AOAM532iwTv7uFJ3l9bXxtfmp+U1KqoKB2r4JTm3gun1Hx9cxt3HUJdS
 eDM/APsjN/gzhVCxE/deNjDGvfPXlspJR73Zl026Naam8HusLACbRuZEE2/9d36K7mqp2VGzjAQ
 nqnHYUqxJtkSKrsTbEk349Czb
X-Received: by 2002:a05:6402:4404:: with SMTP id
 y4mr11919678eda.52.1630910342564; 
 Sun, 05 Sep 2021 23:39:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX0TpXnbRYGfoD24m32rvU84qJrmQaW7wiPn31Nr/Q9F8DbdaCT6Gpt6cuVdJvK5mJP25OsQ==
X-Received: by 2002:a05:6402:4404:: with SMTP id
 y4mr11919656eda.52.1630910342402; 
 Sun, 05 Sep 2021 23:39:02 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id i13sm3885374edc.48.2021.09.05.23.39.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 05 Sep 2021 23:39:02 -0700 (PDT)
Date: Mon, 6 Sep 2021 08:39:00 +0200
From: Andrew Jones <drjones@redhat.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
Message-ID: <20210906063900.t6rbykpwyau5u32s@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
 <20210903110514.22x3txynin5hg46z@gator.home>
 <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
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

On Fri, Sep 03, 2021 at 01:53:27PM -0700, Raghavendra Rao Ananta wrote:
> On Fri, Sep 3, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> > > Since the timer stack (hardware and KVM) is per-CPU, there
> > > are potential chances for races to occur when the scheduler
> > > decides to migrate a vCPU thread to a different physical CPU.
> > > Hence, include an option to stress-test this part as well by
> > > forcing the vCPUs to migrate across physical CPUs in the
> > > system at a particular rate.
> > >
> > > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > > was discovered using arch_timer test with vCPU migrations and
> > > can be easily reproduced.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
> > >  1 file changed, 107 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > index 1383f33850e9..de246c7afab2 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > @@ -14,6 +14,8 @@
> > >   *
> > >   * The test provides command-line options to configure the timer's
> > >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > > + * To stress-test the timer stack even more, an option to migrate the
> > > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> > >   *
> > >   * Copyright (c) 2021, Google LLC.
> > >   */
> > > @@ -24,6 +26,8 @@
> > >  #include <pthread.h>
> > >  #include <linux/kvm.h>
> > >  #include <linux/sizes.h>
> > > +#include <linux/bitmap.h>
> > > +#include <sys/sysinfo.h>
> > >
> > >  #include "kvm_util.h"
> > >  #include "processor.h"
> > > @@ -41,12 +45,14 @@ struct test_args {
> > >       int nr_vcpus;
> > >       int nr_iter;
> > >       int timer_period_ms;
> > > +     int migration_freq_ms;
> > >  };
> > >
> > >  static struct test_args test_args = {
> > >       .nr_vcpus = NR_VCPUS_DEF,
> > >       .nr_iter = NR_TEST_ITERS_DEF,
> > >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > > +     .migration_freq_ms = 0,         /* Turn off migrations by default */
> >
> > I'd rather we enable good tests like these by default.
> >
> Well, that was my original idea, but I was concerned about the ease
> for diagnosing
> things since it'll become too noisy. And so I let it as a personal
> preference. But I can
> include it back and see how it goes.

Break the tests into two? One run without migration and one with. If
neither work, then we can diagnose the one without first, possibly
avoiding the need to diagnose the one with.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
