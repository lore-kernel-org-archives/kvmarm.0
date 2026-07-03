Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F781F94F;
	Fri,  3 Jul 2026 22:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783117159; cv=none; b=piIPr/Rf9xnC/n1VGk6qYmPXSjKTXNvKDaHJfZBUcsIF96dXjF+v+Zpz28d1W0XguEJ7vWI52MKV9oUoeG8cHPSYlEStM+FLZrXROlrOKM7ZBcSz4rQ4Ea2ucZWO9JaSF7LUEvqS7vTpAXF+Ka7rp34LBfIRE3vgW/ILO2d3vsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783117159; c=relaxed/simple;
	bh=/V631/4wUDiGoHeAU38kgV8SpQ7msZE1ng/WuDD/vzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qB5BaPA1m3iJA2gg9//fUJnV1u/MvkSuFledx5/ePIO6Nxl3Y7YyzR2WNjXebSz0NAaAuNo9M9pAq/zJNbMP88q4hh88bHexx2mbbLvVKaOmZ6gKUIFBuqmejiBjswRB+4i90sQUY4i+Rryt8b4Kw/+V0BqwOmaQ8ebvVKHfaUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbosTOBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbosTOBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEF81F000E9;
	Fri,  3 Jul 2026 22:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783117158;
	bh=C4G9rPe/p9YQKEt6zR1zG/eZsME86WBi5aUh/V67Egw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VbosTOBfG5YWtFull86B2ZtlX9TxvqKe6HH0U4pudyhzE0gK/OOEHN9qTTrztyBja
	 hj1N5xgfGeP6mQBHc9OPQhnhIXDfqM/u5P0GHdPu3yPaUKhhWMPZ5dLmmWccFCPHmF
	 rwxNyglMWvhLjJ4blc1z+69kLEuA9B9AA3yKJ3X1iU8BV+Bdph8gYJ0QW9Imeyxbui
	 dlp9F0cTN6znMUxkKKMJmn/F5nNQhzu/3iJpxfjsfTby5z4tigeEym3dYnN+m0op+/
	 f+EMMw5Z93R/eSe07hWMW/KjfFapZVNNZhIv3RhlcWWLq1C1PtCk8Ey8fhRUHsEUoi
	 gKXF8DTqD2Z/A==
Date: Fri, 3 Jul 2026 15:19:16 -0700
From: Oliver Upton <oupton@kernel.org>
To: Carlos =?iso-8859-1?Q?L=F3pez?= <clopez@suse.de>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, maz@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] KVM: arm64: vgic: Fix race between LPI release
 and re-registration
Message-ID: <akg1ZAUJXbLDjBI1@kernel.org>
References: <20260703122601.2617577-2-clopez@suse.de>
 <20260703122601.2617577-3-clopez@suse.de>
 <akg0DgQvu4lsESCG@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akg0DgQvu4lsESCG@kernel.org>

On Fri, Jul 03, 2026 at 03:13:34PM -0700, Oliver Upton wrote:
> Hi Carlos,
> 
> Please wait a few days between spins, we were in the middle of a
> conversation and I didn't have a chance to reply to you since yesterday.
> 
> On Fri, Jul 03, 2026 at 02:26:00PM +0200, Carlos López wrote:
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index 67d107e9a77d..577286069368 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -116,7 +116,15 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
> >  		kfree(irq);
> >  		irq = oldirq;
> >  	} else {
> > -		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
> > +		/*
> > +		 * The entry is either empty or contains a dead LPI (refcount=0)
> > +		 * from the deferred release path, pending cleanup by
> > +		 * vgic_release_deleted_lpis(). Evict and free it if present.
> > +		 */
> > +		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
> > +		ret = xa_err(oldirq);
> > +		if (!ret && oldirq)
> > +			kfree_rcu(oldirq, rcu);
> 
> We need to assert the assumption here that the evicted IRQ has a nonzero

s/nonzero/zero

Obviously not reading what the hell I'm writing :)

> refcount and is pending release. Otherwise I feel like possibly leaking
> memory is better than potentially introducing a UAF.
> 
> Untested diff below.
> 
> Thanks,
> Oliver
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 4477f870c7b3..621a83399184 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -116,18 +116,28 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  		kfree(irq);
>  		irq = oldirq;
>  	} else {
> -		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
> -	}
> -
> -	xa_unlock_irqrestore(&dist->lpi_xa, flags);
> +		oldirq = __xa_store(&dist->lpi_xa, intid, irq, 0);
> +		ret = xa_err(oldirq);
> +		if (ret) {
> +			xa_unlock_irqrestore(&dist->lpi_xa, flags);
> +			kfree(irq);
>  
> -	if (ret) {
> -		xa_release(&dist->lpi_xa, intid);
> -		kfree(irq);
> +			return ERR_PTR(ret);
> +		}
>  
> -		return ERR_PTR(ret);
> +		/*
> +		 * The expectation is that only LPIs which are pending release
> +		 * could possibly be evicted by storing the new entry. Free the
> +		 * old IRQ only if this is the case, as otherwise someone else
> +		 * could still hold a pointer on the outgoing IRQ.
> +		 */
> +		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount) &&
> +					    oldirq->pending_release))

		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount) ||
					    !oldirq->pending_release))

Thanks,
Oliver
