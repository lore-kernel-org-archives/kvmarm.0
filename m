Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF685ECAAD5
	for <kvmarm@archiver.kernel.org>; Thu,  8 Sep 2022 08:34:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D9A4CCE8;
	Thu,  8 Sep 2022 04:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aYhzrC8LzISb; Thu,  8 Sep 2022 04:34:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD314CD2D;
	Thu,  8 Sep 2022 04:34:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 278DC4CBB8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 18:00:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NgUkK5-Tmhju for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2022 18:00:26 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D94D44CBB7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2022 18:00:25 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id t70so9044763pgc.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Sep 2022 15:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=Z6i7/OEeMp+vclfvU0ocYeg3hscpfsRzRk3osMten/8=;
 b=e3Fe+rheW8Na/BXBO0bEG/1zt5AvIyqOPccGgeldHQDysW4dhlQDvScdWW2jF/ykJ0
 1KZwGAcihDgrTllUZHJJCNthA+tnI5/MKxfV98sxO2gZdnNqtwz4ehAALW8HWWs42K4u
 ocGtMwQOJbi17zrV7TwAfsFGcApOG5pyrSRoymiKtunKPdiNxC47IKTkRNH5I0iklGS7
 4o7kfFBEXIsl9Q3af05OVupBoJddnUB5PVwkMSqoL+yMs33XpMb06Gf/XqiqKdeZ+ZhV
 Hi7J8tFb62JxGs/zwwIUjqJqcKSQ9HcUYGQgsRwMCfp8L3VnL/MyK/wxFVZnjlAnT6dN
 a/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=Z6i7/OEeMp+vclfvU0ocYeg3hscpfsRzRk3osMten/8=;
 b=IIU6LFnR+9u8+50XWWdBqbuQcsSRsPjmrovyWaWTLDrJIA+aDWIRQpDi12jOZ1j4j/
 4YGAloXRCUqOVNWrX3TG2Yw74QVJQ94eWT1xAGSn5KtY4zWGEbx9Jgvj2vCdQ+BUg7Cw
 5jRCXKiItX7GXC1wG3wE/VdpKtbIo5L5NsjF73x78kaqwX5hTB+BH3OaIXQ/YE2cnTXo
 oCW5e8k9gHqdty6cjhJ5H4f2he0V+K6PZeq7hkxXqpGW5UngaWiTAl1c6Qza5c91HnfU
 r144vLG0hZAiOVwJazAQ9ZSaaOAeFQbcNGQo0x1XmcvIwVfbQxm159FImcbvPEUOQTvq
 rKPg==
X-Gm-Message-State: ACgBeo0nJqfNdsvMaX5Rm/QRii6+1KNfMLpO+8u52bFB8OOlreZfM73Y
 K+rp2NTVrnHjZvc3z8VRVAkmHQ==
X-Google-Smtp-Source: AA6agR42gCnxTLUemS9/D7J6YQAzvwNbNyEIYR546Fz93K8ats2Z1wyfCNCKWhEadwoFVmBAFIejcg==
X-Received: by 2002:a63:84c1:0:b0:434:fd55:e213 with SMTP id
 k184-20020a6384c1000000b00434fd55e213mr3190251pgd.10.1662588024651; 
 Wed, 07 Sep 2022 15:00:24 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com.
 [34.125.103.223]) by smtp.gmail.com with ESMTPSA id
 i15-20020aa796ef000000b0053e62b6fd22sm2762187pfq.126.2022.09.07.15.00.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 07 Sep 2022 15:00:23 -0700 (PDT)
Date: Wed, 7 Sep 2022 15:00:18 -0700
From: David Matlack <dmatlack@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 09/14] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <YxkUciuwLFvByLOu@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-10-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-10-oliver.upton@linux.dev>
X-Mailman-Approved-At: Thu, 08 Sep 2022 04:34:28 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Aug 30, 2022 at 07:41:27PM +0000, Oliver Upton wrote:
> There is no real urgency to free a stage-2 subtree that was pruned.
> Nonetheless, KVM does the tear down in the stage-2 fault path while
> holding the MMU lock.
> 
> Free removed stage-2 subtrees after an RCU grace period. To guarantee
> all stage-2 table pages are freed before killing a VM, add an
> rcu_barrier() to the flush path.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 91521f4aab97..265951c05879 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -97,6 +97,38 @@ static void *stage2_memcache_zalloc_page(void *arg)
>  	return kvm_mmu_memory_cache_alloc(mc);
>  }
>  
> +#define STAGE2_PAGE_PRIVATE_LEVEL_MASK	GENMASK_ULL(2, 0)
> +
> +static inline unsigned long stage2_page_private(u32 level, void *arg)
> +{
> +	unsigned long pvt = (unsigned long)arg;
> +
> +	BUILD_BUG_ON(KVM_PGTABLE_MAX_LEVELS > STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +	WARN_ON_ONCE(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +
> +	return pvt | level;
> +}
> +
> +static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +{
> +	struct page *page = container_of(head, struct page, rcu_head);
> +	unsigned long pvt = page_private(page);
> +	void *arg = (void *)(pvt & ~STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +	u32 level = (u32)(pvt & STAGE2_PAGE_PRIVATE_LEVEL_MASK);
> +	void *pgtable = page_to_virt(page);
> +
> +	kvm_pgtable_stage2_free_removed(pgtable, level, arg);
> +}
> +
> +static void stage2_free_removed_table(void *pgtable, u32 level, void *arg)
> +{
> +	unsigned long pvt = stage2_page_private(level, arg);
> +	struct page *page = virt_to_page(pgtable);
> +
> +	set_page_private(page, (unsigned long)pvt);
> +	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
> +}
> +
>  static void *kvm_host_zalloc_pages_exact(size_t size)
>  {
>  	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> @@ -627,7 +659,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.zalloc_page		= stage2_memcache_zalloc_page,
>  	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
>  	.free_pages_exact	= free_pages_exact,
> -	.free_removed_table	= kvm_pgtable_stage2_free_removed,
> +	.free_removed_table	= stage2_free_removed_table,
>  	.get_page		= kvm_host_get_page,
>  	.put_page		= kvm_host_put_page,
>  	.page_count		= kvm_host_page_count,
> @@ -770,6 +802,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  	if (pgt) {
>  		kvm_pgtable_stage2_destroy(pgt);
>  		kfree(pgt);
> +		rcu_barrier();

A comment here would be useful to document the behavior. e.g.

        /*
         * Wait for all stage-2 page tables that are being freed
         * asynchronously via RCU callback because ...
         */

Speaking of, what's the reason for this rcu_barrier()? Is there any
reason why KVM can't let in-flight stage-2 freeing RCU callbacks run at
the end of the next grace period?

>  	}
>  }
>  
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
