Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CBC28EC
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 18:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748024581; cv=none; b=PNvIz/q1D7rBBiHMZ5N4e+7Yv8eKaRl5E1qFG2076YgypejZN0UGtzavWW+JWAiMKw+p3ZFkTKEifIIzOs1OWGQxwuQFaXkqrMizJ4L0dvwsU7ZmQRwQFaeeFjhEqy4EfKwq1CuDYC5KvKa3/+yj/4b01epvNwpFe6rvrRjnTTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748024581; c=relaxed/simple;
	bh=FURMKT+84TowhzsIkEhovGXkZpIiDzqXyGhEuCZKrmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKPYKG3bXuzVS8onNNMEJ9IAe6DhJpQyYhxWVILH4abmlMJiy1mPanjnmR1AsvfNTnx5umEWIdf2LUDhq+7kRuVk34N5Do+G7URwNIIwShgjT4GA109t9GP3yFh1u7fus+leQbX9AmaJC0JNIa3Lt3dbgNGNLlupLhAtjlr1cXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BC84KozT; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BC84KozT"
Date: Fri, 23 May 2025 11:22:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748024577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DDirBED/RpKwCCujxSMd9XfR80wHaG7LE4JgGKmfOtE=;
	b=BC84KozTHJZUTjh+gsS6zSv9wzEtZiclUw5/nthhNExdwUNVsrutGhU/I62lzgNCjJ9CBF
	K07Stvl2OR/lE8c4sL0cim0lDV7yDjHVhnEwlZbd7tvxnlKRzLf2X6N4WxlYSM3FJbj55r
	l5u57ZTxqA81sZSllKj94O4+f93FfmE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sweet Tea Dorminy <sweettea@google.com>
Subject: Re: [PATCH 3/5] KVM: arm64: Resolve vLPI by host IRQ in
 vgic_v4_unset_forwarding()
Message-ID: <aDC8-i9YQgCowJTr@linux.dev>
References: <20250523160810.4049313-1-oliver.upton@linux.dev>
 <20250523160810.4049313-4-oliver.upton@linux.dev>
 <87v7prdysh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7prdysh.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Fri, May 23, 2025 at 06:25:50PM +0100, Marc Zyngier wrote:
> > +int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
> >  {
> > -	struct vgic_its *its;
> >  	struct vgic_irq *irq;
> >  	unsigned long flags;
> >  	int ret = 0;
> > @@ -519,31 +536,19 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
> >  	if (!vgic_supports_direct_msis(kvm))
> >  		return 0;
> >  
> > -	/*
> > -	 * Get the ITS, and escape early on error (not a valid
> > -	 * doorbell for any of our vITSs).
> > -	 */
> > -	its = vgic_get_its(kvm, irq_entry);
> > -	if (IS_ERR(its))
> > +	irq = __vgic_host_irq_get_vlpi(kvm, host_irq);
> > +	if (!irq)
> >  		return 0;
> >  
> > -	mutex_lock(&its->its_lock);
> > -
> > -	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
> > -				   irq_entry->msi.data, &irq);
> > -	if (ret)
> > -		goto out;
> > -
> 
> Removing the reliance on the ITS locking is another thing that could
> be mentioned in the commit message, as it is slightly surprising to
> see it here, given that the previous patch is all about that.

Sure, I can add a bit of color. The prior patch left the its_lock in
place since it is still needed to walk the ITS device / ITE lists.

> My other gripe is that we lose the doorbell validation. I'm not sure
> it is a big deal, but I'd rather we keep verifying we're not being fed
> rubbish data, in case we need to rely on that in the future.

We still get doorbell validation on the set() side of things, which IMO
is where it belongs. Whether or not the MSI routing is garbage at time
of unset() isn't relevant, if we handed out a vLPI mapping we need to
kill it.

Thanks,
Oliver
