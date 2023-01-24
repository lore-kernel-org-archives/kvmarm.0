Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCB063DD
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 16:47:03 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id k10-20020a17090a590a00b0022ba875a1a4so12192885pji.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 08:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2vljj7/rdtQykCKsPt9Lrxa/Bdn+0oX4iO+vjCUfhs=;
        b=ANrakzH3C16ULOMIEY/BZEPj1ls68o1YfavF/fITWb8/IFs4PK3beAFyh+RQnPO6/h
         irPZElwWhkUOxWXbQvL9nI5/xlpSSf3TjA762P2/zJD+p9UNrCjA7gEQZ8SP2e6YrcUO
         BgXhphge991wKezRrPsDBRhv9eZr2jjBGekzRShJpOQDwpFxt0jAQWKyK9EAiR5omoOY
         rh/Gm/igDkIUgSsQunqc0nRJDqEtj/bo4YXh0MR4/dwZkYTxt63uAZzC16Sb+tRCArTY
         2Nxnz+3es6F6Km38oJjFUrWuxJAcZN3YHDGDCPYHelWEHH9zzVCOMKIy8I/4dmm0WCYt
         74IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2vljj7/rdtQykCKsPt9Lrxa/Bdn+0oX4iO+vjCUfhs=;
        b=Z4SxaCiYnSoIoJspYWO0AIkHD9ebl2jukVCjiny6iU0NrUdqaSh66yl6lAsPWZjm3m
         i/YTJIHiyvjkcKnCLlUU0sV8Z34vDMrc35e2RTkwNxmooF5cURFNwzNOcQ/aYEtdB3Qs
         qLiaRzcP2Hve2eSInF2bRXEjDQiIoUm51qV0VYYcHv/mEVkzhD+x8swNgnfK1Qi6Q/mp
         jwYJARtUbJcBkK6GBLGQaGlIjYNCTfBbLwv0Tvd+YcajSFjwglA4y5rv0tQ74T3f2DeY
         Z0bxphJNxl/hqXHcNaHiUPDttsvcoZSzF0e6TkF+j6c7aur6yugXlBUbjM5Rh2XgcZlc
         d/Fg==
X-Gm-Message-State: AO0yUKWFfdZUoFRGLxZOuo6ybqdu693yUgXk9PPGZUTk5nSAC1yuSrjx
	V5KjTWN1RcXGOkNEX3ZYRGCN9vueTaq4ql/lTG3JHg==
X-Google-Smtp-Source: AK7set9dmEzbuvISFTxpA3kBoxr52roVrkQ3u6KEsOYgXSAczuLougmffnVtl9e2K1VoYPjnBUpUGw==
X-Received: by 2002:a17:90a:690e:b0:22b:b82a:8b5f with SMTP id r14-20020a17090a690e00b0022bb82a8b5fmr258530pjj.2.1674578822337;
        Tue, 24 Jan 2023 08:47:02 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a3b0e00b00229962d07bcsm1789692pjc.6.2023.01.24.08.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:47:01 -0800 (PST)
Date: Tue, 24 Jan 2023 08:46:58 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Ben Gardon <bgardon@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com,
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y9ALgtnd+h9ivn90@google.com>
References: <20230113035000.480021-1-ricarkol@google.com>
 <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>

On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:
> On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> > range of huge pages. This will be used for eager-splitting huge pages
> > into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> > on write-protection faults, and instead use this function to do it
> > ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> > a time).
> >
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
> >  2 files changed, 96 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 8ad78d61af7f..5fbdc1f259fd 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> >   */
> >  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *                             to PAGE_SIZE guest pages.
> > + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @addr:      Intermediate physical address from which to split.
> > + * @size:      Size of the range.
> > + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> > + *             page-table pages.
> > + *
> > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > + * the top level huge-page block size. This is an exampe using 1GB
> 
> Nit: example
> 
> > + * huge-pages and 4KB granules.
> > + *
> > + *                          [---input range---]
> > + *                          :                 :
> > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > + *                          :                 :
> > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > + *                          :                 :
> > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > + *                          :                 :
> > + *
> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by the size of the memcache. It
> > + * will fail it wasn't able to break any block.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_walk() - Walk a page-table.
> >   * @pgt:       Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 0dee13007776..db9d1a28769b 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
> >         return 0;
> >  }
> >
> > +struct stage2_split_data {
> > +       struct kvm_s2_mmu               *mmu;
> > +       void                            *memcache;
> > +};
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +                              enum kvm_pgtable_walk_flags visit)
> > +{
> > +       struct stage2_split_data *data = ctx->arg;
> > +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > +       kvm_pte_t pte = ctx->old, new, *childp;
> > +       enum kvm_pgtable_prot prot;
> > +       void *mc = data->memcache;
> > +       u32 level = ctx->level;
> > +       u64 phys;
> > +       int ret;
> > +
> > +       /* Nothing to split at the last level */
> 
> Would it be accurate to say:
> /* No huge pages can exist at the root level, so there's nothing to
> split here. */
> 
> I think of "last level" as the lowest/leaf/4k level but
> KVM_PGTABLE_MAX_LEVELS - 1 is 3? 

Right, this is the 4k level.

> Does ARM do the level numbering in
> reverse order to x86?

Yes, it does. Interesting, x86 does

	iter->level--;

while arm does:

	ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);

I don't think this numbering scheme is encoded anywhere in the PTEs, so
either architecture could use the other.


> 
> > +       if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +               return 0;
> > +
> ...
