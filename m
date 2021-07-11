Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0006FC07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 14:08:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A63F6108B
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 14:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A63F6108B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D920B40821;
	Mon, 12 Jul 2021 10:08:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h8L2pWBLqUcq; Mon, 12 Jul 2021 10:08:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0E724086A;
	Mon, 12 Jul 2021 10:08:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADD234029C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Jul 2021 12:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iQUvWT4dwxYq for <kvmarm@lists.cs.columbia.edu>;
 Sun, 11 Jul 2021 12:58:59 -0400 (EDT)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com
 [209.85.222.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A04C40287
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Jul 2021 12:58:59 -0400 (EDT)
Received: by mail-qk1-f174.google.com with SMTP id e14so15374119qkl.9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 11 Jul 2021 09:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WBrOScKV3V16Gyn7bGSSQx+6TsqpJhHYRyGGGXA76Gw=;
 b=XDFA9W2l1rFNr7zIb0SxhYtrGZi0uF2umXU/lKQCUzrolek4SiNuvCz8QlhhppcOQA
 x9j0221CuPLl2I0O4BiflTtMbarRMobfBt+5l2bTLfAfG+Ywex5sQuHCJqTdIoXfnLoO
 CHpgwOGgkdaZqWTMoJfSA9JjfVYRw6Xv22o6kRJ/MjYm6deqSp6TRD0WgS9DuwyBtTCb
 fuigYcMH87jTxs5XBY56KByk8PnjJO/AhHvfcTRG1NM7cyWfFJL5XM1MjlHcD0q49cP6
 4w6Mj+4CiFZz1JEaBhJ35SSJ7LDplkfgDIoi2YzFvUEgxxmBz8NTIoLy+LrOLPnMlWhO
 IQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WBrOScKV3V16Gyn7bGSSQx+6TsqpJhHYRyGGGXA76Gw=;
 b=uUp1/aU0clgxTSes1OUD8dGmv+CZuTrlynRSeaxD1OZvP6df2zFbJK5vmKG9T0nz6s
 fkdGm1Hk8kZpLYcDyDzG2a3M0tETtX1lMaRk4oxFYdrzHiCP2Pq/MlKeXA/LPWDKAw4Z
 xZXBOcvsdtoxaEGyXmh0Rv8smG2VBP0DN+GT7VR4r2A2A/xWra0mQ0AxjMCc+AR3RaP5
 NE2qUFH1aMI+rhMWRIIeL80L7xVKcwX7poV+m5ld+QgZhScYJRLDGddVrVYipCGnbYb4
 Ni3U10pOaawhPsfat6MigExkwtvPXVgcVxjLfZzUlByhyLHARYVF1va7O3IO083mZNW9
 RoBQ==
X-Gm-Message-State: AOAM533cjOn2QixQap48UEPUsI+Yam32aVLy6TwFWPrYKd3opmAzT/CX
 29CHT/7L/GLeQwJ0m2HHVFgF3u2KowJ/s0PMeUf6tA==
X-Google-Smtp-Source: ABdhPJxXCOIObgL8OrlRPXQtRuJlWZZ+YUWJD9kYGloo0i/JQjCzHExS9EJkLyVI5sIdVJoID4+63EbWKLVtdPFxhl8=
X-Received: by 2002:ae9:dd43:: with SMTP id r64mr47648567qkf.216.1626022738963; 
 Sun, 11 Jul 2021 09:58:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-3-senozhatsky@chromium.org>
 <CAJWu+opFedsq6CdgUYErnxsv3-Pr7MHi0vz9=hhpMCujFPp8+A@mail.gmail.com>
 <YOjFWZzgQxjPWaXw@google.com>
In-Reply-To: <YOjFWZzgQxjPWaXw@google.com>
From: Joel Fernandes <joelaf@google.com>
Date: Sun, 11 Jul 2021 12:58:47 -0400
Message-ID: <CAJWu+op31kGH9BpHS5+8ARPuote4n_3XUB=W6YF8yS0ePS1dMA@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] arm64: add guest pvstate support
To: Sergey Senozhatsky <senozhatsky@chromium.org>
X-Mailman-Approved-At: Mon, 12 Jul 2021 10:08:46 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
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

On Fri, Jul 9, 2021 at 5:53 PM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:

> > > +DECLARE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> > > +
> > > +static inline bool paravirt_vcpu_is_preempted(unsigned int cpu)
> > > +{
> > > +       return static_call(pv_vcpu_is_preempted)(cpu);
> > > +}
> > > +
> > > +int __init pv_vcpu_state_init(void);
> > > +
> > >  #else
> > >
> > > +#define pv_vcpu_state_init() do {} while (0)
> > > +
> > >  #define pv_time_init() do {} while (0)
> > >
> > >  #endif // CONFIG_PARAVIRT
> > > diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> > > index 75fed4460407..d8fc46795d94 100644
> > > --- a/arch/arm64/kernel/paravirt.c
> > > +++ b/arch/arm64/kernel/paravirt.c
> > > @@ -40,6 +40,11 @@ struct pv_time_stolen_time_region {
> > >
> > >  static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
> > >
> > > +static DEFINE_PER_CPU(struct vcpu_state, vcpus_states);
> > > +struct static_key pv_vcpu_is_preempted_enabled;
> > > +
> > > +DEFINE_STATIC_CALL(pv_vcpu_is_preempted, dummy_vcpu_is_preempted);
> >
> > Could we use DEFINE_STATIC_CALL_NULL and get rid of the dummy
> > function? I believe that makes the function trampoline as return
> > instruction, till it is updated.
>
> Is DEFINE_STATIC_CALL_NULL for cases when function returns void?
>
> We need something that returns `false` to vcpu_is_preempted() or
> per_cpu(vcpus_states) once pv vcpu-state is initialised.

Ah, that might be problematic. In which case what you did is fine. Thanks,

- Joel



>
> [..]
> > > +static bool __vcpu_is_preempted(unsigned int cpu)
> > > +{
> > > +       struct vcpu_state *st;
> > > +
> > > +       st = &per_cpu(vcpus_states, cpu);
> > > +       return READ_ONCE(st->preempted);
> >
> > I guess you could just do:
> > {
> >   return READ_ONCE(per_cpu(vcpus_states, cpu).preempted);
> > }
>
> Ack.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
