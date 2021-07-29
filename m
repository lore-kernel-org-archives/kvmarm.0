Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F97C432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 20:24:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 497D160F4A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 20:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 497D160F4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE85C4B0C6;
	Thu, 29 Jul 2021 16:24:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fv3kDVzpCFjo; Thu, 29 Jul 2021 16:24:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA5824B0CA;
	Thu, 29 Jul 2021 16:24:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B23F4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 16:24:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gNS5rfFZeZRf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 16:24:05 -0400 (EDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63ED14A4A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 16:24:05 -0400 (EDT)
Received: by mail-lf1-f51.google.com with SMTP id r26so13318341lfp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 13:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Gj7yCj3TgjmiQPtQl0jHjvThrzk1CYgb/iJobvGGefk=;
 b=tl09esBor3zjI+pKbOaNgY4vHM/cu59XWi6upaP0j5ZXoIJjMeDMjLYtUFUsLyn+iW
 xo6xMo/kZo6MvUbXVq76eALXaBvUOZuBqlFleNDkQojj1DTWOmrC+aM1kCGXye8VKf1V
 wv5J3wu2RvdOaHyo1pFpCK9ko2I2tywWIMm0rCQ7J+cZ3Y5oZUSlXXhMXGc2XIr7/aU5
 QVP8igM173wDGREtV03oDcqNYlUSnhMYfx4/tjWFc2pj3LxwDw8Zq7wrvTwvpJRi1WSE
 qRY+A8YZFNHyax+N2dPeGqxEchGSO2B8vG23E2kN0nYBnY/q/TEi1FkqHdqRXowpjLkx
 m0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Gj7yCj3TgjmiQPtQl0jHjvThrzk1CYgb/iJobvGGefk=;
 b=gBpw2uFKleUkeD/080adMi23hRF4AHrm7C/Nd9/voLPEqf89stOyny0k7oPywYJBs7
 Mj+AP/+w5tjd6mf4yApGlxCoT/BtDSPrD+TxiDCbpR/knypfj+cIB0zLhF1fL0G/v/T+
 OJ/gI6u5+RpHVS1P0ZF4HMnfvZVkxNf4Pdk/63RxZsCcI2iYAc4feDoFTqkSDD7a21VZ
 y7t3qy/WW3Sc7mWVwTU9gk1JHRaUMACSz1DTp+6GJZjiJUagkh5rqQc8AyGhoZA0PkzQ
 bogHn/5W7wdbSZ8jBUOaHcBRbYe4Mrso55EtffGryHfDwCdjWJp1/WyPgxB0UBGqAZF6
 wzVw==
X-Gm-Message-State: AOAM531UBmXI/DLxCQ+OnBytCzCDsUjO6angfaXpNP4u/RW+RxEEnPvA
 IyYI3qhmBJYHkpRDvI2akL6lWQ5cZxeMo+h/gurNcg==
X-Google-Smtp-Source: ABdhPJzPxiDGiDFKysX5izFriQkSlWyo919HiI1mAjdl/EIF2YA5xH+2Ix5p0VGNtGuJGYezdz59xwCBRVN47iNQNuc=
X-Received: by 2002:a05:6512:3237:: with SMTP id
 f23mr4870368lfe.524.1627590243514; 
 Thu, 29 Jul 2021 13:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
 <20210729195632.489978-2-oupton@google.com>
 <CAAdAUtge_wRL-Ri-TngototL5jixSfDyJm7nTaYBXJqXU0jfmw@mail.gmail.com>
In-Reply-To: <CAAdAUtge_wRL-Ri-TngototL5jixSfDyJm7nTaYBXJqXU0jfmw@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 29 Jul 2021 13:23:52 -0700
Message-ID: <CAOQ_QshrXJx42AS4Efu3gSZj1fnGgJ9FMFCydtdZ9h3Zj8cy=A@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Record number of signal exits as a vCPU
 stat
To: Jing Zhang <jingzhangos@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, KVM <kvm@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Thu, Jul 29, 2021 at 1:07 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> On Thu, Jul 29, 2021 at 12:56 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Most other architectures that implement KVM record a statistic
> > indicating the number of times a vCPU has exited due to a pending
> > signal. Add support for that stat to arm64.
> >
> > Cc: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  arch/arm64/kvm/arm.c              | 1 +
> >  arch/arm64/kvm/guest.c            | 3 ++-
> >  3 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 41911585ae0c..70e129f2b574 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
> >         u64 wfi_exit_stat;
> >         u64 mmio_exit_user;
> >         u64 mmio_exit_kernel;
> > +       u64 signal_exits;
> >         u64 exits;
> >  };
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e9a2b8f27792..60d0a546d7fd 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                 if (signal_pending(current)) {
> >                         ret = -EINTR;
> >                         run->exit_reason = KVM_EXIT_INTR;
> > +                       ++vcpu->stat.signal_exits;
> >                 }
> >
> >                 /*
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 1dfb83578277..50fc16ad872f 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -50,7 +50,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
> >         STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
> >         STATS_DESC_COUNTER(VCPU, mmio_exit_user),
> >         STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
> > -       STATS_DESC_COUNTER(VCPU, exits)
> > +       STATS_DESC_COUNTER(VCPU, exits),
> > +       STATS_DESC_COUNTER(VCPU, signal_exits),
> How about put signal_exits before exits as the same order in
> kvm_vcpu_stat just for readability?

Definitely.

> >  };
> >  static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
> >                 sizeof(struct kvm_vcpu_stat) / sizeof(u64));
> > --
> > 2.32.0.554.ge1b32706d8-goog
> >
> Reviewed-by: Jing Zhang <jingzhangos@google.com>

Thanks Jing!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
