Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAABC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FB04B2F8;
	Tue, 10 May 2022 02:04:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pue4CYeHzO64; Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6744B216;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EC6D49EAA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:18:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6FLcXlC-M-C for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:18:48 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3413E49E44
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:18:48 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id y32so26014600lfa.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qchi2ovSlwKNdfNz60pRFkmAP/3ewU4lfp3vcRbEGlU=;
 b=eGkU5zTgJUYc8R/bZEvWar9PD0laWJPybiJLqeTwEWYl2flllTcBFbyTo8+oUobAU0
 tWqbrVzupUWUPQ/oEqKFrKkzApM/460q/sBtENEj+svMZC8kN83hBsoV4yIY3D0n+zEG
 cZzlHhUBiUjcWD7ssehHMrg3q1WJTlyGGu0bJLZU2+398Xu4LmELv4nT0n4ltD2TkSar
 l/2zfb86pt9JP3jHi4970ZSAqcirzMd5Dal58pESMXboHZQoPjOrYjod979tp2ffWSY9
 0xKViGZqjX/ynl44ibcdsbVQhptbZe/DypzKucGQve8F4kKGLohzTEJey8jUFc95+8x2
 iUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qchi2ovSlwKNdfNz60pRFkmAP/3ewU4lfp3vcRbEGlU=;
 b=SfEB+3ZFjdKMXO0uS/zSXKuGWUQoOzX/rkMw8fcNvc4URbAJzeHkq3dSmgk2trFe02
 eBwMIDxnb5vIf2ppalb+hXKF5qZ8EOtkV0wjXcO+gDd2cwA8CxD/gIloM9IffkDhVsRD
 ytDnup3rcufoatCXzdqKFHhge5TMyl53cJl4JvvBP9T3QYqj/4quKNrxNIKzB0bq2/tZ
 dGpsY8sqlDXiQ95PCmVA1jbvzDaqm6BDv/dPa32Y4sMn8R7nCw0AzyANbJzD9aHJbcpC
 XFw+55y6DR06PuvDv3Dk6a2Yu9UX73Ijs3gHj7N5ll57t7yF2IzbveBHwPJYk7l5DUKF
 fAgg==
X-Gm-Message-State: AOAM5303i7EBSBCIbUdOPsvKfFNRK2ij8cZljVa458qM93t1FNLeb2C0
 hZn1J4v1zbfmWK1U6qseu6/TdJgz8otPAQygIh2/9w==
X-Google-Smtp-Source: ABdhPJyvz4bFX6ByxPxugEVcuzVcqYiTBrRxjECVFhA951epTBmdMiUFM07b6t6SQS/Z5WmLCW6hDwUciKFtbEvVsLk=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr13933301lfk.537.1652131126435; Mon, 09
 May 2022 14:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-8-dmatlack@google.com>
 <YnRU+zN9T8Zf91Ei@google.com>
In-Reply-To: <YnRU+zN9T8Zf91Ei@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:18:20 -0700
Message-ID: <CALzav=cU8dsXjZy2eUdQ-eA7BBsXU6PaPDepNmmF=sp=Z0xJ4A@mail.gmail.com>
Subject: Re: [PATCH v4 07/20] KVM: x86/mmu: Move guest PT write-protection to
 account_shadowed()
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 10 May 2022 02:04:42 -0400
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

On Thu, May 5, 2022 at 3:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Move the code that write-protects newly-shadowed guest page tables into
> > account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
> > more logical place for this code to live. But most importantly, this
> > reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
> > kvm_vcpu pointer, which will be necessary when creating new shadow pages
> > during VM ioctls for eager page splitting.
> >
> > Note, it is safe to drop the role.level == PG_LEVEL_4K check since
> > account_shadowed() returns early if role.level > PG_LEVEL_4K.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
> >  arch/x86/kvm/mmu/mmu.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index fa7846760887..4f894db88bbf 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -807,6 +807,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> >                                                   KVM_PAGE_TRACK_WRITE);
> >
> >       kvm_mmu_gfn_disallow_lpage(slot, gfn);
> > +
> > +     if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> > +             kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> >  }
> >
> >  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > @@ -2100,11 +2103,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
> >       sp->gfn = gfn;
> >       sp->role = role;
> >       hlist_add_head(&sp->hash_link, sp_list);
> > -     if (!role.direct) {
> > +
> > +     if (!role.direct)
> >               account_shadowed(vcpu->kvm, sp);
> > -             if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
>
> Huh.  Two thoughts.
>
> 1. Can you add a patch to drop kvm_vcpu_write_protect_gfn() entirely, i.e. convert
>    mmu_sync_children() to use kvm_mmu_slot_gfn_write_protect?  It's largely a moot
>    point, but only because mmu_sync_children() only operates on shadow pages that
>    are relevant to the current non-SMM/SMM role.  And _that_ holds true only because
>    KVM does kvm_mmu_reset_context() and drops roots for the vCPU on SMM transitions.
>
>    That'd be a good oppurtunity to move this pair into a helper:
>
>         slots = kvm_memslots_for_spte_role(kvm, sp->role);
>         slot = __gfn_to_memslot(slots, gfn);

Sounds reasonable but let's do that in a separate series since this is
already on v4 and I wouldn't say it's obvious that using the role to
get the memslot will give the same result as using the vCPU, although
that does look to be true.

>
> 2. This got me thinking...  Write-protecting for shadow paging should NOT be
>    associated with the vCPU or even the role.  The SMM memslots conceptually
>    operate on the same guest physical memory, SMM is just given access to memory
>    that is not present in the non-SMM memslots.
>
>    If KVM creates SPTEs for non-SMM, then it needs to write-protect _all_ memslots
>    that contain the relevant gfn, e.g. if the guest takes an SMI and modifies the
>    non-SMM page tables, then KVM needs trap and emulate (or unsync) those writes.
>
>    The mess "works" because no sane SMM handler (kind of a contradiction in terms)
>    will modify non-SMM page tables, and vice versa.
>
>    The entire duplicate memslots approach is flawed.  Better would have been to
>    make SMM a flag and hide SMM-only memslots, not duplicated everything...
>
> > -                     kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> > -     }
> >
> >       return sp;
> >  }
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
