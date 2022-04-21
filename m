Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D4EC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:50:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F0B4B28C;
	Fri, 22 Apr 2022 13:50:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OtmFrehr-krC; Fri, 22 Apr 2022 13:50:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B1A14B2AA;
	Fri, 22 Apr 2022 13:50:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C80F4B26D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 13:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uyIFy6YBSi-Y for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 13:04:07 -0400 (EDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A7914B231
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 13:04:07 -0400 (EDT)
Received: by mail-yb1-f174.google.com with SMTP id f38so9889716ybi.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 10:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Mt5d94ouBNRgK4aft9t5vNr0uFkR55z3XwWAQdD5FUc=;
 b=HrQ6SnoElb85r6De0Gyb6QYtmGW0UZZHoRqYniWGXxhbAJxdJBxxDoGjWfFzlyLHCa
 iS6FEOJghE+gwwbiFuO/qzE+v0/xWyacDc/dig/lj0OLYAFuIqjszn6bBifsCmbCzGIr
 ZlEiv9/ngqKNSNChcABhKOqkpYvRxWU6mu2hEvjbWIdvs8nbFLsj6ub4GEwaRL1dxgib
 GQJBc2PA+Rsc0hrZUet+I8zxDXI7xr1LxSnpddJMeRCy6DAIJcYqCV9Dw81JA9zuNR8F
 b6jtRfyhxgw76JMs9k0bR9BotnAZkTT7vy8KrdVPkKxBKDPwT/PbrInF9l6bNSyIIZE8
 hL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Mt5d94ouBNRgK4aft9t5vNr0uFkR55z3XwWAQdD5FUc=;
 b=b9/Gc6Cn//yjWJqQ9t9trS9F+gtUeISxcHy9lXCRv7QnrxzT4CbG3ycCYeaYG9BZmf
 Gf6lBWBX0V/GVQ/ED17t/omjY+c/5gEKC7ZcYoRrJFHQihawHaH2VIbmLf1sUNl2T81j
 KAT8GvywF70/7iqEt8qJyp5Ia9RAY/fZRGjSRnGemABxBLef8OtpC/eMKMZCgz/cAv/0
 Hp0LnbVHcDXStaqn5Zk3AZUcDlpYYc6yTJoRWMtnAECzRzfW6XcTeVSzKyfEUrjJIEQ0
 j77GCzPH7zPQW8c24gUzIncZRKFUEwVgzUKi6KHzX8MjGG443lBWxtR2aZdXAxLGvOFf
 VriQ==
X-Gm-Message-State: AOAM530cmvxAF/rntLfnC2BQzexkjBAPuQah2JTMe8XuHt4Ei9FNo5D8
 SyOuFAYltSTe0Csd7e8tYBW3YdEnE2vcputCxpxLIg==
X-Google-Smtp-Source: ABdhPJwGlxPxobbr+AhQQh2O9DUBl0dl6jeVvCmp3KF1DE8dxE/HTfIURpAV8tgSrH2T97uM8B8yRKMtO3mXmGlYNio=
X-Received: by 2002:a25:84c6:0:b0:641:5a21:90bc with SMTP id
 x6-20020a2584c6000000b006415a2190bcmr699446ybm.26.1650560646522; Thu, 21 Apr
 2022 10:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-17-oupton@google.com>
 <CANgfPd9bb213hsdKTMW9K0EsVLuKEKCF8V0pb6xM1qfnRj1qfw@mail.gmail.com>
 <YmGKaoStt9Lf9xOP@google.com>
In-Reply-To: <YmGKaoStt9Lf9xOP@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 10:03:55 -0700
Message-ID: <CANgfPd-ebvPq5eqgHz0ED1eSqk0Z-+utoBE8w67uo=GSS+UrpQ@mail.gmail.com>
Subject: Re: [RFC PATCH 16/17] KVM: arm64: Enable parallel stage 2 MMU faults
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Fri, 22 Apr 2022 13:50:47 -0400
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

On Thu, Apr 21, 2022 at 9:46 AM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Apr 21, 2022 at 09:35:27AM -0700, Ben Gardon wrote:
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Voila! Since the map walkers are able to work in parallel there is no
> > > need to take the write lock on a stage 2 memory abort. Relax locking
> > > on map operations and cross fingers we got it right.
> >
> > Might be worth a healthy sprinkle of lockdep on the functions taking
> > "shared" as an argument, just to make sure the wrong value isn't going
> > down a callstack you didn't expect.
>
> If we're going to go this route we might need to just punch a pointer
> to the vCPU through to the stage 2 table walker. All of this plumbing is
> built around the idea that there are multiple tables to manage and
> needn't be in the context of a vCPU/VM, which is why I went the WARN()
> route instead of better lockdep assertions.

Oh right, it didn't even occur to me that those functions wouldn't
have a vCPU / KVM pointer.

>
> > >
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 21 +++------------------
> > >  1 file changed, 3 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 63cf18cdb978..2881051c3743 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1127,7 +1127,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         gfn_t gfn;
> > >         kvm_pfn_t pfn;
> > >         bool logging_active = memslot_is_logging(memslot);
> > > -       bool use_read_lock = false;
> > >         unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> > >         unsigned long vma_pagesize, fault_granule;
> > >         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > @@ -1162,8 +1161,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         if (logging_active) {
> > >                 force_pte = true;
> > >                 vma_shift = PAGE_SHIFT;
> > > -               use_read_lock = (fault_status == FSC_PERM && write_fault &&
> > > -                                fault_granule == PAGE_SIZE);
> > >         } else {
> > >                 vma_shift = get_vma_page_shift(vma, hva);
> > >         }
> > > @@ -1267,15 +1264,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >         if (exec_fault && device)
> > >                 return -ENOEXEC;
> > >
> > > -       /*
> > > -        * To reduce MMU contentions and enhance concurrency during dirty
> > > -        * logging dirty logging, only acquire read lock for permission
> > > -        * relaxation.
> > > -        */
> > > -       if (use_read_lock)
> > > -               read_lock(&kvm->mmu_lock);
> > > -       else
> > > -               write_lock(&kvm->mmu_lock);
> > > +       read_lock(&kvm->mmu_lock);
> > > +
> >
> > Ugh, I which we could get rid of the analogous ugly block on x86.
>
> Maybe we could fold it in to a MMU macro in the arch-generic scope?
> Conditional locking is smelly, I was very pleased to delete these lines :)

Smelly indeed. I don't think hiding it behind a macro would really
help. It's just something we'll have to live with in x86.

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
