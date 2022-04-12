Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E901BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 16:52:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 375ED4B234;
	Tue, 12 Apr 2022 12:52:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mNzgGQNzCtc0; Tue, 12 Apr 2022 12:52:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B641C4B249;
	Tue, 12 Apr 2022 12:52:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA2F4B234
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 12:50:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xo6lxplWZFI3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 12:50:05 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 950A24B231
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 12:50:05 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id x17so24119499lfa.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ylLxyVGKqebDetHyuC2Bc6fDpbbFFhb/7aJqORMHVTY=;
 b=BeeBZYfEZZenHq+VZz3ZtQTJRvLWQlIUvc/hc1brOcgm5kce8lGlmzNx5yqIvOhgUc
 UDCq+4RZxw0MT8gEV/iUosNBbjwK5H7Zu2KRvhnmmK4yGV/2DliGjVpqM19h4PjeX0qX
 q1jpS5mG4Oo4uFkrlUJBZsLj7lHX2j/uSqZepLYxTj4Bwl+wILljvKH1NuMb+PcTL/Dw
 K6DaFHGqo13SN/DmRnQjImAdgE8QQACgkaL5RaJpFFp3lNzLS5t/Bdf0+vjgfpGN15QS
 V0Km+PY4CEHdd2J4zjah3arKKvk9P4JDe90QEqKiwiH4KfrjfGJuSkiscGDAxWwdtaRe
 mjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ylLxyVGKqebDetHyuC2Bc6fDpbbFFhb/7aJqORMHVTY=;
 b=gmrhR2b6+EImDHkTxO5Oe7bn3RE72o0034etpzxfwZ6MBOf9eb8LBDHncx/ZtYSU2g
 ZgGoJyEqb17SvJv1yWH+aRGUDUeBYQr5/670yD9rveIEKDFV1cZvxDPZunQ0rXu2LEwG
 RmcSZrxGgLppZSnL6w836SiTsr24IxT8qVZFyi4RlrVEhkCE+8gre1YO/NYkRYljveJd
 Ae2hoMGoHRmRkBuOJrwoWAm2d6GseHVsWoFP+lnmZdEb0lqshaRBHPAF7WtWesnJtcFc
 1jg1msTXtinDW3Wat+5wNGSULYU8x7iuylfUSJkGE/xJJvQA2QfzOYTXjblfSCCrwyZK
 XAhg==
X-Gm-Message-State: AOAM53220XcFRhh/gXus8irY/sUCn0n0ODEYdhTq50XyS9eT3C4gXPFl
 Lgwq9yEpNbDdPz869wgznLDcO5RLHMlYm0ZagRiwRA==
X-Google-Smtp-Source: ABdhPJxTRKFjPYmnEA5dSZRqS1mYFeUSvf19B6M+jy1KqTK4lzVK4HG6VgeaW5aaLHlSI/Za1/SRULYrkD+BRWtDQo8=
X-Received: by 2002:a19:674c:0:b0:448:3f49:e6d5 with SMTP id
 e12-20020a19674c000000b004483f49e6d5mr26383484lfj.518.1649782204083; Tue, 12
 Apr 2022 09:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
In-Reply-To: <YlTKQz8HVPtyfwKe@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 12 Apr 2022 09:49:37 -0700
Message-ID: <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 12 Apr 2022 12:52:19 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Mon, Apr 11, 2022 at 5:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Apr 11, 2022, David Matlack wrote:
> >
> > One thing that would be helpful is if you can explain in a bit more
> > specifically what you'd like to see. Part of the reason why I prefer
> > to sequence your proposal after eager page splitting is that I do not
> > fully understand what you're proposing, and how complex it would be.
> > e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
> > for nested MMUs does not sound like less churn.
>
> Oh, it's most definitely not less code, and probably more churn.  But, it's churn
> that pushes us in a more favorable direction and that is desirable long term.  I
> don't mind churning code, but I want the churn to make future life easier, not
> harder.  Details below.

Of course. Let's make sure we're on the same page about what churn
introduced by this series will make future life harder that we hope to
avoid. If I understand you correctly, it's the following 2 changes:

 (a.) Using separate functions to allocate SPs and initialize SPs.
 (b.) Separating kvm_mmu_find_shadow_page() from __kvm_mmu_find_shadow_page().

(a.) stems from the fact that SP allocation during eager page
splitting is made directly rather than through kvm_mmu_memory_caches,
which was what you pushed for in the TDP MMU implementation. We could
instead use kvm_mmu_memory_caches for the shadow MMU eager page
splitting to eliminate (a.). But otherwise (a.) is necessary
complexity of eager page splitting because it needs to allocate SPs
differently from the vCPU fault path.

As for (b.), see below...

>
> > From my perspective, this series is a net improvement to the
> > readability and maintainability of existing code, while adding a
> > performance improvement (eager page splitting). All of the changes you
> > are proposing can still be implemented on top if
>
> They can be implemented on top, but I want to avoid inhireting complexity we
> don't actually want/need, unsync support being the most notable.
>
> What I mean by "fork" is that after the cleanups that make sense irrespective of
> eager page splitting, we make a copy of FNAME(page_fault) and add FNAME(get_shadow_page),
> extracting common logic where we can and probably doing something fancy to avoid
> having multiple copies of FNAME(get_shadow_page).  Looking again at the code, it's
> probably best to keep FNAME(fetch), at least for now, as it's only the single unsync
> check that we can purge at this point.
>
> That gives us e.g. FNAME(nested_page_fault) that support EPT and 64-bit NPT, and
> a nested TDP specific get_shadow_page().
>
> Then we rip out the unsync stuff for nested MMUs, which is quite clean because we
> can key off of tdp_enabled.  It'll leave dead code for 32-bit hosts running nested
> VMs, but I highly doubt anyone will notice the perf hit.
>
> At that point, dissect kvm_nested_mmu_get_page() for eager page splitting and
> continue on.
>
> It's not drastically different than what you have now, but it avoids the nastiness
> around unsync pages, e.g. I'm pretty sure kvm_mmu_alloc_shadow_page() can be reused
> as I proposed and the "find" becomes something like:
>
> static struct kvm_mmu_page *kvm_mmu_nested_tdp_find_sp(struct kvm_vcpu *vcpu,
>                                                        gfn_t gfn,
>                                                        unsigned int gfn_hash,
>                                                        union kvm_mmu_page_role role)
> {
>         struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];
>         struct kvm_mmu_page *sp;
>
>         for_each_valid_sp(kvm, sp, sp_list) {
>                 if (sp->gfn != gfn || sp->role.word != role.word)
>                         continue;
>
>                 __clear_sp_write_flooding_count(sp);
>                 return sp;
>         }
>
>         return NULL;
> }

IIUC all of this would be to avoid separating
kvm_mmu_find_shadow_page() from __kvm_mmu_find_shadow_page() correct?
i.e. Nested MMUs would have their own "find" function, which is called
by eager page splitting, and thus no separate
__kvm_mmu_find_shadow_page().

But __kvm_mmu_find_shadow_page(), as implemented in this series, is
about 90% similar to what you proposed for
kvm_mmu_nested_tdp_find_sp(). And in fact it would work correctly to
use __kvm_mmu_find_shadow_page() for nested MMUs, since we know the
sp->unsync condition would just be skipped.

So even if we did everything you proposed (which seems like an awful
lot just to avoid __kvm_mmu_find_shadow_page()), there's a chance we
would still end up with the exact same code. i.e.
kvm_mmu_nested_tdp_find_sp() would be implemented by calling
__kvm_mmu_find_shadow_page(), because it would be a waste to
re-implement an almost identical function?

>
> Having the separate page fault and get_shadow_page(), without the baggage of unsync
> in particular, sets us up for switching to taking mmu_lock for read, and in the
> distant future, implementing whatever new scheme someone concocts for shadowing
> nested TDP.

Taking MMU read lock with per-root spinlocks for nested MMUs is a
great idea btw. I think it would be a great improvement.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
