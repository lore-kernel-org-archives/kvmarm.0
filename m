Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C232C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:50:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7644B285;
	Fri, 22 Apr 2022 13:50:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ars0bdkBRhZb; Fri, 22 Apr 2022 13:50:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D137F4B2A4;
	Fri, 22 Apr 2022 13:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD884B26A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zX6QlP53G5U6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:43:41 -0400 (EDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com
 [209.85.208.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13E6C4B268
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:43:41 -0400 (EDT)
Received: by mail-lj1-f175.google.com with SMTP id bn33so6468517ljb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=86+E8N74tWcxl4OkHzKdfe2B+ol1qinsJ3i5kq4weyE=;
 b=a1dstvI3nz0xC9V2iEbO4mMe5jZ2oRMNhgkxJcw7TvRja8cD2HOxZiYNWufSrt9SGA
 QMh1V1vX1vRzQM5hZeAL1YURCc4bs8xoKqg3iyPeLYstklgJn3sGsxN0PS8qNyBuq5Cb
 fCV3rKD/e102wY82J1HLSHc3kz9Kn0RPPwPpo0xm+4077aTtzBTvmcNAOWXaLAqppWAt
 g8+UA8J0ej52+TXcdv6W0UUI7ypJOBzI66Dh5xFKYXYogABeN82excKo3y1XoMJCsxWK
 2Lho041K3nj1gXeUggyWCnxx1ugQDE7Z4iTBHt+fWGKdfCpRmZ7vSqZADl5Fj+vGYvl8
 oGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=86+E8N74tWcxl4OkHzKdfe2B+ol1qinsJ3i5kq4weyE=;
 b=HnVg6FzJK/ueSEZtzNhF6EwEEEsBshIRhk0YAyIixy0I3AMglboCPKLhHljDs9ivp5
 8qAEhwFDaztbUEKuqzUeEamCIXvbH3XWL+azZImHeIQcJ7zkNUQ2tF9/v3nCSy2vUavO
 M0ceuxM3gbJIcm5ow0xNbMxy2rqkb4jUxzgvhlqsGpXfGZWF3m0Hzn3ZTeC2JKOOzEKf
 JWmBt7v+ZQKZzGTmvBG7VTYynd1NfBSeUFWnDFd7MrPxE+M2oi4s/ygsEMrgprdBtjIg
 JgJJm8WzbZyGPxnfwsza/O3cHgH4FJWYm5jQQtIMdxHN0s3b83R04wldMxvUBCItHiXh
 OzKQ==
X-Gm-Message-State: AOAM532WkahP+31T3aqoUg9+eWqGuIQ14ChdYwew+1owvbxpbbh26tpS
 5XNBgtoU6tB1tFTtrexPCuXGkkR4m3M2pFcQfa+2WQ==
X-Google-Smtp-Source: ABdhPJxme7++mtYHiLB8A8sMAhxUEQ/TToGRr6G0ay3IKZ1/RbT2BsFMkUyKGRXbo7cKuJBLBODJSoFzCpUT4nR3vZE=
X-Received: by 2002:a05:651c:b0d:b0:24d:a008:46f1 with SMTP id
 b13-20020a05651c0b0d00b0024da00846f1mr334936ljr.198.1650559419407; Thu, 21
 Apr 2022 09:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
 <YloIEfCjWyQKJMxI@google.com>
In-Reply-To: <YloIEfCjWyQKJMxI@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 21 Apr 2022 09:43:12 -0700
Message-ID: <CALzav=fk1obOQcYvguvcLww+q4yu5JLEvJkfKZt50dD9iScGKA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Fri, 22 Apr 2022 13:50:47 -0400
Cc: kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, KVMARM <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Apr 15, 2022 at 5:04 PM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 04:35:24PM -0700, David Matlack wrote:
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Presently KVM only takes a read lock for stage 2 faults if it believes
> > > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > > predictably can pile up all the vCPUs in a sufficiently large VM.
> > >
> > > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > > MMU protected by the combination of a read-write lock and RCU, allowing
> > > page walkers to traverse in parallel.
> > >
> > > This series is strongly inspired by the mechanics of the TDP MMU,
> > > making use of RCU to protect parallel walks. Note that the TLB
> > > invalidation mechanics are a bit different between x86 and ARM, so we
> > > need to use the 'break-before-make' sequence to split/collapse a
> > > block/table mapping, respectively.
> >
> > An alternative (or perhaps "v2" [1]) is to make x86's TDP MMU
> > arch-neutral and port it to support ARM's stage-2 MMU. This is based
> > on a few observations:
> >
> > - The problems that motivated the development of the TDP MMU are not
> > x86-specific (e.g. parallelizing faults during the post-copy phase of
> > Live Migration).
> > - The synchronization in the TDP MMU (read/write lock, RCU for PT
> > freeing, atomic compare-exchanges for modifying PTEs) is complex, but
> > would be equivalent across architectures.
> > - Eventually RISC-V is going to want similar performance (my
> > understanding is RISC-V MMU is already a copy-paste of the ARM MMU),
> > and it'd be a shame to re-implement TDP MMU synchronization a third
> > time.
> > - The TDP MMU includes support for various performance features that
> > would benefit other architectures, such as eager page splitting,
> > deferred zapping, lockless write-protection resolution, and (coming
> > soon) in-place huge page promotion.
> > - And then there's the obvious wins from less code duplication in KVM
> > (e.g. get rid of the RISC-V MMU copy, increased code test coverage,
> > ...).
>
> I definitely agree with the observation -- we're all trying to solve the
> same set of issues. And I completely agree that a good long term goal
> would be to create some common parts for all architectures. Less work
> for us ARM folks it would seem ;-)
>
> What's top of mind is how we paper over the architectural differences
> between all of the architectures, especially when we need to do entirely
> different things because of the arch.
>
> For example, I whine about break-before-make a lot throughout this
> series which is somewhat unique to ARM. I don't think we can do eager
> page splitting on the base architecture w/o doing the TLBI for every
> block. Not only that, we can't do a direct valid->valid change without
> first making an invalid PTE visible to hardware. Things get even more
> exciting when hardware revisions relax break-before-make requirements.

Gotcha, so porting the TDP MMU to ARM would require adding
break-before-make support. That seems feasible and we could guard it
behind a e.g. static_key so there is no runtime overhead for
architectures (or ARM hardware revisions) that do not require it.
Anything else come to mind as major architectural differences?

 >
> There's also significant architectural differences between KVM on x86
> and KVM for ARM. Our paging code runs both in the host kernel and the
> hyp/lowvisor, and does:
>
>  - VM two dimensional paging (stage 2 MMU)
>  - Hyp's own MMU (stage 1 MMU)
>  - Host kernel isolation (stage 2 MMU)
>
> each with its own quirks. The 'not exactly in the kernel' part will make
> instrumentation a bit of a hassle too.

Ah, interesting. It'd probably make sense to start with the VM
2-dimensional paging use-case and leave the other use-cases using the
existing MMU, and then investigate transitioning the other use-cases.
Similarly in x86 we still have the legacy MMU for shadow paging (e.g.
hosts with no stage-2 hardware, and nested virtualization).

>
> None of this is meant to disagree with you in the slightest. I firmly
> agree we need to share as many parts between the architectures as
> possible. I'm just trying to call out a few of the things relating to
> ARM that will make this annoying so that way whoever embarks on the
> adventure will see it.
>
> > The side of this I haven't really looked into yet is ARM's stage-2
> > MMU, and how amenable it would be to being managed by the TDP MMU. But
> > I assume it's a conventional page table structure mapping GPAs to
> > HPAs, which is the most important overlap.
> >
> > That all being said, an arch-neutral TDP MMU would be a larger, more
> > complex code change than something like this series (hence my "v2"
> > caveat above). But I wanted to get this idea out there since the
> > rubber is starting to hit the road on improving ARM MMU scalability.
>
> All for it. I cc'ed you on the series for this exact reason, I wanted to
> grab your attention to spark the conversation :)
>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
