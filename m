Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AF0C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 18:13:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DFD9B6138B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 18:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DFD9B6138B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58F594B1BA;
	Mon, 23 Aug 2021 14:13:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id caSLI55A203m; Mon, 23 Aug 2021 14:13:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66BB44B1EC;
	Mon, 23 Aug 2021 14:13:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 551914B1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 14:13:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fL6XJF7y3GRx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 14:13:18 -0400 (EDT)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com
 [209.85.222.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 549CB4B1BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 14:13:18 -0400 (EDT)
Received: by mail-ua1-f51.google.com with SMTP id j16so5754800uag.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 11:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Fjnl2HoYdek4bDGF8q9Dry5mE5i47mO6qIdMvDvvKlM=;
 b=rkOROyK355oHhZhcMezcHUuraKV+r8dH72LpjR0rMOGKx/c8PmrsjE6aKKDRwc6Glo
 DwJv8HlO8xF1ZgHYaY6q7X0VAt7oGIO0iK7TkIHYAfu8BObbdaEnlcFGTtL1MGvk7lTZ
 d6kgwuAAk0+YPLJoO3ZoZIt6dCSdivZkS+6cZER8pbUCt/ZqPseQXCHe7vFccJ7Eih0F
 qMqsGhd1C0wBqTFmGeaLBsnkic1URH+w3RmP1GML7Atu9n+UB+VkZAdD7mqxD2ZBdgGQ
 bkSbFomnuORLEJhk9fcbSWnKGB83p5gqTCOaIp3lHAoLbccdmFXglyZ6DU9dIXizEQsL
 HtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fjnl2HoYdek4bDGF8q9Dry5mE5i47mO6qIdMvDvvKlM=;
 b=Pcg7Gpr8lzEPLNB1lUCOuLV5org0N5hyQWMw4cutAii347pM9V0nUSaJHMWtPlvEQL
 A3jz3so3EtnL7L0qLM2AQs+PHgoA+4Zzy9ZYaUQnj1RhLY45tvGdVDHzyfj36v3hyHjW
 16cQcXCucletYnfUTbjy7TmartXAo6P3L43Efkliax8OvQFDVe/j/5fFpBMWgkXCpRwd
 j57H2n7QHDVSoXw2kaUmgBgd7nyEmFI+K5pdn6aqqQlCsDQo6Qi7+Bny7YngM3NhY4t+
 qxcLFmDO7CUkdHptjpGBm5YyBdJav+xfM1/h3dCqjv4vgP2NqVusidIsYgdSfbA8xZ/C
 cvSQ==
X-Gm-Message-State: AOAM5328rF0x2WSFrsa6ZOFUO8BVD1WjsCiggHKefwx/RZ1DPOpuB02n
 91C1y27VSKm1DohKhFqiTvPcVtqaQxOnb4u1YHqsxw==
X-Google-Smtp-Source: ABdhPJxC8AT7UO7l/MpTyXU+14h3/7m+NIlnb+CGw0dnDlzHEnbKEweXn1vG5LojIqChLuFG9w+lyDYahZqEgRIru5E=
X-Received: by 2002:ab0:344e:: with SMTP id a14mr7018853uaq.23.1629742397652; 
 Mon, 23 Aug 2021 11:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223406.1132426-1-rananta@google.com>
 <87sfz4qx9r.wl-maz@kernel.org>
 <CAJHc60wn7PP1zQ5EKOGQDFbZsf=d9codWTuWbtMT5AHegfbVHw@mail.gmail.com>
 <875yvzqd5d.wl-maz@kernel.org>
In-Reply-To: <875yvzqd5d.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 23 Aug 2021 11:13:06 -0700
Message-ID: <CAJHc60wLPFZ5XFwWVyex5GXr=qm7QWc2yOmkECxLh=L2QnvgWg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Ratelimit error log during guest debug
 exception
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
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

On Sat, Aug 21, 2021 at 3:56 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 21 Aug 2021 00:01:24 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > [1  <text/plain; UTF-8 (7bit)>]
> > On Fri, Aug 20, 2021 at 2:29 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 19 Aug 2021 23:34:06 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Potentially, the guests could trigger a debug exception that's
> > > > outside the exception class range.
> > >
> > > How? All the exception classes that lead to this functions are already
> > > handled in the switch/case statement.
> > >
> > I guess I didn't think this through. Landing into kvm_handle_guest_debug()
> > itself is not possible :)
>
> Exactly.
>
> > > My take on this is that this code isn't reachable, and that it could
> > > be better rewritten as:
> > >
> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 6f48336b1d86..ae7ec086827b 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -119,28 +119,14 @@ static int kvm_handle_guest_debug(struct kvm_vcpu
> > *vcpu)
> > >  {
> > >         struct kvm_run *run = vcpu->run;
> > >         u32 esr = kvm_vcpu_get_esr(vcpu);
> > > -       int ret = 0;
> > >
> > >         run->exit_reason = KVM_EXIT_DEBUG;
> > >         run->debug.arch.hsr = esr;
> > >
> > > -       switch (ESR_ELx_EC(esr)) {
> > > -       case ESR_ELx_EC_WATCHPT_LOW:
> > > +       if (ESR_ELx_EC(esr) ==  ESR_ELx_EC_WATCHPT_LOW)
> > >                 run->debug.arch.far = vcpu->arch.fault.far_el2;
> > > -               fallthrough;
> > > -       case ESR_ELx_EC_SOFTSTP_LOW:
> > > -       case ESR_ELx_EC_BREAKPT_LOW:
> > > -       case ESR_ELx_EC_BKPT32:
> > > -       case ESR_ELx_EC_BRK64:
> > > -               break;
> > > -       default:
> > > -               kvm_err("%s: un-handled case esr: %#08x\n",
> > > -                       __func__, (unsigned int) esr);
> > > -               ret = -1;
> > > -               break;
> > > -       }
> > >
> > > -       return ret;
> > > +       return 0;
> > >  }
> > >
> > This looks better, but do you think we would be compromising on readability?
>
> I don't think so. The exit handler table is, on its own, pretty
> explicit about what we route to this handler, and the comment above
> the function clearly states that we exit to userspace for all the
> debug ECs.

Sounds great. I'm happy to send out a patch with you as 'Suggested-by' , if you
are okay with it.

Regards,
Raghavendra
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
