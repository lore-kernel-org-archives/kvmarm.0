Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C658AC54EE9
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 00:53:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7024BBF8;
	Tue, 13 Sep 2022 20:53:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lqoeZkwtte0w; Tue, 13 Sep 2022 20:53:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F21654BBCC;
	Tue, 13 Sep 2022 20:53:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3418E4BBA8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:53:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s0IJvICVxRaP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2022 20:53:22 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0C904BBA4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 20:53:22 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id b21so13531283plz.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 17:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=s7D2/n8L9/xlIj+hVN8GIcFvSkrDNM1KPpmGzxvTo/g=;
 b=MjaKzwDN2gr+IBBkEtU4oKISjvr8IhyssXGGoZPdWL2vQ+Kc+kf4lIHFyxRCWZxe/6
 tPIKyV/waFHwFtUW/s0IxrR+yzMbZxhaCYWJUbDrsoCjVHcCT8QPKI5L2jMpyVKpqoLr
 C+lgLIDjYk2a/JgjpmDcGPYLaDXheZQ/5h1PjIB5ZCKPvMRzfJ8fo/CVu5Fhg2mDsWUR
 UX3ZA5bX0+YXd0G5eaOP85mFoLnXoI/CIQvXLbCSUCqTxwx4dyJ1Ml2KvZqi7Zryg82w
 ONSiaucCEFXmPb67TjV6JShvU2ZWb80s5L/8+SL7vNTx5v4zxFiLIiEZ48eG+5CvZ1Ka
 0Kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=s7D2/n8L9/xlIj+hVN8GIcFvSkrDNM1KPpmGzxvTo/g=;
 b=zhD+AU7Z2pL9ESrC4yaCDQ17QF857XrJMbSNtUe8YgsaWhE2hXlMG/b8dutV/E1WHN
 4/4B0U9JmW20BLxpzylTcp5XRIuRRq0nb9amEAHnxWNvP6D+pZmUfTUz9nE1yxOgk4x7
 DqNhtKoF0T2pntVdKsN8p9vcWNfdcx30e7Wi7dOIi+jg2DMLIEHQWKurPRvv6YX/ADGn
 YBRCtfN7/m77eyy/0QJSkRxyF3Neeb2hAn4n+UNn5rA6Uzfy8Yp91lRfVygDZs+xGlgS
 /ToOOWWCAYLDaDPgGAC7KwUWpfOSj4abqkhkk7is6knRdJB5ap+gpZo28Lymj4r4dmEp
 jj/g==
X-Gm-Message-State: ACgBeo2Hbq8WwRKkMqm/U1Ps5hnTtptVbOMIfvAF0g/y5FVOUHcP/R7r
 +6mXhFmqjq2GNvNT3pu+hK9LKQ==
X-Google-Smtp-Source: AA6agR4y+7kaPNq1wJxvL/FXkrUH4iSFTMmdqNsD7Bn0tcQWSLnAZOkP8N3MaRfk0obT8kJGNMdoFA==
X-Received: by 2002:a17:902:b616:b0:178:2321:8dbb with SMTP id
 b22-20020a170902b61600b0017823218dbbmr17687773pls.47.1663116801745; 
 Tue, 13 Sep 2022 17:53:21 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 8-20020a621408000000b0053e85a4a2ccsm8532407pfu.26.2022.09.13.17.53.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 13 Sep 2022 17:53:21 -0700 (PDT)
Date: Tue, 13 Sep 2022 17:53:17 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 11/14] KVM: arm64: Make changes block->table to leaf PTEs
 parallel-aware
Message-ID: <YyEl/UILu+OAP5zA@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <20220830195102.964724-1-oliver.upton@linux.dev>
 <YyElq0c6WD1zh7Lu@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YyElq0c6WD1zh7Lu@google.com>
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

On Tue, Sep 13, 2022 at 05:51:55PM -0700, Ricardo Koller wrote:
> On Tue, Aug 30, 2022 at 07:51:01PM +0000, Oliver Upton wrote:
> > In order to service stage-2 faults in parallel, stage-2 table walkers
> > must take exclusive ownership of the PTE being worked on. An additional
> > requirement of the architecture is that software must perform a
> > 'break-before-make' operation when changing the block size used for
> > mapping memory.
> > 
> > Roll these two concepts together into helpers for performing a
> > 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> > has been locked by a software walker. Additionally, use an atomic
> > compare-exchange to 'break' the PTE when the stage-2 page tables are
> > possibly shared with another software walker. Elide the DSB + TLBI if
> > the evicted PTE was invalid (and thus not subject to break-before-make).
> > 
> > All of the atomics do nothing for now, as the stage-2 walker isn't fully
> > ready to perform parallel walks.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 87 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 82 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 61a4437c8c16..71ae96608752 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -49,6 +49,12 @@
> >  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
> >  #define KVM_MAX_OWNER_ID		1
> >  
> > +/*
> > + * Used to indicate a pte for which a 'break-before-make' sequence is in
> > + * progress.
> > + */
> > +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> > +
> >  struct kvm_pgtable_walk_data {
> >  	struct kvm_pgtable		*pgt;
> >  	struct kvm_pgtable_walker	*walker;
> > @@ -586,6 +592,8 @@ struct stage2_map_data {
> >  
> >  	/* Force mappings to page granularity */
> >  	bool				force_pte;
> > +
> > +	bool				shared;
> >  };
> >  
> >  u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
> > @@ -691,6 +699,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >  	return kvm_pte_valid(pte) || kvm_invalid_pte_owner(pte);
> >  }
> >  
> > +static bool stage2_pte_is_locked(kvm_pte_t pte)
> > +{
> > +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> > +}
> > +
> >  static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bool shared)
> >  {
> >  	if (!shared) {
> > @@ -701,6 +714,69 @@ static bool stage2_try_set_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new, bo
> >  	return cmpxchg(ptep, old, new) == old;
> >  }
> >  
> > +/**
> > + * stage2_try_break_pte() - Invalidates a pte according to the
> > + *			    'break-before-make' requirements of the
> > + *			    architecture.
> > + *
> > + * @ptep: Pointer to the pte to break
> > + * @old: The previously observed value of the pte
> > + * @addr: IPA corresponding to the pte
> > + * @level: Table level of the pte
> > + * @shared: true if the stage-2 page tables could be shared by multiple software
> > + *	    walkers
> > + *
> > + * Returns: true if the pte was successfully broken.
> > + *
> > + * If the removed pte was valid, performs the necessary serialization and TLB
> > + * invalidation for the old value. For counted ptes, drops the reference count
> > + * on the containing table page.
> > + */
> > +static bool stage2_try_break_pte(kvm_pte_t *ptep, kvm_pte_t old, u64 addr, u32 level,
> > +				 struct stage2_map_data *data)
> > +{
> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +
> > +	if (stage2_pte_is_locked(old)) {
> > +		/*
> > +		 * Should never occur if this walker has exclusive access to the
> > +		 * page tables.
> > +		 */
> > +		WARN_ON(!data->shared);
> > +		return false;
> > +	}
> 
> The above check is not needed as the cmpxchg() will return false if the
> old pte is equal to "new" (KVM_INVALID_PTE_LOCKED).
> 
> > +
> > +	if (!stage2_try_set_pte(ptep, old, KVM_INVALID_PTE_LOCKED, data->shared))
> > +		return false;
> > +
> > +	/*
> > +	 * Perform the appropriate TLB invalidation based on the evicted pte
> > +	 * value (if any).
> > +	 */
> > +	if (kvm_pte_table(old, level))
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
> > +	else if (kvm_pte_valid(old))
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> > +
> > +	if (stage2_pte_is_counted(old))
> > +		mm_ops->put_page(ptep);
> > +
> > +	return true;
> > +}
> > +
> > +static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t old, kvm_pte_t new,
> > +			    struct stage2_map_data *data)
> > +{

nit: old is not used

> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +
> > +	WARN_ON(!stage2_pte_is_locked(*ptep));
> > +
> > +	if (stage2_pte_is_counted(new))
> > +		mm_ops->get_page(ptep);
> > +
> > +	smp_store_release(ptep, new);
> > +}
> > +
> >  static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
> >  			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> > @@ -836,17 +912,18 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  	if (!childp)
> >  		return -ENOMEM;
> >  
> > +	if (!stage2_try_break_pte(ptep, *old, addr, level, data)) {
> > +		mm_ops->put_page(childp);
> > +		return -EAGAIN;
> > +	}
> > +
> >  	/*
> >  	 * If we've run into an existing block mapping then replace it with
> >  	 * a table. Accesses beyond 'end' that fall within the new table
> >  	 * will be mapped lazily.
> >  	 */
> > -	if (stage2_pte_is_counted(pte))
> > -		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
> > -
> >  	new = kvm_init_table_pte(childp, mm_ops);
> > -	mm_ops->get_page(ptep);
> > -	smp_store_release(ptep, new);
> > +	stage2_make_pte(ptep, *old, new, data);
> >  	*old = new;
> >  
> >  	return 0;
> > -- 
> > 2.37.2.672.g94769d06f0-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
