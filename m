Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AA254B1A8
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788878825; cv=none; b=jW4rAauCzdzNlFYUzF39Vvo/b5SKDUFP7t/2GrAMrlIzUt6MmUXTpGtQtTif0FzgOCx7g+JuHLW44srwAIWR0zcE6WTpWKBb2UKXHZKA+a8iz1ABhiXkzhl9lQ0RubS6KWq0znLKbFjNeE2gn2TyT+fbzUgDLxaEgwbLLv5YX6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788878825; c=relaxed/simple;
	bh=JmC+mwHIM39NGCVxgkwGQ11e2Lyl2fluxhYsRcXulpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUKhjTpJAoj85yBefKKwrWWc6oI07hudEifrAGzmV31ohNqGCHLSB7HXjL6vbzw2Nb2BjObyK6coQiEEKG32iUdeuYRgzIkFVzyp1Rh3tdQ4otXbIt4l/i/ImZeDgBMHOCBpK3glboHwsHb7NObfWzOYBm/p9g7P2EKOMBmEjmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ilCJiKDS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ilCJiKDS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso45625565e9.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 07:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788878816; x=1789483616; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=44wijPDxOs8MXYWMCES6hvBHIczTeQ5fHlAE3Ub1cRQ=;
        b=ilCJiKDSkBzb7ldHkv3qX19tmPuy6CTkEBq1glWtMJu4pasEuqHJgnBryaIgZ3ly9p
         k05lWNRACiXJ2bjLQh90+tNDYKSlw+9hdh5ncL4zMhgMXAkJjHtDYYSQi4AQtwKlEK+/
         Ms2GAo7q9htRdyiL1IBC2GaZuS9iVxazL8qG1dpV9nuZ8sJVndPD/URMLhNqlvhhrlPn
         jlEJfBOo1YCNrla0ioeRHEQDg4x2iyLFjIwS3ext3tuZpyXCg24ATeQbEPbOVSxt99ti
         SbLyRCtK9MLThLCkA7Xo7pLrVHzx5viITCv6p4wG3IKEegBvg6KliraBWrDGWEFJmh1e
         uAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788878816; x=1789483616;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=44wijPDxOs8MXYWMCES6hvBHIczTeQ5fHlAE3Ub1cRQ=;
        b=KO7old7qSX/9rYtDvGygUxSnN7U71FXlLQoVQmaWzzkUR/c/rRaaJe+FBf2vmRka6Q
         c4O/VqTVF7MwJrl2JVlPc0cGZch7iCUD1nwGa+WNl4I48LY/c9y3mIP6oQWgtqPkR/2c
         t44G5wsX6Ii8sGYdkAg5qfWiWSrwULNsN2Py/9Q4ph9W0tHjTPC5yzYTjaa7EeQMgyMr
         H+THG7ca89+GPZhB6Z99ryRD+d3VwL21WbCT9BBhz2Bc2hEs2u29poXEL9tkgcq7NC/L
         qjVHSGEiBRircnx4r+HrhUYuyz5+6rEAauMgzFCcckg2WEqf6ljrlKqR5VnOMrQYe8wY
         GWeQ==
X-Forwarded-Encrypted: i=1; AKwUvBxpdpUWundUEoHhYuRVGfaRcQrbbLjy2o6ptJflgGlMbJUSQtt+DLvW/eztJLuFP0bXIqwoag8=@lists.linux.dev
X-Gm-Message-State: AFuF++l7J1qeV3PZEbGqa8hAMa0V4yHr8+1yNpBktRL0A9w0bTezBZsS
	nufak5j2X6puIMy3wl6AZ4tjnM/AlkG0EsOQiq4iobNVc5yn8DCm+CTPBseHzeUG9Q==
X-Gm-Gg: AYBFou32n22/w9MLobP7xvj63TLirdiTabSjR9pimQjv5mMqbXn+wCK/hLTqDX8BojJ
	i6AlTd/SFc/bMwbsizsG/CZaVYdnbobfDjo0pTXY6gDuP10qIkUin1FGt1QMNcQVPz6jpsSUCTF
	vuTryZJ2U0Bc5lCyW7cohs9+dEo1BfPqsuDsezQEJUjRkjb2qwxdObrMun3IQYFwcyGAT2RNHjZ
	6RhG9FS6s6Q5EloSVZGYSoSrJeJ811QQCbuLMVABgqo7nroNLhfhvXwyck3Wh3EzUS9lNJw9NUi
	fnGdiK2JdNf7vFEuzhjRrmk/65HPTZNvpcdDftL05LKZUvhlANZuXEKFV5gRSWBqsd15cTtYNVL
	dv1XjNbfWop+93jldbbHh8h2YWJWBpHa3ZdRH5AXx+0zv9+/rE7Lt8nH9Z/u9sUhDYM9GVLTFA0
	2SNCSXCUyQ4oyV54mir03f6KwBrdC62q/JOhmIk46LA4W+pVFFyzW5wkZZH6Tol+bUExXCdcAi3
	KJyDGwEGJPi+db8JNB8Y3mv3rGeGhcF
X-Received: by 2002:a05:600c:620b:b0:49c:fa20:cc07 with SMTP id 5b1f17b1804b1-49cff19cbf4mr236754075e9.30.1788878815281;
        Tue, 08 Sep 2026 07:46:55 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48594172546sm28296366f8f.15.2026.09.08.07.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:46:54 -0700 (PDT)
Date: Tue, 8 Sep 2026 15:46:51 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC
Message-ID: <aqAf27qhViD-V5ao@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-17-vdonnefort@google.com>
 <hrhbuwdfu625jtzm75t6wnva6odgreshchyv75ebqntlymslz7@adyxhe7oyypc>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hrhbuwdfu625jtzm75t6wnva6odgreshchyv75ebqntlymslz7@adyxhe7oyypc>

On Mon, Sep 07, 2026 at 06:39:49PM +0100, Wei-Lin Chang wrote:
> On Mon, Aug 03, 2026 at 11:09:00AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 41a8687938eb..355573d53fed 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -824,8 +824,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >   * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> >   * blocks in the input range as allowed by @mc_capacity.
> 
> Maybe also adjust the comment and remove @mc_capacity while changing
> this, looks like it was included by mistake.
> 
> >   */
> > -int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > -			     struct kvm_mmu_memory_cache *mc);
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> >  
> 
> [...]
> 
> > +static int host_stage2_split_gfn_meta(phys_addr_t phys, u64 ipa, u64 size, struct pkvm_hyp_vm *vm)
> > +{
> > +	pkvm_handle_t handle;
> > +	kvm_pte_t pte;
> > +	u64 gfn, end;
> > +	s8 level;
> > +	int ret;
> > +
> > +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (kvm_granule_size(level) != size)
> > +		return -EINVAL;
> > +
> > +	ret = host_stage2_decode_gfn_meta(pte, &handle, &gfn);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (handle != vm->kvm.arch.pkvm.handle || gfn != (ipa >> PAGE_SHIFT))
> > +		return -EINVAL;
> > +
> > +	end = phys + size;
> > +	while (phys < end) {
> > +		u64 meta = host_stage2_encode_gfn_meta(vm, gfn);
> > +		kvm_pte_t annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_GUEST) |
> > +				       FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
> > +
> > +		ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> > +				      phys, PAGE_SIZE, &host_s2_pool,
> > +				      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> > +		if (WARN_ON(ret))
> > +			return ret;
> > +
> > +		phys += PAGE_SIZE;
> > +		gfn++;
> 
> Annotating every PTE is required here because patch 2's
> stage2_map_prefault_idmap() copies the same annotation to each PTE, so
> the resulting PTEs all contain the same gfn.
> 
> In other words patch 2 simply leaves wrong annotations in this case, and
> we make up for it here.
> 
> We can't just remove patch 2 because a HYP owned block needs to be
> broken down with HYP owned annotations when a single page is donated
> back to the host.
> 
> With this, would it be a better design to have an annotation-aware
> helper that splits a host block properly including the annotations, and
> call it whenever pKVM annotates or maps host stage-2?

I ended-up with that solution because it is difficult to draw the line between
pulling pKVM specific knowledge in pgtable.c and reusing pgtable.c private
functions in mem_protect.c. So I wanted a mem_protect.c function that can split
the annotations, but without having to touch pgtable.c. Indeed, that isn't the
most optimal.

Looking again at stage2_split_walker(), perhaps pgtable.c could export only a
single additional function to allow implementing a pkvm version of stage2_split.
This stage2 split can then be used for both guest and host.

Let me see if I can optimise that

Eventually part of the "pkvm_stage2_split()" could be reused by
stage2_map_prefault_idmap() I'll see if that's worth it.

> 
> >  	}
> >  
> > -	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
> >  	return 0;
> >  }
> >  
> 
> [...]
> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index c4ebae0544d4..986b5a19b07a 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1537,9 +1537,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >  			       enum kvm_pgtable_walk_flags visit)
> >  {
> >  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> > -	struct kvm_mmu_memory_cache *mc = ctx->arg;
> > -	struct kvm_s2_mmu *mmu;
> > +	struct stage2_map_data *data = ctx->arg;
> >  	kvm_pte_t pte = ctx->old, new, *childp;
> > +	struct kvm_s2_mmu *mmu = data->mmu;
> > +	void *mc = data->memcache;
> >  	enum kvm_pgtable_prot prot;
> >  	s8 level = ctx->level;
> >  	bool force_pte;
> > @@ -1554,30 +1555,37 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >  	if (!kvm_pte_valid(pte))
> >  		return 0;
> >  
> > -	nr_pages = stage2_block_get_nr_page_tables(level);
> > -	if (nr_pages < 0)
> > -		return nr_pages;
> > -
> > -	if (mc->nobjs >= nr_pages) {
> > -		/* Build a tree mapped down to the PTE granularity. */
> > +	if (unlikely(is_protected_kvm_enabled())) {
> > +		/* pKVM only supports splitting PMD-level blocks */
> > +		if (level != KVM_PGTABLE_LAST_LEVEL - 1)
> > +			return -EINVAL;
> >  		force_pte = true;
> >  	} else {
> > -		/*
> > -		 * Don't force PTEs, so create_unlinked() below does
> > -		 * not populate the tree up to the PTE level. The
> > -		 * consequence is that the call will require a single
> > -		 * page of level 2 entries at level 1, or a single
> > -		 * page of PTEs at level 2. If we are at level 1, the
> > -		 * PTEs will be created recursively.
> > -		 */
> > -		force_pte = false;
> > -		nr_pages = 1;
> > +		struct kvm_mmu_memory_cache *host_mc = mc;
> > +
> > +		nr_pages = stage2_block_get_nr_page_tables(level);
> > +		if (nr_pages < 0)
> > +			return nr_pages;
> > +
> > +		if (host_mc->nobjs >= nr_pages) {
> > +			/* Build a tree mapped down to the PTE granularity. */
> > +			force_pte = true;
> > +		} else if (host_mc->nobjs) {
> > +			/*
> > +			 * Don't force PTEs, so create_unlinked() below does
> > +			 * not populate the tree up to the PTE level. The
> > +			 * consequence is that the call will require a single
> > +			 * page of level 2 entries at level 1, or a single
> > +			 * page of PTEs at level 2. If we are at level 1, the
> > +			 * PTEs will be created recursively.
> > +			 */
> > +			force_pte = false;
> > +			nr_pages = 1;
> > +		} else {
> > +			return -ENOMEM;
> > +		}
> >  	}
> >  
> > -	if (mc->nobjs < nr_pages)
> > -		return -ENOMEM;
> > -
> > -	mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
> >  	phys = kvm_pte_to_phys(pte);
> >  	prot = kvm_pgtable_stage2_pte_prot(pte);
> 
> I feel like this change is trying too hard to make the pKVM case fit
> in stage2_split_walker(). The assumptions differ by much: the original
> usage assumes kvm_mmu_memory_cache, can potentially split more than one
> level, and makes decisions base on the memcache's reserve.
> 
> Perhaps create another function for pKVM?

Looking at this version, the pKVM case is rather small, hence reusing the same
function made sense to me.

A completely separate function is actually what we have in Android kernels at
the moment.

Anyway, as per the discussion above, I'll probably try to create a pKVM specific
version of the split.

> 
> Thanks,
> Wei-Lin Chang
> 
> [...]
