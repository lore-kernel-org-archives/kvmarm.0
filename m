Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4543BC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 18:53:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9A474B252;
	Tue, 11 Jan 2022 13:53:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wnUoHz4Fe9zQ; Tue, 11 Jan 2022 13:52:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABA6A4B24D;
	Tue, 11 Jan 2022 13:52:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 987FA4B24D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 13:52:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B8t-EGJlAV9H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 13:52:56 -0500 (EST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E2474B245
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 13:52:56 -0500 (EST)
Received: by mail-yb1-f173.google.com with SMTP id i3so49982409ybh.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=17MefAb7Wq51LBItM83lwZITi4By/+6kifCdUczNHes=;
 b=qe/vTFEQwfqq+6k74r7b8ljqbjo6ywjiHIZvlXWsbp5cgSwDmZeXP7KquwvmXWtxan
 WIiTsy2bpJ3Edfi0fwgbn5KlEpxI2ct3pCgIQKEnBSsz9YU9mHCiLnH+HrlrvTEJAXQn
 WVPTmLVQeydNcrhrRk3YLrFt9UfEKFk0/QkK/5QWu4sHXrkFZBC/aTcv04KZJzB5HBzx
 OhyWzwxYcxgwBacEU0iNLa8PTrZ1sXHyo/H944RQ2AhQlHyUEVjKaDLxyotS/00b3/3A
 fBQkmgyjGXxOEqWLhMJ/5pZN9YoOzuYeXLnoN+OS+gfAM+/oQhmnjHPWIna3AQU/mNw1
 8hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=17MefAb7Wq51LBItM83lwZITi4By/+6kifCdUczNHes=;
 b=Fb84kyMbdpVlOODsEZfkTuF/JSQRR/+7ILQlFqkfGjGJxD2eQx+GEDk4eLsblIZjKl
 +cSLikeXLazMdXzdKSxQKTb+UhHZyn66xlq8Z7fsUuR4m2duVi+CmtBVZtZ97F89OPjP
 wfyifOy1n7YNXGc1uX7F7uoxHw4itCMiGPIVpFhuQxN03LJq4S0BNGeynjYzG4HxHZQ/
 Boh8bI9E6bikh0j11hkD01GHe7xVOw3YrKzT1KdffpgLgtXDO10ZvmlJY8b8gOYRpGyC
 fCjLq5+LwHPfFKpVKZ5f8IRWQCn0VOQ1O7SkG1/HzIR8NYv358nuCspBxATHN825nhbF
 Qutw==
X-Gm-Message-State: AOAM530Z8EjbQfDvkxLJm/fvuhdLLr1RFSyluuCXCi9r7/wQW1Pxe8Ta
 oEeqKI0oQVJehf0hqGY+r5SOdqEUOXRs7nX2ct6lAA==
X-Google-Smtp-Source: ABdhPJyn0Wq/OnTFO+pZZsGiPNj88pyrxrt8LxfP010ZWFUMpcdrTES6feVX3nFLo0tTGlZ2e9VdGfMDeGrY622KE1E=
X-Received: by 2002:a25:c841:: with SMTP id y62mr8486367ybf.196.1641927175898; 
 Tue, 11 Jan 2022 10:52:55 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
In-Reply-To: <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 11 Jan 2022 10:52:45 -0800
Message-ID: <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Mon, Jan 10, 2022 at 3:57 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > >
> > > > > Hi Raghu,
> > > > >
> > > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > > <rananta@google.com> wrote:
> > > > > >
> > > > > > Capture the start of the KVM VM, which is basically the
> > > > > > start of any vCPU run. This state of the VM is helpful
> > > > > > in the upcoming patches to prevent user-space from
> > > > > > configuring certain VM features after the VM has started
> > > > > > running.
> > >
> > > What about live migration, where the VM has already technically been
> > > started before the first call to KVM_RUN?
> >
> > My understanding is that a new 'struct kvm' is created on the target
> > machine and this flag should be reset, which would allow the VMM to
> > restore the firmware registers. However, we would be running KVM_RUN
> > for the first time on the target machine, thus setting the flag.
> > So, you are right; It's more of a resume operation from the guest's
> > point of view. I guess the name of the variable is what's confusing
> > here.
>
> I was actually thinking that live migration gives userspace an easy
> way to circumvent your restriction. You said, "This state of the VM is
> helpful in the upcoming patches to prevent user-space from configuring
> certain VM features after the VM has started running." However, if you
> don't ensure that these VM features are configured the same way on the
> target machine as they were on the source machine, you have not
> actually accomplished your stated goal.
>
Isn't that up to the VMM to save/restore and validate the registers
across migrations?
Perhaps I have to re-word my intentions for the patch- userspace
should be able to configure the registers before issuing the first
KVM_RUN.

Thanks,
Raghavendra

> > Thanks,
> > Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
