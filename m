Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458CCC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 16 Apr 2022 00:04:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E3BF49EE8;
	Fri, 15 Apr 2022 20:04:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Tt5lzxfy+6J; Fri, 15 Apr 2022 20:04:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33534411BD;
	Fri, 15 Apr 2022 20:04:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD6CF40D0B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 20:04:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iR0xbtiKdBek for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 20:04:38 -0400 (EDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73E5C40C58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 20:04:38 -0400 (EDT)
Received: by mail-io1-f45.google.com with SMTP id 125so9581624iov.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=v7EUmoZBDcoOSgCEPMYrLBJ9e85Zg5h9TjW7zpC21Dg=;
 b=ftWZfy7v/f/DG93DcGz77dRWOYr4bNA/SvNTc0zAPec+2UHfmMs3ZUugcqTPEdoCfJ
 KNcML7ZGC5BUit7RjIUr40BB3oHrFVHRx5fhXnvDGvIQjR/8qF2Y8gstiPEz0EGS+yI4
 xj1M0UlSE/f7RxwByZ1qXQCI2LHFsfFXGOtuyl9Za00sqr2OeHp1v12z7fdwsjz9+n82
 9XY4rty7YJD2qfnqkycJWRfhazyKVdzXsZ7nyn1gT+kLrkpoOBD1ymW24oiq74aDEyIH
 15osNd6623ac/vHHXdv2rRScwiO8kEkwzLn+v7+Wl0m+FpvHs76OpYBZIpGOrFYJcAp6
 xKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=v7EUmoZBDcoOSgCEPMYrLBJ9e85Zg5h9TjW7zpC21Dg=;
 b=Ly49S2eFjcUU2Eit9HsBDugla7/bkgHtDBtYPd/kql5CiqqrCkWxGfq2xYy45zuzIs
 IqnOy/Etk5i8yRTDQz2Xhh1nmWLm3KdbOEGJ90gyv3/s3ATUheGQpv4GK5NE03L7RMNf
 D64uVNMnIttjnqjxZz+3Ik8cQFehDWZwvvOrU7FN96FKJWo8S2zILOWVrRcBN6SfNWgt
 VQTokhbxFq5gpDwIdgQ+5CQY3zVi4rbAGGoPcqcZg45NqqoJkkxx9M/RP5eleDign8t0
 ptwntjHMLvjVKtq4liTxLlP3l0doVcscNpow4NaS3EPEyhXJUYijXd9OoRVLQV+338Mt
 8I+g==
X-Gm-Message-State: AOAM533Xbdtlxr6tdBqUgWId2OxXKox4f5ZWV1RpS5xNq88GLbPoLxzi
 EjfEp/Z4w/RhZeUfFc0E9z9WOQ==
X-Google-Smtp-Source: ABdhPJx5WNudH60IdHmm8u5EeSYrYi3W2BxrIqiNRXfOdkSArYISyE9fEPmanjk3RcvvF4+wvKKxgg==
X-Received: by 2002:a5d:8b8f:0:b0:649:ec6d:98e9 with SMTP id
 p15-20020a5d8b8f000000b00649ec6d98e9mr469641iol.30.1650067477528; 
 Fri, 15 Apr 2022 17:04:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 i3-20020a056602134300b0064620a85b6dsm4156467iov.12.2022.04.15.17.04.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Apr 2022 17:04:36 -0700 (PDT)
Date: Sat, 16 Apr 2022 00:04:33 +0000
From: Oliver Upton <oupton@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
Message-ID: <YloIEfCjWyQKJMxI@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
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

On Fri, Apr 15, 2022 at 04:35:24PM -0700, David Matlack wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Presently KVM only takes a read lock for stage 2 faults if it believes
> > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > predictably can pile up all the vCPUs in a sufficiently large VM.
> >
> > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > MMU protected by the combination of a read-write lock and RCU, allowing
> > page walkers to traverse in parallel.
> >
> > This series is strongly inspired by the mechanics of the TDP MMU,
> > making use of RCU to protect parallel walks. Note that the TLB
> > invalidation mechanics are a bit different between x86 and ARM, so we
> > need to use the 'break-before-make' sequence to split/collapse a
> > block/table mapping, respectively.
> 
> An alternative (or perhaps "v2" [1]) is to make x86's TDP MMU
> arch-neutral and port it to support ARM's stage-2 MMU. This is based
> on a few observations:
> 
> - The problems that motivated the development of the TDP MMU are not
> x86-specific (e.g. parallelizing faults during the post-copy phase of
> Live Migration).
> - The synchronization in the TDP MMU (read/write lock, RCU for PT
> freeing, atomic compare-exchanges for modifying PTEs) is complex, but
> would be equivalent across architectures.
> - Eventually RISC-V is going to want similar performance (my
> understanding is RISC-V MMU is already a copy-paste of the ARM MMU),
> and it'd be a shame to re-implement TDP MMU synchronization a third
> time.
> - The TDP MMU includes support for various performance features that
> would benefit other architectures, such as eager page splitting,
> deferred zapping, lockless write-protection resolution, and (coming
> soon) in-place huge page promotion.
> - And then there's the obvious wins from less code duplication in KVM
> (e.g. get rid of the RISC-V MMU copy, increased code test coverage,
> ...).

I definitely agree with the observation -- we're all trying to solve the
same set of issues. And I completely agree that a good long term goal
would be to create some common parts for all architectures. Less work
for us ARM folks it would seem ;-)

What's top of mind is how we paper over the architectural differences
between all of the architectures, especially when we need to do entirely
different things because of the arch.

For example, I whine about break-before-make a lot throughout this
series which is somewhat unique to ARM. I don't think we can do eager
page splitting on the base architecture w/o doing the TLBI for every
block. Not only that, we can't do a direct valid->valid change without
first making an invalid PTE visible to hardware. Things get even more
exciting when hardware revisions relax break-before-make requirements.

There's also significant architectural differences between KVM on x86
and KVM for ARM. Our paging code runs both in the host kernel and the
hyp/lowvisor, and does:

 - VM two dimensional paging (stage 2 MMU)
 - Hyp's own MMU (stage 1 MMU)
 - Host kernel isolation (stage 2 MMU)

each with its own quirks. The 'not exactly in the kernel' part will make
instrumentation a bit of a hassle too.

None of this is meant to disagree with you in the slightest. I firmly
agree we need to share as many parts between the architectures as
possible. I'm just trying to call out a few of the things relating to
ARM that will make this annoying so that way whoever embarks on the
adventure will see it.

> The side of this I haven't really looked into yet is ARM's stage-2
> MMU, and how amenable it would be to being managed by the TDP MMU. But
> I assume it's a conventional page table structure mapping GPAs to
> HPAs, which is the most important overlap.
> 
> That all being said, an arch-neutral TDP MMU would be a larger, more
> complex code change than something like this series (hence my "v2"
> caveat above). But I wanted to get this idea out there since the
> rubber is starting to hit the road on improving ARM MMU scalability.

All for it. I cc'ed you on the series for this exact reason, I wanted to
grab your attention to spark the conversation :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
