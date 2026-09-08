Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4E93451CD
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 10:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862041; cv=none; b=oDY9/QMedrhHtZo0juAYDvGNhxGYEUYqBG11GdRr/UMJSeH2E4CnLPDlsP7oqr4TRBEQa4CLM2k0CYt5W0TkxB20VOtC1bYbmZ75r4EbZSp7wuYqIAa63m9nGlL0Bqo6u0i8Ciz9VdnXrizXuCknv4Mof/MKa2bFoYmsWoeRjss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862041; c=relaxed/simple;
	bh=YAeJ564bw4dqsOLc/ubCUWi8tUr7lonEE542V0Wv9uY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnDwCSE/G1+xNylGb+SANTNCQHkQ0F1CAHnZNlXjjKsL/mxcJ8lQH41VJma98nYaNiknfihFTMUltWrNcehDabTYdOvqjGiI32xUc82iwCmLF8EwXCaBvgbFQTOGyhm8wKmmBVw349RPo4Eb2+5RcEnmG/3kqy44e6oZhJN7Hcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ff3EuSi+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ff3EuSi+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so62281755e9.3
        for <kvmarm@lists.linux.dev>; Tue, 08 Sep 2026 03:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788862038; x=1789466838; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VQwFKkNHohYJqLfEiVBsi1W4lxWzuV9PCdLiSox37RE=;
        b=ff3EuSi++3HCmCw9yyMnm2TZ2UePcO5GR8431dQZKOgWYJenZ0+piyqnSMuRc/jbY+
         1qqqWuTyS2qgSKkuSYvUGfHTBfXI+P2Fep6wFRytGSbBDkGm1CUkE4OYhl4PCq4dA6GD
         w6lkZ+YAkzBa8exHC8OaTcvUIuTK/qzW79+lx5nRe137PTcIaH+qiQV+CvuMTw2ZL3XM
         n5nEUwWTrbYu6nnNhSfvx9lq5aDf4T5NODomnfoxwjd6IE2GF514B2m1ORm6kDHTb8zo
         8QSg+SHUNzgcaS+tsXUHqnvZ0GCyzub1asBzBrm8gf3AE4iHnK6ZlOXmYqvAOV4+AnWb
         L4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788862038; x=1789466838;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VQwFKkNHohYJqLfEiVBsi1W4lxWzuV9PCdLiSox37RE=;
        b=adr3HL6uNxSFaRF98+doducU7/9lWG/JFLScsrmtgSPzj/F2I4HrQVd/rIVNm53yYz
         IuhEmtcz76F84jJLBoAutmYcU4qNOp+aqDpriMu/ZkBQ+MPNTbmTW/Q0t9+d33Z8/PC9
         VUjcBB/E8I7EjyPS1ek5xCz0HKuIiVh++VcHTJqmmgUVqB0AGY3OkpEVg2Hgwx2o+NCN
         vZDiMeDPw0P61EWVXvtdTH1bLbEe1jaJEzQEWRr0ZNACCO1uUA5tCzRS8H0RgJh4J4Jt
         bJF1wGwTq+ArKXCJC8tn7qtl+/+2byNobTJ4PkSJ/0by4l8fysrpRlgUc2KAsC7LJMs7
         L85Q==
X-Forwarded-Encrypted: i=1; AKwUvByWePHnX7u4NSgpnYfyldHBg8E+9C0rmWrG6ZyAaE9rwe/826xuzL5GdRR+Fe0MimsZdz1XC6c=@lists.linux.dev
X-Gm-Message-State: AFuF++nlvHYRyrj5bs+w93YlpKaVfO9VKZiad6nQCoFEotBjS/YoUpB8
	rrUEN8s/rk7/xnfb4hfV6nJYUIJo0j5ozJKf1WwyhBdDqbAUojVh2gW5pHfX8+T2sQ==
X-Gm-Gg: AYBFou1gFjE9GT+0QAp1t6SlUwT1oTPP5UbP1dTCnGLh4JC4R288CPOa0ZNBZ7SrcE6
	zx9/Jc5TbrYvH9nulTHAEYnW0Vb2ObJQt34jD3PGITbRmQhglv+LhKXZJg0kdp1LMAkM5y1Aa+G
	iFtd8yyUke2izU9unJOYF0xEGJfyQmab99NesI0HfTOxE5kAtTM+eO8MH0w397/YuSamhFP3MSl
	cPje0V0sXYYmex2KsmT4L39GvSC2fRwGH6hGPy1myH/FdfZTY0ZhzuoeW4faXLCoOzqANZz+79a
	cNnG9pP33v77yf1Ub6HzCVqoD2W+HPxMwZiJsL0wf+uvR3Dp3fcHKj348KtRKgBQXZ/hzXTkVm/
	fpaallKBQBcseD8mNXYK++hJb4dzJHGhs6PqcgJQpLmUE694+HMa2nCfz0QzZ6WBevsj0JhGhoD
	lHaSpjsGVnj88pSkdRuu7RNLi6vpL9B8YC4I2uBULvc6Uq3DAjs4atrVFQSsmtB8fkeCjjobYdr
	/SzgOv3Iz7WePX4sGdqAII98eHiJQn0GVnOVR/jDKE=
X-Received: by 2002:a05:600c:8b05:b0:49c:edd2:855 with SMTP id 5b1f17b1804b1-49cf823c411mr287008465e9.6.1788862036554;
        Tue, 08 Sep 2026 03:07:16 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee7fec25sm544179385e9.13.2026.09.08.03.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:07:16 -0700 (PDT)
Date: Tue, 8 Sep 2026 11:07:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 02/20] KVM: arm64: Propagate host stage-2 annotated
 entries on block split
Message-ID: <ap_eUDk2Oo2-qIcm@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-3-vdonnefort@google.com>
 <s3p6em2fovzkpyy5lpslxl7nl6ojhoilyqlydidy4unef6wnuw@mzgrpwwkbaxn>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s3p6em2fovzkpyy5lpslxl7nl6ojhoilyqlydidy4unef6wnuw@mzgrpwwkbaxn>

On Mon, Sep 07, 2026 at 02:58:41PM +0100, Wei-Lin Chang wrote:
> On Mon, Aug 03, 2026 at 11:08:46AM +0100, Vincent Donnefort wrote:
> 
> [...]
> 
> >  static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
> >  {
> >  	kvm_pte_t block_pte = ctx->old;
> > +	bool counted, valid;
> >  	u64 pa;
> >  	int i;
> >  
> > -	if (!kvm_pte_valid(block_pte))
> > +	counted = stage2_pte_is_counted(block_pte);
> > +	valid = kvm_pte_valid(block_pte);
> > +
> > +	if (!valid && !counted)
> > +		return;
> > +
> > +	/*
> > +	 * Shared walks not supported: cannot rollback refcounts on break
> > +	 * failure.
> > +	 */
> > +	if (counted && WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> 
> Doesn't patch 1 also need this shared walk check,

Only the host stage-2 has the IDMAP flag and will run this function.

For the host stage-2, only non valid PTEs and non-RWX PTEs are refcounted.
  * non-valid PTEs are skipped in PATCH 1.
  * non-RWX PTEs are forced PTE-level.

So there's no risk of hitting a refcounted PTE in this function until PATCH 2.

-- 
Vincent

> 
> >  		return;
> >  
> >  	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
> >  	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
> > -		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
> > +		kvm_pte_t pte = valid ?
> > +			kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1) :
> > +			block_pte;
> >  
> >  		/*
> >  		 * Skip ptes in the range being modified by the caller if we're
> > @@ -1053,8 +1066,11 @@ static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, k
> >  		 * that should happen very infrequently.
> >  		 */
> >  		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
> > -		    (pa < ctx->addr) || (pa >= ctx->end))
> > +		    (pa < ctx->addr) || (pa >= ctx->end)) {
> >  			*ptep = pte;
> > +			if (counted)
> > +				ctx->mm_ops->get_page(ptep);
> 
> and this get_page() ?
> 
> Thanks,
> Wei-Lin Chang
> 
> [...]
