Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87150C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F8FE49F20;
	Wed, 23 Mar 2022 05:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ocDQ7cGfCQf0; Wed, 23 Mar 2022 05:57:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB77D4A7FD;
	Wed, 23 Mar 2022 05:57:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2DD49E1E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:06:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0kJ5Ql4q5PMf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 18:06:07 -0400 (EDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 934C349AF7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:06:07 -0400 (EDT)
Received: by mail-lj1-f172.google.com with SMTP id s25so25854247lji.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dDctWXCZdyM5GB7RYASY+je0HYc47y70gOwl8FZOZm4=;
 b=smB2FXdWY0kivKSxas6WhCBIsILQplewNHqP+jCt4AUSWLy/pM2Sqmxa9Vs2b0ddnb
 rysEStWa6DxMu8bCjQoFwFIonkuFBXpcUjSFGIv8ZeKAn7cNKdA3Qn3I3TQG6nhRmz2T
 NG6nR/8T1pwaXdKdWGeKeW6u71IaPmZKO5IUsHHdC1pZPr2GQHbD8YwfMU+8YcYnBoDU
 TcNIBUyP1NQYItJFFYI7W5O7hgFQJpfjqOXWE7e7T90a42b8Yvzfde7AeBvNfktwdgVr
 IVyxA3N7oEsLuXfO91CfQGWGZdyB/gLypP6qaFz3j3yN2qEyvXDRBsa/iwKjJzg6sxc5
 2BJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dDctWXCZdyM5GB7RYASY+je0HYc47y70gOwl8FZOZm4=;
 b=KtMddaeB27hByPJXKsdBWdCQRRM7iyEuAEhl56cSuepiTOtCZ/an/Bxj0HsK7giS6l
 cwWEfrcdgQNxT77xtwcf2QXzHD5PsYFqFQVCxVPGmOfsMA6nx3CcBCryI6q2ODueULMf
 gkxSe5zvgXpLHCWWX6onZYUaPZXjfm3fYslY0pH+plrxocf5eHHgiLXWP/WnFeB94Qib
 xYaWrVSnVEBsS0RH6EJtofTRjbz/loUCYZLjSNSL+i9TD2/8DDHuZYHc7P+4QVaNbWGP
 Kq4Ccc/K68LWV7v7jPT1JvOnVaSGWEYAFfWsZLh5ORtS5me4PvxdhpfcUnGnX1uP0FOm
 mRuQ==
X-Gm-Message-State: AOAM533beXAu6q9zR5RPU5ezaZR9VORc8DRquJ4rZUnSliW9ZSdT5lI8
 Bp91SNmcJcLooETycnPKI+XubL//6Jb6qXwT9t4yFA==
X-Google-Smtp-Source: ABdhPJynK/JJXFYQj2VAWjdUhNJu91ZGpwnFDHqBcP8k3VgI99deds+U0mT8GuZkBk87T+opYdYujghah01FAEA+v/g=
X-Received: by 2002:a2e:8255:0:b0:247:dff4:1f with SMTP id
 j21-20020a2e8255000000b00247dff4001fmr20905527ljh.16.1647986766015; 
 Tue, 22 Mar 2022 15:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-7-dmatlack@google.com>
 <YjBWdv3nEk3Cz40m@xz-m1.local>
In-Reply-To: <YjBWdv3nEk3Cz40m@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 15:05:39 -0700
Message-ID: <CALzav=dmfFNvitGvO-RCnxmqHpSiQN68JV6Q+UTem8Wfwma+wA@mail.gmail.com>
Subject: Re: [PATCH v2 06/26] KVM: x86/mmu: Pass memslot to
 kvm_mmu_new_shadow_page()
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
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

On Tue, Mar 15, 2022 at 2:04 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:08AM +0000, David Matlack wrote:
> > Passing the memslot to kvm_mmu_new_shadow_page() avoids the need for the
> > vCPU pointer when write-protecting indirect 4k shadow pages. This moves
> > us closer to being able to create new shadow pages during VM ioctls for
> > eager page splitting, where there is not vCPU pointer.
> >
> > This change does not negatively impact "Populate memory time" for ept=Y
> > or ept=N configurations since kvm_vcpu_gfn_to_memslot() caches the last
> > use slot. So even though we now look up the slot more often, it is a
> > very cheap check.
> >
> > Opportunistically move the code to write-protect GFNs shadowed by
> > PG_LEVEL_4K shadow pages into account_shadowed() to reduce indentation
> > and consolidate the code. This also eliminates a memslot lookup.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b6fb50e32291..519910938478 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -793,16 +793,14 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn)
> >       update_gfn_disallow_lpage_count(slot, gfn, -1);
> >  }
> >
> > -static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> > +static void account_shadowed(struct kvm *kvm,
> > +                          struct kvm_memory_slot *slot,
> > +                          struct kvm_mmu_page *sp)
> >  {
> > -     struct kvm_memslots *slots;
> > -     struct kvm_memory_slot *slot;
> >       gfn_t gfn;
> >
> >       kvm->arch.indirect_shadow_pages++;
> >       gfn = sp->gfn;
> > -     slots = kvm_memslots_for_spte_role(kvm, sp->role);
> > -     slot = __gfn_to_memslot(slots, gfn);
> >
> >       /* the non-leaf shadow pages are keeping readonly. */
> >       if (sp->role.level > PG_LEVEL_4K)
> > @@ -810,6 +808,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> >                                                   KVM_PAGE_TRACK_WRITE);
> >
> >       kvm_mmu_gfn_disallow_lpage(slot, gfn);
> > +
> > +     if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> > +             kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>
> It's not immediately obvious in this diff, but when looking at the code
> yeah it looks right to just drop the 4K check..

Yeah it's a bit subtle but (as you probably noticed) account_shadowed()
returns early if the level is above PG_LEVEL_4K.


>
> I also never understood why we only write-track the >1 levels but only
> wr-protect the last level.  It'll be great if there's quick answer from
> anyone.. even though it's probably unrelated to the patch.
>
> The change looks all correct:
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
