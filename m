Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876516FC2
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 16:25:14 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id z5so22339198qtn.8
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 08:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AFepK2rkB6ezD70sOO4MhlZcyxN8oS1icDWJsj/PPKQ=;
        b=Qhoq6nyimphHqRE5WzVN8RgkyLd4oDJPLhqmOaXFoUid4CPWPTXVbx5yfIcS/DOpDi
         Q66ZjIRewef/dTRmmUZgomkm9Zy1xH+8qmHVBQ8bgeRyLulUUHGdB6RbVOZ7mtVrdILk
         4N7yn9eJ/7b0IwZHWlL0nh9QjVDOJuijesSDZ/8rzE+ihdxXQwVLvCiFCgFTclMcaG5x
         RbqeniZ0qbfppXUI3yQWv6m5/JOGgE9m0961DBmvFhyq59PuPQ63p9Olt1BIvoED6GOo
         aaRL6rERcJQWqI+1IFfJ5Asu6m84awWlRbc3hzZ7WSly5iAsVvZGHX4C5K5mP8sGf5ZL
         GamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFepK2rkB6ezD70sOO4MhlZcyxN8oS1icDWJsj/PPKQ=;
        b=pNPcDtkmlliWwiO2Y3z039w3WKOTX4tuGjpErXrzmGbLuP2M/gJYzg2ojWP/1wACwB
         UxNqBoWnxKNSL6Xn7sAkjjeA5RynFXajFuezd6RcyFB6MZpW1MxfDhy44k7v40h5YB2B
         F2cQhsKKl9Ciy2DvaV6qdeW2uoGoGtHOdOrATFFvK/9KEgZWmxTHP3sSwjHz98FXS1oc
         ckDEonoNz1MBjVcqkscA2nRVjOWboDk6ipx/5nwrSHF8LpyRAGcYFF0ftFc3oVSA1QYj
         TKCLnPEju/5fauB5t0bivTGSNWdq2tgS3dqrfbl+pEgr2nw3keXG+YK/rNVhN6pzw77O
         oa7w==
X-Gm-Message-State: AO0yUKWFMSoG5rEl+NuSnQVBrYDBRm2KGrqQlH52gDfs0Po3QOpOkLhh
	nISjH/1z6yZdC/yskJTGFf3TLO4HAyPG4eZCJXWJCw==
X-Google-Smtp-Source: AK7set9ikM4pL943zsnOf8yKyyR11BmkOt0tLqoP8fuVV3p3LRQ9jdICX6UpZLZ8msIH4DpPAMZoNgO+hZsONxK16LM=
X-Received: by 2002:ac8:58cb:0:b0:3ba:240b:99ad with SMTP id
 u11-20020ac858cb000000b003ba240b99admr355236qta.65.1676478313326; Wed, 15 Feb
 2023 08:25:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-10-ricarkol@google.com>
 <9201764f-baa1-250a-39ac-0305bce789a3@redhat.com> <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
In-Reply-To: <CAOHnOrzGXU29JK+8aRq0SnMe6Ske04YWffJhPU6iUXjGyyoQtA@mail.gmail.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Wed, 15 Feb 2023 08:25:02 -0800
Message-ID: <CAOHnOrwZGyzARsOqfgNGk9cH4rUoi-FyKXbbKa-fu=MzA+yO1g@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] KVM: arm64: Split huge pages when dirty logging
 is enabled
To: Gavin Shan <gshan@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, reijiw@google.com, 
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

> > > +
> > > +             next = __stage2_range_addr_end(addr, end, chunk_size);
> > > +             ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
> > > +                                            cache, cache_capacity);
> > > +             if (ret)
> > > +                     break;
> > > +     } while (addr = next, addr != end);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > >   #define stage2_apply_range_resched(kvm, addr, end, fn)                      \
> > >       stage2_apply_range(kvm, addr, end, fn, true)
> > >
> >
> > I'm wandering if stage2_apply_range() can be reused to avoid invent another similar
> > function. the gap are the granularity and conditions to reschedule.
>
> Will try and see what it looks like and report back.
>

Tried and don't like the result very much:

static int _stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
phys_addr_t end,
                               int (*fn)(struct kvm_pgtable *, u64,
u64),
                               bool fn_ignore_failures, bool
fn_drop_mmu_lock,
                               struct kvm_mmu_memory_cache *cache, int
cache_capacity,
                               bool resched)

The generic function would require too many arguments to work for all cases.

Thanks,
Ricardo
