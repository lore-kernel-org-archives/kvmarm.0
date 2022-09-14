Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E786BC54EE9
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 00:49:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EFEB4BC5E;
	Tue, 13 Sep 2022 20:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mSCIhwwslR6K; Tue, 13 Sep 2022 20:49:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D364BC4B;
	Tue, 13 Sep 2022 20:49:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 882D94BC3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:49:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gDD4V5kXoGCz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 20:49:32 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E1F34BC22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:49:32 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id fv3so12972844pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 17:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=VC9mI68no/Lhw0HfZpwkORWcc1RC3UZIYHwVkfGB/r4=;
 b=hrIqf5MD/xB/9myyBeSm33TcaOokPoX7OBfouhtK+QYu3xN2uBJxyO2hwvyYtuh2W0
 RdwXYSsNmn+DsH/Gpdq5vM3R8ZfCoKhKciL2HGbxoduQKF7c8ktRoTQjLfMESLPFpZyL
 Ns0E2DVLJos2dtMmG5R41fTtTe3J/4Tlo1NyAQwzTGqI70CMfMYO11+ICelzhKCetwtW
 SkPeKYcul80lg+mpqpXs6SCD0MpG3NKQFFzJeeWkjLD0aS7zcXg0vSm1kwe5vEoNUwPa
 CPS85UG7CF4R83h+gydjSaaK82yV2BkpbSMULGBFAaCTe6LmRRsym1vdrmpcBBksyYr9
 H8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=VC9mI68no/Lhw0HfZpwkORWcc1RC3UZIYHwVkfGB/r4=;
 b=CFZScRIRB/9U5vmoU2Uk8T/se8EFqmaSmJi0Cd46seevS7aaQ7LjjF6I7DQ//7MOVP
 47tY7Z0XHdDVYkoC80RRNbUWUSqDmVFEUSKgqnySM4WpcsKV3uwB8Vc+lB5p2KB+0zqT
 ZseyovqGmXJQkDJkTKn0HMsCVsf9v9aWAk4tBIIIogEK0B/zjgP4b6lBqdMrmYnM27Y3
 zwbzJIehSgpzRKiXK8cQHpBHmcw19iiJjmCIxVMTh2E4Xz/68UO2bObylzijIFSzOaLu
 1JiX4FYcbStH6dVpLsVD7F3GjQh8jfvhfVInGLIR9hG3Yj+iijv+5f0S8CylbajMcL0U
 ABfQ==
X-Gm-Message-State: ACrzQf2M0PRd+sPDPthQ0G2oiGfv6TQaLJInHnG3749u5xbbtgNFwpAb
 W5i0EdY7xdmceTzqpJ4sf2rE/g==
X-Google-Smtp-Source: AMsMyM526FQxM1WokLTXGOLY1vbfrlIhdoLZtMq7zQSlveMaKcR+WWo9mX4QO1UTnf2rxrP+iQLIoA==
X-Received: by 2002:a17:90a:7006:b0:200:aabc:891 with SMTP id
 f6-20020a17090a700600b00200aabc0891mr1948603pjk.67.1663116571104; 
 Tue, 13 Sep 2022 17:49:31 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 y186-20020a6232c3000000b00535e46171c1sm8503863pfy.117.2022.09.13.17.49.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Sep 2022 17:49:30 -0700 (PDT)
Date: Tue, 13 Sep 2022 17:49:27 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 09/14] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Message-ID: <YyElF+MMXSumzszf@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830194132.962932-10-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830194132.962932-10-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Oliver,

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

If the pgt pointer (arg) is not aligned for some reason, I think it
might be better to BUG_ON(). Alternatively, why not trying to pass a new
struct (with level and arg) that's freed by the rcu callback.

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
