Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5294CEACF
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 05:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I59idK8K"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cfd9ce0745so48735ad.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 21:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701149968; x=1701754768; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hd11373At0fgNthDfz475jB2pnftz8WhsrA0gYblitY=;
        b=I59idK8KnOC66u+JrUhEtPFRxgd+va1+NXJwNdBI1S1/KkFS8CTeafMcfRCsaxTk+w
         QAgI67yVYHihZdMng7F9JC2EOvCLFb1/ABPqR9d6u51tp6DbUM49i5D/pyLjb1CuoXBf
         GgqBA4Xxj+BqcA7dz2aydKHGYAfw7VhhHAvGwjJ1DMt+/+WguIOY6kCvrDql5xXYTss1
         5RjZXjfcp4GxQPNXHLxlxDugZT6FMmj5+gFB2PY1PQ6s3wFkxmIQR1zxqVOEH0dCp+X/
         KrlnTVFPGAvAQJ+ekoiPuX8cseb6KEVzOK4WgUZAVJc+B7NmJl7rjOwofk/W9JIDxNmx
         UwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701149968; x=1701754768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hd11373At0fgNthDfz475jB2pnftz8WhsrA0gYblitY=;
        b=HMenWnaTiUhQqxkChxoHgpjMHl9VfJ6zxEf3hvIpHezT1kUVjj2ko0A118WloHOSeb
         IoRmV3YzdUrWyH6WAEDVatmsaQCik737NLT2xE1ImVLKmBqwfF4rY+j9itHZDfhVoTpE
         jCnBSfiBU76NwUIZMpU0dc3rw9y4xgbvucxFmKDV6IKUQtE4yzM+C4pf4QDGZloJCtvK
         DkyzwPngly42WsIE0vzSwNUgdFqzP93mLKGqqeDGCyjKVK4IExH67F/ejshPtzM750mr
         vgJVvZo/kzPGKuJ+Z1t46x7LtSd1mvvUSNFEua40zMR0pT/OuamZJJBV1b5/9Z+KzZam
         lFNg==
X-Gm-Message-State: AOJu0YyqzJY71eAjcfTIhkdtxqDQJGGuriBTfyufj/0goatRRjMr6bth
	Ny2vC2L5bHOgsqDjkNZAV8ZSftAtS5RZk0Jr7bhDSA==
X-Google-Smtp-Source: AGHT+IHMM+TBLPbm7+22ArJ0V2KCgdhbcD8w4150pEudfRnDapexGxJDfjwu4kPbNStb74F9bfmDWp9Y8DnvbExoUpc=
X-Received: by 2002:a17:903:1206:b0:1cf:6f62:88d9 with SMTP id
 l6-20020a170903120600b001cf6f6288d9mr1243304plh.9.1701149968448; Mon, 27 Nov
 2023 21:39:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231119165721.9849-1-alexandru.elisei@arm.com> <20231119165721.9849-22-alexandru.elisei@arm.com>
In-Reply-To: <20231119165721.9849-22-alexandru.elisei@arm.com>
From: Peter Collingbourne <pcc@google.com>
Date: Mon, 27 Nov 2023 21:39:17 -0800
Message-ID: <CAMn1gO5WYC5Xx7LfBxN_j-xqkVT+tjXP5PqDfrvhgqPOa0ZCsA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 21/27] mm: arm64: Handle tag storage pages mapped
 before mprotect(PROT_MTE)
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, 
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, 
	mhiramat@kernel.org, rppt@kernel.org, hughd@google.com, steven.price@arm.com, 
	anshuman.khandual@arm.com, vincenzo.frascino@arm.com, david@redhat.com, 
	eugenis@google.com, kcc@google.com, hyesoo.yu@samsung.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexandru,

On Sun, Nov 19, 2023 at 8:59=E2=80=AFAM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/include/asm/mte_tag_storage.h |  1 +
>  arch/arm64/kernel/mte_tag_storage.c      | 15 +++++++
>  arch/arm64/mm/fault.c                    | 55 ++++++++++++++++++++++++
>  include/linux/migrate.h                  |  8 +++-
>  include/linux/migrate_mode.h             |  1 +
>  mm/internal.h                            |  6 ---
>  6 files changed, 78 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/mte_tag_storage.h b/arch/arm64/includ=
e/asm/mte_tag_storage.h
> index b97406d369ce..6a8b19a6a758 100644
> --- a/arch/arm64/include/asm/mte_tag_storage.h
> +++ b/arch/arm64/include/asm/mte_tag_storage.h
> @@ -33,6 +33,7 @@ int reserve_tag_storage(struct page *page, int order, g=
fp_t gfp);
>  void free_tag_storage(struct page *page, int order);
>
>  bool page_tag_storage_reserved(struct page *page);
> +bool page_is_tag_storage(struct page *page);
>
>  vm_fault_t handle_page_missing_tag_storage(struct vm_fault *vmf);
>  vm_fault_t handle_huge_page_missing_tag_storage(struct vm_fault *vmf);
> diff --git a/arch/arm64/kernel/mte_tag_storage.c b/arch/arm64/kernel/mte_=
tag_storage.c
> index a1cc239f7211..5096ce859136 100644
> --- a/arch/arm64/kernel/mte_tag_storage.c
> +++ b/arch/arm64/kernel/mte_tag_storage.c
> @@ -500,6 +500,21 @@ bool page_tag_storage_reserved(struct page *page)
>         return test_bit(PG_tag_storage_reserved, &page->flags);
>  }
>
> +bool page_is_tag_storage(struct page *page)
> +{
> +       unsigned long pfn =3D page_to_pfn(page);
> +       struct range *tag_range;
> +       int i;
> +
> +       for (i =3D 0; i < num_tag_regions; i++) {
> +               tag_range =3D &tag_regions[i].tag_range;
> +               if (tag_range->start <=3D pfn && pfn <=3D tag_range->end)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
>  int reserve_tag_storage(struct page *page, int order, gfp_t gfp)
>  {
>         unsigned long start_block, end_block;
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 6730a0812a24..964c5ae161a3 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -12,6 +12,7 @@
>  #include <linux/extable.h>
>  #include <linux/kfence.h>
>  #include <linux/signal.h>
> +#include <linux/migrate.h>
>  #include <linux/mm.h>
>  #include <linux/hardirq.h>
>  #include <linux/init.h>
> @@ -956,6 +957,50 @@ void tag_clear_highpage(struct page *page)
>  }
>
>  #ifdef CONFIG_ARM64_MTE_TAG_STORAGE
> +
> +#define MR_TAGGED_TAG_STORAGE  MR_ARCH_1
> +
> +extern bool isolate_lru_page(struct page *page);
> +extern void putback_movable_pages(struct list_head *l);

Could we move these declarations to a non-mm-internal header and
#include it instead of manually declaring them here?

> +
> +/* Returns with the page reference dropped. */
> +static void migrate_tag_storage_page(struct page *page)
> +{
> +       struct migration_target_control mtc =3D {
> +               .nid =3D NUMA_NO_NODE,
> +               .gfp_mask =3D GFP_HIGHUSER_MOVABLE | __GFP_TAGGED,
> +       };
> +       unsigned long i, nr_pages =3D compound_nr(page);
> +       LIST_HEAD(pagelist);
> +       int ret, tries;
> +
> +       lru_cache_disable();
> +
> +       for (i =3D 0; i < nr_pages; i++) {
> +               if (!isolate_lru_page(page + i)) {
> +                       ret =3D -EAGAIN;
> +                       goto out;
> +               }
> +               /* Isolate just grabbed another reference, drop ours. */
> +               put_page(page + i);
> +               list_add_tail(&(page + i)->lru, &pagelist);
> +       }
> +
> +       tries =3D 5;
> +       while (tries--) {
> +               ret =3D migrate_pages(&pagelist, alloc_migration_target, =
NULL, (unsigned long)&mtc,
> +                                   MIGRATE_SYNC, MR_TAGGED_TAG_STORAGE, =
NULL);
> +               if (ret =3D=3D 0 || ret !=3D -EBUSY)

This could be simplified to:

if (ret !=3D -EBUSY)

Peter
