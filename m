Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA01C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 22:13:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FCB749F40;
	Tue, 11 Jan 2022 17:13:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N2SVkvVm3EcW; Tue, 11 Jan 2022 17:13:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BDD24AC78;
	Tue, 11 Jan 2022 17:13:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0403E49F40
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:13:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JZ+H1+IJDLUL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 17:13:08 -0500 (EST)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com
 [209.85.222.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0176E49F3F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:13:07 -0500 (EST)
Received: by mail-ua1-f49.google.com with SMTP id c36so1217194uae.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mVqyboTrUQf4DREgs2Gld2sJABz7v9pKGO6C5NIz4lU=;
 b=tKnIVcqYQ8IH51qXU8mwqZbrbChJV08ItDElKaGcLDPbMX6bagUXInkdQQ7SX+KlDd
 BCft/nCDq1V1roh3GxIHlxxoqoLrs20C4BN+ufRrdNDSALUNUa2H52/9c6WQec7jfuXS
 7kybQhRfipMnEhOhoBfRL5MbHvzGFvJCAGihzDfHwrRpt3257iEcZ6C46HKGzEgaaK/Q
 HAqIPiGZmjEFWTtqkRY5bI0d/xox3Spp0+Q+IZ8ElcRXPER8Acj0EHiBLBx6TdfbeZEw
 lwbRgzC2wcl5fpJKZBxhMYDnO8jpfK4F2pxc7MAJQEo05J+cuQC9U7WR6TMIiT/zLHA3
 Ksdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mVqyboTrUQf4DREgs2Gld2sJABz7v9pKGO6C5NIz4lU=;
 b=ePgNt2bSDo91ucMX8A+nIK0SbZMHDVzsVgIyC9EDU7fqg1D3Isr7HKACQ1iVBdEnWT
 hdQvcdmKO5rUqkW/1RZypxFRgEp9/FlnhAEbcCjRDm9ZaA7/fCwUj4MP3AvBId4c9n+n
 fq4Q2YrCjMgmw8xiX2bzHLLEFdcXzCmEChPdA315n71AThT6hmGM6YBhjQ/d2mdJJHbl
 IKoFUqPqOlZ6jL1yPYghIC8YQsVeQisHA+R4xJ3mVy8KDtmbCh++ZtLEdjdQ8kHnLWF2
 r13TOEXJz8mnxAA4ZKCbsAXMQvzIcBUEhHf3P8SMuRwbMiulfX3+BWZVbnwKO3eXAfje
 sQCg==
X-Gm-Message-State: AOAM530aHbN2/BcMttln518/UBlJyzuAw99ItwLLCJ1kushE+/gegGuX
 CQ67kTzi9D3FDXZ3TkoHbkTbpYQKuLhGjMY8oesd3w==
X-Google-Smtp-Source: ABdhPJy+BkpO1MwRN9S58PetXGK8On3GmtY4knYWGb93a+7u1ctUaZ8CuimluWsQBlC/QERXOTupuNqged+fF2I5Zt8=
X-Received: by 2002:ab0:13c3:: with SMTP id n3mr2983807uae.39.1641939187476;
 Tue, 11 Jan 2022 14:13:07 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com>
 <20220111095505.spwflhcdfxwveh3u@gator>
In-Reply-To: <20220111095505.spwflhcdfxwveh3u@gator>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 11 Jan 2022 14:12:56 -0800
Message-ID: <CAAdAUti4v-ybMvDUErUO==iAU+tt_fuUPdgq4g2D0hSx=88D8g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To: Andrew Jones <drjones@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

On Tue, Jan 11, 2022 at 1:55 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Jan 10, 2022 at 09:04:41PM +0000, Jing Zhang wrote:
> > For ARM64, if no vgic is setup before the dirty log perf test, the
> > userspace irqchip would be used, which would affect the dirty log perf
> > test result.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index 1954b964d1cf..b501338d9430 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -18,6 +18,12 @@
> >  #include "test_util.h"
> >  #include "perf_test_util.h"
> >  #include "guest_modes.h"
> > +#ifdef __aarch64__
> > +#include "aarch64/vgic.h"
> > +
> > +#define GICD_BASE_GPA                        0x8000000ULL
> > +#define GICR_BASE_GPA                        0x80A0000ULL
> > +#endif
> >
> >  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
> >  #define TEST_HOST_LOOP_N             2UL
> > @@ -200,6 +206,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >               vm_enable_cap(vm, &cap);
> >       }
> >
> > +#ifdef __aarch64__
> > +     vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
>                                     ^^ extra parameter
The patch is based on kvm/queue, which has a patch adding an extra
parameter nr_irqs.

>
> Thanks,
> drew
>
> > +#endif
> > +
> >       /* Start the iterations */
> >       iteration = 0;
> >       host_quit = false;
> > --
> > 2.34.1.575.g55b058a8bb-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
