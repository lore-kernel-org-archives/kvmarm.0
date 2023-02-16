Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2FF17D7
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 03:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676517202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zoOkEzB0kmRy+M/p48Af6Cj1FYB05AzmjRmk4oGhjFs=;
	b=aj9xGOtjKfhAYwZ5qB2oRWf1egLypfgQvwL6KXTcxLlEaB4M7tAa+7DGz6wrYL8eAgPXbl
	7bxHgxF8zXlngOzX3kLp7EetSy580HUetnlFgPgK5zmnI0fFOzuSG0aoqxx8QIZZZ5h2ug
	tTYcVeOVe6IhKy88oRg5QESuAWoPZJ0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-345-XtcA_Sb3MSiVDpPXuI1Low-1; Wed, 15 Feb 2023 22:13:20 -0500
X-MC-Unique: XtcA_Sb3MSiVDpPXuI1Low-1
Received: by mail-qv1-f69.google.com with SMTP id r10-20020a0562140c8a00b0056ed45f262dso407466qvr.11
        for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 19:13:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676517200;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zoOkEzB0kmRy+M/p48Af6Cj1FYB05AzmjRmk4oGhjFs=;
        b=cn7db/7Lcvg8uPbvb7Wa2zu2/p9d9yQs8NsHTAE6g4NXdCo5Hx2dvv9LnaecE+bbGT
         zyLHC5yozkcUukyFbdePwzy0vkmTlnoRKVEosX7z5hn/x3qCJFemMa8ggGtskpfJwu/K
         l9Wuba/GYiSImlyX97DFfdRE4x030t8KvibENELQiwjCtxkUYaczKtZ/ZMrGbmqqX4Dp
         Gy55VTiUs0rHjjVxBaKKPU2YyfakbJ0O42hyTeVVuv1EjlNAjB7DKycuWEmevtWtKFt4
         GmLzuKa1J+QGIXfOXCz3K2vkMaSNUIMo6kFWXsTwsfP3METcdHEn2xJE2YAsRbpZBCje
         na4Q==
X-Gm-Message-State: AO0yUKUdEu2cFBI3ArCXm75wYRvjKwNWvXkfQTEc9SDKVgFG0ta0YVhd
	AJkYhp3t32/rje77WKejIXGUBINdC7EOTaOjEtBC3fL+U/Wt7TLQYLzrFTu8aFIqpx30Th0pus7
	zZd9/RPe8W3RWg6ZP
X-Received: by 2002:a0c:b243:0:b0:56e:f7dd:47b7 with SMTP id k3-20020a0cb243000000b0056ef7dd47b7mr1288684qve.5.1676517199768;
        Wed, 15 Feb 2023 19:13:19 -0800 (PST)
X-Google-Smtp-Source: AK7set8E+mmOFuH3yf989H9X7PldHiXDI5VmmTALPKUYrEaEKqC/q5A5ipaOW/+iVa3MUekWFsCcJQ==
X-Received: by 2002:a0c:b243:0:b0:56e:f7dd:47b7 with SMTP id k3-20020a0cb243000000b0056ef7dd47b7mr1288657qve.5.1676517199521;
        Wed, 15 Feb 2023 19:13:19 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u63-20020a379242000000b00731c30ac2e8sm322365qkd.74.2023.02.15.19.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 19:13:19 -0800 (PST)
Message-ID: <85bbfda3-405d-9bd5-d5fa-f2e14c3acad7@redhat.com>
Date: Thu, 16 Feb 2023 11:13:11 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 02/12] KVM: arm64: Rename free_unlinked to free_removed
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230215174046.2201432-1-ricarkol@google.com>
 <20230215174046.2201432-3-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230215174046.2201432-3-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 2/16/23 01:40, Ricardo Koller wrote:
> Make it clearer that the "free_removed" functions refer to tables that
> have never been part of the paging structure: they are "unlinked".
>
> No functional change intended.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
>   arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
>   arch/arm64/kvm/mmu.c                  | 10 +++++-----
>   4 files changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 3339192a97a9..7c45082e6c23 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -99,7 +99,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>    *				allocation is physically contiguous.
>    * @free_pages_exact:		Free an exact number of memory pages previously
>    *				allocated by zalloc_pages_exact.
> - * @free_removed_table:		Free a removed paging structure by unlinking and
> + * @free_unlinked_table:	Free an unlinked paging structure by unlinking and
>    *				dropping references.
>    * @get_page:			Increment the refcount on a page.
>    * @put_page:			Decrement the refcount on a page. When the
> @@ -119,7 +119,7 @@ struct kvm_pgtable_mm_ops {
>   	void*		(*zalloc_page)(void *arg);
>   	void*		(*zalloc_pages_exact)(size_t size);
>   	void		(*free_pages_exact)(void *addr, size_t size);
> -	void		(*free_removed_table)(void *addr, u32 level);
> +	void		(*free_unlinked_table)(void *addr, u32 level);
>   	void		(*get_page)(void *addr);
>   	void		(*put_page)(void *addr);
>   	int		(*page_count)(void *addr);
> @@ -450,7 +450,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>   void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>   
>   /**
> - * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> + * kvm_pgtable_stage2_free_unlinked() - Free un unlinked stage-2 paging structure.

Free an unlinked stage-2

>    * @mm_ops:	Memory management callbacks.
>    * @pgtable:	Unlinked stage-2 paging structure to be freed.
>    * @level:	Level of the stage-2 paging structure to be freed.
> @@ -458,7 +458,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>    * The page-table is assumed to be unreachable by any hardware walkers prior to
>    * freeing and therefore no TLB invalidation is performed.
>    */
> -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
>   
>   /**
>    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 552653fa18be..b030170d803b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -91,9 +91,9 @@ static void host_s2_put_page(void *addr)
>   	hyp_put_page(&host_s2_pool, addr);
>   }
>   
> -static void host_s2_free_removed_table(void *addr, u32 level)
> +static void host_s2_free_unlinked_table(void *addr, u32 level)
>   {
> -	kvm_pgtable_stage2_free_removed(&host_mmu.mm_ops, addr, level);
> +	kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
>   }
>   
>   static int prepare_s2_pool(void *pgt_pool_base)
> @@ -110,7 +110,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
>   	host_mmu.mm_ops = (struct kvm_pgtable_mm_ops) {
>   		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
>   		.zalloc_page = host_s2_zalloc_page,
> -		.free_removed_table = host_s2_free_removed_table,
> +		.free_unlinked_table = host_s2_free_unlinked_table,
>   		.phys_to_virt = hyp_phys_to_virt,
>   		.virt_to_phys = hyp_virt_to_phys,
>   		.page_count = hyp_page_count,
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index e093e222daf3..0a5ef9288371 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -841,7 +841,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (ret)
>   		return ret;
>   
> -	mm_ops->free_removed_table(childp, ctx->level);
> +	mm_ops->free_unlinked_table(childp, ctx->level);
>   	return 0;
>   }
>   
> @@ -886,7 +886,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>    * The TABLE_PRE callback runs for table entries on the way down, looking
>    * for table entries which we could conceivably replace with a block entry
>    * for this mapping. If it finds one it replaces the entry and calls
> - * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
> + * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
>    *
>    * Otherwise, the LEAF callback performs the mapping at the existing leaves
>    * instead.
> @@ -1250,7 +1250,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>   	pgt->pgd = NULL;
>   }
>   
> -void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> +void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
>   {
>   	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
>   	struct kvm_pgtable_walker walker = {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a3ee3b605c9b..9bd3c2cfb476 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -130,21 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>   
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
>   
> -static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
>   {
>   	struct page *page = container_of(head, struct page, rcu_head);
>   	void *pgtable = page_to_virt(page);
>   	u32 level = page_private(page);
>   
> -	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
> +	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
>   }
>   
> -static void stage2_free_removed_table(void *addr, u32 level)
> +static void stage2_free_unlinked_table(void *addr, u32 level)
>   {
>   	struct page *page = virt_to_page(addr);
>   
>   	set_page_private(page, (unsigned long)level);
> -	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> +	call_rcu(&page->rcu_head, stage2_free_unlinked_table_rcu_cb);
>   }
>   
>   static void kvm_host_get_page(void *addr)
> @@ -681,7 +681,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>   	.zalloc_page		= stage2_memcache_zalloc_page,
>   	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
>   	.free_pages_exact	= kvm_s2_free_pages_exact,
> -	.free_removed_table	= stage2_free_removed_table,
> +	.free_unlinked_table	= stage2_free_unlinked_table,
>   	.get_page		= kvm_host_get_page,
>   	.put_page		= kvm_s2_put_page,
>   	.page_count		= kvm_host_page_count,

-- 
Regards,
Shaoqin

