Return-Path: <SRS0=5C08=FU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329B6C4361B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 09:42:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 78A7A23105
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 09:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78A7A23105
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B08474B2E2;
	Wed, 16 Dec 2020 04:41:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z07iB1taUrkk; Wed, 16 Dec 2020 04:41:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB42E4B44C;
	Wed, 16 Dec 2020 04:41:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7D04B570
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2020 20:45:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2NNUBgSO07iu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2020 20:45:43 -0500 (EST)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
 [209.85.160.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E72364B533
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2020 20:45:43 -0500 (EST)
Received: by mail-qt1-f195.google.com with SMTP id 2so6350421qtt.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2020 17:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kCToIgJ9t4fgOgR1IG7z/T+GyYq+8OtwKPwUFbQA53E=;
 b=Gi1o+o2odN0GzIaw5X46sC3GPFaeMhjoBJnGwwFiCma44bSFjsl0bgwIxoEg9ec0Kp
 OztQkTIT0mU8btHuUYdrAT4EBge+EdFc4M94KJ50AivdTCaUvXua82zvmcJn/JcJ0DqM
 GdIW0Wjfmmh0z3upTz/s8oanoeVm2H+6egJWp0TS+xccJ3MoOzpnLVgObdOzRQ0p/26J
 beoVo2wEs4tlY6mVtHNJ8VGZDCOEpSbST+AcuoWOvWGmTF1lgyN3Sd/zwvNFkrQvSnJP
 N0T98P8htYMq+8wRWezxBwXtp74BY8sEV/M6s3OVeHNqUSOsRFaePCy8ZVgFL4MP7Elw
 3/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kCToIgJ9t4fgOgR1IG7z/T+GyYq+8OtwKPwUFbQA53E=;
 b=W94uZF8nuo8q8yDj2IgfxKtN+alqyIiUJG02zRfJPaPUHv1pIdPvo6vqlxalNaPvYn
 8pfEqeiQ+1wqH6dfqUuAU0mXaOTC/B7K/0aF2H2gE4RPNe+9iY57iAQwNu5FZETjuqNu
 bZYwx6v0a0Dc1tluFmhFXKtPtNagT1bprfnkyVj6GOIPvYGB7xFc+AX6fpHL8m2bbWm9
 mZ/crGXETIHzC6plA9YL51PA72nHhNFHiARToBaIaavymekFd1ebP7lAAkzLO3tRzOk7
 eh3PTK8qyofuVrRdwnGUsjv6aW68d2+mBSO8AVYUc17mQUkLoPRC5hgqvWORBbs8rm0v
 s7qw==
X-Gm-Message-State: AOAM5338xUPgoRnGWg2xU55Cm8+jwPLaqKYfWzOLMVWGs1SD/fatMRHX
 wffxZtOHB8EJYUDDgSdw6wBsj+jI2gWgPRtb0hYoyw==
X-Google-Smtp-Source: ABdhPJwU/7CORIsAIiTVntmow90QUVubXxG+PPZiFr2mV+dF13CoGd56D1d8SNThX0rRsMFvF8yaaWWUEt3jESh+Tz0=
X-Received: by 2002:ac8:6758:: with SMTP id n24mr41536181qtp.258.1608083143215; 
 Tue, 15 Dec 2020 17:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
 <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
 <20200911085841.GB562@jagdpanzerIV.localdomain>
 <CAJWu+oq26OK1-7Ze2pb5xpRJ-tS9wtXOdGFrYpHq+fhkyGhjkA@mail.gmail.com>
 <fdc35e25f2bc2cdfa0849a84802eafd6@kernel.org>
 <CAJWu+ooy=r=G+AnyriQDA9_4CJqfO6hkf=c8heV8HV+yNea_PQ@mail.gmail.com>
 <78091359dab0d8decfc452f7c5c25971@kernel.org> <X9M9JuK5DIWzgdyQ@google.com>
In-Reply-To: <X9M9JuK5DIWzgdyQ@google.com>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 15 Dec 2020 20:45:32 -0500
Message-ID: <CAJWu+oqwYQDvcRa3_TPtDDXGnUOBPEqM4vCLCc7konKSe0jPEg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Wed, 16 Dec 2020 04:41:56 -0500
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
 Marc Zyngier <maz@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

Hi Marc, Quentin,

On Fri, Dec 11, 2020 at 4:34 AM Quentin Perret <qperret@google.com> wrote:
>
> On Thursday 10 Dec 2020 at 08:45:22 (+0000), Marc Zyngier wrote:
> > On 2020-12-10 01:39, Joel Fernandes wrote:
> >
> > [...]
> >
> > > > Quentin and I have discussed potential ways of improving guest
> > > > scheduling
> > > > on terminally broken systems (otherwise known as big-little), in the
> > > > form of a capacity request from the guest to the host. I'm not really
> > > > keen on the host exposing its own capacity, as that doesn't tell the
> > > > host what the guest actually needs.
> > >
> > > I am not sure how a capacity request could work well. It seems the
> > > cost of a repeated hypercall could be prohibitive. In this case, a
> > > lighter approach might be for KVM to restrict vCPU threads to run on
> > > certain types of cores, and pass the capacity information to the guest
> > > at guest's boot time.
> >
> > That seems like a very narrow use case. If you actually pin vcpus to
> > physical CPU classes, DT is the right place to put things, because
> > it is completely static. This is effectively creating a virtual
> > big-little, which is in my opinion a userspace job.
>
> +1, all you should need for this is to have the VMM pin the vCPUS and
> set capacity-dmips-mhz in the guest DT accordingly. And if you're
> worried about sharing the runqueue with host tasks, could you vacate the
> host CPUs using cpusets or such?

I agree, the VMM is the right place for it with appropriate DT
settings. I think this is similar to how CPUID is emulated on Intel as
well (for example to specify SMT topology for a vCPU) -- it is done by
the VMM.

On sharing vCPU with host tasks, that is indeed an issue because the
host does not know the priority of an app (For example, a "top app"
running in Android in a VM). The sharing with host tasks should be Ok
as long as the scheduler priorities of the vCPU threads on the host
are setup correctly?

> The last difficult bit is how to drive DVFS. I suppose Marc's suggestion
> to relay capacity requests from the guest would help with that.

Yeah I misunderstood Marc.  I think for DVFS, a hypercall for capacity
request should work and be infrequent enough. IIRC, there is some rate
limiting support in cpufreq governors as well that should reduce the
rate of hypercalls if needed.

> > > This would be a one-time cost to pay. And then,
> > > then the guest scheduler can handle the scheduling appropriately
> > > without any more hypercalls. Thoughts?
> >
> > Anything that is a one-off belongs to firmware configuration, IMO.
> >
> > The case I'm concerned with is when vcpus are allowed to roam across
> > the system, and hit random physical CPUs because the host has no idea
> > of the workload the guest deals with (specially as the AMU counters
> > are either absent or unusable on any available core).

It sounds like this might be a usecase for pinning the vCPU threads
appropriately (So designate a set of vCPU threads to only run on bigs
and another set to only run on LITTLEs).  The host can setup the DT to
describe this and the VM kernel's scheduler can do appropriate task
placement.  Did I miss anything?

> > The cost of a hypercall really depends on where you terminate it.
> > If it is a shallow exit, that's only a few hundred cycles on any half
> > baked CPU. Go all the way to userspace, and the host scheduler is the
> > limit. But the frequency of that hypercall obviously matters too.
> >
> > How often do you expect the capacity request to fire? Probably not
> > on each and every time slice, right?
> >
> > Quentin, can you shed some light on this?
>
> Assuming that we change the 'capacity request' (aka uclamp.min of the
> vCPU) every time the guest makes a frequency request, then the answer
> very much is 'it depends on the workload'. Yes there is an overhead, but
> I think it is hard to say how bad that would be before we give it a go.
> It's unfortunately not uncommon to have painfully slow frequency changes
> on real hardware, so this may be just fine. And there may be ways we
> can mitigate this too (with rate limiting and such), so all in all it is
> worth a try.

Agreed.

> Also as per the above, this still would help even if the VMM pins vCPUs
> and such, so these two things can live and complement each other I
> think.

Makes sense.

> Now, for the patch originally under discussion here, no objection from
> me in principle, it looks like a nice improvement to the stolen time
> stuff and I can see how that could help some use-cases, so +1 from me.

Sounds good!

thanks,

 - Joel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
