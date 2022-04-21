Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22242C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:50:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCDAD4B27F;
	Fri, 22 Apr 2022 13:50:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EhwsFQN4CzOg; Fri, 22 Apr 2022 13:50:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9DDC4B2A7;
	Fri, 22 Apr 2022 13:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D5DD4B1D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:57:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nuui3xIp9mUO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 12:57:44 -0400 (EDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 030E44B0CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 12:57:43 -0400 (EDT)
Received: by mail-yb1-f174.google.com with SMTP id p65so9813674ybp.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 09:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cd7VNqz49ygj/O4UJWXzkGobo65UJfz5UPdoBEmOe7Q=;
 b=dGscUWZoj1e1HyGOcqBRSS5CrnxTGzyftEuoC36qDGfMjsxnd7J8FJPYKkhmXbhESi
 SgoBJw0iC5T2/+DcIyhWkJNR4fXmNTMLUG34G+Y6r0RopSlSLLIOV2y2vDaRaBJyJ2w9
 9tu3QZAKRDwts/cI58ZwesvVIanL7d5nOzW2FNqEwoS2nNK4gUtb9BHYeQUD2y2i9/c0
 OzTXrixonKk1S0WERX+2iW7NTAkp8Npg6hfI/fQjuO7+l/PgqirKjwM85MGLpX4OmANp
 li3yMxI/WwqN4fyiIN9fdiSI53P4m8Ov5Mj29fdEhJvM5WSsf1Cb0J8fzp1uHFL6M4xw
 SC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cd7VNqz49ygj/O4UJWXzkGobo65UJfz5UPdoBEmOe7Q=;
 b=S8k6mNM11VTqKBXT+vyPCaGUXBZzIglLM5Aci+KCZ2BPMrI1ZthYiAsmMXBBaKq3Se
 7XdiaSOEEsA+9lYZqeX65qsK8tOlkz0Uoq5gTZQJyc4oA7qW3xQ6KyO6Ugi6LLD8PR7W
 QfInqqsy7crMZn+mJdmxCtpWBEHze3i/OB8hZDHSpLurjU3LH4CewlulFtJoUTLz/fzx
 walEyU+G5iQaWXtXHelsoxHfSaM+qbAV3JHIuoG0Fcf+XGKOAq2xTIta+OEKM1Q+DqrH
 7ia5P5gDq0vgkKxkzHhaxXkZnvjOYVw5EAmPgWPUM/Y4dVpRTdR3ruYAfd3T3yXfyblK
 G9bA==
X-Gm-Message-State: AOAM530PM7dW0jYGOIzCLpI5dN6o2H9+CFHwbe1poY59Ld6ew7fkBh8S
 b4ypUeuIbGVLDW5bd20cixAW6d7O7hQDHaB1ZVg7iw==
X-Google-Smtp-Source: ABdhPJzf2IxEf+MJhO6vY8kqURjFFp1Ri0to8KxTdQWq4zfs9C6bKJx8y9ifyDEITwNp7ShT1yqiKumS2tz2RxLv13Q=
X-Received: by 2002:a25:add6:0:b0:641:2562:4022 with SMTP id
 d22-20020a25add6000000b0064125624022mr582597ybe.391.1650560263152; Thu, 21
 Apr 2022 09:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-7-oupton@google.com>
In-Reply-To: <20220415215901.1737897-7-oupton@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 21 Apr 2022 09:57:32 -0700
Message-ID: <CANgfPd8RLDtmFks0BLEVyHPaEANF93d4iJxHt3n6cKewQsBLuA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] KVM: arm64: Implement break-before-make
 sequence for parallel walks
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> The ARM architecture requires that software use the 'break-before-make'
> sequence whenever memory is being remapped. An additional requirement of
> parallel page walks is a mechanism to ensure exclusive access to a pte,
> thereby avoiding two threads changing the pte and invariably stomping on
> one another.
>
> Roll the two concepts together into a new helper to implement the
> 'break' sequence. Use a special invalid pte value to indicate that the
> pte is under the exclusive control of a thread. If software walkers are
> traversing the tables in parallel, use an atomic compare-exchange to
> break the pte. Retry execution on a failed attempt to break the pte, in
> the hopes that either the instruction will succeed or the pte lock will
> be successfully acquired.
>
> Avoid unnecessary DSBs and TLBIs by only completing the sequence if the
> evicted pte was valid. For counted non-table ptes drop the reference
> immediately. Otherwise, references on tables are dropped in post-order
> traversal as the walker must recurse on the pruned subtree.
>
> All of the new atomics do nothing (for now), as there are a few other
> bits of the map walker that need to be addressed before actually walking
> in parallel.

I want to make sure I understand the make before break / PTE locking
patterns here.
Please check my understanding of the following cases:

Case 1: Change a leaf PTE (for some reason)
1. Traverse the page table to the leaf
2. Invalidate the leaf PTE, replacing it with a locked PTE
3. Flush TLBs
4. Replace the locked PTE with the new value

In this case, no need to lock the parent SPTEs, right? This is pretty simple.

Case 2:  Drop a page table
1. Traverse to some non-leaf PTE
2. Lock the PTE, invalidating it
3. Recurse into the child page table
4. Lock the PTEs in the child page table. (We need to lock ALL the
PTEs here right? I don't think we'd get away with locking only the
valid ones)
5. Flush TLBs
6. Unlock the PTE from 2
7. Free the child page after an RCU grace period (via callback)

Case 3: Drop a range of leaf PTEs
1. Traverse the page table to the first leaf
2. For each leaf in the range:
        a. Invalidate the leaf PTE, replacing it with a locked PTE
3. Flush TLBs
4. unlock the locked PTEs

In this case we have to lock ALL PTEs in the range too, right? My
worry about the whole locking scheme is making sure each thread
correctly remembers which PTEs it locked versus which might have been
locked by other threads.
On x86 we solved this by only locking one SPTE at a time, flushing,
then fixing it, but if you're locking a bunch at once it might get
complicated.
Making this locking scheme work without demolishing performance seems hard.

>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 172 +++++++++++++++++++++++++++++------
>  1 file changed, 146 insertions(+), 26 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index bf46d6d24951..059ebb921125 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -49,6 +49,12 @@
>  #define KVM_INVALID_PTE_OWNER_MASK     GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID               1
>
> +/*
> + * Used to indicate a pte for which a 'make-before-break' sequence is in
> + * progress.
> + */
> +#define KVM_INVALID_PTE_LOCKED         BIT(10)
> +
>  struct kvm_pgtable_walk_data {
>         struct kvm_pgtable              *pgt;
>         struct kvm_pgtable_walker       *walker;
> @@ -707,6 +713,122 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>         return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
>  }
>
> +static bool stage2_pte_is_locked(kvm_pte_t pte)
> +{
> +       return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> +}
> +
> +static inline bool kvm_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
> +{
> +       if (!shared) {
> +               WRITE_ONCE(*ptep, new);
> +               return true;
> +       }
> +
> +       return cmpxchg(ptep, old, new) == old;
> +}
> +
> +/**
> + * stage2_try_break_pte() - Invalidates a pte according to the
> + *                         'break-before-make' sequence.
> + *
> + * @ptep: Pointer to the pte to break
> + * @old: The previously observed value of the pte; used for compare-exchange in
> + *      a parallel walk
> + * @addr: IPA corresponding to the pte
> + * @level: Table level of the pte
> + * @shared: true if the tables are shared by multiple software walkers
> + * @data: pointer to the map walker data
> + *
> + * Returns: true if the pte was successfully broken.
> + *
> + * If the removed pt was valid, performs the necessary DSB and TLB flush for
> + * the old value. Drops references to the page table if a non-table entry was
> + * removed. Otherwise, the table reference is preserved as the walker must also
> + * recurse through the child tables.
> + *
> + * See ARM DDI0487G.a D5.10.1 "General TLB maintenance requirements" for details
> + * on the 'break-before-make' sequence.
> + */
> +static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level, bool shared,
> +                                struct stage2_map_data *data)
> +{
> +       /*
> +        * Another thread could have already visited this pte and taken
> +        * ownership.
> +        */
> +       if (stage2_pte_is_locked(old)) {
> +               /*
> +                * If the table walker has exclusive access to the page tables
> +                * then no other software walkers should have locked the pte.
> +                */
> +               WARN_ON(!shared);
> +               return false;
> +       }
> +
> +       if (!kvm_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, shared))
> +               return false;
> +
> +       /*
> +        * If we removed a valid pte, break-then-make rules are in effect as a
> +        * translation may have been cached that traversed this entry.
> +        */
> +       if (kvm_pte_valid(old)) {
> +               dsb(ishst);
> +
> +               if (kvm_pte_table(old, level))
> +                       /*
> +                        * Invalidate the whole stage-2, as we may have numerous leaf
> +                        * entries below us which would otherwise need invalidating
> +                        * individually.
> +                        */
> +                       kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> +               else
> +                       kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> +       }
> +
> +       /*
> +        * Don't drop the reference on table entries yet, as the walker must
> +        * first recurse on the unlinked subtree to unlink and drop references
> +        * to child tables.
> +        */
> +       if (!kvm_pte_table(old, level) && stage2_pte_is_counted(old))
> +               data->mm_ops->put_page(ptep);
> +
> +       return true;
> +}
> +
> +/**
> + * stage2_make_pte() - Installs a new pte according to the 'break-before-make'
> + *                    sequence.
> + *
> + * @ptep: pointer to the pte to make
> + * @new: new pte value to install
> + *
> + * Assumes that the pte addressed by ptep has already been broken and is under
> + * the ownership of the table walker. If the new pte to be installed is a valid
> + * entry, perform a DSB to make the write visible. Raise the reference count on
> + * the table if the new pte requires a reference.
> + *
> + * See ARM DDI0487G.a D5.10.1 "General TLB maintenance requirements" for details
> + * on the 'break-before-make' sequence.
> + */
> +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +       /* Yikes! We really shouldn't install to an entry we don't own. */
> +       WARN_ON(!stage2_pte_is_locked(*ptep));
> +
> +       if (stage2_pte_is_counted(new))
> +               mm_ops->get_page(ptep);
> +
> +       if (kvm_pte_valid(new)) {
> +               WRITE_ONCE(*ptep, new);
> +               dsb(ishst);
> +       } else {
> +               smp_store_release(ptep, new);
> +       }
> +}
> +
>  static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>                            u32 level, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -760,18 +882,17 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         else
>                 new = kvm_init_invalid_leaf_owner(data->owner_id);
>
> -       if (stage2_pte_is_counted(old)) {
> -               /*
> -                * Skip updating the PTE if we are trying to recreate the exact
> -                * same mapping or only change the access permissions. Instead,
> -                * the vCPU will exit one more time from guest if still needed
> -                * and then go through the path of relaxing permissions.
> -                */
> -               if (!stage2_pte_needs_update(old, new))
> -                       return -EAGAIN;
> +       /*
> +        * Skip updating the PTE if we are trying to recreate the exact same
> +        * mapping or only change the access permissions. Instead, the vCPU will
> +        * exit one more time from the guest if still needed and then go through
> +        * the path of relaxing permissions.
> +        */
> +       if (!stage2_pte_needs_update(old, new))
> +               return -EAGAIN;
>
> -               stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> -       }
> +       if (!stage2_try_break_pte(ptep, old, addr, level, shared, data))
> +               return -EAGAIN;
>
>         /* Perform CMOs before installation of the guest stage-2 PTE */
>         if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> @@ -781,9 +902,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>         if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
>                 mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>
> -       smp_store_release(ptep, new);
> -       if (stage2_pte_is_counted(new))
> -               mm_ops->get_page(ptep);
> +       stage2_make_pte(ptep, new, data->mm_ops);
>         if (kvm_phys_is_valid(phys))
>                 data->phys += granule;
>         return 0;
> @@ -800,15 +919,10 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
>         if (!stage2_leaf_mapping_allowed(addr, end, level, data))
>                 return 0;
>
> -       data->childp = kvm_pte_follow(*old, data->mm_ops);
> -       kvm_clear_pte(ptep);
> +       if (!stage2_try_break_pte(ptep, *old, addr, level, shared, data))
> +               return -EAGAIN;
>
> -       /*
> -        * Invalidate the whole stage-2, as we may have numerous leaf
> -        * entries below us which would otherwise need invalidating
> -        * individually.
> -        */
> -       kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> +       data->childp = kvm_pte_follow(*old, data->mm_ops);
>         data->anchor = ptep;
>         return 0;
>  }
> @@ -837,18 +951,24 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>         if (!data->memcache)
>                 return -ENOMEM;
>
> +       if (!stage2_try_break_pte(ptep, *old, addr, level, shared, data))
> +               return -EAGAIN;
> +
>         childp = mm_ops->zalloc_page(data->memcache);
> -       if (!childp)
> +       if (!childp) {
> +               /*
> +                * Release the pte if we were unable to install a table to allow
> +                * another thread to make an attempt.
> +                */
> +               stage2_make_pte(ptep, 0, data->mm_ops);
>                 return -ENOMEM;
> +       }
>
>         /*
>          * If we've run into an existing block mapping then replace it with
>          * a table. Accesses beyond 'end' that fall within the new table
>          * will be mapped lazily.
>          */
> -       if (stage2_pte_is_counted(*old))
> -               stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> -
>         kvm_set_table_pte(ptep, childp, mm_ops);
>         mm_ops->get_page(ptep);
>         *old = *ptep;
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
