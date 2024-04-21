Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C307E6
	for <kvmarm@lists.linux.dev>; Sun, 21 Apr 2024 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713719015; cv=none; b=sc9bY8XgpSvyjeDKYwMQnYOPVllCtSyacbEZD2imgAo5XkaS8dUs1SuMppoxGSv3Dq8a9ZguH7KZm2JLx4C/J3FRYsAVRiHTRGqWPou49Q50cynI5I8+D4hWpBfuT6wf5TAJN5FRmNSL2xORi1sGblKT25QwJbw1FvlzypVsCKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713719015; c=relaxed/simple;
	bh=IdQyYEHNH1LVzoiu9R0CjRnJRd4AGpKf2yu362x7Qlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQKbtVv6jZPUys890X0lH0EuJX1X72+c23EoAjCRfZoSHS5tTL8xEMaCPD20ChwAzBX9l7t5YLWbYzTV0a9gc563auz2CxHkBfStsELwLGmBWmk3J4/mFF8LczQlKRS155ExBDMbTWNitXg92koc7CDQGAlVFwWVSLP5Kh9DFHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xaib81hK; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xaib81hK"
Date: Sun, 21 Apr 2024 10:03:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713719011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ocqqMtd1Xliboul5e7kfC49oq6NYAajrGvLkT0CruOI=;
	b=xaib81hKJDQ5Dq04epPuYyoBAJhD6+HQ5AoNU+t6LDFT9gO+bHHqmFWtFvp2V3/AitYkHe
	DJEH61zu4SgYFuBREaLbdX6Gg6YsMKMW8f0CsTt4+qrCOxKuKhm8tNSOcQPddiMZMiLuPo
	6GJ4xUDm7PuLF8VxhPJFH67v7/i3fkA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 09/19] KVM: arm64: vgic-its: Maintain a translation
 cache per ITS
Message-ID: <ZiVG3JoK1Soe6Eqj@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
 <20240419223842.951452-10-oliver.upton@linux.dev>
 <86mspnqa8e.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mspnqa8e.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 21, 2024 at 11:30:09AM +0100, Marc Zyngier wrote:
> On Fri, 19 Apr 2024 23:38:32 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > +	if (xa_reserve_irq(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT))
> > +		return;
> > +
> 
> This thing tickles me a bit. What does it mean from the PoV of the
> caller? That although we have missed in the cache initially, someone
> else is populating it?

Sorry, I'm a touch confused. This call is to preallocate space in the
xarray to store something at index @cache_key. Even if there already was
a valid entry (meaning no need for memory allocation), xa_reserve()
ought to return 0.

> The final code reads like this:
> 
> 	if (xa_reserve_irq(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT))
> 		return;
> 
> 	xa_lock_irqsave(&its->translation_cache, flags);
> 	rcu_read_lock();
> 
> 	/*
> 	 * We could have raced with another CPU caching the same
> 	 * translation behind our back, so let's check it is not in
> 	 * already
> 	 */
> 	db = its->vgic_its_base + GITS_TRANSLATER;
> 	if (__vgic_its_check_cache(kvm, db, devid, eventid))
> 		goto out;
> 
> Does it mean we could drop this check? And even relax the locking?

I don't think so, a race still exists. For example, Userspace could issue
concurrent calls to KVM_SIGNAL_MSI for the same device / event.

We could do away with the *explicit* locking if this code were
restructured to drop references on old entries returned from xa_store(),
like:

static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
				       u32 devid, u32 eventid,
				       struct vgic_irq *irq)
{
	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
	phys_addr_t db = its->vgic_its_base + GITS_TRANSLATER;
	struct vgic_irq *old;

	/* Do not cache a directly injected interrupt */
	if (irq->hw)
		return;

	/*
	 * The irq refcount is guaranteed to be nonzero while holding the
	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
	 */
	lockdep_assert_held(&its->its_lock);
	vgic_get_irq_kref(irq);

	/*
	 * We could have raced with another CPU caching the same translation
	 * behind our back. Ensure we don't leak a reference if that is the case.
	 */
	old = xa_store_irq(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
	if (old)
		vgic_put_irq(old);
}

-- 
Thanks,
Oliver
