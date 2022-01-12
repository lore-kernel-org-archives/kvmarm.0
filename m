Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C3AC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 18:29:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE5F84B0DE;
	Wed, 12 Jan 2022 13:29:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z9reibAEFzah; Wed, 12 Jan 2022 13:29:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0BC449F28;
	Wed, 12 Jan 2022 13:29:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DB5949F22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:29:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1HFCsAi0NiH4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 13:29:19 -0500 (EST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7936749E4A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:29:19 -0500 (EST)
Received: by mail-yb1-f174.google.com with SMTP id p5so7982170ybd.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ioZFa8MC1+lYZ4QoC/7YWzVkd4bJ+z/9gnEvzeEbMy4=;
 b=EJNOGgBTzR4d+pUvCYvjfawgKqJB8uCOzmTw2NhI6Ch4V2hprO0Xm+S2ceCFGHixST
 1aOvJU8qmRqqf10TwmjZB/8yIck9/Ul0B2TrybLH8AZpQedw43I5Bhd0xGkNCK3hhApy
 sj2igGZoPKoPqkAfZ8uTtQME39e63cTzXDayaDxqglMPXGFYONmw7IjqWg2VOTyOgczU
 duKpoVMkB1wPF5NntnPSm9sleh730pv1OcV64hAIMOwqJ0/sBg559ydh50Pk+jXjiWUg
 cWMTbPH7K5Oxj15BMlROOqtJokzcsrIOAEZ8lqCr5R7bNYW1msKEMfthMnmoh94skcj9
 qXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ioZFa8MC1+lYZ4QoC/7YWzVkd4bJ+z/9gnEvzeEbMy4=;
 b=Aa1sXjSukc57bzaA1MZ8dVq54c5NHHTqFx3RKu1REqA0iciCNhRde7lhw3wUZjSOYd
 HV0XD8JCELdeZWmb2dhsdheX3SVFTGnEq0uFmY3ITqGow5MkKSjmrmNcCYvpJXXBctaE
 cDsPADyupJDzZcvErwGZ5JDUsbLtzBPatewCRVOPe3pTE/q3hI0yyRbsCy02tq14F5qe
 BBVhQs5M67Otb2J50pY/SDh+7mcTXLQHArx7wx4xvZWbJrKXVVuUAQfcr5ICCk1Z4CYD
 FHjiWNBIH8nTAUL2F9ZgZior68uindvs0dVn0tS9whmVuLNT3olrQ8sO2+i3BzGBjKcm
 m1Ag==
X-Gm-Message-State: AOAM530k8Nh39Yd7qhBr12JVThamxASYmgWrc8bZ3vYVqyDJdtT/yOKc
 tQ196NwyvzHXU/SQ4xFBhUlz57qEVEzb1QzMUIyVBg==
X-Google-Smtp-Source: ABdhPJxP9y/VohUfFKSPP8Ebe2w7tuIIiYl3DrsSGfw54USAQIa0/WSL7GFfuDNgf1DGqj0M08Dx9O0UOuOOD7NOH9w=
X-Received: by 2002:a25:244e:: with SMTP id k75mr1255464ybk.172.1642012158650; 
 Wed, 12 Jan 2022 10:29:18 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
In-Reply-To: <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 12 Jan 2022 10:29:07 -0800
Message-ID: <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
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

On Tue, Jan 11, 2022 at 11:16 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Tue, Jan 11, 2022 at 10:52 AM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > On Mon, Jan 10, 2022 at 3:57 PM Jim Mattson <jmattson@google.com> wrote:
> > >
> > > On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> > > > >
> > > > > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > > > > <rananta@google.com> wrote:
> > > > > >
> > > > > > Hi Reiji,
> > > > > >
> > > > > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > > > >
> > > > > > > Hi Raghu,
> > > > > > >
> > > > > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > > > > <rananta@google.com> wrote:
> > > > > > > >
> > > > > > > > Capture the start of the KVM VM, which is basically the
> > > > > > > > start of any vCPU run. This state of the VM is helpful
> > > > > > > > in the upcoming patches to prevent user-space from
> > > > > > > > configuring certain VM features after the VM has started
> > > > > > > > running.
> > > > >
> > > > > What about live migration, where the VM has already technically been
> > > > > started before the first call to KVM_RUN?
> > > >
> > > > My understanding is that a new 'struct kvm' is created on the target
> > > > machine and this flag should be reset, which would allow the VMM to
> > > > restore the firmware registers. However, we would be running KVM_RUN
> > > > for the first time on the target machine, thus setting the flag.
> > > > So, you are right; It's more of a resume operation from the guest's
> > > > point of view. I guess the name of the variable is what's confusing
> > > > here.
> > >
> > > I was actually thinking that live migration gives userspace an easy
> > > way to circumvent your restriction. You said, "This state of the VM is
> > > helpful in the upcoming patches to prevent user-space from configuring
> > > certain VM features after the VM has started running." However, if you
> > > don't ensure that these VM features are configured the same way on the
> > > target machine as they were on the source machine, you have not
> > > actually accomplished your stated goal.
> > >
> > Isn't that up to the VMM to save/restore and validate the registers
> > across migrations?
>
> Yes, just as it is up to userspace not to make bad configuration
> changes after the first VMRUN.
>
> > Perhaps I have to re-word my intentions for the patch- userspace
> > should be able to configure the registers before issuing the first
> > KVM_RUN.
>
> Perhaps it would help if you explained *why* you are doing this. It
> sounds like you are either trying to protect against a malicious
> userspace, or you are trying to keep userspace from doing something
> stupid. In general, kvm only enforces constraints that are necessary
> to protect the host. If that's what you're doing, I don't understand
> why live migration doesn't provide an end-run around your protections.
It's mainly to safeguard the guests. With respect to migration, KVM
and the userspace are collectively playing a role here. It's up to the
userspace to ensure that the registers are configured the same across
migrations and KVM ensures that the userspace doesn't modify the
registers after KVM_RUN so that they don't see features turned OFF/ON
during execution. I'm not sure if it falls into the definition of
protecting the host. Do you see a value in adding this extra
protection from KVM?

Regards,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
