Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31600C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 17:34:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93BCA4B1BF;
	Fri,  8 Apr 2022 13:34:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4afGXDPqsyn2; Fri,  8 Apr 2022 13:34:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 507994B130;
	Fri,  8 Apr 2022 13:34:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D72949B0A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 13:34:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MLIEPBP1ky-K for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 13:34:53 -0400 (EDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D07AD41021
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 13:34:53 -0400 (EDT)
Received: by mail-yb1-f176.google.com with SMTP id l36so16284765ybj.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 10:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Jd42eljeoA7am6iun/EUSb1/8DBUsy7OfKLkpCfQnwI=;
 b=LCmXkljF/PTt+d5imunqFnne5A0MjGLtTl1xSjGaE0A5FsH+fLknxoJFEWyEWwjgnO
 /4HSeVhdLNK52NjIYtcP/h0qXSOrEpVM1ysII5gkbbxdG8ideLw0TrAkHoOBPZHeXKus
 pR1pnrTNIOXO7xPIapV0Hfy2GnHgaRnrhr/wMG1hReEJkvPiChzVc9gzgb7Puz3MRNQm
 3Cjzu8TaYow5v5QZ/JnvRso6K2M3Uxvgb0yEdEGOV2jEYUdG0tmFsttOJKlVR4P9HgrQ
 cCZz469HW8rEd5ZXwyQ0P7kgBAUurURAbHxE4ZXbZ9yCYeBKNtze6BsUx4OieqJLGnX4
 8p0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Jd42eljeoA7am6iun/EUSb1/8DBUsy7OfKLkpCfQnwI=;
 b=HZR9efcDHPCJWnhQsFEnuJZzFwDVJYIqShMBpYtrHiowCOK00Y5C5MVvvIg37lilPj
 49grB+flkOjj2xYxeyyiTXplyGLZBxA79TvIfdMAxYJ/8U737R5eN0AiKUzNwR/6gelf
 Fu3WJZyxV/IQaIgamlUbmX9ySCd1UjJNVlGz6j80tYNajpefsaEheLkwH31YALISIIXX
 hQrh4LeD3ZihK/qWtaM+tBKa/JvbES2PmHi/vt5sRRWTAOf7Wuc8HHBej72t1T4utqOt
 d9wPcatl/osO9/FNCyFV54xMU0Rb3Ysb8dpmmOQA+k1SITB6z9f1ZQsyJ2LnWrzt8Qlh
 krVg==
X-Gm-Message-State: AOAM533QQhUwo+24H6+6J0gLAx9y/yOT6L4iWhj69SsjDhKZ8aI8oBdg
 X55mlQZWkWUtEYdtTeXYMZwK58eKkit55gQB1py+0A==
X-Google-Smtp-Source: ABdhPJyJF/Vu21u1Ybk49qtraB/Ha/OoaBBpU4AzP6a6DQvrKFHEfKt9PFNVhB8Y0En5o6Xn94X9VMasp0/Xh92pKhg=
X-Received: by 2002:a25:dfc4:0:b0:63d:b28e:93ec with SMTP id
 w187-20020a25dfc4000000b0063db28e93ecmr15429921ybg.474.1649439293125; Fri, 08
 Apr 2022 10:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-3-rananta@google.com>
 <87ilrlb6un.wl-maz@kernel.org>
 <CAJHc60yFD=osoifUpB4LBNo93eVq9zNV41bnu7uBZ0HsBGbMeA@mail.gmail.com>
 <87v8vj1pfl.wl-maz@kernel.org>
In-Reply-To: <87v8vj1pfl.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 8 Apr 2022 10:34:42 -0700
Message-ID: <CAJHc60wwXyC=cgpBHf4XXcpvuN=+HW2hjiOX+NidQ2euRHb-qg@mail.gmail.com>
Subject: Re: [PATCH v5 02/10] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Apr 8, 2022 at 9:59 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 07 Apr 2022 18:24:14 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Hi Marc,
> >
> > > > +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0                BIT(0)
> > >
> > > I'm really in two minds about this. Having one bit per service is easy
> > > from an implementation perspective, but is also means that this
> > > disallow fine grained control over which hypercalls are actually
> > > available. If tomorrow TRNG 1.1 adds a new hypercall and that KVM
> > > implements both, how does the selection mechanism works? You will
> > > need a version selector (a la PSCI), which defeats this API somehow
> > > (and renders the name of the #define invalid).
> > >
> > > I wonder if a more correct way to look at this is to enumerate the
> > > hypercalls themselves (all 5 of them), though coming up with an
> > > encoding is tricky (RNG32 and RNG64 would clash, for example).
> > >
> > > Thoughts?
> > >
> > I was on the fence about this too. The TRNG spec (ARM DEN 0098,
> > Table-4) mentions that v1.0 should have VERSION, FEATURES, GET_UUID,
> > and RND as mandatory features. Hence, if KVM advertised that it
> > supports TRNG v1.0, I thought it would be best to expose all or
> > nothing of v1.0 by guarding them with a single bit.
> > Broadly, the idea is to have a bit per version. If v1.1 comes along,
> > we can have another bit for that. If it's not too ugly to implement,
> > we can be a little more aggressive and ensure that userspace doesn't
> > enable v1.1 without enabling v1.0.
>
> OK, that'd be assuming that we'll never see a service where version A
> is incompatible with version B and that we have to exclude one or the
> other. Meh. Let's cross that bridge once it is actually built.
>
> [...]
>
> > > > +     mutex_lock(&kvm->lock);
> > > > +
> > > > +     /*
> > > > +      * If the VM (any vCPU) has already started running, return success
> > > > +      * if there's no change in the value. Else, return -EBUSY.
> > >
> > > No, this should *always* fail if a vcpu has started. Otherwise, you
> > > start allowing hard to spot races.
> > >
> > The idea came from the fact that userspace could spawn multiple
> > threads to configure the vCPU registers. Since we don't have the
> > VM-scoped registers yet, it may be possible that userspace has issued
> > a KVM_RUN on one of the vCPU, while the others are lagging behind and
> > still configuring the registers. The slower threads may see -EBUSY and
> > could panic. But if you feel that it's an overkill and the userspace
> > should deal with it, we can return EBUSY for all writes after KVM_RUN.
>
> I'd rather have that. There already is stuff that rely on things not
> changing once a vcpu has run, so I'd rather be consistent.
>
Sure, I'll return EBUSY if the VM has started regardless of the incoming value.
> >
> > > > +      */
> > > > +     if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> > > > +             ret = *fw_reg_bmap != val ? -EBUSY : 0;
> > > > +             goto out;
> > > > +     }
> > > > +
> > > > +     WRITE_ONCE(*fw_reg_bmap, val);
> > >
> > > I'm not sure what this WRITE_ONCE guards against. Do you expect
> > > concurrent reads at this stage?
> > >
> > Again, the assumption here is that userspace could have multiple
> > threads reading and writing to these registers. Without the VM scoped
> > registers in place, we may end up with a read/write to the same memory
> > location for all the vCPUs.
>
> We only have one vcpu updating this at any given time (that's what the
> lock ensures). A simple write should be OK, as far as I can tell.
>
I agree that a write against another write should be fine without the
WRITE_ONCE. But my little concern was this write against a read
(unsure how userspace accesses these registers). I'm guessing it
shouldn't hurt to keep them in place, no? :)

Regards,
Raghavendra

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
