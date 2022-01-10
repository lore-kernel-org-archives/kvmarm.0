Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F954C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 09:00:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C39864B244;
	Tue, 11 Jan 2022 04:00:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pvnuVtDkLWNJ; Tue, 11 Jan 2022 04:00:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6991F4B262;
	Tue, 11 Jan 2022 04:00:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 694A84A524
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:57:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JDR-qVqw5RZN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 18:57:12 -0500 (EST)
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com
 [209.85.161.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D2FE4A369
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:57:12 -0500 (EST)
Received: by mail-oo1-f51.google.com with SMTP id
 t13-20020a4a760d000000b002dab4d502dfso4006394ooc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 15:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vSSSnrqTuvGyEJlGAFCeYpACHeVTMvACrp2X7lsYlbo=;
 b=nNGZGb/fCIB2jDSCk/PIrO7Qauom/vxWfeoXRAUwsXGjTX6HlFoNaAe7E4j2jjz/iq
 kTI7LDXzhhHRvjsTwUMV7ZQcXimqzFeJBGIDiNOw5Z8q/D+Mrdt5yhXH8t+6PKR9odPO
 qiv7zA0RPNhX/VN6yJKVAlrhG1q5ZHCN0QqadS1Gnw0GjqkTxckyha+XTV9jAX9Kwo4L
 AxKer6I6rT/aDJUmuyuAVVYtsQzhyYq9TAXFgL/+xMO84xDncNKTQZBRO0F/vQxfGhXx
 Ww0JHxmJoBAXAIgYj1Uh75HxAWJpc6rq6zNyIW/DF7gGZ3b15XuUuSgM73T4U2bb0aak
 YGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vSSSnrqTuvGyEJlGAFCeYpACHeVTMvACrp2X7lsYlbo=;
 b=FfoZSGvTX+0yv6yeoMXUYoxVYo51t8wMalEwpBMPqPVrnafDqxM2uhLn1earCiDc76
 Jxdx3GpsBuI+vH9MGnJON84gXH6ES5eteArQXASRNCEEQ6MxSvOmlQa4g9JYi7JFQo6B
 74D0wAbE2WlCYvpBFgXGXst7AQ8kG0Lce/ne0Mx3Q/EUzRMz528jH9/9JGGQMbmFCQr+
 tbRBJUpZnvkzVWF3FPuFHKXxoonNKa9yBv9AhhZjxWXLtrYj4cu6O/6TFdNIOCXzucPP
 JDFGJrvA897AOPoZ81bSe7A9rc4+VuHFBzTyTDCFa5nnwkAoCrQ/ZUm6HmgaSHnwMzx6
 TFQQ==
X-Gm-Message-State: AOAM532eKKOavRk3ACc2/htlDQfVRHUGaV+uws9Zc+oN2SoELUP++vHk
 78KigSvv88nhPVCDB2W/9JVN6HKJ817Z3XT4ZuBCZQ==
X-Google-Smtp-Source: ABdhPJybT9OWDGZiQuBy7ZZfZDdvwUtX2enEK8TtOnoWTNRfA6QdvKJLhoeaodRUZv+xWokigwspjYrcy/3TIUFdvD4=
X-Received: by 2002:a4a:ac0a:: with SMTP id p10mr1471897oon.96.1641859031601; 
 Mon, 10 Jan 2022 15:57:11 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
In-Reply-To: <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 10 Jan 2022 15:57:00 -0800
Message-ID: <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To: Raghavendra Rao Ananta <rananta@google.com>
X-Mailman-Approved-At: Tue, 11 Jan 2022 04:00:43 -0500
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

On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > Hi Reiji,
> > >
> > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > Hi Raghu,
> > > >
> > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > <rananta@google.com> wrote:
> > > > >
> > > > > Capture the start of the KVM VM, which is basically the
> > > > > start of any vCPU run. This state of the VM is helpful
> > > > > in the upcoming patches to prevent user-space from
> > > > > configuring certain VM features after the VM has started
> > > > > running.
> >
> > What about live migration, where the VM has already technically been
> > started before the first call to KVM_RUN?
>
> My understanding is that a new 'struct kvm' is created on the target
> machine and this flag should be reset, which would allow the VMM to
> restore the firmware registers. However, we would be running KVM_RUN
> for the first time on the target machine, thus setting the flag.
> So, you are right; It's more of a resume operation from the guest's
> point of view. I guess the name of the variable is what's confusing
> here.

I was actually thinking that live migration gives userspace an easy
way to circumvent your restriction. You said, "This state of the VM is
helpful in the upcoming patches to prevent user-space from configuring
certain VM features after the VM has started running." However, if you
don't ensure that these VM features are configured the same way on the
target machine as they were on the source machine, you have not
actually accomplished your stated goal.

> Thanks,
> Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
