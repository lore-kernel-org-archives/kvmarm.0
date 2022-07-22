Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFCCC433EF
	for <kvmarm@archiver.kernel.org>; Sun, 24 Jul 2022 10:36:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 882AE4EA43;
	Sun, 24 Jul 2022 06:36:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Thi0tyH+cYDc; Sun, 24 Jul 2022 06:36:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 569684EA3D;
	Sun, 24 Jul 2022 06:36:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FD014CC39
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 16:59:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFm5gfHbFjXn for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2022 16:59:04 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74A734CC3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 16:59:04 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id 12so5109705pga.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2022 13:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=sRtc60bVHDuSQyy9YfLGbb/EZRQBkQQyTX+neLttrJI=;
 b=VT9WZjGGoaYO6wyINeAk1IALZT19I8nvGaJlOLvSTsMGMXO2aI48bLngF7CtjZAvoY
 Nk4dj0ETYHZSQT86zOPNHYg7GeO54xGWEIJhFv/C0BrBO+t5mqhus74Y4xbk+8fyul8M
 HfArgcswQSvdoHC84nrbwn2mXJxz+9qFiCBQ69YkVOPUHk9BdnilnJfVEOdrt3RS3CJ4
 +mBwVu+wySOMJ/nQcZ/3u7v3umsb304sjJE7eni7WKU27HJWuFzI6grkrasDGOuFewyR
 5YIPM89seaz3zWvRqyMCiwRGPEmx5/kbjcwH21G8dckWuQ/kFANi+7LycZSgyao947dV
 do6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sRtc60bVHDuSQyy9YfLGbb/EZRQBkQQyTX+neLttrJI=;
 b=LXEOnACaOJaxm5JjC8I2bhY6yaGS1Ko9/PuG42jXpEcJUoLRWt6Aj+BunSP2mCxRyX
 CpdxNkqOOUVt4AfsqCkpOkxaVEWkauqyVxIVKrUY+PNo8hwkN3Ft334twCADcrhytOib
 6eQ1pX5dub2OOdDdlIWHBtef3ichpUSEFVYz+GjNLgI16/d90aWVuoimKiZWw34kzd1i
 oWMNzDHu1RHfAJutq2t3HxhPqEZvZ743fK+746l8qeOy/Pxe2iWb1ns+p829wDr6Pfn3
 +QoQ8xY7iSp5pNjJ6PWZpqSDiCiKXzvtO/xotXDg2cOLaUlzig4BtTJViOQMgk6dWzuY
 Ov2A==
X-Gm-Message-State: AJIora+G7TJbjspl/aLSLnA3Z10PVLtAoSTJNVH0xrwcN0oC6UwViGv9
 t8Y9t93Dkob+K90SZWEcC+MF6g==
X-Google-Smtp-Source: AGRyM1tTvyJodPHKaLxzuJZFM95uuASDg1Sh5BgVVmp6RF38yEdu4iqgj2c7B6w9K0El2nFlSq1YJQ==
X-Received: by 2002:a63:6a45:0:b0:419:cb1b:891b with SMTP id
 f66-20020a636a45000000b00419cb1b891bmr1367197pgc.135.1658523543280; 
 Fri, 22 Jul 2022 13:59:03 -0700 (PDT)
Received: from google.com (59.39.145.34.bc.googleusercontent.com.
 [34.145.39.59]) by smtp.gmail.com with ESMTPSA id
 d26-20020a634f1a000000b004088f213f68sm3893786pgb.56.2022.07.22.13.59.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Jul 2022 13:59:02 -0700 (PDT)
Date: Fri, 22 Jul 2022 20:58:59 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YtsPk5+hZNMEwT0c@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220429201131.3397875-4-yosryahmed@google.com>
X-Mailman-Approved-At: Sun, 24 Jul 2022 06:36:50 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Apr 29, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 for in secondary pagetable stats.
> 
> For the legacy mmu, accounting pagetable stats is combined KVM's
> existing for mmu pages in newly introduced kvm_[un]account_mmu_page()
> helpers.
> 
> For tdp mmu, introduce new tdp_[un]account_mmu_page() helpers. That
> combines accounting pagetable stats with the tdp_mmu_pages counter
> accounting.
> 
> tdp_mmu_pages counter introduced in this series [1]. This patch was
> rebased on top of the first two patches in that series.
> 
> [1]https://lore.kernel.org/lkml/20220401063636.2414200-1-mizhang@google.com/
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---

It looks like there are two metrics for mmu in x86: one for shadow mmu
and the other for TDP mmu. Is there any plan to merge them together?

>  arch/x86/kvm/mmu/mmu.c     | 16 ++++++++++++++--
>  arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++++++++--
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 78d8e1d8fb99..e5b0e826445d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1679,6 +1679,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
>  	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>  }
>  
> +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, +1);
> +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +}
> +
> +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	kvm_mod_used_mmu_pages(kvm, -1);
> +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +}
> +
>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  {
>  	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
> @@ -1734,7 +1746,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>  	 */
>  	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>  	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> -	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> +	kvm_account_mmu_page(vcpu->kvm, sp);
>  	return sp;
>  }
>  
> @@ -2363,7 +2375,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>  			list_add(&sp->link, invalid_list);
>  		else
>  			list_move(&sp->link, invalid_list);
> -		kvm_mod_used_mmu_pages(kvm, -1);
> +		kvm_unaccount_mmu_page(kvm, sp);
>  	} else {
>  		/*
>  		 * Remove the active root from the active page list, the root
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3456277ade18..6295c4da5dee 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -371,6 +371,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  	}
>  }
>  
> +static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	atomic64_inc(&kvm->arch.tdp_mmu_pages);
> +	kvm_account_pgtable_pages((void *)sp->spt, +1);
> +}
> +
> +static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +	kvm_account_pgtable_pages((void *)sp->spt, -1);
> +}
> +
>  /**
>   * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
>   *
> @@ -383,7 +395,7 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			      bool shared)
>  {
> -	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +	tdp_unaccount_mmu_page(kvm, sp);
>  
>  	if (!sp->lpage_disallowed)
>  		return;
> @@ -1121,7 +1133,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  		tdp_mmu_set_spte(kvm, iter, spte);
>  	}
>  
> -	atomic64_inc(&kvm->arch.tdp_mmu_pages);
> +	tdp_account_mmu_page(kvm, sp);
>  
>  	return 0;
>  }
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
