Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6004B7B
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 17:43:26 +0000 (UTC)
Received: by mail-qv1-f51.google.com with SMTP id l7so8560530qvw.7
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 09:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676483005;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tiueSxPH/5XMq2okwELIwCkEeHw1Uv6uhMkuP28yRjI=;
        b=BrgSNZyXjhQJUqM/WJn/VeUjmhWHjH5OMxDQX7Dbd87++G6ZzReos0q5DO9hqPkLlp
         tI3mcWHBOZmUUiA6VJjJ+6xMDFYpfRclZRynpvXbq9QwZwchd5mIoZRwQxHP/TRuaFwS
         XtWBMKaMTXsTeU3Zdg6axqVtfZVM++48yywYYR/VJZqg+ykeh78PA4peuFBCXtrDjHbD
         ueUJYflyn5j7vEqm002Cm27n7CXFu9GaqiGXbhTozJFnPI/9PCMUNNTt/GSjeo3GSKuC
         e/7SHv3qzhsZPKrvgS8cGGz0dAi98kgQkqXJvN05R83NgMyc1ewZC6E2wfD1qjTJ+G1q
         nQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676483005;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tiueSxPH/5XMq2okwELIwCkEeHw1Uv6uhMkuP28yRjI=;
        b=XmxWsyve7ZVXwNLWdS0tW58jvv43WKWOpZ1KYrPQFf473N1p7JMn3EGKOrO7eVqyMG
         +7CsOkvISloYK66MRp/BzXQCo/LZl0LY4lIgh7SznFCrtZbzYdUs6Lsz0ybiGoRmXZMm
         86daR4w8X5GzIDuEiq2FFbu6IaXATy0R81LqwOuJPYPgriLwNandO12UwRvpUcHQeDsr
         rMz8gzwEuYb11H5y0u9qqvnRj/iKTcozpqJ7cSSe6G5VgQuXVnRnrUGUImtvXxtnBkfL
         0jAeCrIt0XCLYiIMTxdM92yQOmCmc1cLeLueP+wx1vM5QK6UadAvqh2u6oj4ybL6z9hr
         IQmw==
X-Gm-Message-State: AO0yUKXCZU+uUthhLN4GlbR5E1Gsu6In/uovcmWLtvcNMoPoadsuR+2d
	UrtE63pBVg/5akfGSOKR2sRPcQYNXU88bKqyeIvATg==
X-Google-Smtp-Source: AK7set+a5es9bxSHn3aiGfI4t3jgQHTlrPEsm/w+jNk+g8yEwbDTQChK8aA/CQgUD+G6tn4oiY4kWhI8V4PEqBbOi/U=
X-Received: by 2002:a0c:e086:0:b0:56e:a207:142d with SMTP id
 l6-20020a0ce086000000b0056ea207142dmr220072qvk.6.1676483005133; Wed, 15 Feb
 2023 09:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-5-ricarkol@google.com>
 <cae4a1d9-b5c2-2929-6d88-5a3fbe719651@redhat.com> <CAOHnOrxqEsbRD302Wwn9N06d6xj5NWy4p+C9DBjEm6Z4z2FvXg@mail.gmail.com>
 <CAOHnOrwprM8v3xXCA5sEVD1cHVQRS6vsPvdXiC1NocrzyQcoYw@mail.gmail.com> <e8513463-75cc-ca11-2fe8-1ba1b32411d8@redhat.com>
In-Reply-To: <e8513463-75cc-ca11-2fe8-1ba1b32411d8@redhat.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Wed, 15 Feb 2023 09:43:14 -0800
Message-ID: <CAOHnOryXUxZdeocg3YA8Qhu3xpXPFZVkQ0ZbO=YrcvDR1SYXow@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Gavin Shan <gshan@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, reijiw@google.com, 
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 9, 2023 at 2:48 PM Gavin Shan <gshan@redhat.com> wrote:
>
> On 2/10/23 3:17 AM, Ricardo Koller wrote:
> > "(> > > +     if (data->mc_capacity < nr_pages)
> >>>> +             return -ENOMEM;
> >>>> +
> >>>> +     phys = kvm_pte_to_phys(pte);
> >>>> +     prot = kvm_pgtable_stage2_pte_prot(pte);
> >>>> +
> >>>> +     ret = kvm_pgtable_stage2_create_unlinked(data->mmu->pgt, &new, phys,
> >>>> +                                              level, prot, mc, force_pte);
> >>>> +     if (ret)
> >>>> +             return ret;
> >>>> +
> >>>> +     if (!stage2_try_break_pte(ctx, data->mmu)) {
> >>>> +             childp = kvm_pte_follow(new, mm_ops);
> >>>> +             kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
> >>>> +             mm_ops->put_page(childp);
> >>>> +             return -EAGAIN;
> >>>> +     }
> >>>> +
> >>>> +     /*
> >>>> +      * Note, the contents of the page table are guaranteed to be made
> >>>> +      * visible before the new PTE is assigned because stage2_make_pte()
> >>>> +      * writes the PTE using smp_store_release().
> >>>> +      */
> >>>> +     stage2_make_pte(ctx, new);
> >>>> +     dsb(ishst);
> >>>> +     data->mc_capacity -= nr_pages;
> >>>> +     return 0;
> >>>> +}
> >>>> +
> >>>
> >>> I think it's possible 'data->mc_capability' to be replaced by 'mc->nobjs'
> >>> because they're same thing. With this, we needn't to maintain a duplicate
> >>> 'data->mc_capability' since 'data->mc' has been existing.
> >>
> >> Ah, nice, yes. That would be simpler.
> >>
> >
> > Actually, there's a complication. The memcache details are hidden
> > inside of pgtable.c,
> > so different types of memcaches (for vhe and nvhe) can be used for allocations.
> > Specifically, the memcache objects are passed as an opaque pointer ("void *")
> > and can be used with "struct hyp_pool" and "struct kvm_mmu_memory_cache".
> >
> > So, here are all the options that I can think of:
> >
> >          1. stage2_split_walker() is just used on the VHE case with the
> >          "struct kvm_mmu_memory_cache" memcache, so we could just use it
> >          instead of a "void *":
> >
> >                  kvm_pgtable_stage2_split(..., struct kvm_mmu_memory_cache *mc);
> >
> >          However, it could be used for the NVHE case as well, plus
> >          this would go against the overall design of pgtable.c which tries
> >          to use opaque objects for most things.
> >
> >          2. add a "get_nobjs()" method to both memcaches. This is tricky
> >          because "struct hyp_pool" doesn't directly track its capacity. I
> >          would rather not mess with it.
> >
> >          3. This whole accounting of available pages in the memcache is
> >          needed because of the way I implemented stage2_split_walker() and
> >          the memcache interface.  stage2_split_walker() tries to allocate
> >          as many pages for the new table as allowed by the capacity of the
> >          memcache. The issue with blindingly trying until the allocation
> >          fails is that kvm_mmu_memory_cache_alloc() WARNs and tries to
> >          allocate using GFP_ATOMIC when !nobjs. We don't want to do that,
> >          so we could extend kvm_pgtable_mm_ops.zalloc_page() with a
> >          NO_GFP_ATOMIC_ON_EMPTY (or similar). This flag would have to be
> >          ignored on the hyp side.
> >
> >          4. what this patch is currently doing: tracking the capacity by
> >          hand.
> >
> > I prefer options 4 and 3. WDYT?
> >
>
> Yeah, stage2_split_walker() is currently only used by VHE and it calls to
> stage2_map_walker() to create the unlinked page table, which is shared by
> VHE and nVHE. I think option 3 would be better than 4 because we generally
> just want to fetch the pre-allocated page table, instead of allocating a
> new page table with GFP_ATOMIC. However, I'm also fine with option 4. I

Going with option 4 then for version 3.

> think this can be improved in the future if you agree.

Definitely!

Thanks,
Ricardo

>
> >>
> >>>
> >>>> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >>>> +                          void *mc, u64 mc_capacity)
> >>>> +{
> >>>> +     struct stage2_split_data split_data = {
> >>>> +             .mmu            = pgt->mmu,
> >>>> +             .memcache       = mc,
> >>>> +             .mc_capacity    = mc_capacity,
> >>>> +     };
> >>>> +
> >>>> +     struct kvm_pgtable_walker walker = {
> >>>> +             .cb     = stage2_split_walker,
> >>>> +             .flags  = KVM_PGTABLE_WALK_LEAF,
> >>>> +             .arg    = &split_data,
> >>>> +     };
> >>>> +
> >>>> +     return kvm_pgtable_walk(pgt, addr, size, &walker);
> >>>> +}
> >>>> +
> >>>>    int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >>>>                              struct kvm_pgtable_mm_ops *mm_ops,
> >>>>                              enum kvm_pgtable_stage2_flags flags,
> >>>>
> >>>
>
> Thanks,
> Gavin
>
