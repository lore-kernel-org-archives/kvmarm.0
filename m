Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BBA15A86D
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 01:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780363920; cv=none; b=bCcR743BQj1lkeSrYGDWzSne2aWkO0IIvQubCY/QBb3knko8lhb9UyR2a6ry8zK2gf5+22u/s+oJwWOV5EbkZyllYcRhxuVsGb3XuF2Ee2GdcHcqYkZ3DjNxdmS+nEreP/DrIw1jNmTBeC534nDo6gpLyYKS5WRcJeuF3jkCFg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780363920; c=relaxed/simple;
	bh=enAQ0z2rMaOhfApLzKBYrRY1EShBbcJkVSMXj1eBNwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTKMqeoLkLulHOJYvrfxMV9IQfBv1QqIGYnQLE/8ThDBzqcBfqjaKrkwHBrKv7RVNNHnhbaoq7JT4A+vTyx47896Wn8w0CFxPTJWp4cG2cgy7thZhakeq2gapF1wcl7ZQg5o2ZYcGPEmnH+zXz0FBo/YLubTBJdxjhr63XFb2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOMrVrWe; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOMrVrWe"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36bcf3d2565so2030470a91.3
        for <kvmarm@lists.linux.dev>; Mon, 01 Jun 2026 18:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780363918; x=1780968718; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b3xy2uhIBa9uRGlGCKv6RNNnKNeckiaUZ7Fy0PM5Q/c=;
        b=KOMrVrWel5Ujb+Vu7tQaijAPVA0I+iwFe5+kB9rUVqgrJRI2AVXYzVz55rSGhLCdhS
         AcJeVkfNRHd0/1l6lTiPKKi8JWZiE/OMvv2blhmQVdVfAXXBd3bx4H6O6WZpoRhlS1bl
         cKLfzYUdhpJ11xrGYWR8D872nUgseq8OjMkDFhLfA3zPRmNXp58aeg3WIT0Pk1D9wMPl
         bBp0lqIM4s7h21JC6mtsfEA6q+6uTHahGqfO9NEQpkVzk223DqH6kqQJ3xfdz/54mbbh
         SNXit4cCx/dgUIhWkVBvqsHyYH1LeIFskEOtD8b052m+TNRhlAbO8wrUnpKBxeS4JwG7
         Ssiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780363918; x=1780968718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3xy2uhIBa9uRGlGCKv6RNNnKNeckiaUZ7Fy0PM5Q/c=;
        b=Ns/+0WBKBsM/OKMAe931dGqAv1NVOOcYWHNJ+AizGQENM1zckwSvL/9tRt/iwhqk0z
         CLgVHCqHR3YiH3/EWRWrD0sNwzYKCwk48p0Hrl/r57y04bGp76JSf1lztpuFf2XzQKn1
         3/85C/qdRGIcExl9tEyyF30s3tPp4xouBPyPj+T8tlpvu/1mB9GPPy1xNuETWSPRUCgn
         Y+palq4RKTp2dnQwko5gJI0Ue+WtGk/uah3c7wyKPzDYfhttGmb1UlacytRXU8BocDkD
         Yas/pjJY0aZs8/jpu4LUnnvQNA4ULD9FgAXy7ebLaCyHdlc1WN5PmOksjpI5pKC8JSek
         g0rQ==
X-Forwarded-Encrypted: i=1; AFNElJ8F4L3Byhjun4OUXqpngUgd4ZMHK2nPs2r9fZxomr0/jNRpkKvJ53+VLKIEAI9WX43Xy3Muxnw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7tcDiTywDnn+nUgvVoWi9qvcibyyCbJf6hKFSnK7ZPccmhJTI
	rGyuZvRoLfzicaekV2eiaJgGhfdB0eBgn7XxjLdTL9oJOkWYHL5HaU1k
X-Gm-Gg: Acq92OFgxI1G/Ul5MPWppBie/84sPoH6AnF8nPpNqQOLuLzJEyOJYfTnLWFXqDn4mlI
	XJXwjGK2LnRKJcMegGZWtRMchhfs7+nUa8dc2xTemsMHOHVt2+ffQILSot+B5R0k4L55VUuZ4nn
	Fpj8/pQCHYy5sCmDWQMK1A0mZ+lQZH2aC39dz83L/bMNeFHW0ecSHa8NWvenbU6WVuEFIXkeGrn
	gsEtXgGzKC4uWt5d+jhVo0lHmE5F3U36FCppwQDVQkwsd2s7Afc/8C15Td9mnKDwmfYyRSEZ7xt
	1+8H14/ZKjnH3TRmthdBjooLK3VSAiyG36iAGWQaOCjaKw2UR+/gIbgUezXL2PoEPOJpBgOY29v
	6oe1BH+3qYK/yg7YZCPMbjbL2QIx81sppmwEC7X6wdLsfg9hNltwSlInixzvU0Mho4z21ur22Sv
	oxlstIc7Qr+HqbnMLwHSoRV78MtILOtNNs6Bt8gJ2LDVEDiYcg4FGpLIeXrNqkx3JH
X-Received: by 2002:a17:903:3884:b0:2bf:33a9:bf4a with SMTP id d9443c01a7336-2bf368a3d92mr163696255ad.38.1780363918317;
        Mon, 01 Jun 2026 18:31:58 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm112089405ad.25.2026.06.01.18.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:31:57 -0700 (PDT)
Date: Tue, 2 Jun 2026 10:31:53 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Oliver Upton <oupton@kernel.org>
Cc: maz@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kees@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: Re: [PATCH] KVM: arm64: vgic-its: Drop the translation cache
 reference only for the erased entry
Message-ID: <ah4yiavdXTB10P0d@v4bel>
References: <ah2c5lu4JbUg7dj-@v4bel>
 <ah3Yx0fjguUdCk_G@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah3Yx0fjguUdCk_G@kernel.org>

On Mon, Jun 01, 2026 at 12:08:55PM -0700, Oliver Upton wrote:
> Hi Hyunwoo,
> 
> Nice find.
> 
> On Mon, Jun 01, 2026 at 11:53:26PM +0900, Hyunwoo Kim wrote:
> > vgic_its_invalidate_cache() walks the per-ITS translation cache with
> > xa_for_each() and drops the cache's reference on each entry with
> > vgic_put_irq(). It puts the iterated pointer, though, rather than the
> > value returned by xa_erase().
> > 
> > The function is called from contexts that do not exclude one another: the
> > ITS command handlers hold its_lock, the GITS_CTLR write path holds
> > cmd_lock, and the path that clears EnableLPIs in a redistributor's
> > GICR_CTLR holds neither. Two or more of them can drain the same cache
> > concurrently, and if each one observes the same entry, erases it and then
> > puts it, the single reference the cache holds on that entry is dropped
> > more than once. The entry can then be freed while an ITE still maps it.
> > 
> > xa_erase() is atomic and returns the previous entry, so put only the entry
> > that this context actually removed. The cache reference is then dropped
> > exactly once per entry even when the invalidations run concurrently, and
> > the behavior is unchanged when only one context runs.
> 
> Next time:
> 
> Cc: stable@vger.kernel.org
> 
> > Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 1d7e5d560af4..1e3706ac3b8e 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -597,8 +597,10 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
> >  	unsigned long idx;
> >  
> >  	xa_for_each(&its->translation_cache, idx, irq) {
> > -		xa_erase(&its->translation_cache, idx);
> > -		vgic_put_irq(kvm, irq);
> > +		/* Only the context that erases the entry drops its cache ref. */
> > +		irq = xa_erase(&its->translation_cache, idx);
> > +		if (irq)
> > +			vgic_put_irq(kvm, irq);
> >  	}
> >  }
> 
> This definitely works but TBH I'd rather just plug the subtle race and
> do invalidations behind the its_lock since it already nests with the
> cmd_lock.

Thank you for the review.

> 
> Could you give this a spin?

After testing, I've confirmed that this patch approach works well too.

Shall I submit v2 based on this fix?

> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 2ea9f1c7ebcd..b2225da212ec 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -596,6 +596,8 @@ static void vgic_its_invalidate_cache(struct vgic_its *its)
>  	struct vgic_irq *irq;
>  	unsigned long idx;
>  
> +	lockdep_assert_held(&its->its_lock);
> +
>  	xa_for_each(&its->translation_cache, idx, irq) {
>  		xa_erase(&its->translation_cache, idx);
>  		vgic_put_irq(kvm, irq);
> @@ -607,17 +609,16 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm)
>  	struct kvm_device *dev;
>  	struct vgic_its *its;
>  
> -	rcu_read_lock();
> +	guard(mutex)(&kvm->lock);
>  
> -	list_for_each_entry_rcu(dev, &kvm->devices, vm_node) {
> +	list_for_each_entry(dev, &kvm->devices, vm_node) {
>  		if (dev->ops != &kvm_arm_vgic_its_ops)
>  			continue;
>  
>  		its = dev->private;
> +		guard(mutex)(&its->its_lock);
>  		vgic_its_invalidate_cache(its);
>  	}
> -
> -	rcu_read_unlock();
>  }
>  
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
> @@ -1725,8 +1726,10 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
>  		goto out;
>  
>  	its->enabled = !!(val & GITS_CTLR_ENABLE);
> -	if (!its->enabled)
> +	if (!its->enabled) {
> +		guard(mutex)(&its->its_lock);
>  		vgic_its_invalidate_cache(its);
> +	}
>  
>  	/*
>  	 * Try to process any pending commands. This function bails out early
> 
> --
> Thanks,
> Oliver


Best regards,
Hyunwoo Kim
