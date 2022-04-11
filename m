Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CF8C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 11:14:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2883D4B0F1;
	Tue, 12 Apr 2022 07:14:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nlzu+hAvfIRC; Tue, 12 Apr 2022 07:14:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDC884B1C5;
	Tue, 12 Apr 2022 07:14:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C773E49EFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 19:41:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bbKpDCPno425 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2022 19:41:41 -0400 (EDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com
 [209.85.208.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D4B649E29
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 19:41:41 -0400 (EDT)
Received: by mail-lj1-f172.google.com with SMTP id s13so22060592ljd.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2022 16:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=q17E+fHKk5Th+BI8Tj0S78AdPyNKUlnW29K14ISNtBQ=;
 b=K40jOpUlphvQ1cZf+e6cBGIBVFGLKJ32IXPMsUg6Rud+5raoGXjJePu9S+gTTXt6v7
 /2Wlva2b9ZfJ9DvZ1GBzZ6IQAtAg5Hrqlz9BfcQ/6TgJPw3F4GS1tcEN4SL31y2MWglr
 4YhIx9f2ECjJjuKdFnLJmJb1+nLyfpRutN+BaCAHdUisS2MjReeVv4zgH1m4XsuV+Aab
 tuQzoLW8vVTpGloaHRidtvcPBfFEV3LAwG7hoJQYRpFKBSIgAjYcJ/c5rFgC90V1LHtq
 Rqy57u+h/U5mlPQmy35ygdhnBhQMZAVguU2DxuHInAwgvT/uoVKCDo2VTZcJZn+CrvQf
 +tCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=q17E+fHKk5Th+BI8Tj0S78AdPyNKUlnW29K14ISNtBQ=;
 b=8Os89psk4fS0lUQry36oPaJf7fC9W6K/S5Vuhz2GqcqnriUHwUNC69NCRbHZKWWPkE
 LCHqBND5QHiUS2ryJTMUL8yU/3+iGhGDJcqHBeJb6KYbjF1/v2eNlU2vd06B83Bg69U3
 dyvVihKurR6rXHTm1jQJe25amHC/M6gVJU2hTajA62ecAJ3NDMXL47BC992s9T//k8rg
 NBYXaoRbNyT8VwEmHvvNVtLf49w+UI5v3pk97Z41FoNrzq1XX7zSjGTPP76bBLvxCt0+
 x5RsDLd8hmEVBytixSTHDddK7jXWVRYvHk+LAOt3ISCPnwh8V8lRz355gEZzltxh2w2k
 i1sA==
X-Gm-Message-State: AOAM533yVK2yVZ5YNXqwlREHeQGLvBUc+HzapjoKFAUw3fifeBF4Xo2/
 zObxJhnJV1yjjN5I6/P7O9MEYnrCc7v2gaBdO6IrSw==
X-Google-Smtp-Source: ABdhPJxYGp7OwrMeWKTpxOiX1rp3z1eskcZp4s0ucsF/ixzgk8f54RP2AiNfWLG9/o9mz9UGBiWkKsUwgELcxFw2weQ=
X-Received: by 2002:a05:651c:54c:b0:249:9d06:24ef with SMTP id
 q12-20020a05651c054c00b002499d0624efmr21986148ljp.331.1649720499710; Mon, 11
 Apr 2022 16:41:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
In-Reply-To: <YlSLuZphElMyF2sG@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 11 Apr 2022 16:41:12 -0700
Message-ID: <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 12 Apr 2022 07:14:13 -0400
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

On Mon, Apr 11, 2022 at 1:12 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Apr 11, 2022, David Matlack wrote:
> > On Mon, Apr 11, 2022 at 10:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > > Circling back to eager page splitting, this series could be reworked to take the
> > > first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
> > > order to provide the necessary path for reworking nested MMU page faults.  Then it
> > > can remove unsync and shrinker support for nested MMUs.  With those gone,
> > > dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
> > > than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
> > > some of the complexity/churn.
> >
> > These sound like useful improvements but I am not really seeing the
> > value of sequencing them before this series:
> >
> >  - IMO the "churn" in patches 1-14 are a net improvement to the
> > existing code. They improve readability by decomposing the shadow page
> > creation path into smaller functions with better names, reduce the
> > amount of redundant calculations, and reduce the dependence on struct
> > kvm_vcpu where it is not needed. Even if eager page splitting is
> > completely dropped I think they would be useful to merge.
>
> I definitely like some of patches 1-14, probably most after a few read throughs.
> But there are key parts that I do not like that are motivated almost entirely by
> the desire to support page splitting.  Specifically, I don't like splitting the
> logic of finding a page, and I don't like having a separate alloc vs. initializer
> (though I'm guessing this will be needed somewhere to split huge pages for nested
> MMUs).
>
> E.g. I'd prefer the "get" flow look like the below (completely untested, for
> discussion purposes only).  There's still churn, but the core loop is almost
> entirely unchanged.
>
> And it's not just this series, I don't want future improvements nested TDP to have
> to deal with the legacy baggage.

One thing that would be helpful is if you can explain in a bit more
specifically what you'd like to see. Part of the reason why I prefer
to sequence your proposal after eager page splitting is that I do not
fully understand what you're proposing, and how complex it would be.
e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
for nested MMUs does not sound like less churn.

From my perspective, this series is a net improvement to the
readability and maintainability of existing code, while adding a
performance improvement (eager page splitting). All of the changes you
are proposing can still be implemented on top if and when they become
a priority (including merging {,__}kvm_find_shadow_page()). And if we
limit eager page splitting to nested MMUs, we don't have to worry
about maintaining eager page splitting with TDP shadow MMU or legacy
shadow paging over time.


>
> Waaaay off topic, why do we still bother with stat.max_mmu_page_hash_collision?
> I assume it was originally added to tune the hashing logic?  At this point is it
> anything but wasted cycles?
>
> static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
>                                                      gfn_t gfn,
>                                                      unsigned int gfn_hash,
>                                                      union kvm_mmu_page_role role)
> {
>         struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];
>         struct kvm_mmu_page *sp;
>         LIST_HEAD(invalid_list);
>
>         int collisions = 0;
>
>         for_each_valid_sp(kvm, sp, sp_list) {
>                 if (sp->gfn != gfn) {
>                         collisions++;
>                         continue;
>                 }
>
>                 if (sp->role.word != role.word) {
>                         /*
>                          * If the guest is creating an upper-level page, zap
>                          * unsync pages for the same gfn.  While it's possible
>                          * the guest is using recursive page tables, in all
>                          * likelihood the guest has stopped using the unsync
>                          * page and is installing a completely unrelated page.
>                          * Unsync pages must not be left as is, because the new
>                          * upper-level page will be write-protected.
>                          */
>                         if (role.level > PG_LEVEL_4K && sp->unsync)
>                                 kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
>
>                         continue;
>                 }
>
>                 /* unsync and write-flooding only apply to indirect SPs. */
>                 if (sp->role.direct)
>                         goto out;
>
>                 if (sp->unsync) {
>                         /*
>                          * The page is good, but is stale.  kvm_sync_page does
>                          * get the latest guest state, but (unlike mmu_unsync_children)
>                          * it doesn't write-protect the page or mark it synchronized!
>                          * This way the validity of the mapping is ensured, but the
>                          * overhead of write protection is not incurred until the
>                          * guest invalidates the TLB mapping.  This allows multiple
>                          * SPs for a single gfn to be unsync.
>                          *
>                          * If the sync fails, the page is zapped.  If so, break
>                          * in order to rebuild it.
>                          */
>                         if (!kvm_sync_page(vcpu, sp, &invalid_list))
>                                 break;
>
>                         WARN_ON(!list_empty(&invalid_list));
>                         kvm_flush_remote_tlbs(vcpu->kvm);
>                 }
>
>                 __clear_sp_write_flooding_count(sp);
>                 goto out;
>         }
>
>         sp = NULL;
>
> out:
>         if (collisions > kvm->stat.max_mmu_page_hash_collisions)
>                 kvm->stat.max_mmu_page_hash_collisions = collisions;
>
>         kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
>         return sp;
> }
>
> static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>                                                       gfn_t gfn,
>                                                       unsigned int gfn_hash,
>                                                       union kvm_mmu_page_role role)
> {
>         struct kvm_mmu_page *sp = __kvm_mmu_alloc_shadow_page(vcpu, role.direct);
>         struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>         struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];
>
>         ++kvm->stat.mmu_cache_miss;
>
>         sp->gfn = gfn;
>         sp->role = role;
>         sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
>
>         /*
>          * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
>          * depends on valid pages being added to the head of the list.  See
>          * comments in kvm_zap_obsolete_pages().
>          */
>         list_add(&sp->link, &kvm->arch.active_mmu_pages);
>         kvm_mod_used_mmu_pages(kvm, 1);
>
>         sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>         hlist_add_head(&sp->hash_link, sp_list);
>
>         if (!role.direct)
>                 account_shadowed(kvm, slot, sp);
> }
>
>
> static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>                                                     gfn_t gfn,
>                                                     union kvm_mmu_page_role role)
> {
>         unsigned int gfn_hash = kvm_page_table_hashfn(gfn);
>         struct kvm_mmu_page *sp;
>         bool created = false;
>
>         sp = kvm_mmu_find_shadow_page(vcpu, gfn, gfn_hash, role);
>         if (!sp) {
>                 created = true;
>                 sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, gfn_hash, role);
>         }
>
>         trace_kvm_mmu_get_page(sp, created);
>         return sp;
> }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
