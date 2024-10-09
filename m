Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B661547CF
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 23:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728516654; cv=none; b=dG26LNL0hisgcptFqd6NJYOm2/zKsyPOa/tKEXO9l5KtpL8d0/d5C3pgdUY9ed7ZRc0Q+YijiIijB1h43EmkJnP7iZ2vpYXpNLc7F7hyy1kfbtrljq+utiPrKUHjhosKjA7/0UVNr4wU0VC84D19WuiVMszxkZfUU65DKkgwR6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728516654; c=relaxed/simple;
	bh=+ZnW71K1E+mkHBFyzy2uAhcstCghiktRTewDAjfZndE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMwC1svEMDB1+a5No4kytrFxDnuIJQPzP4wSNURocs1/nvTZQSJeDu+M+Khgab64GhWLbkUTplq450dj4myGcDL4oZe8wnWoy/ETKsqrFMj+XDOb/tUGco+S3Jo45OKYH4UpDvA+2Kmw3eq4VaY1d/8obRyleKDk2qpeDhu5XNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F0Th5p25; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F0Th5p25"
Date: Wed, 9 Oct 2024 23:30:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728516650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vRSxDUIp1/atWQhiw+G9PbI69H3tunjQHvqo42wufEs=;
	b=F0Th5p25ZR3VlEmS5geH8lL8dxgiqQJ7UJXJGMlS/GvhxRD4BRW0LF2NFvJVe2cK5m7kV5
	FFaG1CXC32lpdxRAoCnHgL3vQe3u64M/a4gCXfP7Vxm6THvv5s12jY/X+tERZaM8KmHACT
	SenH6wXNUszkY8oWStmo2NcyCIUz8EA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Message-ID: <ZwcSJdIRgoKogsJk@linux.dev>
References: <20241009183603.3221824-1-maz@kernel.org>
 <ZwbYvHJdOqePYjDf@linux.dev>
 <ZwbbQGpZpGQXaNYK@google.com>
 <ZwcRct7VWnW0bObA@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwcRct7VWnW0bObA@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 11:27:52PM +0000, Oliver Upton wrote:
> On Wed, Oct 09, 2024 at 12:36:32PM -0700, Sean Christopherson wrote:
> > On Wed, Oct 09, 2024, Oliver Upton wrote:
> > > On Wed, Oct 09, 2024 at 07:36:03PM +0100, Marc Zyngier wrote:
> > > > As there is very little ordering in the KVM API, userspace can
> > > > instanciate a half-baked GIC (missing its memory map, for example)
> > > > at almost any time.
> > > > 
> > > > This means that, with the right timing, a thread running vcpu-0
> > > > can enter the kernel without a GIC configured and get a GIC created
> > > > behind its back by another thread. Amusingly, it will pick up
> > > > that GIC and start messing with the data structures without the
> > > > GIC having been fully initialised.
> > > 
> > > Huh, I'm definitely missing something. Could you remind me where we open
> > > up this race between KVM_RUN && kvm_vgic_create()?
> 
> Ah, duh, I see it now. kvm_arch_vcpu_run_pid_change() doesn't serialize
> on a VM lock, and kvm_vgic_map_resources() has an early return for
> vgic_ready() letting it blow straight past the config_lock.
> 
> Then if we can't register the MMIO region for the distributor
> everything comes crashing down and a vCPU has made it into the KVM_RUN
> loop w/ the VGIC-shaped rug pulled out from under it. There's definitely
> another functional bug here where a vCPU's attempts to poke the

a theoretical bug, that is. In practice the window to race against
likely isn't big enough to get the in-guest vCPU to the point of poking
the halfway-initialized distributor.

> distributor wind up reaching userspace as MMIO exits. But we can worry
> about that another day.
> 
> If memory serves, kvm_vgic_map_resources() used to do all of this behind
> the config_lock to cure the race, but that wound up inverting lock
> ordering on srcu.
> 
> Note to self: Impose strict ordering on GIC initialization v. vCPU
> creation if/when we get a new flavor of irqchip.
> 
> > > I'd thought the fact that the latter takes all the vCPU mutexes and
> > > checks if any vCPU in the VM has run would be enough to guard against
> > > such a race, but clearly not...
> > 
> > Any chance that fixing bugs where vCPU0 can be accessed (and run!) before its
> > fully online help?
> 
> That's an equally gross bug, but kvm_vgic_create() should still be safe
> w.r.t. vCPU creation since both hold the kvm->lock in the right spot.
> That is, since kvm_vgic_create() is called under the lock any vCPUs
> visible to userspace should exist in the vCPU xarray.
> 
> The crappy assumption here is kvm_arch_vcpu_run_pid_change() and its
> callees are allowed to destroy VM-scoped structures in error handling.
> 
> > E.g. if that closes the vCPU0 hole, maybe the vCPU1 case can
> > be handled a bit more gracefully?
> 
> I think this is about as graceful as we can be. The sorts of screw-ups
> that precipitate this error handling may involve stupidity across
> several KVM ioctls, meaning it is highly unlikely to be attributable /
> recoverable.
> 
> -- 
> Thanks,
> Oliver

-- 
Thanks,
Oliver
