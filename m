Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F840EBF6
	for <kvmarm@lists.linux.dev>; Wed,  9 Nov 2022 22:23:59 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id s4so41103qtx.6
        for <kvmarm@lists.linux.dev>; Wed, 09 Nov 2022 14:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w5/EZUdDhtVCH8vTuPdQHSfkRC7SLLFLdcojKP24b3k=;
        b=p5Cuz9SiXRLDID2KLBRc7xBDhTgKAQtnvu1No40nnQ14HV0/EH9fLPUFxFbuQB8mt9
         fpC5T+QHlENlj/TVgJYL+wKK219fkUBqaEdGubQWvGUKCEJig0Btqie1vi7NbpDjMuRU
         jX5ZdiNetYXlROw2fkZB1yAoauQTkHpE+0Jk5LBqTb6EgXr82vNcVK10qAEfdJzHxhba
         /R9ThS3QNoKHzgaEdkxPxv8zQkrZgVEe9ET2PCToZV3S9Nz6/qxGBQKU66LtpeOUPB6S
         pq9ZLyNYp0lgULr/8gixPHf08socAIlOpx7Kk8SraN0RzdLtoDs+HZpJXXOY66H/gQVm
         c5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5/EZUdDhtVCH8vTuPdQHSfkRC7SLLFLdcojKP24b3k=;
        b=l/pAq4ZaQhEtFnsYwrQx7hJiiHW/VPGIVjY+v53pkrrcDTjB/Smf0s+R6JKVW0yzRp
         YIeJXuKvTV67Pn/Z6WcMHAyeB504Zr8Q7435NfM9KPIv2n2uSxff1haCYaH7KxTapf0c
         vdri8r2124HTmZVEPwMAVgUAk5zu1qv6JTwsZ6FmBpZ0BpzljYfb+j2OQgSPUtNWjqER
         7gVjtumfWcI6rPtF535/QUJCvOq0XAjMdWTFznPjnGk9+3iV8we3TRudJHK5ProLkLqB
         Ut1KS1Rp8EFqDKjqLGuqIUMX5gv2lWdunWFlsjJU/Auk/51pEQnG8Da1pTgGAxu53A8M
         IA6A==
X-Gm-Message-State: ACrzQf3r5ZsuYGoF4BImvEe35aqhuwBH14IqsbngDUbslJk+GUhSoWnZ
	xsytAUlfb7VwKxbh7oA6eX8tiLAvh7R2l0yPJDPu3A==
X-Google-Smtp-Source: AMsMyM7PvGCnAK5sM25XaFmsHhngdZKUVCNI4eyBriYVD5YZUFXb5dnYYME1f779JG8sEFkUd3Pu1eE6GRqa+981FmU=
X-Received: by 2002:ac8:7d4d:0:b0:3a5:5987:432b with SMTP id
 h13-20020ac87d4d000000b003a55987432bmr26352212qtb.566.1668032638369; Wed, 09
 Nov 2022 14:23:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221107215644.1895162-1-oliver.upton@linux.dev> <20221107215644.1895162-7-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-7-oliver.upton@linux.dev>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 9 Nov 2022 14:23:47 -0800
Message-ID: <CANgfPd-g4fdWEkX8EHWd3PdDQhEMSmsE5ET7PzWMwz5KoAy5Gw@mail.gmail.com>
Subject: Re: [PATCH v5 06/14] KVM: arm64: Use an opaque type for pteps
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	David Matlack <dmatlack@google.com>, Quentin Perret <qperret@google.com>, Gavin Shan <gshan@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221109222347.XdF7yrHKtjP5sl47coCYtuti1pjohpgkuDT8AUpA0jk@z>

On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Use an opaque type for pteps and require visitors explicitly dereference
> the pointer before using. Protecting page table memory with RCU requires
> that KVM dereferences RCU-annotated pointers before using. However, RCU
> is not available for use in the nVHE hypervisor and the opaque type can
> be conditionally annotated with RCU for the stage-2 MMU.
>
> Call the type a 'pteref' to avoid a naming collision with raw pteps. No
> functional change intended.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  9 ++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++-------------
>  arch/arm64/kvm/mmu.c                 |  2 +-
>  3 files changed, 23 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 93b1feeaebab..cbd2851eefc1 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>
>  typedef u64 kvm_pte_t;
>
> +typedef kvm_pte_t *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)

Since shared is not used and never true as of this commit, it would
probably be worth explaining what it's for in the change description.


> +{
> +       return pteref;
> +}
> +
>  #define KVM_PTE_VALID                  BIT(0)
>
>  #define KVM_PTE_ADDR_MASK              GENMASK(47, PAGE_SHIFT)
> @@ -175,7 +182,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>  struct kvm_pgtable {
>         u32                                     ia_bits;
>         u32                                     start_level;
> -       kvm_pte_t                               *pgd;
> +       kvm_pteref_t                            pgd;
>         struct kvm_pgtable_mm_ops               *mm_ops;
>
>         /* Stage-2 only */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 363a5cce7e1a..7511494537e5 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -175,13 +175,14 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>  }
>
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -                             struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level);
> +                             struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level);
>
>  static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                                       struct kvm_pgtable_mm_ops *mm_ops,
> -                                     kvm_pte_t *ptep, u32 level)
> +                                     kvm_pteref_t pteref, u32 level)
>  {
>         enum kvm_pgtable_walk_flags flags = data->walker->flags;
> +       kvm_pte_t *ptep = kvm_dereference_pteref(pteref, false);
>         struct kvm_pgtable_visit_ctx ctx = {
>                 .ptep   = ptep,
>                 .old    = READ_ONCE(*ptep),
> @@ -193,7 +194,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 .flags  = flags,
>         };
>         int ret = 0;
> -       kvm_pte_t *childp;
> +       kvm_pteref_t childp;
>         bool table = kvm_pte_table(ctx.old, level);
>
>         if (table && (ctx.flags & KVM_PGTABLE_WALK_TABLE_PRE))
> @@ -214,7 +215,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>                 goto out;
>         }
>
> -       childp = kvm_pte_follow(ctx.old, mm_ops);
> +       childp = (kvm_pteref_t)kvm_pte_follow(ctx.old, mm_ops);
>         ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
>         if (ret)
>                 goto out;
> @@ -227,7 +228,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
>  }
>
>  static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> -                             struct kvm_pgtable_mm_ops *mm_ops, kvm_pte_t *pgtable, u32 level)
> +                             struct kvm_pgtable_mm_ops *mm_ops, kvm_pteref_t pgtable, u32 level)
>  {
>         u32 idx;
>         int ret = 0;
> @@ -236,12 +237,12 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>                 return -EINVAL;
>
>         for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
> -               kvm_pte_t *ptep = &pgtable[idx];
> +               kvm_pteref_t pteref = &pgtable[idx];
>
>                 if (data->addr >= data->end)
>                         break;
>
> -               ret = __kvm_pgtable_visit(data, mm_ops, ptep, level);
> +               ret = __kvm_pgtable_visit(data, mm_ops, pteref, level);
>                 if (ret)
>                         break;
>         }
> @@ -262,9 +263,9 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
>                 return -EINVAL;
>
>         for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
> -               kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
> +               kvm_pteref_t pteref = &pgt->pgd[idx * PTRS_PER_PTE];
>
> -               ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
> +               ret = __kvm_pgtable_walk(data, pgt->mm_ops, pteref, pgt->start_level);
>                 if (ret)
>                         break;
>         }
> @@ -507,7 +508,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
>  {
>         u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
>
> -       pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
> +       pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_page(NULL);
>         if (!pgt->pgd)
>                 return -ENOMEM;
>
> @@ -544,7 +545,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>         };
>
>         WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> -       pgt->mm_ops->put_page(pgt->pgd);
> +       pgt->mm_ops->put_page(kvm_dereference_pteref(pgt->pgd, false));
>         pgt->pgd = NULL;
>  }
>
> @@ -1157,7 +1158,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>         u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>
>         pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
> -       pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
> +       pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
>         if (!pgt->pgd)
>                 return -ENOMEM;
>
> @@ -1200,7 +1201,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>
>         WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
>         pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
> -       pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> +       pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(pgt->pgd, false), pgd_sz);
>         pgt->pgd = NULL;
>  }
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 60ee3d9f01f8..5e197ae190ef 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -640,7 +640,7 @@ static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
>  static int get_user_mapping_size(struct kvm *kvm, u64 addr)
>  {
>         struct kvm_pgtable pgt = {
> -               .pgd            = (kvm_pte_t *)kvm->mm->pgd,
> +               .pgd            = (kvm_pteref_t)kvm->mm->pgd,
>                 .ia_bits        = VA_BITS,
>                 .start_level    = (KVM_PGTABLE_MAX_LEVELS -
>                                    CONFIG_PGTABLE_LEVELS),
> --
> 2.38.1.431.g37b22c650d-goog
>
