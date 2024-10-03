Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC5138DD1
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 17:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727977964; cv=none; b=YTEc0QeLdySUWSUiYeUnlQpSt2bXBqASemzRUduTT5Zohl8/TlyLF/KK+F6sZl2GH6mCT0IuWttgsQ+2cDJ0RdjwHt5/6rjJyrYupktUzH5W6nZMuA14hYHyRAoFEqUahODe638p5tonK1sSj7yYosI2RIxnZawb/5b22Wd7fOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727977964; c=relaxed/simple;
	bh=ktgUS3sAoeAE0ngqC+F819XNtko9OW1qIv4epnvr0u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bUue6g1v7dhPMXg59LNPMgueGGg8D87hAmkrgNw2OesI36u1ZLXAXvGK7Jp9ON6Zy7LoK4T6zheOi3C+RrNAeKnPnaTHWwblkJFB+p6hzs8SyHGYy5cX0Z3tkT7r+AbLHLO86qPx19hSsq3cDHU7n7z0qVAMjyHsooZVWJpOukI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=urJxj+lA; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="urJxj+lA"
Date: Thu, 3 Oct 2024 17:52:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727977958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cznqk+x1KiQ5rHKmxrO0wQvscqIrkPck3IlkjXi4jvY=;
	b=urJxj+lAW7isAHd8UpR9w6mdlsF8Cz0ksSIgM3gbe3OdmuK5Y80h9G9Nft0aDu+7lvSF4h
	A2BWy5h4Iv1DXvXoUa7AXt5jhC8zgf7fKe30sAHcmDGm04+iRnb18qHS1Bux5OBujLOZpU
	eoGyMbAZiIhpbELsXt5OWjiIauMRQb4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <Zv7Z4D0L3bnxJi8h@linux.dev>
References: <ZvxH3el9SNuNWwi8@google.com>
 <ZvxeeVn8LphHxWeS@linux.dev>
 <ZvyFkqsRFBAYwqP7@google.com>
 <86cykj75a0.wl-maz@kernel.org>
 <ZvyOcnZqNzfD7MZx@linux.dev>
 <ZvySjfDWOhl2O1IA@google.com>
 <865xqa6q0a.wl-maz@kernel.org>
 <Zv3fcT9lCSujib7J@linux.dev>
 <Zv3hgOhjaQGAuIOG@linux.dev>
 <Zv7KNFX4Mykff6I5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv7KNFX4Mykff6I5@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 03, 2024 at 09:45:40AM -0700, Sean Christopherson wrote:

[...[

> > > OTOH, our global TLBs don't model hardware exactly since a vCPU doing
> > > rapid context switches trash the TLBs of *all* vCPUs in the system.
> > > The cost of reusing an MMU is quite noticeable, since our unmap
> > > implementation is slightly crap at the moment, the cost of which shows
> > > up both on sides of the reclaim (victim and user).
> > 
> > Oh, and why unmap is crap:
> 
> Heh, isn't unmap by definition crap?  If KVM needs to unmap and rebuild an S2 MMU,
> then KVM is already in a slow, sub-optimal situation.

Not really, the unmap plumbing is used for applying the intent of a
guest TLBI too. Sub-optimal or not, it is exactly what the VM asked for,
and it'd be in our interest to handle the unmap as expeditiously as
possible.

> > > Still should drop the reference in most other cases, as I do *not* want
> > > to entertain vCPUs holding a reference when they've gone out to
> > > userspace.
> 
> Why not?  The vCPU is still running, keeping its S2 MMU resident is desirable, no?

How could we possibly know what the intent of userspace is? The VMM
could just as well throw that vCPU fd on ice for an eternity.

For example, you could have a PSCI implementation that lives in
userspace. Guest does CPU_OFF and the VMM decides to terminate the
backing thread and keep the FD around for the next CPU_ON.

Since KVM still views that fd as 'runnable', it'd sit on the reference
that vCPU holds indefinitely. On top of that, it adds complexity to the
implementation since we would need more refcount cleanup flows to handle
these straggler references.

> Essentially all I'm suggesting is that instead of having a common pool of 2*vCPUs
> TLBs per L1 VMM, have 2 (or however many) TLBs per L1 vCPU, plus maybe N extra
> TLBs per L1 VMM.  I.e. mimic the hierarchical design of hardware caches and TLBs
> to some extent.

Making TLBs private to the L1 vCPU is almost guaranteed to be a net loss
in performance. The common case for an L2 VM is that all L2 vCPUs share the
*exact* same translation tables and MMU configuration. So even if you're
running an N vCPU L2, you've only allocated 1 nested MMU context to it.

The ARM architecture has gone as far as making this an explicit contract
between hardware + software. That is, FEAT_TTCNP allows translations to
be shared across the Inner Shareable domain. There's hardware out there
that takes advantage of this, and there is a performance advantage to
enabling the feature.

The guest hypervisor is free to disregard this part of the architecture
and keep MMUs private between CPUs. At the same time, I see zero
incentive for optimizing this use case and am absolutely fine with there
being a performance penalty associated with this configuration.

-- 
Thanks,
Oliver
