Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFD3C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 11:18:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E40594B25D;
	Wed, 12 Jan 2022 06:18:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tgI4czHi6w+u; Wed, 12 Jan 2022 06:18:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA6E94B1F3;
	Wed, 12 Jan 2022 06:18:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2654B1E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:17:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nWbqwwU9L7YK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 14:16:59 -0500 (EST)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com
 [209.85.210.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B1974B161
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:16:59 -0500 (EST)
Received: by mail-ot1-f41.google.com with SMTP id
 r7-20020a05683001c700b005906f5b0969so19758768ota.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 11:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RmmeEOXgL4aczt2lYfVEJ81JJyR5GHuXnUEqtqtBYAw=;
 b=cOATJM7qKaMwa1rfMreaSBRrwDDzMO7PjOtbZd5NEoxEnpoVYSyEoZ9YYXqeYIXSvr
 YE9v8N/iag490QDHMRj+L/DdGLjpFJHDqQCT7vnsL3SeJdwkX63Af178WulVTiUohxbi
 2Z/g/UTUnmDWrvpF1A4BuycMUQiQMZtfEfDMEJMhly8ysY21Lwy1FYkVyAAHc2Y+CloD
 QUqxx8+pjJdctbF3pQ+CoqO2LSEEj2OAsTt02lMfMbyq/L2h4o6KshlrJhMnTMxz7HRI
 kj1j8PJ6vmHhfhTs5wV82Z3hYb9FrcuJ2q8JzsdRPEiJYoahPTsWOV6v37b2pmdg3f9Q
 Qtpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RmmeEOXgL4aczt2lYfVEJ81JJyR5GHuXnUEqtqtBYAw=;
 b=NdMxHU69EeiykVfKTUbh+BPOxvn1KQk6GWHLBNyxXTveRaFrVA9teJx99OHK5bZQ9m
 VUGXqHYUVRDcNYfhxMvy1LMxagNcX54cMQdnAs1hqWI70kCq7E7Kn67gIKnjkFOvm4qa
 Nnzmw6+lpoatmO/48UmCvnO1ZcUUY0JqdLcN9tId2HJCR+stMDsfM7f7Tp79/eN4G/wW
 RSD+uTs3Wbr95r6vFZpVlZy+r+pUigOePwquauybqAYuu7A4wQxMNAot/P0Yvm1a+Hmq
 +IFgcqf7yZ2IS15I8NJHCUV8RoaKuSjw+NbsLZo6gAxiVCjEjWTtfSOU5N1qwOjdWEPs
 l0Tg==
X-Gm-Message-State: AOAM531DF3f8JE5jHdHTojSH5Hdsj5G0ldddBifuM9pNIZLriC6LaGtn
 GuGdVAOW+3xYYrdynKo1df+3NeNUrTQUTsMF4qbknw==
X-Google-Smtp-Source: ABdhPJyFhnhDMW2ISK4zn+lMszvCQjj7MkaLiyC7O4OUsyaW0HdldRqbQFmZ06I5CZ/gdojGHnnTpqjIXgdkiahuGYk=
X-Received: by 2002:a05:6830:441f:: with SMTP id
 q31mr4578699otv.14.1641928618059; 
 Tue, 11 Jan 2022 11:16:58 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
In-Reply-To: <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 11 Jan 2022 11:16:46 -0800
Message-ID: <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Raghavendra Rao Ananta <rananta@google.com>
X-Mailman-Approved-At: Wed, 12 Jan 2022 06:18:12 -0500
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

On Tue, Jan 11, 2022 at 10:52 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Mon, Jan 10, 2022 at 3:57 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > > > <rananta@google.com> wrote:
> > > > >
> > > > > Hi Reiji,
> > > > >
> > > > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > > >
> > > > > > Hi Raghu,
> > > > > >
> > > > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > > > <rananta@google.com> wrote:
> > > > > > >
> > > > > > > Capture the start of the KVM VM, which is basically the
> > > > > > > start of any vCPU run. This state of the VM is helpful
> > > > > > > in the upcoming patches to prevent user-space from
> > > > > > > configuring certain VM features after the VM has started
> > > > > > > running.
> > > >
> > > > What about live migration, where the VM has already technically been
> > > > started before the first call to KVM_RUN?
> > >
> > > My understanding is that a new 'struct kvm' is created on the target
> > > machine and this flag should be reset, which would allow the VMM to
> > > restore the firmware registers. However, we would be running KVM_RUN
> > > for the first time on the target machine, thus setting the flag.
> > > So, you are right; It's more of a resume operation from the guest's
> > > point of view. I guess the name of the variable is what's confusing
> > > here.
> >
> > I was actually thinking that live migration gives userspace an easy
> > way to circumvent your restriction. You said, "This state of the VM is
> > helpful in the upcoming patches to prevent user-space from configuring
> > certain VM features after the VM has started running." However, if you
> > don't ensure that these VM features are configured the same way on the
> > target machine as they were on the source machine, you have not
> > actually accomplished your stated goal.
> >
> Isn't that up to the VMM to save/restore and validate the registers
> across migrations?

Yes, just as it is up to userspace not to make bad configuration
changes after the first VMRUN.

> Perhaps I have to re-word my intentions for the patch- userspace
> should be able to configure the registers before issuing the first
> KVM_RUN.

Perhaps it would help if you explained *why* you are doing this. It
sounds like you are either trying to protect against a malicious
userspace, or you are trying to keep userspace from doing something
stupid. In general, kvm only enforces constraints that are necessary
to protect the host. If that's what you're doing, I don't understand
why live migration doesn't provide an end-run around your protections.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
