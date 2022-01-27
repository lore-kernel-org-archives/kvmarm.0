Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989DFC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 15:06:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210CE4A369;
	Thu, 27 Jan 2022 10:06:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BLHEOIubEw0Q; Thu, 27 Jan 2022 10:06:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0254A1B0;
	Thu, 27 Jan 2022 10:06:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E320B4A11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 10:06:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GtRz+XT+P50l for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 10:06:44 -0500 (EST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
 [209.85.208.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B9C8C4A100
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 10:06:44 -0500 (EST)
Received: by mail-ed1-f42.google.com with SMTP id p12so4038144edq.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 07:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cA1lg3Dd5LbRAQ5aawd3cz5k8zHSySm2HgwQKBcf6DY=;
 b=UJMBk5sOyDdO52DubA7r6BLKw1F+menFstYh1fMWNG94Fmv2bq0s+zts9U2mBlBJVg
 jVUdZ7e37YUBOZRVYxPbMmjufyUSDt12n4ge1Um4rg1Wxq/xynvEhapidPTdaQwyS+q3
 l0Do78hON1dznFIEbjwXbriIT8h7l9/5/XcJSj/rzuLP5XpVHQAUg/4/jwx6vOl3meh1
 UIqT/QaJb7LH5MlQ0AIyMM4/z5PLsoW+C1pveqHQZcz277oy37rexPpMf6UlQxpQjt5o
 wzA2ekVhJ1dbKEPQMML4hdWQPHhHyGgWUDLzN16AU9XqzTtMuU3vv96vwuwGLAEq6/Vq
 AAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cA1lg3Dd5LbRAQ5aawd3cz5k8zHSySm2HgwQKBcf6DY=;
 b=bnH68CjfKAduCYD8xnp3W9+9J43Ia9CpeyDaoNbW6qhEBPjqM6INqs/A21jrnVupPM
 eBTWDX0enqYz6noChGu+3ZeAFBGo6mf3EnCuO1HmdygZ1pu4s0HCfPfGG9YuuhW9xuAU
 PlH5zaK1V/QJzmRixPaJoevB9TdxUTZ/MyJiUFZJgyNiSgGNwlGodRqVZoku9Zc0hKGm
 YGX7ylv9nbsYUl5OJ2ObGneMjBb+up0m+vtOUMzg9TVBIlYXbtWl8qrfoTvfsO065/Zf
 lfyLW6Y0pvNjzMhMExhyV/V/+VG3xhUpQ8UuxcchQyVAQ/yM1DEEJ+ROvIrd9XQ6xZNz
 0GCw==
X-Gm-Message-State: AOAM5319NnjKEaq2pd/oapBzINX+anHUlxNKRA+5Cbry9hOo0AGDKT8c
 mo4VRuG5+QBRrCNGdzA7BxCcL4QgWQmzKJXPtfH3E3aMnBE=
X-Google-Smtp-Source: ABdhPJwdqC53pKKOmb7Ul4w+8PEMJOe9FlNNbGVfhT2KbeWAUotCmLEV7n9OSxuEqzobzhyspNKa4miN74rjlwQuxjY=
X-Received: by 2002:a50:bb0b:: with SMTP id y11mr4024325ede.71.1643296003331; 
 Thu, 27 Jan 2022 07:06:43 -0800 (PST)
MIME-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-5-ricarkol@google.com>
 <20220127074922.6m53vckomn7lacog@gator>
In-Reply-To: <20220127074922.6m53vckomn7lacog@gator>
From: Ricardo Koller <ricarkol@google.com>
Date: Thu, 27 Jan 2022 07:06:31 -0800
Message-ID: <CAOHnOrwjNzvrZV9qPWNnE2P5W_5DfTRXNuuJu+DjEvj2SNPi+g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] kvm: selftests: aarch64: fix some vgic related
 comments
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Jan 26, 2022 at 11:49 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Jan 26, 2022 at 07:08:57PM -0800, Ricardo Koller wrote:
> > Fix the formatting of some comments and the wording of one of them (in
> > gicv3_access_reg).
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reported-by: Reiji Watanabe <reijiw@google.com>
> > Cc: Andrew Jones <drjones@redhat.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
>
> I didn't give my r-b to this patch before, but you can keep it, because
> here's another one
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks Andrew. Sorry, it was supposed to go to the assert one.

> > ---
> >  tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
> >  tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 10 ++++++----
> >  tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
> >  3 files changed, 16 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > index 0106fc464afe..f0230711fbe9 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> > @@ -306,7 +306,8 @@ static void guest_restore_active(struct test_args *args,
> >       uint32_t prio, intid, ap1r;
> >       int i;
> >
> > -     /* Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> > +     /*
> > +      * Set the priorities of the first (KVM_NUM_PRIOS - 1) IRQs
> >        * in descending order, so intid+1 can preempt intid.
> >        */
> >       for (i = 0, prio = (num - 1) * 8; i < num; i++, prio -= 8) {
> > @@ -315,7 +316,8 @@ static void guest_restore_active(struct test_args *args,
> >               gic_set_priority(intid, prio);
> >       }
> >
> > -     /* In a real migration, KVM would restore all GIC state before running
> > +     /*
> > +      * In a real migration, KVM would restore all GIC state before running
> >        * guest code.
> >        */
> >       for (i = 0; i < num; i++) {
> > @@ -503,7 +505,8 @@ static void guest_code(struct test_args *args)
> >               test_injection_failure(args, f);
> >       }
> >
> > -     /* Restore the active state of IRQs. This would happen when live
> > +     /*
> > +      * Restore the active state of IRQs. This would happen when live
> >        * migrating IRQs in the middle of being handled.
> >        */
> >       for_each_supported_activate_fn(args, set_active_fns, f)
> > @@ -840,7 +843,8 @@ int main(int argc, char **argv)
> >               }
> >       }
> >
> > -     /* If the user just specified nr_irqs and/or gic_version, then run all
> > +     /*
> > +      * If the user just specified nr_irqs and/or gic_version, then run all
> >        * combinations.
> >        */
> >       if (default_args) {
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > index e4945fe66620..263bf3ed8fd5 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> > @@ -19,7 +19,7 @@ struct gicv3_data {
> >       unsigned int nr_spis;
> >  };
> >
> > -#define sgi_base_from_redist(redist_base)    (redist_base + SZ_64K)
> > +#define sgi_base_from_redist(redist_base)    (redist_base + SZ_64K)
> >  #define DIST_BIT                             (1U << 31)
> >
> >  enum gicv3_intid_range {
> > @@ -105,7 +105,8 @@ static void gicv3_set_eoi_split(bool split)
> >  {
> >       uint32_t val;
> >
> > -     /* All other fields are read-only, so no need to read CTLR first. In
> > +     /*
> > +      * All other fields are read-only, so no need to read CTLR first. In
> >        * fact, the kernel does the same.
> >        */
> >       val = split ? (1U << 1) : 0;
> > @@ -160,8 +161,9 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
> >
> >       GUEST_ASSERT(bits_per_field <= reg_bits);
> >       GUEST_ASSERT(!write || *val < (1U << bits_per_field));
> > -     /* Some registers like IROUTER are 64 bit long. Those are currently not
> > -      * supported by readl nor writel, so just asserting here until then.
> > +     /*
> > +      * This function does not support 64 bit accesses. Just asserting here
> > +      * until we implement readq/writeq.
> >        */
> >       GUEST_ASSERT(reg_bits == 32);
> >
> > diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > index b3a0fca0d780..79864b941617 100644
> > --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> > @@ -150,7 +150,8 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
> >               attr += SZ_64K;
> >       }
> >
> > -     /* All calls will succeed, even with invalid intid's, as long as the
> > +     /*
> > +      * All calls will succeed, even with invalid intid's, as long as the
> >        * addr part of the attr is within 32 bits (checked above). An invalid
> >        * intid will just make the read/writes point to above the intended
> >        * register space (i.e., ICPENDR after ISPENDR).
> > --
> > 2.35.0.rc0.227.g00780c9af4-goog
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
