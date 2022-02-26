Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C7AC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 26 Feb 2022 18:28:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6886F4B621;
	Sat, 26 Feb 2022 13:28:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jhU8hAvC89A8; Sat, 26 Feb 2022 13:28:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEA854B611;
	Sat, 26 Feb 2022 13:28:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B98774B5AA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Feb 2022 13:28:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nGV2nNMzPg6s for <kvmarm@lists.cs.columbia.edu>;
 Sat, 26 Feb 2022 13:28:34 -0500 (EST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
 [209.85.208.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 217D64B477
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Feb 2022 13:28:34 -0500 (EST)
Received: by mail-lj1-f175.google.com with SMTP id u11so11796919lju.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 26 Feb 2022 10:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YhAgqiWLbIhprpB4PTDWt6I/fMa4rCNESBFaVBRMGDk=;
 b=eF7sTfy8PRdrb5HHtbrH1LzmyvW0DK91TGdIQim+9sPGZkTcokk57lq6AU2sC6XCtN
 KZQHn4B6exdIG2xwONt7g+IsZk613AAMSVFbZpCl1fn9dhihWlm5FkWBSWT3xyxGbrkl
 GyrDbBJIT0oSJE/NnurO9H4rgeRRdlj84EfMdP/FVKZ0hYY+YMYJ9+RA93KZUIje4RAe
 jnhJOfj0CvGUuV0OaqwQe//20t/Kn5uEC5YtjdfhCuxXqM8YoihpoFCYD1wUpRl5unmf
 d4tbH0RXyyr93hd0k50r41p8V/7Qpe7r85LPvkCUpCBLKAx6TgeqQzYs/RMw4Vns5+bc
 Tzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YhAgqiWLbIhprpB4PTDWt6I/fMa4rCNESBFaVBRMGDk=;
 b=DesWOMY+dzJpCtXYIxDZV3vIebCZAV3vPI0TqFfZy6n09x3Y5fVbLz2iyqM5xrVW+N
 neXS9BLTgnP9g/AbB4CP7rQApR92oEhOUVWearIVijItQDTK2/xZ6+TIAfV0r5bxUapk
 jAkvwYRcOVmsYu1QmVkzzKZjlLMClSVLNvcwIF4kVn9kASszUzF2NvHR7azGlbd3B43A
 av0D+u/rsz/AlU/YSUIz4KgwsdKMlaIdm9WqxmzJGlhNW/rFJv3gL+vo2QYwEQQDm3/W
 7DFHOHBVAeGj2Aj8JMrpraajOp9ZKwlgpwb1NqLRvz4sIPXKF3AtvwsGc6Hw6SLyx4t4
 /Xxg==
X-Gm-Message-State: AOAM530bxh0yk4Sf9mboCDwLNyN2iA4bh7IQWUG1rFB86p8xm9DhS+DR
 y4oF6cqsT/pzOQJyiNCESm2G8Iic/wz1ZkB+fXQJFw==
X-Google-Smtp-Source: ABdhPJxKzfIa2r2T8l8vr9vzs4enUHCu5WQWCNzEzy+VRL15+oBvPXtlpfEul4sVs5zWWtJh4YRYFC3zKqUfZsh2EIs=
X-Received: by 2002:a05:651c:160c:b0:244:c704:8315 with SMTP id
 f12-20020a05651c160c00b00244c7048315mr9079489ljq.170.1645900112391; Sat, 26
 Feb 2022 10:28:32 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-14-oupton@google.com>
 <87sfs82rz4.wl-maz@kernel.org> <YhflJ74nF2N+u1i4@google.com>
 <8735k57tnx.wl-maz@kernel.org>
In-Reply-To: <8735k57tnx.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Sat, 26 Feb 2022 10:28:21 -0800
Message-ID: <CAOQ_Qsi1n2PTGe3F5BAhy3yHS4ar_0n0tru7smAfwAFWGY3Jug@mail.gmail.com>
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

On Sat, Feb 26, 2022 at 3:29 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 24 Feb 2022 20:05:59 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > On Thu, Feb 24, 2022 at 03:40:15PM +0000, Marc Zyngier wrote:
> > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > index 2bb8d047cde4..a7de84cec2e4 100644
> > > > --- a/arch/arm64/kvm/psci.c
> > > > +++ b/arch/arm64/kvm/psci.c
> > > > @@ -245,6 +245,11 @@ static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
> > > >           return 1;
> > > >   }
> > > >
> > > > + if (kvm->arch.system_suspend_exits) {
> > > > +         kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND);
> > > > +         return 0;
> > > > + }
> > > > +
> > >
> > > So there really is a difference in behaviour here. Userspace sees the
> > > WFI behaviour before reset (it implements it), while when not using
> > > the SUSPEND event, reset occurs before anything else.
> > >
> > > They really should behave in a similar way (WFI first, reset next).
> >
> > I mentioned this on the other patch, but I think the conversation should
> > continue here as UAPI context is in this one.
> >
> > If SUSPEND exits are disabled and SYSTEM_SUSPEND is implemented in the
> > kernel, userspace cannot observe any intermediate state. I think it is
> > necessary for migration, otherwise if userspace were to save the vCPU
> > post-WFI, pre-reset the pending reset would get lost along the way.
> >
> > As far as userspace is concerned, I think the WFI+reset operation is
> > atomic. SUSPEND exits just allow userspace to intervene before said
> > atomic operation.
> >
> > Perhaps I'm missing something: assuming SUSPEND exits are disabled, what
> > value is provided to userspace if it can see WFI behavior before the
> > reset?
>
> Signals get in the way, and break the notion of atomicity. Userspace
> *will* observe this.
>
> I agree that save/restore is an important point, and that snapshoting
> the guest at this stage should capture the reset value. But it is the
> asymmetry of the behaviours that I find jarring:
>
> - if you ask for userspace exit, no reset value is applied and you
>   need to implement the reset in userspace
>
> - if you *don't* ask for a userspace exit, the reset values are
>   applied, and a signal while in WFI will result in this reset being
>   observed
>
> Why can't the userspace exit path also apply the reset values *before*
> exiting? After all, you can model this exit to userspace as
> reset+WFI+'spurious exit from WFI'. This would at least unify the two
> behaviours.

I hesitated applying the reset context to the CPU before the userspace
exit because that would be wildly different from the other system
events. Userspace wouldn't have much choice but to comply with the
guest request at that point.

What about adopting the following:

 - Drop the in-kernel SYSTEM_SUSPEND emulation. I think you were
getting at this point in [1], and I'd certainly be open to it. Without
a userspace exit, I don't think there is anything meaningfully
different between this call and a WFI instruction.

 - Add data to the kvm_run structure to convey the reset state for a
SYSTEM_SUSPEND exit. There's plenty of room left in the structure for
more, and can be done generically (just an array of data) for future
expansion. We already are going to need a code change in userspace to
do this right, so may as well update its view of kvm_run along the
way.

 - Exit to userspace with PSCI_RET_INTERNAL_FAILURE queued up for the
guest. Doing so keeps the exits consistent with the other system
exits, and affords userspace the ability to deny the call when it
wants to.

[1]: http://lore.kernel.org/r/87fso63ha2.wl-maz@kernel.org

> I still dislike the reset state being applied early, but consistency
> (and save/restore) trumps taste here. I know I'm being pedantic here,
> but we've been burned with loosely defined semantics in the past, and
> I want to get this right. Or less wrong.

I completely agree with you. The semantics are a bit funky, and I
really do wonder if the easiest way around that is to just make the
implementation a userspace problem.

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
