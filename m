Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BE7C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 09:57:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A01C49ED1;
	Wed,  2 Mar 2022 04:57:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BuaP3fye9ptr; Wed,  2 Mar 2022 04:57:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 000E949E22;
	Wed,  2 Mar 2022 04:57:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36DD549E22
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 04:57:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ROh2k63Bqttj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 04:57:21 -0500 (EST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7CC049E21
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 04:57:21 -0500 (EST)
Received: by mail-lj1-f180.google.com with SMTP id l12so1433278ljh.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 01:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aKuyfSIYmSlG46+Z3eVPpfXvTwAhmEo9kXpqu0l3v6Y=;
 b=A8u395OXpOi6TkdoibjC+Wuttx3LnpW2WXCr2Oo0LNHP2OSPniYGjR39jifoZa9qZ+
 LaqceycIJH+ghxlUWaBH+fPhfgkgqP/GsUlnijw3YnqePC5ObkYIfPAfgpHQ9yEH1EcF
 4ho0q0Ck1DxPVmB6jf1Loy4WhCSwoi/UgPZY2tHTINtoFRzFlDSNaw6xP1pffpGAwvoa
 ohQjlWdxFX2MBDkbfvRgUaLlQ1BMahM4MRwoUbdHS523yGn4CRtmHXEu6eZC4Xq6jbZ7
 IlbVdkDI6/w5FisYJOijzdnuqb1C5PGu8FVSmhdV+T5pV++on2//8hnwhvlEjDIetzGL
 N0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aKuyfSIYmSlG46+Z3eVPpfXvTwAhmEo9kXpqu0l3v6Y=;
 b=wnYPh3SUl+B3jyMdYt2nNwO6X4pn/a82AeO6MW4dYdjzWcEq+W9hgQVvR+PqR7+4yw
 wYH+aa/PST4igk3nuvQqtTq7hNYKwoQfURnHJxBHpZjd7Li2FJS22z0zF/Dn3B24E7la
 /wCLvlHixVRJMl8mD3TwZsxBcVb9U+NJneVs1/mNBYxJtfnyloYEFxCPcPOhzOWVNtkO
 fr7l7rT5vzIe/5FQpInhuYgoOQKmvOUXfSlC5MkMKeysjVmrMk5YynJfnAXaYrB9r/Le
 TOQD2Irtm8uNagb03gjnvH9O39R0hD4WUwkeia9VJj/Zu34ea6Ynqz34piTRD7Sklceq
 Fj0A==
X-Gm-Message-State: AOAM532ZrrG8habrsjS/GFe8PaKiMCQ01RrHaX7XacvmENRDqI/Lr99I
 UkF4dxIwsCzdUPq98PV0t0tm54Ew9rXmcWBilmaDvg==
X-Google-Smtp-Source: ABdhPJwYdrHqTN7+CaZOAynhxMqmxut3XkZa7AgLknNJcuy8LukxF4yCQ0mB4d4CiA3XB4hytqtOmmabhkrAtpIB/tY=
X-Received: by 2002:a2e:b16e:0:b0:244:d368:57e with SMTP id
 a14-20020a2eb16e000000b00244d368057emr20011637ljm.251.1646215039693; Wed, 02
 Mar 2022 01:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-14-oupton@google.com>
 <87sfs82rz4.wl-maz@kernel.org> <YhflJ74nF2N+u1i4@google.com>
 <8735k57tnx.wl-maz@kernel.org>
 <CAOQ_Qsi1n2PTGe3F5BAhy3yHS4ar_0n0tru7smAfwAFWGY3Jug@mail.gmail.com>
 <87a6e83cme.wl-maz@kernel.org>
In-Reply-To: <87a6e83cme.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Wed, 2 Mar 2022 01:57:08 -0800
Message-ID: <CAOQ_QsiEM_O4oY_R3VasaiaGSMwJxAa=uBx6fi9yM9oYjWc_WQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/19] KVM: arm64: Add support KVM_SYSTEM_EVENT_SUSPEND
 to PSCI SYSTEM_SUSPEND
To: Marc Zyngier <maz@kernel.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

On Wed, Mar 2, 2022 at 1:52 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 26 Feb 2022 18:28:21 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > On Sat, Feb 26, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 24 Feb 2022 20:05:59 +0000,
> > > Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Thu, Feb 24, 2022 at 03:40:15PM +0000, Marc Zyngier wrote:
> > > > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > > > index 2bb8d047cde4..a7de84cec2e4 100644
> > > > > > --- a/arch/arm64/kvm/psci.c
> > > > > > +++ b/arch/arm64/kvm/psci.c
> > > > > > @@ -245,6 +245,11 @@ static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > > > > >           return 1;
> > > > > >   }
> > > > > >
> > > > > > + if (kvm->arch.system_suspend_exits) {
> > > > > > +         kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND);
> > > > > > +         return 0;
> > > > > > + }
> > > > > > +
> > > > >
> > > > > So there really is a difference in behaviour here. Userspace sees the
> > > > > WFI behaviour before reset (it implements it), while when not using
> > > > > the SUSPEND event, reset occurs before anything else.
> > > > >
> > > > > They really should behave in a similar way (WFI first, reset next).
> > > >
> > > > I mentioned this on the other patch, but I think the conversation should
> > > > continue here as UAPI context is in this one.
> > > >
> > > > If SUSPEND exits are disabled and SYSTEM_SUSPEND is implemented in the
> > > > kernel, userspace cannot observe any intermediate state. I think it is
> > > > necessary for migration, otherwise if userspace were to save the vCPU
> > > > post-WFI, pre-reset the pending reset would get lost along the way.
> > > >
> > > > As far as userspace is concerned, I think the WFI+reset operation is
> > > > atomic. SUSPEND exits just allow userspace to intervene before said
> > > > atomic operation.
> > > >
> > > > Perhaps I'm missing something: assuming SUSPEND exits are disabled, what
> > > > value is provided to userspace if it can see WFI behavior before the
> > > > reset?
> > >
> > > Signals get in the way, and break the notion of atomicity. Userspace
> > > *will* observe this.
> > >
> > > I agree that save/restore is an important point, and that snapshoting
> > > the guest at this stage should capture the reset value. But it is the
> > > asymmetry of the behaviours that I find jarring:
> > >
> > > - if you ask for userspace exit, no reset value is applied and you
> > >   need to implement the reset in userspace
> > >
> > > - if you *don't* ask for a userspace exit, the reset values are
> > >   applied, and a signal while in WFI will result in this reset being
> > >   observed
> > >
> > > Why can't the userspace exit path also apply the reset values *before*
> > > exiting? After all, you can model this exit to userspace as
> > > reset+WFI+'spurious exit from WFI'. This would at least unify the two
> > > behaviours.
> >
> > I hesitated applying the reset context to the CPU before the userspace
> > exit because that would be wildly different from the other system
> > events. Userspace wouldn't have much choice but to comply with the
> > guest request at that point.
> >
> > What about adopting the following:
> >
> >  - Drop the in-kernel SYSTEM_SUSPEND emulation. I think you were
> > getting at this point in [1], and I'd certainly be open to it. Without
> > a userspace exit, I don't think there is anything meaningfully
> > different between this call and a WFI instruction.
>
> The only difference is the reset part. And I agree, it only makes the
> kernel part more complicated than we strictly need it to be. It also
> slightly clashes with the rest of the system events, in the sense that
> it is the only one that would have an in-kernel implementation (both
> reboot and power-off are entirely implemented in userspace).
>
> So I definitely agree about dropping this.
>
> >
> >  - Add data to the kvm_run structure to convey the reset state for a
> > SYSTEM_SUSPEND exit. There's plenty of room left in the structure for
> > more, and can be done generically (just an array of data) for future
> > expansion. We already are going to need a code change in userspace to
> > do this right, so may as well update its view of kvm_run along the
> > way.
>
> The reset state is already available in the guest registers, which are
> available to userspace. What else do we need to expose?

Nothing. It is just a slight nitnoid thing for me where
KVM_EXIT_SYSTEM_SUSPEND behaves a bit differently than the others. If
a VMM wants to reject the call, it needs to manually set up the SMCCC
return value, whereas on the others a naive call to KVM_RUN will do
the job since KVM already sets up the failure value.

Unsure if this warrants a kvm_run change, leaning towards no if it is
well documented.

> >  - Exit to userspace with PSCI_RET_INTERNAL_FAILURE queued up for the
> > guest. Doing so keeps the exits consistent with the other system
> > exits, and affords userspace the ability to deny the call when it
> > wants to.
>
> Yup, that's what I like about pushing this completely to userspace.
>
> >
> > [1]: http://lore.kernel.org/r/87fso63ha2.wl-maz@kernel.org
> >
> > > I still dislike the reset state being applied early, but consistency
> > > (and save/restore) trumps taste here. I know I'm being pedantic here,
> > > but we've been burned with loosely defined semantics in the past, and
> > > I want to get this right. Or less wrong.
> >
> > I completely agree with you. The semantics are a bit funky, and I
> > really do wonder if the easiest way around that is to just make the
> > implementation a userspace problem.
>
> We're in violent agreement.

Lol

> It means that we only need the MP_STATE
> part to implement WFI from userspace.
>
> Could you try and respin this? Also, it'd be good to see a prototype
> of userspace code using this, as this is a new API.

Sure thing. I'll keep it to kvmtool, since that's the most familiar to
me. Also, I think I had an RFC for kvmtool many moons ago...

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
