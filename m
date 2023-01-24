Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A3A7C
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 01:03:36 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id w14so16678552edi.5
        for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 17:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kdLCNu5g0MEWkTl6tJScXbNxCMJ8U+qIEm3Aol/ITa0=;
        b=URLmVirikmUa4T1zkW6InNmOqlSKCTmsD0IbC2AiBdaR7g8gxec2vugC7lXJ8h7a0C
         ouoHs2GZF2cMMR+/UpM1c8dXPKHVGrIIIX3a675dp6P1wMZf2wJRWt2Ips27f5/GxmJL
         zKHys07lF/E0xpp7BplTG95jfkd0Obo/oz8WClok8umhcgYOTMr1whh4eT6gKXkVTbUr
         4IxRJGAM/8ZIV73L5HmHA6JjtKUib7sNCJCZTEYPkCt+1GQDsEoWFBsfr+nvDKhqfZ01
         8dVdcII1EMPuWAlzGARCmYlyDX/RAFQgh98QaKLqGmRh9w4nc9mtp0EoowA0vj6Q/AZh
         fFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kdLCNu5g0MEWkTl6tJScXbNxCMJ8U+qIEm3Aol/ITa0=;
        b=wpd8ZZRYHFSbjsknOsv3Hx8WAfM39e3zYmsB9ubiqD59IhpmTN1zzaP7oI1Ra6o75H
         +BPxZVJMmq2iB+WEQDzAn5YvOqv2/egGRgmg9eGPLjLO/J7rSnXQCi8YXDdNvaYYiFfe
         dCLxjyHfj43zbVGp7LnvWJWfL3gQj6He9wzd773qM5lY/DLShBG3cOV3C92lBXj6sjaI
         5Rwt0gMiaLn5RzpdrcBkPDCsxt1fDDv7lB/8xQ82+nxJJZ7HiLHlOKsvWGTzaadh0tSz
         PFbeSs9muU1SWY2ZAcPpao2ndnyOk7WmShsl4HCAaw3GMyamL0r9UYUeRhWu+/fTH4m2
         aUrg==
X-Gm-Message-State: AFqh2kqPFOjZ3bPZRRE+tNwiAoTAYWGFUf9oGzU/uC7ghxAhCXJ/R1Td
	xu3sh4RhMUVkxv4B7SI5g+xzzb352dF3y9xXXQaaeg==
X-Google-Smtp-Source: AMrXdXtkBsLV+yHlXs66c/nt+Q3Yj/xqGrGw5sOBktBjaUUwEdx1r0FKYFwPaUx6lcJPb2Gde+GQpnjUGQOJLAs7Wp8=
X-Received: by 2002:a05:6402:40a:b0:49d:aca5:9ae0 with SMTP id
 q10-20020a056402040a00b0049daca59ae0mr3275286edv.106.1674522214798; Mon, 23
 Jan 2023 17:03:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-4-ricarkol@google.com>
In-Reply-To: <20230113035000.480021-4-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 23 Jan 2023 17:03:23 -0800
Message-ID: <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a new stage2 function, kvm_pgtable_stage2_split(), for splitting a
> range of huge pages. This will be used for eager-splitting huge pages
> into PAGE_SIZE pages. The goal is to avoid having to split huge pages
> on write-protection faults, and instead use this function to do it
> ahead of time for large ranges (e.g., all guest memory in 1G chunks at
> a time).
>
> No functional change intended. This new function will be used in a
> subsequent commit.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 29 ++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 67 ++++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8ad78d61af7f..5fbdc1f259fd 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -644,6 +644,35 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>   */
>  int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>
> +/**
> + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> + *                             to PAGE_SIZE guest pages.
> + * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> + * @addr:      Intermediate physical address from which to split.
> + * @size:      Size of the range.
> + * @mc:                Cache of pre-allocated and zeroed memory from which to allocate
> + *             page-table pages.
> + *
> + * @addr and the end (@addr + @size) are effectively aligned down and up to
> + * the top level huge-page block size. This is an exampe using 1GB

Nit: example

> + * huge-pages and 4KB granules.
> + *
> + *                          [---input range---]
> + *                          :                 :
> + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> + *                          :                 :
> + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> + *                          :                 :
> + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> + *                          :                 :
> + *
> + * Return: 0 on success, negative error code on failure. Note that
> + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> + * blocks in the input range as allowed by the size of the memcache. It
> + * will fail it wasn't able to break any block.
> + */
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:       Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0dee13007776..db9d1a28769b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1229,6 +1229,73 @@ int kvm_pgtable_stage2_create_removed(struct kvm_pgtable *pgt,
>         return 0;
>  }
>
> +struct stage2_split_data {
> +       struct kvm_s2_mmu               *mmu;
> +       void                            *memcache;
> +};
> +
> +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +                              enum kvm_pgtable_walk_flags visit)
> +{
> +       struct stage2_split_data *data = ctx->arg;
> +       struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> +       kvm_pte_t pte = ctx->old, new, *childp;
> +       enum kvm_pgtable_prot prot;
> +       void *mc = data->memcache;
> +       u32 level = ctx->level;
> +       u64 phys;
> +       int ret;
> +
> +       /* Nothing to split at the last level */

Would it be accurate to say:
/* No huge pages can exist at the root level, so there's nothing to
split here. */

I think of "last level" as the lowest/leaf/4k level but
KVM_PGTABLE_MAX_LEVELS - 1 is 3? Does ARM do the level numbering in
reverse order to x86?

> +       if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +               return 0;
> +
...
