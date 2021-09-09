Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5554C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:39:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C4B66115A
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3C4B66115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC924B13D;
	Thu,  9 Sep 2021 12:39:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LVhmlrbJkcrd; Thu,  9 Sep 2021 12:39:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77C26400D5;
	Thu,  9 Sep 2021 12:39:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03FDD400D5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:39:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCHnQhZDYb71 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 12:39:09 -0400 (EDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com
 [209.85.219.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F086E4005D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:39:08 -0400 (EDT)
Received: by mail-yb1-f182.google.com with SMTP id q70so5084102ybg.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=z6S9aCreq/0VGuneRW3q7amVuNejEfZAPRbvdWpbNPQ=;
 b=m6C+xr8tBL6hn8M8cZtiWUFtOEKpLOROHS4EvWaOJSbMPA7AjRIRr1vjbiUaLXdHri
 9bChgFEoA7TNwaIB2TxgMA7wdFDJ9wlKq71tu4BLkfkS5MTzQ26PFHISd9tpV4M3imSE
 QGv01Iujhkw0xNImfBFO/zLPR8xyfFHJs5LYzOtGCVPAXXaOpZrLqwu9aW7BDbNX1jF9
 bZyN/dJlHSEnfAZJhYmTl2j93j7oCs4u4IJoQL2RBGzQ3SrLvdei7URfW3nBY/I+KbnI
 2fXNMFhGYk7bOI8C9+qndcbxbrCBqkwBQkMwJmF07nSgKWQvjwdtAF5XbVnq7umSh8Mf
 /Rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=z6S9aCreq/0VGuneRW3q7amVuNejEfZAPRbvdWpbNPQ=;
 b=OpiZQdsCbPC7XbFW0N6waYEG25jq5taq4zxfdZX3k3ztN2qE8XomZOS63nmN0usekA
 TtibC1XAMb36eY27iREPyT7aK+trY9mlASHvsZKk98Br9/Y5BmLqKi20x+R6eMV5Wbjl
 lXeGJjQ/iKqki3gmU45HWXYH6p2ZTqDpZQ+vs9bckaSZ+FbfbggaULNQytNUM7juXBze
 /e9n9ljqfRXzazLzdUZdxjhUKHscbkfSn87LfZP/1gOpVANojlr5sniuJsJmdsrp9UVZ
 wVjcJLFFNtvA1xTXOpzupwQz7qTLRAkLDWfqFUj/CuCURXzAuwZiQpfaXOx7i/fgYkId
 fuPA==
X-Gm-Message-State: AOAM533zD9aln6vbLyhY7xRWMa+ChGL+v4GOYXbM37SbpXPXuzsHAedY
 gtxoJCNHoO1yJs4vnkA3iCudLAlrH+bfGB5wKqs8Dg==
X-Google-Smtp-Source: ABdhPJzQhQS8ZeN1ti9BJ6nGicAZyMX4s6L1J/GWjGE8KzWUlbKpTmRa1mxRjjyzjuZ9X5UHGcqUo+phpbusAExxylk=
X-Received: by 2002:a25:21c5:: with SMTP id h188mr4685737ybh.23.1631205548028; 
 Thu, 09 Sep 2021 09:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-12-rananta@google.com>
 <YTmZPSEm3Fj6l1PN@google.com>
In-Reply-To: <YTmZPSEm3Fj6l1PN@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 09:38:56 -0700
Message-ID: <CAJHc60x_r46W+81=A76zC=zW_3xqmvMWf3CspiQKVVnPA0TtTA@mail.gmail.com>
Subject: Re: [PATCH v4 11/18] KVM: arm64: selftests: Add basic GICv3 support
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Sep 8, 2021 at 10:18 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:11AM +0000, Raghavendra Rao Ananta wrote:
> > Add basic support for ARM Generic Interrupt Controller v3.
> > The support provides guests to setup interrupts.
> >
> > The work is inspired from kvm-unit-tests and the kernel's
> > GIC driver (drivers/irqchip/irq-gic-v3.c).
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   2 +-
> >  .../selftests/kvm/include/aarch64/gic.h       |  21 ++
> >  tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++++
> >  .../selftests/kvm/lib/aarch64/gic_private.h   |  21 ++
> >  .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 ++++++++++++++++++
> >  .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++++
> >  6 files changed, 446 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
> >
>
> [...]
>
> > +static void
> > +gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
> > +{
> > +     const struct gic_common_ops *gic_ops;
>
> does this need to be initialized? I haven't tried compiling, but it
> seems it should trigger a compiler warning as it is only initialized if
> type == GIC_V3.
>
Huh, I thought I had a default case covering this (must have gone lost
during code reorg).
Nice catch though! Surprisingly, the compiler never warned. I'm not
sure if its smart
enough to figure out that the caller of this function had
GUEST_ASSERT(type < GIC_TYPE_MAX);
Anyway, I'll clean it up.

Regards,
Raghavendra

> > +     spin_lock(&gic_lock);
> > +
> > +     /* Distributor initialization is needed only once per VM */
> > +     if (gic_common_ops) {
> > +             spin_unlock(&gic_lock);
> > +             return;
> > +     }
> > +
> > +     if (type == GIC_V3)
> > +             gic_ops = &gicv3_ops;
> > +
> > +     gic_ops->gic_init(nr_cpus, dist_base);
> > +     gic_common_ops = gic_ops;
> > +
> > +     /* Make sure that the initialized data is visible to all the vCPUs */
> > +     dsb(sy);
> > +
> > +     spin_unlock(&gic_lock);
> > +}
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
