Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C8FC54EE9
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 00:52:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051634BC5A;
	Tue, 13 Sep 2022 20:52:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fWSO50EK1wL1; Tue, 13 Sep 2022 20:52:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C984BC53;
	Tue, 13 Sep 2022 20:52:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06C564BC3C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:52:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RjPbm2eZVs+V for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 20:52:00 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6CA84BC22
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:52:00 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id bh13so12888163pgb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 17:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=CT92j6tCxFfRZCqWY+0RsmfIURyeela0R3FbUxkSEXA=;
 b=cgRpIsMu0sY8TKHmNRgR4MKetGHKJRZYfqHceV78oKOfizDpGrpq06Zv1NGuZ38zuf
 odVigm4u4qPDOor5HN5/WV1I6v9q8s4tp4asoO+7epdSmsdWWXnB2pdcDpIknT6vWeW3
 3sLrxnuxYzsvZ/3F90rE6r9i2v4cwDq9nxwQUzcS5iBBMjcN2gAUnWD0rBLfdH8x2K1B
 za6wyueWfWee0Lb/tiz6uh8Q3aKTaXyiqoO/owaxkeOv7o35mbY9lkTcrtadV8v5S9tm
 DNlp6ypDZ6+A6Oe9vpyrkjGkJSQmtULSvaAcl0VJ6V2oGbwxb4atbZ0CT9Y1h++BC7MI
 Gu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=CT92j6tCxFfRZCqWY+0RsmfIURyeela0R3FbUxkSEXA=;
 b=uhqLtty7XwS74m/PHlC1cYg6Ku+jsPZfc9AAc6FNQa2TX7e7sshYH3nmOi0EXAjNVZ
 qpKtgcg+IEz9O7704JrbIA6fEVJTgok56z1TYusdUuX9oWOJJR4iqOo41nCgu8puuJ//
 LeedBEWjqwWJpJ6Bm/P7pFd2FH73cfujzmwb9XMUDrMZj93lcks4WG5g/vbknvriLCnI
 UmAEl6KHqptgN6egh1tynYwQNSTYCuJ4S9mSxGxHwSmJgtIXzcM+RDlDWtm2ybCLwHHj
 7BS8CkNmgKTUGehc8dsFBVErtwsGwNRk5q3pRycRZ9plNjV1JRg5ypUJNKg0LyYc7bvX
 K2jw==
X-Gm-Message-State: ACgBeo3Q9grKnBrWIcP+6P4crJ2h2jsy6uhAavfKh2zeYQjDmKn4QoKE
 x9wY4z2VDJPyPp+jOa4bJHKFqQ==
X-Google-Smtp-Source: AA6agR5GjBnaRX3fVEsuzgfSGNv0ro7BnN3Nfszv29mu5h+OuwOhxaI1d2CFE4UJ9YkeXhgPmagp5w==
X-Received: by 2002:a05:6a00:14c4:b0:542:cd3a:591e with SMTP id
 w4-20020a056a0014c400b00542cd3a591emr14315838pfu.27.1663116719529; 
 Tue, 13 Sep 2022 17:51:59 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 p8-20020a1709027ec800b00174ea015ee2sm9297880plb.38.2022.09.13.17.51.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Sep 2022 17:51:58 -0700 (PDT)
Date: Tue, 13 Sep 2022 17:51:55 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 11/14] KVM: arm64: Make changes block->table to leaf PTEs
 parallel-aware
Message-ID: <YyElq0c6WD1zh7Lu@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830195102.964724-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220830195102.964724-1-oliver.upton@linux.dev>
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

On Tue, Aug 30, 2022 at 07:51:01PM +0000, Oliver Upton wrote:
> In order to service stage-2 faults in parallel, stage-2 table walkers
> must take exclusive ownership of the PTE being worked on. An additional
> requirement of the architecture is that software must perform a
> 'break-before-make' operation when changing the block size used for
> mapping memory.
> 
> Roll these two concepts together into helpers for performing a
> 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> has been locked by a software walker. Additionally, use an atomic
> compare-exchange to 'break' the PTE when the stage-2 page tables are
> possibly shared with another software walker. Elide the DSB + TLBI if
> the evicted PTE was invalid (and thus not subject to break-before-make).
> 
> All of the atomics do nothing for now, as the stage-2 walker isn't fully
> ready to perform parallel walks.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 87 +++++++++++++++++++++++++++++++++---
>  1 file changed, 82 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 61a4437c8c16..71ae96608752 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -49,6 +49,12 @@
>  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
>  #define KVM_MAX_OWNER_ID		1
>  
> +/*
> + * Used to indicate a pte for which a 'break-before-make' sequence is in
> + * progress.
> + */
> +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> +
>  struct kvm_pgtable_walk_data {
>  	struct kvm_pgtable		*pgt;
>  	struct kvm_pgtable_walker	*walker;
> @@ -586,6 +592,8 @@ struct stage2_map_data {
>  
>  	/* Force mappings to page granularity */
>  	bool				force_pte;
> +
> +	bool				shared;
>  };
>  
>  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> @@ -691,6 +699,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>  	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
>  }
>  
> +static bool stage2_pte_is_locked(kvm_pte_t pte)
> +{
> +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> +}
> +
>  static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
>  {
>  	if (!shared) {
> @@ -701,6 +714,69 @@ static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bo
>  	return cmpxchg(ptep, old, new) == old;
>  }
>  
> +/**
> + * stage2_try_break_pte() - Invalidates a pte according to the
> + *			    'break-before-make' requirements of the
> + *			    architecture.
> + *
> + * @ptep: Pointer to the pte to break
> + * @old: The previously observed value of the pte
> + * @addr: IPA corresponding to the pte
> + * @level: Table level of the pte
> + * @shared: true if the stage-2 page tables could be shared by multiple software
> + *	    walkers
> + *
> + * Returns: true if the pte was successfully broken.
> + *
> + * If the removed pte was valid, performs the necessary serialization and TLB
> + * invalidation for the old value. For counted ptes, drops the reference count
> + * on the containing table page.
> + */
> +static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level,
> +				 struct stage2_map_data *data)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +
> +	if (stage2_pte_is_locked(old)) {
> +		/*
> +		 * Should never occur if this walker has exclusive access to the
> +		 * page tables.
> +		 */
> +		WARN_ON(!data->shared);
> +		return false;
> +	}

The above check is not needed as the cmpxchg() will return false if the
old pte is equal to "new" (KVM_INVALID_PTE_LOCKED).

> +
> +	if (!stage2_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, data->shared))
> +		return false;
> +
> +	/*
> +	 * Perform the appropriate TLB invalidation based on the evicted pte
> +	 * value (if any).
> +	 */
> +	if (kvm_pte_table(old, level))
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> +	else if (kvm_pte_valid(old))
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> +
> +	if (stage2_pte_is_counted(old))
> +		mm_ops->put_page(ptep);
> +
> +	return true;
> +}
> +
> +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new,
> +			    struct stage2_map_data *data)
> +{
> +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> +
> +	WARN_ON(!stage2_pte_is_locked(*ptep));
> +
> +	if (stage2_pte_is_counted(new))
> +		mm_ops->get_page(ptep);
> +
> +	smp_store_release(ptep, new);
> +}
> +
>  static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
>  			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
>  {
> @@ -836,17 +912,18 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	if (!childp)
>  		return -ENOMEM;
>  
> +	if (!stage2_try_break_pte(ptep, *old, addr, level, data)) {
> +		mm_ops->put_page(childp);
> +		return -EAGAIN;
> +	}
> +
>  	/*
>  	 * If we've run into an existing block mapping then replace it with
>  	 * a table. Accesses beyond 'end' that fall within the new table
>  	 * will be mapped lazily.
>  	 */
> -	if (stage2_pte_is_counted(pte))
> -		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> -
>  	new = kvm_init_table_pte(childp, mm_ops);
> -	mm_ops->get_page(ptep);
> -	smp_store_release(ptep, new);
> +	stage2_make_pte(ptep, *old, new, data);
>  	*old = new;
>  
>  	return 0;
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
