Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82D318E04E
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 06:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729147196; cv=none; b=BMPmqgsMx5fmr+OkyZwVReUhuPOg8ZjzbJuQalRWhFPoo02pqHXxijfvmN6U9HjMFx1MOUV8gr/V+lG6APIa6dOZKPMRZvF1h6lGlqKVVuU/v+erYUVvDIp16uC1iR9Sbt4WvnNEhbPZbY+1XFgLKwL1d/HWBJNGjc/Y0Xlb8mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729147196; c=relaxed/simple;
	bh=Ahi5x0yhZX83vXZdi7Z3WjWyhYboIUJJkm8mE/jznK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5KN4v3z8Lvz0ajbc+/mt+uPFgbJVLXvkijW0UyvOdm6ZzSKiwkH8lea6L1o3uAVpClcRRPZ80EhXaUK+UBCTILycVQCog1NjimVZENRElvT8WtcBVgeHttHqkrQEizQizuM8am6enPovIGyD6/hKX1iDPzeLafGWyH/QIi1R20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n1UHIbAM; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n1UHIbAM"
Date: Wed, 16 Oct 2024 23:39:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729147191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UvnCZ0YB/sgOauIYIlHpcBslfSA4W1kgb4ISSzXCTyM=;
	b=n1UHIbAM2iSsVxc/71vlBp2vXVI3u1K2EyG+ExAbupv690Hvy4Tfbp6ZEmyPppuhkH78sB
	ALWnQ6PQLTHWp39vDpr8hviJjQpRWimvdY+AioeiwPrZv8HB7z3d1/+PAaoJL0Ar0GLmMQ
	tv9a5jAJx/zAWWODJMwzxuV5dAlro7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: WangYuli <wangyuli@uniontech.com>
Cc: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	rdunlap@infradead.org, sebott@redhat.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
	zhanjun@uniontech.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-its: Do not call vgic_put_irq() within
 vgic_its_inject_cached_translation()
Message-ID: <ZxCxL8ZCHRm7RTCA@linux.dev>
References: <FEBA39FEBDA1C9D7+20241017061334.222103-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FEBA39FEBDA1C9D7+20241017061334.222103-1-wangyuli@uniontech.com>
X-Migadu-Flow: FLOW_OUT

Hi,

On Thu, Oct 17, 2024 at 02:13:34PM +0800, WangYuli wrote:
> There is a probability that the host machine will also restart
> when the virtual machine is restarting.

This is a start, but can you please describe in detail what the flow is
you're seeing that leads to the refcount bug / UAF?

> Commit ad362fe07fec ("KVM: arm64: vgic-its: Avoid potential UAF
> in LPI translation cache") released the reference count of an IRQ
> when it shouldn't have. This led to a situation where, when the
> system finally released the IRQ, it found that the structure had
> already been freed, triggering a
> 'refcount_t: underflow; use-after-free' error.
> 
> In fact, the function "vgic_put_irq" should be called by
> "vgic_its_inject_cached_translation" instead of
> "vgic_its_trigger_msi".

This line doesn't match your patch, and instead aligns with the upstream
behavior.

The put in vgic_its_inject_cached_translation() pairs with the get in
vgic_its_check_cache(). We need to do this because the LPI injection
fast path happens outside of the its_lock.

The slow path for LPI injection takes the its_lock and is safe because
the ITE holds a reference on the descriptor as well. Because of that,
vgic_its_trigger_msi() doesn't touch the refcount on the resolved IRQ.

So I'm not following how any of this leads to the underflow you observe.
Even if the put in vgic_its_inject_cached_translation() causes the
refcount to drop to 0, it is likely that an unbalanced put happened
somewhere else in the ITS emulation.

-- 
Thanks,
Oliver
