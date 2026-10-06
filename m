Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2684A3AAF60
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791283633; cv=none; b=tw6SoYrEQ+8YC4JGYI8R4Qdm2RjRvabAOgfnr1QyxyYgnsvngpjmmEs299GWf2Z+JUDYEcjKtCQBncbbRR1ALK8+cpRronLZgaiHeG1y21OcRojv0Ya8OtuRuuUJKxT7265AKzhj+Mj+rM+h8Hhk8T+pDC/HcZCpg0pdwT+LtbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791283633; c=relaxed/simple;
	bh=VCi/kjLFAJJGXjgxhIYMwC657u5zE4DOnBkrZHplcNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdzMdF2Vv0BqlihBat36qqPy9CKkZTAi8TR3nAOSbEV671DLSg9QVaIHqEXbKXx62iU8AekkW4rkW3h9r60i5s66KDc9h2ImhnOcdLw0NmbxnZbaK18CSLDtm2BywZMvebgs4jKHtXfjd3Z/Vxay5POMTDyCrerh3KfMaXao6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OUHgNs1H; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUHgNs1H"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a018493d57so55215e9.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 03:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791283630; x=1791888430; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oNhJI/vsDPATwVHCwRxldmCYKg+ihLyBJJx7xKlf2yc=;
        b=OUHgNs1HJCmsTYjVBafhalr0d0SFpD6Ycvfkbr0rpEUu+1gKcVUTGrWMqf57/69Kb5
         8d38IiOeepwb6d4kZshA6RWZWu5LgF6YCuAxTAG1J4IUBwpe+MxRCISowAgFPSCVBCNL
         92f57mX08xQ4whEMGndzjxlyXjR07qwnNuA36zUFe4LceXVNb0GaYgFPXieMJ79tiEcI
         g1FEqhz0zM7S1AxHprd7nmpnxls8PZTBvfU3fSvKXRo38FZ8YwUTA9vA9N3lK1VhZKJo
         llxcx0/90Ctat9SaNI9Cc/4gSZ2piLIBnUzSzpDBl3BI+u8KLNhOOp9P61z67FoiULBm
         LjkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791283630; x=1791888430;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oNhJI/vsDPATwVHCwRxldmCYKg+ihLyBJJx7xKlf2yc=;
        b=J308FS3UG4LVv03cl/GCJ7fWzSid5vOKbyMnYY6ktvAOLa3l82BJjXLmO1rJkYqUyE
         EMcppQneb02mN9fuNJ+8Ty7/CWpSg9CQ61xn2TXTh6N/wBsdNhsWEZqQI4wVS8DncQ1r
         3IDpfT7daqsz2OSNOOMC7IO1/KU78W/7hLcsiPRMpJ7oOOyR4eaP6TGGeGxDYLs0XcTO
         wlmrmJ1xpnaUp1Ff6wAyYLkT7M/Y0mVKeP7cyTtJRzCxzFGo6wa+mK4N9SQhT6rVmXe6
         +2QCp2/KUVzukh9i9BFVtOMlZLN3G3ELCsKGeLYJwhlTzfVFX+J0Zn672q2cm0jUT1/n
         +HTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzYivA/ztHENZ18ta7t2JiiQAXhX8HcR3FgzvEC3M6VADXtJf6FJRpI4/BovhIh5HHnbQ7xD1g=@lists.linux.dev
X-Gm-Message-State: AFuF++lx+lQ7HHy707439BXbRmVlgZiu3oIw6MHDRLPYKrs0iRAmVAli
	FqdvLMmp9ChBgLFI0tNCdK0CbVgdsWbcEhmqp+OIIAXQuaa/rcwWUX9owYzZYw6Sdw==
X-Gm-Gg: AYBFou2DZyr08wd9q6z7abG6IXhdne3zE8JaDRTN1nYNaEt/fQAoNWJmRn9Tf/65Mxq
	dMnJGeT0eAIkenL/EslV764twLxWkPN0eSNyhV/LLhtt1mKguXzGhXYqCeuxDC9tfHBCDTkRoce
	9Tup/xqFogahh7K7YlIxihdmn/smJrKBUYnkUwhS7LIp4dOsnBllFOxbwK4h5zZ+oCeTh8pUU6a
	GvRjbvTz6+NHGDpgO2SGbvAqWherJMykOq8inanBeEcjB1ssWTNIj0W2ubdcJWDVzv6FRDh3ym9
	lfmVUfVr2pVUf23bgroCwy5V/t811Bia26K0qFU17P5W46isjmKcnH1xkNY7xNpLAlYIk4DCu4s
	ypKP8003skwUmlBUGlcPChT3xj++XTh2+YzMir30rBrl30G2igViW1Wpvo27CcbgGn+Phvn6GQs
	pP7GbM2nSg0yPnHtrVmeODDe/i6vUJEiXuaqPi8DYaYA0p2ifXmS9QWyX4rwGfg97BKqGnFPK/7
	hmEnHiWTRHnRqzq34Qq1V00MELRNX7V2UN2nEUd
X-Received: by 2002:a05:600c:6290:b0:4a1:7af1:5386 with SMTP id 5b1f17b1804b1-4a17b4587a5mr465225e9.1.1791283629775;
        Tue, 06 Oct 2026 03:47:09 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c69afe66bsm3896689f8f.30.2026.10.06.03.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 03:47:08 -0700 (PDT)
Date: Tue, 6 Oct 2026 10:47:04 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, tabba@google.com,
	sebastianene@google.com, keirf@google.com, qperret@google.com,
	linu.cherian@arm.com
Subject: Re: [PATCH v3 2/2] KVM: arm64: Support BBM level 3
Message-ID: <asTRqPfsrnbBWVSF@google.com>
References: <20260904132855.638117-1-smostafa@google.com>
 <20260904132855.638117-3-smostafa@google.com>
 <asO77kvqqwCsJt8I@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asO77kvqqwCsJt8I@google.com>

On Mon, Oct 05, 2026 at 04:02:06PM +0100, Vincent Donnefort wrote:
> On Fri, Sep 04, 2026 at 01:28:55PM +0000, Mostafa Saleh wrote:
> > If the system supports hardware Break-Before-Make (BBM) level 3, use it
> > to replace stage-2 PTEs directly. Otherwise, fall back to the software
> > BBM sequence.
> > 
> > For BBML3 the sequence is:
> > 1) Get a reference count on the containing table for the new PTE.
> > 2) Atomically update the PTE with the new valid descriptor.
> > 3) Invalidate the TLB for the old PTE.
> > 4) Drop the reference count holding the old PTE.
> > 
> > Add 2 helpers:
> > 1) kvm_pgtable_use_bbml3(): Checks for the architecture requirement
> >    for BBML3.
> > 
> > 2) stage2_use_bbml3(): Extra checks added by SW design (FWB and DIC)
> >    - As BBML3 will update the PTE atomically, it can only know it
> >      raced with another core at the point of the cmpxchg failing,
> >      unlike the SW implementation which locks the PTE first.
> >      And as we must issue CMOs to the new mapped page before the
> >      update, that means with BBML3 racing cores will issue redundant
> >      CMOs.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 111 ++++++++++++++++++++++++++++-------
> >  1 file changed, 90 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index d670da8882a5..a9ba761e9a01 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -82,6 +82,27 @@ static bool kvm_pte_table(kvm_pte_t pte, s8 level)
> >  	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
> >  }
> >  
> > +/*
> > + * Check if BBML3 can be used for this PTE update.
> > + * Fallback to software break-before-make for leaf-to-leaf changes.
> > + */
> > +static bool kvm_pgtable_use_bbml3(const struct kvm_pgtable_visit_ctx *ctx,
> > +				  kvm_pte_t new)
> > +{
> > +	if (!system_supports_bbml3())
> > +		return false;
> > +
> > +	if (!kvm_pte_valid(ctx->old) || !kvm_pte_valid(new))
> > +		return false;
> > +
> > +	/* Block <-> Table is ok. */
> > +	if (kvm_pte_table(new, ctx->level) ||
> > +	    kvm_pte_table(ctx->old, ctx->level))
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> >  static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
> >  {
> >  	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
> > @@ -835,25 +856,46 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
> >  		mm_ops->put_page(ctx->ptep);
> >  }
> >  
> > +/*
> > + * Don't use bbml3 for stage-2 if FWB or DIC are not supported
> > + * as that means racing cores will issue duplicate CMOs.
> > + */
> > +static bool stage2_use_bbml3(const struct kvm_pgtable_visit_ctx *ctx,
> > +			     kvm_pte_t new)
> > +{
> > +	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
> > +	    !cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> > +		return false;
> > +
> > +	return kvm_pgtable_use_bbml3(ctx, new);
> > +}
> > +
> >  /**
> >   * stage2_try_break_pte() - Invalidates a pte according to the
> >   *			    'break-before-make' requirements of the
> > - *			    architecture.
> > + *			    architecture, if BBML3 is supported it
> > + *			    will be used and this function won't
> > + *			    break the PTE.
> >   *
> >   * @ctx: context of the visited pte.
> >   * @mmu: stage-2 mmu
> > + * @new: New pte installed in make.
> >   *
> > - * Returns: true if the pte was successfully broken.
> > + * Returns: true if the pte was successfully broken or BBML3 is used.
> >   *
> >   * If the removed pte was valid, performs the necessary serialization and TLB
> >   * invalidation for the old value. For counted ptes, drops the reference count
> >   * on the containing table page.
> >   */
> >  static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> > -				 struct kvm_s2_mmu *mmu)
> > +				 struct kvm_s2_mmu *mmu, kvm_pte_t new)
> >  {
> >  	kvm_pte_t locked_pte;
> >  
> > +	/* All handled in stage2_make_pte() */
> > +	if (stage2_use_bbml3(ctx, new))
> > +		return true;
> > +
> 
> Wouldn't it be easier to keep try_break_pte/make_pte to the !bbml3 case and to
> just create a make_pte_bbml3() variant to be called when stage2_use_bbml3()?
> 
>   if (!stage2_use_bbml3()) {
>       if (stage2_try_break_pte())
>           return -EAGAIN;
>       stage2_make_pte();
>   } else {
>       if (stage2_make_pte_bbml3())
>           return -EAGAIN;
>   }
> 
> I believe also, the error path would look less weird as we catch an error in
> make_pte() but without reverting the break_pte() (even if it is correct right
> now).
> 
> And perhaps you could introduce a function that does both break/make
> (stage2_update_pte()?) called by both stage2_split_walker() and
> stage2_map_walk_leaf(). This would avoid repeating the error path.

I though about that and was not sure about it at the beginning as
mentioned in the cover letter:
    Initially, I encapsulated the full logic of BBM in one function,
    which was not readable, due to different ordering and dealing with
    CMO, TLBI.

I think that can be better if we call the new helper for all sites
except for stage2_map_walker_try_leaf(). Although we would need to
open code the bbml3 check there now. I can try and see how it looks.

Thanks,
Mostafa

> 
> Otherwise, everything looks functional to me.
> 
> -- 
> Vincent
> 
