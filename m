Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5020EC4332F
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 16:30:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C080A61101
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 16:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C080A61101
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53EAD4B20C;
	Tue,  7 Sep 2021 12:30:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AMZSHPZOz28u; Tue,  7 Sep 2021 12:30:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F6F4B1C0;
	Tue,  7 Sep 2021 12:30:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B964B1C0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 12:30:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gkdEgFbDU-ST for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 12:30:46 -0400 (EDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com
 [209.85.208.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCC704B19D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 12:30:46 -0400 (EDT)
Received: by mail-lj1-f171.google.com with SMTP id i28so17493546ljm.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 09:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PU8BOGj/hM9faC7h3f2YNkNVZWgFRKQgS/a6ZHKLdP0=;
 b=B2YxoLE3yOMXCXdenJTEuuWIzJXeuBIjukYW+1FgkIzdC/FnXjtjch5h+mN6LvVYOB
 U2XV0GYWoYTNRiAL7Uub16Hi4yVECrWYB0QZh5sYZsbxX8Oi0dS7OeteWGw7+BM6Ejua
 l1xXnR4ylGsFA0jnPsQTo/eSdqJ7Tyr5R/a4jD0+o6npN59dCpV5dh+XF0jKKuY9+I+l
 s6BHDKwUs4H0eVS0MNYyLxJa4jd7lSzC5jzQQG5vkczSm1m2HBSH1/Iu9+++pP++ZYfv
 xzUIeCFGByeZvsjxaqe4g7+bAvYppIzaVt29gVjL1EnUSwinTq4J1mOb1IxBhmMLHm0/
 vYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PU8BOGj/hM9faC7h3f2YNkNVZWgFRKQgS/a6ZHKLdP0=;
 b=gN482ZdBVfH+CPSU1znV7g/lV3W8JNV8JfW11UNf+kCUq3UPP8pg0fI6iJxks3g8ZV
 h53cq04IDNwl5Pln1wU76zUfEyatqPIdkmWVr7cFchoVxnDE4xFk2Hy4i+ewCZx1YBNl
 hZCbxMhJMQ6JLeukH+zAHVNesqrbuOqVzxPbQ4jVvN90X0OddIOxjnaS1DJkbQkxVL18
 SQM54kTErzz9/dvUwqtIBcLafOrhI6v5m3XNGP57uWLdAQ7gzm+KdxRDr/SCEUmNpJQF
 iMWwGT8FovmbVKZleKXBikyAS5xICdlzXqdmy9knIPpYA5JJknAXwxxvFPjujpF6sweB
 Y9/A==
X-Gm-Message-State: AOAM530IsairU1TBUKJ9td1VJFCWO41JbuE6fe/MVwOdPOt6l27DxmPY
 7lY0Zp4ASYbYzj7MAaXeWFu917tbCqtL7Xjs/0P6qw==
X-Google-Smtp-Source: ABdhPJycG+lO7/cDng39gVxRn2icxFL6m85mj0anFsna8tzXBF9o4oXgHaqU7jFLXMhCvBkT7i8rLYJz+o19Av0Vj4s=
X-Received: by 2002:a2e:a0c8:: with SMTP id f8mr8445691ljm.170.1631032244856; 
 Tue, 07 Sep 2021 09:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
 <87ilzecbkj.wl-maz@kernel.org>
In-Reply-To: <87ilzecbkj.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Tue, 7 Sep 2021 11:30:33 -0500
Message-ID: <CAOQ_QsgOtufyB6_qGAs4fQf6kd81FSMSj44uiVRgoFQWOf3nRA@mail.gmail.com>
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

On Mon, Sep 6, 2021 at 4:12 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Thu, 19 Aug 2021 23:36:34 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Certain VMMs/operators may wish to give their guests the ability to
> > initiate a system suspend that could result in the VM being saved to
> > persistent storage to be resumed at a later time. The PSCI v1.0
> > specification describes an SMC, SYSTEM_SUSPEND, that allows a kernel to
> > request a system suspend. This call is optional for v1.0, and KVM
> > elected to not support the call in its v1.0 implementation.
> >
> > This series adds support for the SYSTEM_SUSPEND PSCI call to KVM/arm64.
> > Since this is a system-scoped event, KVM cannot quiesce the VM on its
> > own. We add a new system exit type in this series to clue in userspace
> > that a suspend was requested. Per the KVM_EXIT_SYSTEM_EVENT ABI, a VMM
> > that doesn't care about this event can simply resume the guest without
> > issue (we set up the calling vCPU to come out of reset correctly on next
> > KVM_RUN).
>
> More idle thoughts on this:
>
> Although the definition of SYSTEM_SUSPEND is very simple from a PSCI
> perspective, I don't think it is that simple at the system level,
> because PSCI is only concerned with the CPU.
>
> For example, what is a wake-up event? My first approach would be to
> consider interrupts to be such events. However, this approach suffers
> from at least two issues:
>
> - How do you define which interrupts are actual wake-up events?
>   Nothing in the GIC architecture defines what a wake-up is (let alone
>   a wake-up event).

Good point.

One possible implementation of suspend could just be a `WFI` in a
higher EL. In this case, KVM could emulate WFI wake up events
according to D1.16.2 in DDI 0487G.a. But I agree, it isn't entirely
clear what constitutes a wakeup from powered down state.

> - Assuming you have a way to express the above, how do you handle
>   wake-ups from interrupts that have their source in the kernel (such
>   as timers, irqfd sources)?

I think this could be handled, so long as we allow userspace to
indicate it has woken a vCPU. Depending on this, in the next KVM_RUN
we'd say:

- Some IMP DEF event occurred; I'm waking this CPU now
- I've either chosen to ignore the guest or will defer to KVM's
suspend implementation

> How do you cope with directly injected interrupts?

No expert on this, I'll need to do a bit more reading to give a good
answer here.

> It looks to me that your implementation can only work with userspace
> provided events, which is pretty limited.

Right. I implemented this from the mindset that userspace may do
something heavyweight when a guest suspends, like save it to a
persistent store to resume later on. No matter what we do in KVM, I
think it's probably best to give userspace the right of first refusal
to handle the suspension.

> Other items worth considering: ongoing DMA, state of the caches at
> suspend time, device state in general All of this really needs to be
> defined before we can move forward with this feature.

I believe it is largely up to the caller to get devices in a quiesced
state appropriate for a system suspend, but PSCI is delightfully vague
on this topic. On the contrary, it is up to KVM's implementation to
guarantee caches are clean when servicing the guest request.

I'll crank on this a bit more and see if I have more thoughts.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
