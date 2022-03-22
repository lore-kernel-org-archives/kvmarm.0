Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4861C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 940EB49F35;
	Wed, 23 Mar 2022 05:57:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zL71222j1PLx; Wed, 23 Mar 2022 05:57:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7214D4B0B3;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3139F40C52
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:52:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B90kcNxbvR5o for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 18:52:22 -0400 (EDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF53240B80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:52:22 -0400 (EDT)
Received: by mail-lf1-f51.google.com with SMTP id 5so14064223lfp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WvvHbaLzRYu7wKbKBkm0f3RCm6Tn7L9LKo6nWKndQoM=;
 b=IeY+8LZbgT5WN7RXZk7eh5d4wwEgng3XBSCniMnT9QQ7QynNJwZl7uqW7IKmQbo57i
 9WsPaoXnjD8RCC9dMJB2euDfnWOanl9VNI5e72UmnBkRwmDoIKf2X+UGaOYLgaXrQHUy
 RILbd+Y2hFukTlo6qBE9n95ArzhdO1ynnb7dT9o+uTxioSnIM2113VbgYH4kxLeiy2Yk
 wLRr3byfZRvARMnc1IHMc7Kb1nmIm278w00qMLp9kgcTtYRuy2IqBS9AxlsuczMBGoHZ
 S1bsn1pIYGuQI/BJQXmQvaI4b6yZK2RE/eASsco4xU31oK99EL3IlMefS9t6EbdC4+4L
 TQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WvvHbaLzRYu7wKbKBkm0f3RCm6Tn7L9LKo6nWKndQoM=;
 b=m/d61z0IDPYa+mp01hjE16+rPlkdO0hZeFb+gmOdDTo7Pz9mwfiIIQRLZzNH1cXbiL
 AVDLgTESMhs9s8tQf3Xk1CT/X0WvLFu+id80hNYGKS+D0rNLwaCbuG4dWiZe5Ret6GZ6
 4+HmKItVJ071Erd6ksM7DAU00zxTgW4TwE1hFm2ImmmdJVP9InaEEWy1qTvaa1j/wGOK
 5wzrJGDbAl0eAidfk+hSKLiNIq9ZOx+xE+hLWvXtyYuMTMib+u9f7lHdTqWV7DXLX0Oc
 YbTNL8cD3fgwqgfOPyZrauKS6mCWROx1TP1lGaUMJ5WpmuV/u38fpvRCJ+F4GKJMlL6j
 1Qog==
X-Gm-Message-State: AOAM530U0Lk0ZmM7xqhZtps7Dl5HybM/JLeNq27TM3eJNkYT6qC4z+BN
 +/Db2drPiAIV6fQZB6eKGSGYlkEpLs0rhygBJMf2aw==
X-Google-Smtp-Source: ABdhPJwI/z0/a17reQN2zQe+86LABc5jxg23lp5/QgxLJAcsYtyoxn6igiqHu+q8XWGSRty2B7/wG5HPsWsQkXUiGVs=
X-Received: by 2002:a05:6512:128e:b0:44a:4067:9ffe with SMTP id
 u14-20020a056512128e00b0044a40679ffemr3043386lfs.64.1647989540978; Tue, 22
 Mar 2022 15:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-17-dmatlack@google.com>
 <YjGgjTnP/9sG8L+2@xz-m1.local>
In-Reply-To: <YjGgjTnP/9sG8L+2@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 15:51:54 -0700
Message-ID: <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed
 translations
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

On Wed, Mar 16, 2022 at 1:32 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> > In order to split a huge page we need to know what access bits to assign
> > to the role of the new child page table. This can't be easily derived
> > from the huge page SPTE itself since KVM applies its own access policies
> > on top, such as for HugePage NX.
> >
> > We could walk the guest page tables to determine the correct access
> > bits, but that is difficult to plumb outside of a vCPU fault context.
> > Instead, we can store the original access bits for each leaf SPTE
> > alongside the GFN in the gfns array. The access bits only take up 3
> > bits, which leaves 61 bits left over for gfns, which is more than
> > enough. So this change does not require any additional memory.
>
> I have a pure question on why eager page split needs to worry on hugepage
> nx..
>
> IIUC that was about forbidden huge page being mapped as executable.  So
> afaiu the only missing bit that could happen if we copy over the huge page
> ptes is the executable bit.
>
> But then?  I think we could get a page fault on fault->exec==true on the
> split small page (because when we copy over it's cleared, even though the
> page can actually be executable), but it should be well resolved right
> after that small page fault.
>
> The thing is IIUC this is a very rare case, IOW, it should mostly not
> happen in 99% of the use case?  And there's a slight penalty when it
> happens, but only perf-wise.
>
> As I'm not really fluent with the code base, perhaps I missed something?

You're right that we could get away with not knowing the shadowed
access permissions to assign to the child SPTEs when splitting a huge
SPTE. We could just copy the huge SPTE access permissions and then let
the execute bit be repaired on fault (although those faults would be a
performance cost).

But the access permissions are also needed to lookup an existing
shadow page (or create a new shadow page) to use to split the huge
page. For example, let's say we are going to split a huge page that
does not have execute permissions enabled. That could be because NX
HugePages are enabled or because we are shadowing a guest translation
that does not allow execution (or both). We wouldn't want to propagate
the no-execute permission into the child SP role.access if the
shadowed translation really does allow execution (and vice versa).

>
> >
> > In order to keep the access bit cache in sync with the guest, we have to
> > extend FNAME(sync_page) to also update the access bits.
>
> Besides sync_page(), I also see that in mmu_set_spte() there's a path that
> we will skip the rmap_add() if existed:
>
>         if (!was_rmapped) {
>                 WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
>                 kvm_update_page_stats(vcpu->kvm, level, 1);
>                 rmap_add(vcpu, slot, sptep, gfn);
>         }
>
> I didn't check, but it's not obvious whether the sync_page() change here
> will cover all of the cases, hence raise this up too.

Good catch. I will need to dig into this more to confirm but I think
you might be right.

>
> >
> > Now that the gfns array caches more information than just GFNs, rename
> > it to shadowed_translation.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          | 32 +++++++++++++++++++-------------
> >  arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++--
> >  arch/x86/kvm/mmu/paging_tmpl.h  |  7 +++++--
> >  4 files changed, 38 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f72e80178ffc..0f5a36772bdc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -694,7 +694,7 @@ struct kvm_vcpu_arch {
> >
> >       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> >       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > -     struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> > +     struct kvm_mmu_memory_cache mmu_shadowed_translation_cache;
>
> I'd called it with a shorter name.. :) maybe mmu_shadowed_info_cache?  No
> strong opinion.
>
> >       struct kvm_mmu_memory_cache mmu_page_header_cache;
> >
> >       /*
>
> [...]
>
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index b6e22ba9c654..c5b8ee625df7 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -32,6 +32,11 @@ extern bool dbg;
> >
> >  typedef u64 __rcu *tdp_ptep_t;
> >
> > +struct shadowed_translation_entry {
> > +     u64 access:3;
> > +     u64 gfn:56;
>
> Why 56?

I was going for the theoretical maximum number of bits for a GFN. But
that would be 64 - 12 = 52... so I'm not sure what I was thinking
here.

I'll switch it to 52 and add a comment.

>
> > +};
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
