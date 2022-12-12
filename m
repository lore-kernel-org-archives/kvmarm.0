Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492A53B9
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 19:32:17 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id x24so5586864qkf.5
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 11:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mowh6IPNmR3LfyP4Dfupt4EtlOdkli9ymGjaw17vXI=;
        b=rm4I+wZFg2eJb2x8Va4Maw+iWq9AhwTPFcd5+4c65xHXN6A5VLXkr9Pzd+ERVn8WhT
         rXhKRHb0OCZ+Y251Cv06Op2FK6vM2ZvEcORuna52lFhL+6E0foSYaY0b0PInsi9lsPV8
         Bgem1uzt3AsOakc9GqY8CaGWz+mrz3XBlCJqtwog7YunyQdMthSrwnUiksKZYyXlRAE0
         U9EOqeHbYuzJisNspTwwqAApwqaC+6zidytdTp+shU4lKB0hfKRno0XiysILsLDo8L/z
         g3pQYrNCjufpK6hqXNdALJyiGfuRRPgueVHAc2pb1HOTaCnJmd2+UOOHx+8cakJYk0rR
         nBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Mowh6IPNmR3LfyP4Dfupt4EtlOdkli9ymGjaw17vXI=;
        b=7w95MM6QsfEkrmcE/Fq2Hh8vY7f0Ox3ux7eVxBcsOzDqPOSghmsEJMHj/qKTnsQw+/
         K56+l92GCHgZROimpGuUNN5NiMNON/Obt/wvBlOgXtx0Sv2k38KgcrUr924tbK02gDJT
         FQB3RQdrHdGWmNHbHi4fza3d0BkSO4/9XBq/I/vjLND7WeqXHc28mPcrvFGGlGf4QFlk
         iFsSx7JQ2die6DN8IhPKxKT0ZA7KvS5UEhuqivOU5Sp0h/wGU91OBPsefdaKbGIqZ4m5
         diXP5wOqZF9nrqHmcmGcyRZ0TDBUVoqyHSa66muJe9E8g2aurIn1WqHQyl9ykVgrLw/k
         X5Sg==
X-Gm-Message-State: ANoB5pkT0PvgQOt8584qHOvEWTBRk00rNdCIzZ8dX9iaXXdNv5SAtv44
	15QJOeTMn1cYpv5sd44lRY6hntYNLlnafrOiW5snKQ==
X-Google-Smtp-Source: AA0mqf76PYiP6JK2x7WnSIvO5AyXyfgzfQ+XX+DgyhybSiTFwMNyTSUY4u6lHGW51+1mrY7J65iPpmVnUeYRL2TUxNA=
X-Received: by 2002:a05:620a:4394:b0:6ff:680:f3c with SMTP id
 a20-20020a05620a439400b006ff06800f3cmr1474664qkp.670.1670873535923; Mon, 12
 Dec 2022 11:32:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-21-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-21-dmatlack@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 12 Dec 2022 11:32:05 -0800
Message-ID: <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Nadav Amit <namit@vmware.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Mingwei Zhang <mizhang@google.com>, Krish Sadhukhan <krish.sadhukhan@oracle.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221212193205.FgOyWGe4lunwp4YC3qLTiKfd0N9Fe85EQGYXUfuwPwQ@z>

On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
>
> Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
> function for computing the max level that a given GFN can be mapped in
> KVM's page tables. This will be used in a future commit to enable moving
> the TDP MMU to common code.
>
> Provide a default implementation for non-x86 architectures that just
> returns the max level. This will result in more zapping than necessary
> when disabling dirty logging (i.e. less than optimal performance) but no
> correctness issues.

Apologies if you already implemented it in a later patch in this
series, but would it not at least be possible to port
host_pfn_mapping_level to common code and check that?
I'm assuming, though I could be wrong, that all archs map GFNs with at
most a host page table granularity mapping.
I suppose that doesn't strictly need to be included in this series,
but it would be worth addressing in the commit description.

>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c     | 14 ++++++++++----
>  arch/x86/kvm/mmu/tdp_pgtable.c |  7 +++++++
>  2 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7670fbd8e72d..24d1dbd0a1ec 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1696,6 +1696,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>                 clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
>  }
>
> +__weak int tdp_mmu_max_mapping_level(struct kvm *kvm,
> +                                    const struct kvm_memory_slot *slot,
> +                                    struct tdp_iter *iter)
> +{
> +       return TDP_MAX_HUGEPAGE_LEVEL;
> +}
> +
>  static void zap_collapsible_spte_range(struct kvm *kvm,
>                                        struct kvm_mmu_page *root,
>                                        const struct kvm_memory_slot *slot)
> @@ -1727,15 +1734,14 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>                 /*
>                  * If iter.gfn resides outside of the slot, i.e. the page for
>                  * the current level overlaps but is not contained by the slot,
> -                * then the SPTE can't be made huge.  More importantly, trying
> -                * to query that info from slot->arch.lpage_info will cause an
> +                * then the SPTE can't be made huge. On x86, trying to query
> +                * that info from slot->arch.lpage_info will cause an
>                  * out-of-bounds access.
>                  */
>                 if (iter.gfn < start || iter.gfn >= end)
>                         continue;
>
> -               max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> -                                                             iter.gfn, PG_LEVEL_NUM);
> +               max_mapping_level = tdp_mmu_max_mapping_level(kvm, slot, &iter);
>                 if (max_mapping_level < iter.level)
>                         continue;
>
> diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
> index b07ed99b4ab1..840d063c45b8 100644
> --- a/arch/x86/kvm/mmu/tdp_pgtable.c
> +++ b/arch/x86/kvm/mmu/tdp_pgtable.c
> @@ -163,3 +163,10 @@ void tdp_mmu_arch_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>         if (shared)
>                 spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  }
> +
> +int tdp_mmu_max_mapping_level(struct kvm *kvm,
> +                             const struct kvm_memory_slot *slot,
> +                             struct tdp_iter *iter)
> +{
> +       return kvm_mmu_max_mapping_level(kvm, slot, iter->gfn, PG_LEVEL_NUM);
> +}
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
