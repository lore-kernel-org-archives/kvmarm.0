Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58912C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 22:15:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8ED41071;
	Tue, 26 Apr 2022 18:15:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OzH9W5zDPBiD; Tue, 26 Apr 2022 18:15:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EFF2408BA;
	Tue, 26 Apr 2022 18:15:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98434B1DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 17:32:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u0JeIR60WJBf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 17:32:42 -0400 (EDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8EB74B192
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 17:32:42 -0400 (EDT)
Received: by mail-yb1-f176.google.com with SMTP id j2so111592ybu.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 14:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=0ZElxhuSAR2kXik+WV1CBJfP81aAcXn9nSZuYMrCj5o=;
 b=Ys3zkWxkCB6PuqZ83NVnRDcny4MAsiGdW/b+Qjy2gbCMH9u+f2MX69Cfp1fYEU9XYO
 9G7GFpkd6BSiZnypz773adzA5fsdPDawhwYsFGopnLuQ+C35+S7k/iebM5lG1dOzvVu0
 jgtdAaVJ74KBmCkYe9wButz4+CPrqnYV6uZGKpLOTq85+eghdwWICE6fGWtqosWfE6s5
 SZuA64/A/PC/gITmxIcFwZ7tIIL6ejcy0RF1p4R8k2ttehJtiJJs+7xHE65pY4kCX3Dz
 +1yvXgZGOVBA4BWRCVY/NrmMbnPmDI80KHajjstP3p7gvXnUi06uBgHsqOhTuguyTOH1
 rfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=0ZElxhuSAR2kXik+WV1CBJfP81aAcXn9nSZuYMrCj5o=;
 b=iPuy+8JJc2bAgW2sNG9tahDE+257ApT+LUxTqwehKe+xXQReeJIffvUhTopQ7R8095
 UXvfmK/oYnM1eJq0+kMht6RL0bdgVekKuQD13c01Un+6VnstVWEubZwukHLvM4q7UUdm
 xVKdhqhYjtU6frhXLZNRrYBv/z/7q8fVAxyTleG6zZrk50q0VXimRDLZpYxHNjspJFKm
 6FB/36TJ40LsrY9uClmGrB28YKakI0VA9WE1DTiUu0S5q4TTS+ct3T+PBm/+WNiJIreF
 o+vGzfbj5HqLntr4xHR5PSD3Jz6k6ESGihi4WUqxnhV/fGalDySkx4gOA9K631camNwF
 9mKg==
X-Gm-Message-State: AOAM530ajFyMYdKFA2Cxb01ECPqOwg+XZaJW+fsG+PIu3TI7S+4Uevrc
 YcOQ4l/g71Ph1XvQKAkq1WXNsWeCfuJ6ylTbvCyAIg==
X-Google-Smtp-Source: ABdhPJzFMeiSjx3amPJwdpBsr0sO+o/E22b8+fl9lFfN8jPlz1sXc1Yu45mvpYv1CGSYHPRXdZW91qjUr4hT0vY4fUc=
X-Received: by 2002:a25:d209:0:b0:648:370f:573c with SMTP id
 j9-20020a25d209000000b00648370f573cmr16501351ybg.255.1651008761872; Tue, 26
 Apr 2022 14:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
 <CANgfPd8RLDtmFks0BLEVyHPaEANF93d4iJxHt3n6cKewQsBLuA@mail.gmail.com>
 <YmGn8hVSGWvna02R@google.com>
In-Reply-To: <YmGn8hVSGWvna02R@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Tue, 26 Apr 2022 14:32:31 -0700
Message-ID: <CANgfPd9=Q_JTsLBxjgxBwkdAdpAKDe6ZC0fAY0oGY4nkm11chA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Tue, 26 Apr 2022 18:15:18 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
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

On Thu, Apr 21, 2022 at 11:52 AM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Apr 21, 2022 at 09:57:32AM -0700, Ben Gardon wrote:
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > The ARM architecture requires that software use the 'break-before-make'
> > > sequence whenever memory is being remapped. An additional requirement of
> > > parallel page walks is a mechanism to ensure exclusive access to a pte,
> > > thereby avoiding two threads changing the pte and invariably stomping on
> > > one another.
> > >
> > > Roll the two concepts together into a new helper to implement the
> > > 'break' sequence. Use a special invalid pte value to indicate that the
> > > pte is under the exclusive control of a thread. If software walkers are
> > > traversing the tables in parallel, use an atomic compare-exchange to
> > > break the pte. Retry execution on a failed attempt to break the pte, in
> > > the hopes that either the instruction will succeed or the pte lock will
> > > be successfully acquired.
> > >
> > > Avoid unnecessary DSBs and TLBIs by only completing the sequence if the
> > > evicted pte was valid. For counted non-table ptes drop the reference
> > > immediately. Otherwise, references on tables are dropped in post-order
> > > traversal as the walker must recurse on the pruned subtree.
> > >
> > > All of the new atomics do nothing (for now), as there are a few other
> > > bits of the map walker that need to be addressed before actually walking
> > > in parallel.
> >
> > I want to make sure I understand the make before break / PTE locking
> > patterns here.
> > Please check my understanding of the following cases:
> >
> > Case 1: Change a leaf PTE (for some reason)
> > 1. Traverse the page table to the leaf
> > 2. Invalidate the leaf PTE, replacing it with a locked PTE
> > 3. Flush TLBs
> > 4. Replace the locked PTE with the new value
> >
> > In this case, no need to lock the parent SPTEs, right? This is pretty simple.
>
> Right, if we're changing the OA of a leaf PTE. If we are just adjusting
> attributes on a leaf we go through stage2_attr_walker(), which skips
> step 2 and does the rest in this order: 1, 4, 3.
>
> > Case 2:  Drop a page table
> > 1. Traverse to some non-leaf PTE
> > 2. Lock the PTE, invalidating it
> > 3. Recurse into the child page table
> > 4. Lock the PTEs in the child page table. (We need to lock ALL the
> > PTEs here right? I don't think we'd get away with locking only the
> > valid ones)
>
> Right. We can just skip some of the TLBI/DSB dance when making an
> invalid->invalid transition.
>
> > 5. Flush TLBs
> > 6. Unlock the PTE from 2
> > 7. Free the child page after an RCU grace period (via callback)
> >
> > Case 3: Drop a range of leaf PTEs
> > 1. Traverse the page table to the first leaf
> > 2. For each leaf in the range:
> >         a. Invalidate the leaf PTE, replacing it with a locked PTE
> > 3. Flush TLBs
> > 4. unlock the locked PTEs
> >
> > In this case we have to lock ALL PTEs in the range too, right? My
> > worry about the whole locking scheme is making sure each thread
> > correctly remembers which PTEs it locked versus which might have been
> > locked by other threads.
>
> Isn't exclusivity accomplished by checking what you get back from the
> xchg()? If I get a locked PTE back, some other thread owns the PTE. If I
> get anything else, then I've taken ownership of that PTE.

That's true if you only modify one PTE at a time, but if you want to
batch flushes by:
1. Locking a bunch of PTEs
2. TLB invalidate
3. Set them to some new value (e.g. 0)
Then you need to track which ones you locked. If you locked an entire
contiguous region, that works, but you need some way to ensure you
don't think you locked a pte locked by another thread.

>
> > On x86 we solved this by only locking one SPTE at a time, flushing,
> > then fixing it, but if you're locking a bunch at once it might get
> > complicated.
> > Making this locking scheme work without demolishing performance seems hard.
>
> We only change at most a single active PTE per fault on the stage 2 MMU.
> We do one of three things on that path:
>
>  1. Install a page/block PTE to an empty PTE
>  2. Replace a table PTE with a block PTE
>  3. Replace a block PTE with a table PTE
>
> 1 is pretty cheap and can skip flushes altogether.
>
> 2 only requires a single TLBI (a big, painful flush of the stage 2 context),
> but child PTEs needn't be flushed.
>
> 3 also requires a single TLBI, but can be done with an IPA and level
> hint.
>
> Perhaps the answer is to push teardown into the rcu callback altogether,
> IOW don't mess with links in the subtree until then. At that point
> there's no need for TLBIs nor atomics.
>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
