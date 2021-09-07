Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61560C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:14:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3DAF61101
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D3DAF61101
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60FF74B120;
	Tue,  7 Sep 2021 14:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i6XJS8QXO5ku; Tue,  7 Sep 2021 14:14:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB894B0D7;
	Tue,  7 Sep 2021 14:14:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B6F4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:14:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HtNbWXPmfOyi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:14:13 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF7244B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:14:12 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id w4so17933371ljh.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=22psKZppfuCAffbrjrbw25DXVA7uHKusFcTh62wjOrA=;
 b=ZsPluqlohe8YzCmrUxmZMF/+jjRmjT5KYoRJs1opsmNsf3Bp4ae3ForwixHWgEgCeY
 5Y8I9R0Cz5x2Xma89hhMFvqu6DQxARrBceZRsr3XFr/WM5wtjuJoW0GHaFhNzAXwFhhI
 S1EkHrF5JrPEWMWAGZjUnkxdYtLDIUE7KMwMyn4xYU4QeBH/t8iIaHdO2kpHUqQE7RbN
 RL8K3WMYRyk4pFWxhzkrYv3BNPmMYdweSvLfB9g+HYjS108Vu9oxTz0gG+Iszdc9QpNp
 o7ntk257yaGK+2j+yToa9OxS2zAfN7wH4SwuVmKDeGT+RLp6l+BxSBfGS7/9x8i9T/P6
 V4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=22psKZppfuCAffbrjrbw25DXVA7uHKusFcTh62wjOrA=;
 b=OA+MmFxoCb8BAxHR3Bh8F9SrfpIPR4SJYl7iHI7+YQwqdCiMrle7Z6YHS3uDzxmQPI
 Hgkk98S+FpDWuE9Npilxz3O+Oy96GDxhPJ4np6St4bjLLMHTxId8kC6337A0Vl/S/i2I
 8hLHxbL7ZjbPEj6dCxgQf54I1SGE83D1GTJyZsAJnN88m3OUeLnCM209xoWgprc3xkho
 VAF8lx5fOeZfuD5yj/R3ccj7ZISBZ1vC2eq8zkQQKKJRWHUt0T9GXm26BV398wVIIQN3
 3/xlTRN1n8ZgHwssspE9S5T5lzt0mhSzRrBCVTNBOLglF1GYYFHdSsCoLzPZMsh3cWeM
 FUVw==
X-Gm-Message-State: AOAM533dQmP1kmu5JjBsqEI6YWkgYpYiwLaAfoUVh3DPgAxVZQsC0xaO
 U6Q9qPyhThvhuXo40ldx2E7Ck7eGWBgFJbNgMoy/DA==
X-Google-Smtp-Source: ABdhPJxpRADUwGV2bBvnW+3ObzfFz4JybOlhXviFqaZUe/0MV2VIaZSPxY+osoNDQi1BW1Iz/9zAmiTORRFOB6YNqaQ=
X-Received: by 2002:a2e:154e:: with SMTP id 14mr16249321ljv.374.1631038451111; 
 Tue, 07 Sep 2021 11:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
 <87ilzecbkj.wl-maz@kernel.org>
 <CAOQ_QsgOtufyB6_qGAs4fQf6kd81FSMSj44uiVRgoFQWOf3nRA@mail.gmail.com>
 <87a6kocmcx.wl-maz@kernel.org>
In-Reply-To: <87a6kocmcx.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Tue, 7 Sep 2021 13:14:00 -0500
Message-ID: <CAOQ_QshZe8ay03XqCo4DkM6zUaOuEoS5bRbrOy+FsuXaJ=YyKA@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

On Tue, Sep 7, 2021 at 12:43 PM Marc Zyngier <maz@kernel.org> wrote:
> > > Although the definition of SYSTEM_SUSPEND is very simple from a PSCI
> > > perspective, I don't think it is that simple at the system level,
> > > because PSCI is only concerned with the CPU.
> > >
> > > For example, what is a wake-up event? My first approach would be to
> > > consider interrupts to be such events. However, this approach suffers
> > > from at least two issues:
> > >
> > > - How do you define which interrupts are actual wake-up events?
> > >   Nothing in the GIC architecture defines what a wake-up is (let alone
> > >   a wake-up event).
> >
> > Good point.
> >
> > One possible implementation of suspend could just be a `WFI` in a
> > higher EL. In this case, KVM could emulate WFI wake up events
> > according to D1.16.2 in DDI 0487G.a. But I agree, it isn't entirely
> > clear what constitutes a wakeup from powered down state.
>
> It isn't, and it is actually IMPDEF (there isn't much in the ARM ARM
> in terms of what constitutes a low power state). And even if you
> wanted to emulate a WFI in userspace, the problem of interrupts that
> have their source in the kernel remains. How to you tell userspace
> that such an event has occurred if the vcpu thread isn't in the
> kernel?

Well, are there any objections to saying for the KVM implementation we
observe the WFI wake-up events per the cited section of the ARM ARM?

> > > It looks to me that your implementation can only work with userspace
> > > provided events, which is pretty limited.
> >
> > Right. I implemented this from the mindset that userspace may do
> > something heavyweight when a guest suspends, like save it to a
> > persistent store to resume later on. No matter what we do in KVM, I
> > think it's probably best to give userspace the right of first refusal
> > to handle the suspension.
>
> Maybe. But if you want to handle wake-up from interrupts to actually
> work, you must return to the kernel for the wake-up to occurs.
>
> The problem is that you piggyback on an existing feature (suspend) to
> implement something else (opportunistic save/restore?). Oddly enough
> the stars don't exactly align! ;-)
>
> I have the feeling that a solution to this problem would be to exit to
> userspace with something indicating an *intent* to suspend. At this
> stage, userspace can do two things:
>
> - resume the guest: the guest may have been moved to some other
>   machine, cold storage, whatever... The important thing is that the
>   guest is directly runnable without any extra event
>
> - confirm the suspension by returning to the kernel, which will
>   execute a blocking WFI on behalf of the guest
>
> With this, you end-up with something that is works from an interrupt
> perspective (even for directly injected interrupts), and you can save
> your guest on suspend.

This is exactly what I was trying to get at with my last mail,
although not quite as eloquently stated. So I completely agree.

Just to check understanding for v2:

We agree that an exit to userspace is fine so it has the opportunity
to do something crazy when the guest attempts a suspend. If a VMM does
nothing and immediately re-enters the kernel, we emulate the suspend
there by waiting for some event to fire, which for our purposes we
will say is an interrupt originating from userspace or the kernel
(WFI). In all, the SUSPEND exit type does not indicate that emulation
terminates with the VMM. It only indicates we are about to block in
the kernel.

If there is some IMPDEF event specific to the VMM, it should signal
the vCPU thread to kick it out of the kernel, make it runnable, and
re-enter. No need to do anything special from the kernel perspective
for this. This is only for the case where we decide to block in the
kernel.

>
> >
> > > Other items worth considering: ongoing DMA, state of the caches at
> > > suspend time, device state in general All of this really needs to be
> > > defined before we can move forward with this feature.
> >
> > I believe it is largely up to the caller to get devices in a quiesced
> > state appropriate for a system suspend, but PSCI is delightfully vague
> > on this topic.
>
> Indeed, it only deals with the CPU. Oh look, another opportunity to
> write a new spec! :)
>
> > On the contrary, it is up to KVM's implementation to
> > guarantee caches are clean when servicing the guest request.
>
> This last point is pretty unclear to me. If the guest doesn't clean to
> the PoC (or even to one of the PoPs) when it calls into suspend,
> that's a clear indication that it doesn't care about its data. Why
> should KVM be more conservative here? It shouldn't be in the business
> of working around guest bugs.

PSCI is vague on this, sadly. DEN0022D.b, 5.4.8 "Implementation
responsibilities: Cache and coherency management states" that for
CPU_SUSPEND, the PSCI implementation must perform a cache clean
operation before entering the powerdown state. I don't see any reason
why SYSTEM_SUSPEND should be excluded from this requirement.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
